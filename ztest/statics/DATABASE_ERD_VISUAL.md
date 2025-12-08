# Database Entity Relationship Diagram (ERD)

## Visual Representation

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     FOOD, RECIPE & ALLERGIES API                        │
│                          Database Schema                                 │
└─────────────────────────────────────────────────────────────────────────┘


┌──────────────────┐
│   1_cuisine      │ (Base Table)
├──────────────────┤
│ • id (PK)        │
│ • name           │
│ • slug (UNIQUE)  │
│ • description    │
│ • image_url      │
│ • created_at     │
└────────┬─────────┘
         │
         │ Referenced by
         │ (One-to-Many)
         ▼
┌──────────────────────────────────────────┐
│           4_recipe                       │ (Core Entity)
├──────────────────────────────────────────┤
│ • id (PK)                                │
│ • name, slug (UNIQUE), description       │
│ • instructions                           │
│ • cuisine_id (FK → cuisine)              │◄────────┐
│ • difficulty (enum)                      │         │
│ • meal_type (enum)                       │         │
│ • prep_time_minutes                      │         │
│ • cook_time_minutes                      │         │
│ • total_time_minutes                     │         │
│ • servings                               │         │
│ • is_vegetarian, is_vegan               │         │
│ • is_gluten_free, is_dairy_free         │         │
│ • allergy_ids[] (FK → allergy)          │◄────┐   │
│ • featured_image, gallery_images[]      │     │   │
│ • video_url                              │     │   │
│ • rating ⭐                              │     │   │
│ • review_count                           │     │   │
│ • view_count                             │     │   │
│ • viewed_score 📈 (TRENDING)            │     │   │
│ • is_published, published_at            │     │   │
│ • metadata (JSON)                        │     │   │
│ • created_at, updated_at                │     │   │
└────┬─────────────────────┬───────────────┘     │   │
     │                     │                     │   │
     │                     │                     │   │
     │ Referenced by       │ Referenced by       │   │
     │ (One-to-Many)       │ (One-to-Many)       │   │
     │                     │                     │   │
     ▼                     ▼                     │   │
┌──────────────────┐  ┌──────────────────┐      │   │
│ 5_recipe_        │  │ 6_recipe_        │      │   │
│   ingredient     │  │   review         │      │   │
├──────────────────┤  ├──────────────────┤      │   │
│ • id (PK)        │  │ • id (PK)        │      │   │
│ • recipe_id (FK) │  │ • recipe_id (FK) │      │   │
│ • ingredient_id  │  │ • reviewer_name  │      │   │
│   (FK)           │  │ • reviewer_email │      │   │
│ • quantity       │  │ • rating (1-5)   │      │   │
│ • unit (enum)    │  │ • review_text    │      │   │
│ • preparation_   │  │ • review_images[]│      │   │
│   note           │  │ • is_approved    │      │   │
│ • order_index    │  │ • is_verified_   │      │   │
│ • created_at     │  │   purchase       │      │   │
└────────┬─────────┘  │ • helpful_count  │      │   │
         │            │ • created_at     │      │   │
         │            │ • updated_at     │      │   │
         │            └──────────────────┘      │   │
         │                                      │   │
         │ References                           │   │
         │ (Many-to-One)                        │   │
         ▼                                      │   │
┌──────────────────────────────────────┐        │   │
│        3_ingredient                  │        │   │
├──────────────────────────────────────┤        │   │
│ • id (PK)                            │        │   │
│ • name, slug (UNIQUE), description   │        │   │
│ • category (enum: 15 types)          │        │   │
│ • is_vegetarian, is_vegan           │        │   │
│ • is_gluten_free, is_dairy_free     │        │   │
│ • allergy_ids[] (FK → allergy)      │◄───────┼───┘
│ • nutritional_info (JSON)            │        │
│ • image_url                          │        │
│ • created_at, updated_at            │        │
└────────────────────┬─────────────────┘        │
                     │                          │
                     │ References               │
                     │ (Many-to-Many via Array) │
                     ▼                          │
              ┌──────────────────┐              │
              │   2_allergy      │ (Base Table) │
              ├──────────────────┤              │
              │ • id (PK)        │◄─────────────┘
              │ • name           │
              │ • slug (UNIQUE)  │
              │ • description    │
              │ • severity (enum)│
              │   - mild         │
              │   - moderate     │
              │   - severe       │
              │ • created_at     │
              └──────────────────┘


┌──────────────────────────────────────┐
│   7_recipe_view_history              │ (Analytics/Trending)
├──────────────────────────────────────┤
│ • id (PK)                            │
│ • recipe_id (FK → recipe)            │
│ • viewer_ip                          │
│ • user_agent                         │
│ • referrer                           │
│ • viewed_at ⏰                       │
└──────────────────────────────────────┘
         │
         │ Aggregated by
         │ Background Task
         ▼
    Updates recipe.viewed_score 📈
    (Trending Score Calculation)
```

---

## Relationship Types

### One-to-Many (→)
- **cuisine** → **recipe**: One cuisine has many recipes
- **recipe** → **recipe_ingredient**: One recipe has many ingredients
- **recipe** → **recipe_review**: One recipe has many reviews
- **recipe** → **recipe_view_history**: One recipe has many view records
- **ingredient** → **recipe_ingredient**: One ingredient used in many recipes

### Many-to-Many (↔)
- **recipe** ↔ **ingredient**: Via `recipe_ingredient` junction table
- **recipe** ↔ **allergy**: Via `recipe.allergy_ids[]` array
- **ingredient** ↔ **allergy**: Via `ingredient.allergy_ids[]` array

---

## Table Dependency Levels

```
Level 0 (Independent Base Tables):
┌─────────────┐  ┌─────────────┐
│  1_cuisine  │  │  2_allergy  │
└─────────────┘  └─────────────┘

Level 1 (Depends on Allergy):
        ┌──────────────────┐
        │  3_ingredient    │
        └──────────────────┘

Level 2 (Core Entity):
        ┌──────────────────┐
        │    4_recipe      │
        └──────────────────┘

Level 3 (Recipe Relationships):
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────────┐
│ 5_recipe_        │  │ 6_recipe_        │  │ 7_recipe_view_       │
│   ingredient     │  │   review         │  │   history            │
└──────────────────┘  └──────────────────┘  └──────────────────────┘
```

---

## Data Flow: Trending System

```
┌─────────────────────────────────────────────────────────────────┐
│                    TRENDING RECIPE SYSTEM                        │
└─────────────────────────────────────────────────────────────────┘

1. USER VIEWS RECIPE
   │
   ▼
┌──────────────────────────────────────┐
│  API: get_recipe_by_slug_GET.xs      │
│  - Fetches recipe data               │
│  - Increments view_count             │
│  - Logs view to history              │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│  7_recipe_view_history               │
│  INSERT:                             │
│  - recipe_id                         │
│  - viewer_ip                         │
│  - user_agent                        │
│  - referrer                          │
│  - viewed_at = NOW                   │
└──────────────────────────────────────┘
                   │
                   │ Accumulates over time
                   ▼
┌──────────────────────────────────────┐
│  BACKGROUND TASK (Daily)             │
│  update_trending_scores.xs           │
│                                      │
│  1. Query views from last 7 days    │
│  2. Group by recipe_id              │
│  3. Count views per recipe          │
│  4. Calculate weighted score:       │
│     - Recent views weighted higher  │
│     - Older views weighted lower    │
│  5. Update recipe.viewed_score      │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│  4_recipe                            │
│  UPDATE:                             │
│  - viewed_score = calculated_value   │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│  API: get_trending_recipes_GET.xs    │
│  - Query recipes                     │
│  - ORDER BY viewed_score DESC        │
│  - Return top trending recipes       │
└──────────────────────────────────────┘
```

---

## Index Strategy

### Primary Keys (7)
Every table has a primary key on `id`

### Unique Indexes (6)
- `cuisine.slug`
- `allergy.slug`
- `ingredient.slug`
- `recipe.slug`

### Foreign Key Indexes (8)
- `recipe.cuisine_id`
- `recipe_ingredient.recipe_id`
- `recipe_ingredient.ingredient_id`
- `recipe_review.recipe_id`
- `recipe_view_history.recipe_id`

### Composite Indexes (3)
- `recipe_ingredient(recipe_id, order_index)` - For ordered ingredient lists
- `recipe_review(recipe_id, created_at)` - For chronological reviews
- `recipe_view_history(recipe_id, viewed_at)` - **Critical for trending calculations**

### GIN Indexes (2)
- `ingredient.nutritional_info` - For JSON queries
- `recipe.metadata` - For flexible metadata queries

### Filterable Field Indexes (25+)
All boolean flags, enums, and sortable fields are indexed for fast filtering

---

## Field Type Summary

| Type | Count | Usage |
|------|-------|-------|
| `int` | 25+ | IDs, counts, times, foreign keys |
| `text` | 30+ | Names, descriptions, notes |
| `bool` | 14 | Dietary flags, publishing status |
| `enum` | 5 | Categories, difficulty, meal type, unit, severity |
| `timestamp` | 14 | Created/updated/viewed times |
| `decimal` | 2 | Rating, viewed_score |
| `image` | 6 | Single images |
| `image[]` | 2 | Image galleries |
| `video` | 1 | Recipe videos |
| `email` | 1 | Reviewer email |
| `json` | 2 | Nutritional info, metadata |
| `int[]` | 2 | Allergy ID arrays |

---

## Enum Values

### `difficulty` (4 values)
- easy
- medium
- hard
- expert

### `meal_type` (6 values)
- breakfast
- lunch
- dinner
- snack
- dessert
- appetizer

### `severity` (3 values)
- mild
- moderate
- severe

### `category` (15 values)
- vegetable, fruit, meat, poultry, seafood
- dairy, grain, legume, nut
- spice, herb, oil, condiment, sweetener, other

### `unit` (24 values)
- cup/cups, tablespoon/tablespoons, teaspoon/teaspoons
- gram/grams, kilogram/kilograms
- ounce/ounces, pound/pounds
- milliliter/milliliters, liter/liters
- piece/pieces, pinch, to taste, whole, slice/slices

---

## Key Metrics

| Metric | Value |
|--------|-------|
| Total Tables | 7 |
| Total Fields | 80+ |
| Total Indexes | 50+ |
| Foreign Keys | 8 |
| Unique Constraints | 6 |
| Enum Types | 5 |
| JSON Fields | 2 |
| Array Fields | 4 |
| Boolean Flags | 14 |

---

## Database Size Estimates

Based on typical production usage:

| Table | Estimated Rows | Size |
|-------|---------------|------|
| cuisine | 50-100 | Small |
| allergy | 20-50 | Small |
| ingredient | 500-2,000 | Medium |
| recipe | 1,000-10,000 | Large |
| recipe_ingredient | 10,000-100,000 | Large |
| recipe_review | 5,000-50,000 | Medium |
| recipe_view_history | 100,000-1,000,000+ | Very Large |

**Note**: `recipe_view_history` will grow continuously. Consider:
- Archiving old records (>90 days)
- Partitioning by date
- Regular cleanup tasks

---

## Query Performance Considerations

### Fast Queries ✅
- Get recipe by slug (unique index)
- Filter recipes by cuisine (indexed FK)
- Filter by dietary flags (indexed booleans)
- Get trending recipes (indexed `viewed_score`)
- Get top-rated recipes (indexed `rating`)
- Get recipe ingredients in order (composite index)

### Moderate Queries ⚠️
- Search recipes by name (full-text search recommended)
- Filter by multiple criteria (uses multiple indexes)
- Complex allergen exclusions (array operations)

### Heavy Queries 🔴
- Aggregate view statistics (large table scans)
- Calculate trending scores (aggregation over time ranges)
- Generate analytics reports (complex joins)

**Solution**: Use background tasks for heavy operations

---

## Security & Privacy

### Public API (`auth = false`)
All tables are set to `auth = false` for public API access

### Sensitive Data
- `viewer_ip` in `recipe_view_history` - Consider anonymization
- `reviewer_email` - Optional field, validated

### Moderation
- `recipe_review.is_approved` - Prevents spam
- `recipe.is_published` - Controls visibility

---

## Scalability Features

✅ **Indexed for Performance**: All filterable fields indexed
✅ **Normalized Design**: Proper relationships, no data duplication
✅ **Flexible Schema**: JSON fields for extensibility
✅ **Efficient Arrays**: Array fields for many-to-many without extra tables
✅ **Composite Indexes**: Optimized for common query patterns
✅ **Trending System**: Separate history table for analytics
✅ **Moderation Workflow**: Review approval system

---

This ERD provides a complete visual overview of the database structure, relationships, and data flow for the Food, Recipe & Allergies API! 🎉
