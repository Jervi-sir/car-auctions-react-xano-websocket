# Quick Reference: Table Structure

## Table Overview

| # | Table Name | Purpose | Key Relationships |
|---|------------|---------|-------------------|
| 1 | `cuisine` | Cuisine types | Referenced by `recipe` |
| 2 | `allergy` | Allergen info | Referenced by `ingredient`, `recipe` |
| 3 | `ingredient` | Recipe ingredients | References `allergy`, used in `recipe_ingredient` |
| 4 | `recipe` | Main recipes | References `cuisine`, `allergy` |
| 5 | `recipe_ingredient` | Recipe-ingredient links | References `recipe`, `ingredient` |
| 6 | `recipe_review` | User reviews | References `recipe` |
| 7 | `recipe_view_history` | View tracking | References `recipe` |

## Field Quick Reference

### 1_cuisine
```
id, name, slug, description, image_url, created_at
```

### 2_allergy
```
id, name, slug, description, severity, created_at
```

### 3_ingredient
```
id, name, slug, description, category,
is_vegetarian, is_vegan, is_gluten_free, is_dairy_free,
allergy_ids[], nutritional_info (JSON), image_url, created_at
```

### 4_recipe
```
id, name, slug, description, instructions,
cuisine_id, difficulty (enum), meal_type (enum),
prep_time_minutes, cook_time_minutes, total_time_minutes, servings,
is_vegetarian, is_vegan, is_gluten_free, is_dairy_free,
allergy_ids[],
featured_image, gallery_images[], video_url,
rating, review_count, view_count, viewed_score,
is_published, published_at,
metadata (JSON), created_at, updated_at
```

### 5_recipe_ingredient
```
id, recipe_id, ingredient_id,
quantity, unit, preparation_note, order_index,
created_at
```

### 6_recipe_review
```
id, recipe_id,
reviewer_name, reviewer_email, rating, review_text,
review_images[], is_approved, is_verified_purchase, helpful_count,
created_at, updated_at
```

### 7_recipe_view_history
```
id, recipe_id,
viewer_ip, user_agent, referrer, viewed_at
```

## Enum Values

### recipe.difficulty
- `easy`
- `medium`
- `hard`
- `expert`

### recipe.meal_type
- `breakfast`
- `lunch`
- `dinner`
- `snack`
- `dessert`
- `appetizer`

## Common Query Patterns

### Get all published recipes
```xanoscript
db.query recipe {
  where = $db.recipe.is_published
  sort = {recipe.created_at: "desc"}
  return = {type: "list"}
} as $recipes
```

### Get recipe with ingredients
```xanoscript
// 1. Get recipe
db.query recipe {
  where = $db.recipe.slug == $input.slug
  return = {type: "single"}
} as $recipe

// 2. Get ingredients for recipe
db.query recipe_ingredient {
  join = {
    ingredient: {
      table: "ingredient"
      where: $db.recipe_ingredient.ingredient_id == $db.ingredient.id
    }
  }
  where = $db.recipe_ingredient.recipe_id == $recipe.id
  sort = {recipe_ingredient.order_index: "asc"}
  eval = {
    ingredient_name: $db.ingredient.name
    quantity: $db.recipe_ingredient.quantity
    unit: $db.recipe_ingredient.unit
  }
  return = {type: "list"}
} as $ingredients
```

### Find allergy-safe recipes
```xanoscript
db.query recipe {
  where = $db.recipe.is_published
    && $db.recipe.allergy_ids not overlaps $input.allergy_ids
  return = {type: "list"}
} as $safe_recipes
```

### Filter recipes by dietary requirements
```xanoscript
db.query recipe {
  where = $db.recipe.is_published
    && $db.recipe.is_vegetarian ==? $input.is_vegetarian
    && $db.recipe.is_vegan ==? $input.is_vegan
    && $db.recipe.is_gluten_free ==? $input.is_gluten_free
    && $db.recipe.cuisine_id ==? $input.cuisine_id
  return = {type: "list"}
} as $recipes
```

### Get trending recipes (last 7 days)
```xanoscript
var $cutoff_date {
  value = now|transform_timestamp:"-7 days":"UTC"
}

db.query recipe {
  where = $db.recipe.is_published
    && $db.recipe.viewed_at >= $cutoff_date
  sort = {recipe.viewed_score: "desc"}
  return = {
    type: "list"
    paging: {
      page: 1
      per_page: 10
    }
  }
} as $trending_recipes
```

### Search recipes by name
```xanoscript
db.query recipe {
  where = $db.recipe.is_published
    && ($db.recipe.name includes? $input.search
        || $db.recipe.description includes? $input.search)
  return = {type: "list"}
} as $results
```

### Get top-rated recipes
```xanoscript
db.query recipe {
  where = $db.recipe.is_published
    && $db.recipe.rating >= 4.0
  sort = {recipe.rating: "desc"}
  return = {
    type: "list"
    paging: {
      page: $input.page
      per_page: 20
    }
  }
} as $top_recipes
```

## Validation Patterns

### Check recipe exists
```xanoscript
precondition ($recipe != null) {
  error_type = "notfound"
  error = "Recipe not found"
}
```

### Check recipe is published
```xanoscript
precondition ($recipe != null && $recipe.is_published) {
  error_type = "notfound"
  error = "Recipe not found or not published"
}
```

### Validate rating
```xanoscript
precondition ($input.rating >= 1 && $input.rating <= 5) {
  error_type = "inputerror"
  error = "Rating must be between 1 and 5"
}
```

## Index Usage Tips

### Fast Queries (Indexed)
✅ Filter by `is_published`
✅ Filter by `cuisine_id`
✅ Filter by `difficulty`
✅ Filter by `meal_type`
✅ Filter by `is_vegetarian`, `is_vegan`, etc.
✅ Sort by `rating`, `created_at`, `viewed_score`
✅ Search by `slug` (unique index)

### Slower Queries (Not Indexed)
⚠️ Full-text search in `description` or `instructions`
⚠️ Complex JSON queries in `metadata`
⚠️ Array operations on `allergy_ids` (use `contains` or `overlaps`)

## Data Integrity Rules

1. **Slugs must be unique** - Enforced by unique index
2. **Ratings must be 1-5** - Enforced by `filters=min:1|max:5`
3. **Foreign keys must exist** - Reference valid IDs in related tables
4. **Published recipes must have published_at** - Set when `is_published = true`
5. **Recipe ratings should match review average** - Update via task or trigger
6. **View counts should match history records** - Update when logging views

## Performance Tips

1. **Use pagination** for large result sets
2. **Filter by indexed fields** first in WHERE clauses
3. **Use null-safe operators** (`==?`, `includes?`) for optional filters
4. **Limit JOIN depth** to avoid performance issues
5. **Use `eval`** to select only needed fields from JOINs
6. **Cache frequently accessed data** (cuisines, allergies)
7. **Archive old view history** to keep table size manageable

## Common Mistakes to Avoid

❌ Using `includes` on arrays (use `contains` instead)
❌ Forgetting null-safe operators for optional filters
❌ Not checking if recipe exists before accessing properties
❌ Using `type: "single"` when multiple results expected
❌ Not indexing frequently filtered fields
❌ Forgetting to set `is_published` when querying public APIs
❌ Not validating rating range (1-5)
❌ Using `$$` outside of `map` expressions
