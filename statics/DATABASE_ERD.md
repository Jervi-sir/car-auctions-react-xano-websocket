# Database Entity Relationship Diagram

## Visual Schema Overview

```
┌─────────────────┐
│   1_cuisine     │
│─────────────────│
│ • id (PK)       │
│ • name          │
│ • slug (unique) │
│ • description   │
│ • image_url     │
│ • created_at    │
└─────────────────┘
         │
         │ 1:N
         ▼
┌─────────────────────────────────┐
│         4_recipe                │
│─────────────────────────────────│
│ • id (PK)                       │
│ • name                          │
│ • slug (unique)                 │
│ • description                   │
│ • instructions                  │
│ • cuisine_id (FK → cuisine)     │
│ • difficulty (enum)             │
│ • meal_type (enum)              │
│ • prep_time_minutes             │
│ • cook_time_minutes             │
│ • total_time_minutes            │
│ • servings                      │
│ • is_vegetarian                 │
│ • is_vegan                      │
│ • is_gluten_free                │
│ • is_dairy_free                 │
│ • allergy_ids[] (FK → allergy)  │
│ • featured_image                │
│ • gallery_images[]              │
│ • video_url                     │
│ • rating                        │
│ • review_count                  │
│ • view_count                    │
│ • viewed_score                  │
│ • is_published                  │
│ • published_at                  │
│ • metadata (JSON)               │
│ • created_at                    │
│ • updated_at                    │
└─────────────────────────────────┘
    │           │           │
    │ 1:N       │ 1:N       │ 1:N
    ▼           ▼           ▼
┌───────────────────────┐  ┌──────────────────────┐  ┌────────────────────────┐
│ 5_recipe_ingredient   │  │  6_recipe_review     │  │ 7_recipe_view_history  │
│───────────────────────│  │──────────────────────│  │────────────────────────│
│ • id (PK)             │  │ • id (PK)            │  │ • id (PK)              │
│ • recipe_id (FK)      │  │ • recipe_id (FK)     │  │ • recipe_id (FK)       │
│ • ingredient_id (FK)  │  │ • reviewer_name      │  │ • viewer_ip            │
│ • quantity            │  │ • reviewer_email     │  │ • user_agent           │
│ • unit                │  │ • rating (1-5)       │  │ • referrer             │
│ • preparation_note    │  │ • review_text        │  │ • viewed_at            │
│ • order_index         │  │ • review_images[]    │  └────────────────────────┘
│ • created_at          │  │ • is_approved        │
└───────────────────────┘  │ • is_verified        │
         │                 │ • helpful_count      │
         │ N:1             │ • created_at         │
         ▼                 │ • updated_at         │
┌─────────────────────────┐└──────────────────────┘
│    3_ingredient         │
│─────────────────────────│
│ • id (PK)               │
│ • name                  │
│ • slug (unique)         │
│ • description           │
│ • category              │
│ • is_vegetarian         │
│ • is_vegan              │
│ • is_gluten_free        │
│ • is_dairy_free         │
│ • allergy_ids[] (FK)    │
│ • nutritional_info (JSON)│
│ • image_url             │
│ • created_at            │
└─────────────────────────┘
         │
         │ N:M (via array)
         ▼
┌─────────────────┐
│   2_allergy     │
│─────────────────│
│ • id (PK)       │
│ • name          │
│ • slug (unique) │
│ • description   │
│ • severity      │
│ • created_at    │
└─────────────────┘
         ▲
         │ N:M (via array)
         │
    (also referenced by recipe.allergy_ids[])
```

## Relationship Legend

- **PK** = Primary Key
- **FK** = Foreign Key
- **1:N** = One-to-Many relationship
- **N:M** = Many-to-Many relationship
- **[]** = Array field
- **(unique)** = Unique constraint

## Table Dependencies (Creation Order)

```
Level 1 (No dependencies):
  ├─ 1_cuisine
  └─ 2_allergy

Level 2 (Depends on Level 1):
  └─ 3_ingredient (depends on: allergy)

Level 3 (Depends on Levels 1-2):
  └─ 4_recipe (depends on: cuisine, allergy)

Level 4 (Depends on Levels 1-3):
  ├─ 5_recipe_ingredient (depends on: recipe, ingredient)
  ├─ 6_recipe_review (depends on: recipe)
  └─ 7_recipe_view_history (depends on: recipe)
```

## Key Relationships Explained

### 1. Cuisine → Recipe (1:N)
- One cuisine can categorize many recipes
- Example: "Italian" cuisine → Pasta Carbonara, Margherita Pizza, etc.

### 2. Recipe → Recipe Ingredient (1:N)
- One recipe has many ingredients
- Example: "Pasta Carbonara" → Pasta, Eggs, Bacon, Cheese, etc.

### 3. Ingredient → Recipe Ingredient (1:N)
- One ingredient can be used in many recipes
- Example: "Tomato" → Pasta Sauce, Salad, Pizza, etc.

### 4. Recipe ↔ Allergy (N:M via array)
- Recipes can have multiple allergens
- Allergens can be in multiple recipes
- Stored as array in `recipe.allergy_ids[]`

### 5. Ingredient ↔ Allergy (N:M via array)
- Ingredients can contain multiple allergens
- Allergens can be in multiple ingredients
- Stored as array in `ingredient.allergy_ids[]`

### 6. Recipe → Review (1:N)
- One recipe can have many reviews
- Reviews track ratings and feedback

### 7. Recipe → View History (1:N)
- One recipe can have many view records
- Used for trending calculations and analytics

## Query Patterns

### Get Recipe with All Related Data
```
1. Query recipe by slug
2. Join recipe_ingredient → ingredient
3. Join cuisine
4. Filter by allergy_ids (if needed)
5. Get reviews (sorted by created_at)
6. Calculate average rating
```

### Find Allergy-Safe Recipes
```
1. Query recipes where allergy_ids NOT OVERLAPS user_allergy_ids
2. Join recipe_ingredient
3. Join ingredient where allergy_ids NOT OVERLAPS user_allergy_ids
4. Return safe recipes
```

### Get Trending Recipes
```
1. Query recipe_view_history (last 7 days)
2. Group by recipe_id
3. Calculate view counts
4. Update recipe.viewed_score
5. Query recipes sorted by viewed_score DESC
```

### Search Recipes by Ingredients
```
1. Query recipe_ingredient where ingredient_id IN user_ingredient_ids
2. Group by recipe_id
3. Join recipe
4. Return matching recipes
```
