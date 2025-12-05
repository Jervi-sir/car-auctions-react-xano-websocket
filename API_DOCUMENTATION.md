# Food, Recipe & Allergies API Documentation

## Overview

This is a production-ready public API system for food, recipes, and allergies management. The API allows developers to fetch and filter data across recipes, ingredients, cuisines, and allergies.

## Database Tables

### Core Tables (with numbered prefixes for relationship order):

1. **1_allergy.xs** - Allergen information with severity levels
2. **2_cuisine.xs** - Cuisine types and regional categorization
3. **3_ingredient.xs** - Ingredients with nutritional info and dietary flags
4. **4_recipe.xs** - Core recipe table with comprehensive metadata
5. **5_recipe_ingredient.xs** - Junction table linking recipes to ingredients
6. **6_recipe_review.xs** - User reviews and ratings for recipes

## API Groups & Endpoints

### 📖 Recipes API (`/recipes`)

#### `GET /recipes`
List published recipes with advanced filtering
- **Filters**: cuisine, difficulty, meal type, dietary restrictions, cooking time, rating
- **Search**: by name or description
- **Pagination**: configurable page size (max 100)
- **Sorting**: by created_at, rating, view_count, total_time_minutes

#### `GET /recipes/by-slug`
Get single recipe by slug with full details
- Returns: recipe details, ingredients list, reviews
- Automatically increments view count

#### `GET /recipes/trending`
Get trending recipes based on views and ratings
- **Parameters**: limit (max 50), days lookback (max 30)
- Sorted by view count descending

#### `GET /recipes/top-rated`
Get highest-rated recipes
- **Filters**: minimum rating, minimum rating count
- **Parameters**: limit (max 100)

#### `POST /recipes/reviews`
Submit a review for a recipe
- **Required**: recipe_id, reviewer_name, rating (1-5)
- **Optional**: reviewer_email, review_text, modifications
- Reviews require approval before display

#### `GET /recipes/by-ingredients`
Find recipes by available ingredients
- **Input**: array of ingredient IDs
- **Options**: match all or match any
- Useful for "what can I make with these ingredients" queries

---

### 🥕 Ingredients API (`/ingredients`)

#### `GET /ingredients`
List ingredients with filtering
- **Filters**: category, dietary flags (vegetarian, vegan, gluten-free)
- **Search**: by name
- **Pagination**: up to 200 items per page

#### `GET /ingredients/by-id`
Get ingredient details
- Returns: ingredient info + recipes using this ingredient
- Includes recipe previews with ratings and images

#### `GET /ingredients/categories`
List all ingredient categories with counts
- Returns: all 15 categories with item counts
- Categories: vegetable, fruit, meat, seafood, dairy, grain, spice, herb, nut, legume, oil, condiment, sweetener, beverage, other

---

### 🚫 Allergies API (`/allergies`)

#### `GET /allergies`
List all allergies
- **Filters**: severity level, search by name
- Sorted alphabetically

#### `GET /allergies/by-id`
Get allergy details
- Returns: allergy info + affected ingredients + affected recipes
- Useful for understanding allergen impact

#### `GET /allergies/safe-recipes`
Find allergy-safe recipes
- **Input**: array of allergy IDs to avoid
- **Filters**: meal type, difficulty
- Excludes recipes containing specified allergens

---

### 🌍 Cuisines API (`/cuisines`)

#### `GET /cuisines`
List all cuisines
- **Filters**: region, search by name
- Sorted alphabetically

#### `GET /cuisines/by-id`
Get cuisine details with recipes
- Returns: cuisine info + paginated recipes
- Recipes sorted by rating

#### `GET /cuisines/popular`
Get popular cuisines by recipe count
- **Parameters**: limit (max 50)
- Sorted by number of published recipes

---

### 🔍 Search API (`/search`)

#### `GET /search`
Global search across all entities
- **Input**: search query (min 2 characters)
- **Types**: recipes, ingredients, cuisines, allergies
- **Parameters**: limit per type (max 50)
- Returns grouped results by entity type

---

## Key Features

✅ **Comprehensive Filtering**: Dietary restrictions, allergies, cuisine, difficulty, meal type, cooking time  
✅ **Smart Search**: Full-text search across names, descriptions, and tags  
✅ **Allergen Safety**: Find recipes safe for specific allergies  
✅ **Ingredient-Based Discovery**: Find recipes by available ingredients  
✅ **Trending & Top-Rated**: Discover popular and highly-rated recipes  
✅ **Review System**: User reviews with moderation workflow  
✅ **Pagination**: All list endpoints support pagination  
✅ **Performance**: Optimized with proper database indexing  
✅ **Public API**: No authentication required for read operations  

## Response Formats

### Paginated List Response
```json
{
  "itemsReceived": 20,
  "curPage": 1,
  "nextPage": 2,
  "prevPage": null,
  "offset": 0,
  "perPage": 20,
  "items": [...]
}
```

### Single Item Response
Returns the object directly without pagination wrapper.

### Error Response
```json
{
  "error": "Error message",
  "type": "inputerror|notfound|validation"
}
```

## Dietary Flags

All recipes and ingredients support these boolean flags:
- `is_vegetarian`
- `is_vegan`
- `is_gluten_free`
- `is_dairy_free` (recipes only)

## Enum Values

### Recipe Difficulty
- `easy`
- `medium`
- `hard`
- `expert`

### Meal Type
- `breakfast`
- `lunch`
- `dinner`
- `snack`
- `dessert`
- `appetizer`
- `beverage`

### Allergy Severity
- `mild`
- `moderate`
- `severe`
- `life_threatening`

### Ingredient Categories
- `vegetable`, `fruit`, `meat`, `seafood`, `dairy`, `grain`
- `spice`, `herb`, `nut`, `legume`, `oil`
- `condiment`, `sweetener`, `beverage`, `other`

## Usage Examples

### Find vegan Italian dinner recipes under 30 minutes
```
GET /recipes?cuisine_id=1&is_vegan=true&meal_type=dinner&max_time_minutes=30
```

### Find recipes safe for peanut and dairy allergies
```
GET /allergies/safe-recipes?allergy_ids=[1,2]&meal_type=lunch
```

### Search for "pasta" across all entities
```
GET /search?query=pasta&types=["recipes","ingredients"]
```

### Get trending recipes from last 7 days
```
GET /recipes/trending?limit=20&days=7
```

## Best Practices

1. **Use pagination** for list endpoints to avoid large responses
2. **Cache responses** where appropriate (cuisines, allergies rarely change)
3. **Combine filters** to narrow results effectively
4. **Use slugs** for recipe URLs instead of IDs for SEO
5. **Respect rate limits** (implement on your end as needed)

## Next Steps

To deploy this API:
1. Push the table definitions to Xano
2. Push the API endpoint definitions to Xano
3. Populate initial data (cuisines, allergies, ingredients)
4. Test all endpoints
5. Generate API documentation from Swagger
6. Implement rate limiting if needed
