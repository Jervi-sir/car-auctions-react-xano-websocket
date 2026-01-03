# Quick Start Guide - Database Tables Created ✅

## What Was Created

✅ **7 Database Tables** in `/tables/` directory:
- `1_cuisine.xs` - Cuisine types (Italian, Mexican, etc.)
- `2_allergy.xs` - Allergen types (peanuts, dairy, etc.)
- `3_ingredient.xs` - Recipe ingredients with dietary info
- `4_recipe.xs` - Main recipe table with **viewed_score** field
- `5_recipe_ingredient.xs` - Recipe-ingredient junction table
- `6_recipe_review.xs` - Recipe reviews and ratings
- `7_recipe_view_history.xs` - View tracking for trending calculations

---

## Key Features Implemented

### 🎯 Trending System Architecture
The database is designed with a two-table trending system:

1. **`recipe_view_history`** - Logs every view with timestamp
   - Captures: `recipe_id`, `viewer_ip`, `user_agent`, `referrer`, `viewed_at`
   - Indexed on `recipe_id` + `viewed_at` for fast queries

2. **`recipe.viewed_score`** - Stores calculated trending score
   - Updated by background task
   - Indexed for fast sorting
   - Enables "trending recipes" API endpoint

### 📊 Comprehensive Indexing
- **50+ indexes** for optimal query performance
- **Unique slugs** on all major tables for SEO
- **Composite indexes** for common query patterns
- **GIN indexes** for JSON field queries

### 🥗 Dietary & Allergen Tracking
- Boolean flags: `is_vegetarian`, `is_vegan`, `is_gluten_free`, `is_dairy_free`
- Array-based allergen relationships
- Severity levels for allergies

### 📸 Rich Media Support
- Featured images and image galleries
- Video support for recipe tutorials
- Review images from users

---

## Table Relationship Summary

```
1_cuisine ──┐
            ├──> 4_recipe ──┬──> 5_recipe_ingredient ──> 3_ingredient
2_allergy ──┘               ├──> 6_recipe_review                │
                            └──> 7_recipe_view_history          │
                                                                 │
                            2_allergy ◄──────────────────────────┘
```

---

## Next Steps

### 1️⃣ Push Tables to Xano (Optional)
If you have Xano CLI configured:
```bash
xano push tables/
```

### 2️⃣ Create Seed Functions
Create functions to populate tables with sample data:

**Recommended order:**
1. `functions/1_seed_cuisines.xs`
2. `functions/2_seed_allergies.xs`
3. `functions/3_seed_ingredients.xs`
4. `functions/4_seed_recipes.xs`
5. `functions/5_seed_recipe_ingredients.xs`
6. `functions/6_seed_recipe_reviews.xs`
7. `functions/7_seed_recipe_view_history.xs`
8. `functions/10_seed_all_tables.xs` (master function)

### 3️⃣ Create Background Task
Create trending score calculation task:

**File**: `tasks/update_trending_scores.xs`

**Logic**:
```xanoscript
task update_trending_scores {
  active = false
  
  stack {
    // 1. Calculate window (last 7 days)
    var $window_start {
      value = now|transform_timestamp:"-7 days":"UTC"
    }
    
    // 2. Query all recipes
    db.query recipe {
      return = {type: "list"}
    } as $recipes
    
    // 3. For each recipe, count recent views
    foreach ($recipes) {
      each as $recipe {
        // Query views in last 7 days
        db.query recipe_view_history {
          where = $db.recipe_view_history.recipe_id == $recipe.id
            && $db.recipe_view_history.viewed_at >= $window_start
          return = {type: "list"}
        } as $recent_views
        
        // Calculate score (can add weighting)
        var $score {
          value = $recent_views|count
        }
        
        // Update recipe
        db.edit recipe {
          field_name = "id"
          field_value = $recipe.id
          data = {
            viewed_score: $score
          }
        }
      }
    }
    
    debug.log {
      value = "Updated trending scores for all recipes"
    }
  }
  
  // Run daily at midnight
  schedule = [{starts_on: 2025-12-06 00:00:00+0000, freq: 86400}]
}
```

### 4️⃣ Create API Endpoints

**Recommended API endpoints** in `/apis/recipes/`:

#### Core Endpoints
- `1_list_recipes_GET.xs` - List recipes with filtering
- `2_get_recipe_by_slug_GET.xs` - Get recipe details (+ log view)
- `3_search_recipes_GET.xs` - Search by name/description
- `4_trending_recipes_GET.xs` - Get trending (sort by viewed_score)
- `5_top_rated_recipes_GET.xs` - Get top-rated

#### Review Endpoints
- `10_submit_review_POST.xs` - Submit a review
- `11_get_recipe_reviews_GET.xs` - Get reviews for a recipe

#### Ingredient Endpoints
- `20_list_ingredients_GET.xs` - List ingredients
- `21_get_ingredient_by_slug_GET.xs` - Get ingredient details
- `22_recipes_by_ingredient_GET.xs` - Find recipes using ingredient

#### Allergy Endpoints
- `30_list_allergies_GET.xs` - List all allergies
- `31_allergy_safe_recipes_GET.xs` - Find recipes excluding allergens

### 5️⃣ Create API Group
**File**: `apis/recipes/api_group.xs`

```xanoscript
// Public API for recipe management and discovery
api_group recipes {
  canonical = "YOUR_UNIQUE_ID"
}
```

---

## Important Implementation Notes

### ⚠️ View Tracking
When implementing `get_recipe_by_slug_GET.xs`, make sure to:
1. Fetch the recipe
2. **Insert a record into `recipe_view_history`**
3. Increment `recipe.view_count`
4. Return recipe data

Example:
```xanoscript
// After fetching recipe
db.add recipe_view_history {
  data = {
    recipe_id: $recipe.id
    viewer_ip: $env.ip
    user_agent: $env.user_agent
    referrer: $env.referrer
    viewed_at: now
  }
}

// Update view count
db.edit recipe {
  field_name = "id"
  field_value = $recipe.id
  data = {
    view_count: $recipe.view_count + 1
  }
}
```

### 📈 Trending Algorithm
The basic algorithm counts views in the last 7 days. You can enhance it:

**Weighted by recency**:
- Views in last 24 hours: weight × 7
- Views 1-3 days ago: weight × 5
- Views 3-5 days ago: weight × 3
- Views 5-7 days ago: weight × 1

**Formula**:
```
viewed_score = (recent_views × 7) + (medium_views × 3) + (older_views × 1)
```

### 🔍 Common Query Patterns

**Filter by cuisine**:
```xanoscript
where = $db.recipe.cuisine_id == $input.cuisine_id
```

**Filter by dietary requirements**:
```xanoscript
where = $db.recipe.is_vegan == true
  && $db.recipe.is_gluten_free == true
```

**Exclude allergens**:
```xanoscript
where = $db.recipe.allergy_ids not overlaps $input.exclude_allergy_ids
```

**Search by name**:
```xanoscript
where = $db.recipe.name includes? $input.search
  || $db.recipe.description includes? $input.search
```

**Get trending**:
```xanoscript
db.query recipe {
  where = $db.recipe.is_published
  sort = {recipe.viewed_score: "desc"}
  return = {
    type: "list"
    paging: {
      page: $input.page
      per_page: 20
    }
  }
} as $trending_recipes
```

---

## Database Statistics

| Metric | Value |
|--------|-------|
| **Tables Created** | 7 |
| **Total Fields** | 80+ |
| **Total Indexes** | 50+ |
| **Foreign Keys** | 8 |
| **Enum Types** | 5 |
| **Array Fields** | 4 |
| **JSON Fields** | 2 |

---

## File Structure

```
xano/
├── tables/
│   ├── 1_cuisine.xs              ✅ Created
│   ├── 2_allergy.xs              ✅ Created
│   ├── 3_ingredient.xs           ✅ Created
│   ├── 4_recipe.xs               ✅ Created (with viewed_score)
│   ├── 5_recipe_ingredient.xs    ✅ Created
│   ├── 6_recipe_review.xs        ✅ Created
│   └── 7_recipe_view_history.xs  ✅ Created (for trending)
│
├── functions/                     ⏳ Next: Create seed functions
│   └── (create seed functions here)
│
├── tasks/                         ⏳ Next: Create trending task
│   └── (create update_trending_scores.xs)
│
└── apis/                          ⏳ Next: Create API endpoints
    └── recipes/
        └── (create API endpoints here)
```

---

## Documentation Files

✅ `TABLES_CREATED.md` - Comprehensive table documentation
✅ `DATABASE_ERD_VISUAL.md` - Visual ERD with ASCII diagrams
✅ `DATABASE_SCHEMA.md` - Original schema documentation
✅ `QUICK_START.md` - This file

---

## Testing Checklist

Once you create APIs and seed data:

### Data Integrity
- [ ] All foreign keys resolve correctly
- [ ] Slugs are unique across tables
- [ ] Enum values are valid
- [ ] Required fields are populated

### Trending System
- [ ] Views are logged to `recipe_view_history`
- [ ] Background task updates `viewed_score`
- [ ] Trending API returns correct order
- [ ] Scores reflect recent activity

### Filtering
- [ ] Dietary filters work (vegetarian, vegan, etc.)
- [ ] Allergen exclusion works
- [ ] Cuisine filtering works
- [ ] Search functionality works

### Performance
- [ ] Queries use indexes (check query plans)
- [ ] Pagination works correctly
- [ ] Sorting is fast
- [ ] No N+1 query problems

---

## Support & Resources

- **Xanoscript Documentation**: Check `/docs/` folder
- **Knowledge Base**: `knowledge.md` - Comprehensive Xanoscript syntax guide
- **Database Schema**: `DATABASE_SCHEMA.md` - Detailed schema explanation
- **ERD**: `DATABASE_ERD_VISUAL.md` - Visual relationships

---

## Ready to Build! 🚀

Your database foundation is complete and production-ready. The tables follow all Xanoscript best practices and are optimized for:

✅ **Performance** - Comprehensive indexing
✅ **Scalability** - Proper relationships and normalization
✅ **Flexibility** - JSON fields for extensibility
✅ **Analytics** - View tracking and trending system
✅ **User Engagement** - Reviews, ratings, and moderation
✅ **Safety** - Allergen tracking and dietary filtering
✅ **SEO** - Unique slugs for all entities

**Next**: Create seed functions to populate your database with sample data! 🌱
