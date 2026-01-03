# Recipe API - Complete Documentation

## 📚 Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Base URL](#base-url)
4. [Response Format](#response-format)
5. [Error Handling](#error-handling)
6. [Rate Limiting](#rate-limiting)
7. [API Endpoints](#api-endpoints)
   - [Recipes](#recipes-api)
   - [Cuisines](#cuisines-api)
   - [Reviews](#reviews-api)
   - [Ingredients](#ingredients-api)
   - [Allergies](#allergies-api)
8. [Code Examples](#code-examples)
9. [Changelog](#changelog)

---

## Overview

The Recipe API provides a comprehensive platform for discovering, filtering, and interacting with recipes. It supports advanced filtering by dietary preferences, cuisines, difficulty levels, and includes a sophisticated trending system based on view analytics.

**Version**: 1.0  
**Last Updated**: December 2025  
**Status**: Production Ready

### Key Features

✅ **60+ Recipes** across 15 cuisines  
✅ **Advanced Filtering** by dietary preferences, difficulty, meal type  
✅ **Trending System** with weighted view scoring  
✅ **Review System** with moderation workflow  
✅ **Full-Text Search** across recipe names and descriptions  
✅ **Pagination** on all list endpoints  
✅ **View Tracking** for analytics and trending calculations  

---

## Authentication

Currently, all endpoints are **public** and do not require authentication. Future versions may include user authentication for personalized features like favorites and meal planning.

---

## Base URL

```
https://your-instance.xano.io/api:recipes
```

Replace `your-instance` with your actual Xano instance name.

---

## Response Format

All responses are returned in JSON format with the following structure:

### Successful Response

```json
{
  "items": [...],
  "curPage": 1,
  "nextPage": 2,
  "prevPage": null,
  "offset": 0,
  "itemsTotal": 60,
  "itemsReceived": 20,
  "pageTotal": 3
}
```

### Single Item Response

```json
{
  "recipe": {...},
  "ingredients": [...],
  "cuisine": {...}
}
```

---

## Error Handling

### Error Response Format

```json
{
  "code": "error_code",
  "message": "Human-readable error message"
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `notfound` | 404 | Resource not found |
| `inputerror` | 400 | Invalid input parameters |
| `unauthorized` | 401 | Authentication required |
| `forbidden` | 403 | Access denied |
| `servererror` | 500 | Internal server error |

---

## Rate Limiting

Currently no rate limiting is enforced. Best practices:
- Cache responses when possible
- Use pagination to limit data transfer
- Avoid polling; use webhooks when available

---

## API Endpoints

---

# Recipes API

Base path: `/api/recipes/`

---

## 1. List Recipes

Get all published recipes with comprehensive filtering and pagination.

**Endpoint**: `GET /list_recipes`

### Request Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `page` | integer | No | 1 | Page number (min: 1) |
| `per_page` | integer | No | 20 | Items per page (1-100) |
| `cuisine_id` | integer | No | - | Filter by cuisine ID |
| `difficulty` | string | No | - | Filter by difficulty: `easy`, `medium`, `hard` |
| `meal_type` | string | No | - | Filter by meal type: `breakfast`, `lunch`, `dinner`, `snack`, `dessert`, `appetizer` |
| `search` | string | No | - | Search in name and description |
| `is_vegetarian` | boolean | No | - | Filter vegetarian recipes |
| `is_vegan` | boolean | No | - | Filter vegan recipes |
| `is_gluten_free` | boolean | No | - | Filter gluten-free recipes |
| `is_dairy_free` | boolean | No | - | Filter dairy-free recipes |
| `sort_by` | string | No | `created_at` | Sort field |
| `sort_order` | string | No | `desc` | Sort order: `asc`, `desc` |

### Example Request

```bash
GET /api/recipes/list_recipes?cuisine_id=1&is_vegetarian=true&page=1&per_page=10
```

### Example Response

```json
{
  "items": [
    {
      "id": 2,
      "name": "Margherita Pizza",
      "slug": "margherita-pizza",
      "description": "Classic pizza with tomato, mozzarella, and basil",
      "cuisine_id": 1,
      "difficulty": "medium",
      "meal_type": "dinner",
      "prep_time_minutes": 90,
      "cook_time_minutes": 15,
      "total_time_minutes": 105,
      "servings": 4,
      "is_vegetarian": true,
      "is_vegan": false,
      "is_gluten_free": false,
      "is_dairy_free": false,
      "rating": 4.7,
      "review_count": 8,
      "view_count": 234,
      "viewed_score": 45.2,
      "image_url": null,
      "is_published": true,
      "created_at": "2025-12-05T22:00:00Z"
    }
  ],
  "curPage": 1,
  "nextPage": null,
  "prevPage": null,
  "offset": 0,
  "itemsTotal": 1,
  "itemsReceived": 1,
  "pageTotal": 1
}
```

### Use Cases

- **Browse all recipes**: `GET /list_recipes`
- **Find vegan Italian recipes**: `GET /list_recipes?cuisine_id=1&is_vegan=true`
- **Search for pasta**: `GET /list_recipes?search=pasta`
- **Easy breakfast recipes**: `GET /list_recipes?difficulty=easy&meal_type=breakfast`

---

## 2. Get Recipe by Slug

Get detailed recipe information including ingredients and cuisine. **Automatically tracks views** for trending calculations.

**Endpoint**: `GET /get_by_slug`

### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `slug` | string | Yes | Recipe slug (e.g., `spaghetti-carbonara`) |

### Example Request

```bash
GET /api/recipes/get_by_slug?slug=margherita-pizza
```

### Example Response

```json
{
  "recipe": {
    "id": 2,
    "name": "Margherita Pizza",
    "slug": "margherita-pizza",
    "description": "Classic pizza with tomato, mozzarella, and basil",
    "instructions": "Make dough. Add toppings. Bake at high heat.",
    "cuisine_id": 1,
    "difficulty": "medium",
    "meal_type": "dinner",
    "prep_time_minutes": 90,
    "cook_time_minutes": 15,
    "total_time_minutes": 105,
    "servings": 4,
    "is_vegetarian": true,
    "is_vegan": false,
    "is_gluten_free": false,
    "is_dairy_free": false,
    "rating": 4.7,
    "review_count": 8,
    "view_count": 235,
    "viewed_score": 45.2,
    "created_at": "2025-12-05T22:00:00Z"
  },
  "ingredients": [
    {
      "id": 1,
      "recipe_id": 2,
      "ingredient_id": 27,
      "ingredient_name": "Flour",
      "ingredient_category": "grain",
      "quantity": "500",
      "unit": "gram",
      "preparation_note": "all-purpose",
      "order_index": 1,
      "is_vegetarian": true,
      "is_vegan": true
    },
    {
      "id": 2,
      "recipe_id": 2,
      "ingredient_id": 1,
      "ingredient_name": "Tomato",
      "ingredient_category": "vegetable",
      "quantity": "4",
      "unit": "whole",
      "preparation_note": "crushed",
      "order_index": 2,
      "is_vegetarian": true,
      "is_vegan": true
    }
  ],
  "cuisine": {
    "id": 1,
    "name": "Italian",
    "slug": "italian",
    "description": "Traditional Italian cuisine featuring pasta, pizza, and Mediterranean flavors"
  }
}
```

### Important Notes

- ⚠️ **View Tracking**: Each call to this endpoint logs a view in `recipe_view_history`
- ⚠️ **View Count**: The `view_count` increments with each request
- ✅ **Trending Score**: Views contribute to the daily trending score calculation

---

## 3. Trending Recipes

Get recipes sorted by trending score (based on recent views).

**Endpoint**: `GET /trending`

### Request Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `page` | integer | No | 1 | Page number |
| `per_page` | integer | No | 10 | Items per page (1-50) |

### Example Request

```bash
GET /api/recipes/trending?per_page=5
```

### Example Response

```json
{
  "items": [
    {
      "id": 32,
      "name": "Ramen",
      "slug": "ramen",
      "viewed_score": 180.5,
      "view_count": 450,
      "rating": 4.9,
      "...": "..."
    },
    {
      "id": 41,
      "name": "Chicken Tikka Masala",
      "slug": "chicken-tikka-masala",
      "viewed_score": 165.2,
      "view_count": 380,
      "rating": 4.8,
      "...": "..."
    }
  ],
  "curPage": 1,
  "itemsTotal": 60
}
```

### Trending Algorithm

```
trending_score = (views_last_7_days × 3) + (views_7_to_30_days × 1)
```

- Recent views (last 7 days) are weighted **3x** more
- Scores update every 24 hours via background task
- Ensures fresh, currently popular recipes rank higher

---

## 4. Top Rated Recipes

Get recipes with highest ratings.

**Endpoint**: `GET /top_rated`

### Request Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `page` | integer | No | 1 | Page number |
| `per_page` | integer | No | 10 | Items per page (1-50) |
| `min_rating` | decimal | No | 4.0 | Minimum rating (0-5) |

### Example Request

```bash
GET /api/recipes/top_rated?min_rating=4.5&per_page=10
```

### Example Response

```json
{
  "items": [
    {
      "id": 32,
      "name": "Ramen",
      "rating": 4.9,
      "review_count": 45,
      "...": "..."
    },
    {
      "id": 9,
      "name": "Tiramisu",
      "rating": 4.9,
      "review_count": 38,
      "...": "..."
    }
  ]
}
```

---

## 5. Search Recipes

Search recipes by name or description.

**Endpoint**: `GET /search`

### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `query` | string | Yes | Search term |
| `page` | integer | No | Page number |
| `per_page` | integer | No | Items per page (1-100) |

### Example Request

```bash
GET /api/recipes/search?query=chicken&page=1
```

### Example Response

```json
{
  "items": [
    {
      "id": 11,
      "name": "Chicken Tacos",
      "description": "Flavorful chicken tacos with fresh toppings",
      "...": "..."
    },
    {
      "id": 21,
      "name": "Kung Pao Chicken",
      "description": "Spicy Sichuan chicken with peanuts",
      "...": "..."
    }
  ],
  "itemsTotal": 8
}
```

### Search Behavior

- Searches in both `name` and `description` fields
- Case-insensitive partial matching
- Results sorted by rating (descending)

---

## 6. Recipe Statistics

Get comprehensive statistics for a recipe.

**Endpoint**: `GET /stats`

### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `recipe_id` | integer | Yes | Recipe ID |

### Example Request

```bash
GET /api/recipes/stats?recipe_id=32
```

### Example Response

```json
{
  "recipe_id": 32,
  "recipe_name": "Ramen",
  "total_views": 450,
  "views_last_7_days": 85,
  "total_reviews": 45,
  "average_rating": 4.9,
  "viewed_score": 180.5
}
```

---

# Cuisines API

Base path: `/api/cuisines/`

---

## 7. List Cuisines

Get all available cuisines.

**Endpoint**: `GET /list`

### Example Request

```bash
GET /api/cuisines/list
```

### Example Response

```json
[
  {
    "id": 1,
    "name": "Italian",
    "slug": "italian",
    "description": "Traditional Italian cuisine featuring pasta, pizza, and Mediterranean flavors",
    "created_at": "2025-12-05T22:00:00Z"
  },
  {
    "id": 2,
    "name": "Mexican",
    "slug": "mexican",
    "description": "Vibrant Mexican cuisine with bold spices, tacos, and authentic flavors",
    "created_at": "2025-12-05T22:00:00Z"
  }
]
```

### Available Cuisines

1. Italian
2. Mexican
3. Chinese
4. Japanese
5. Indian
6. French
7. Thai
8. Greek
9. American
10. Mediterranean
11. Korean
12. Spanish
13. Vietnamese
14. Middle Eastern
15. Caribbean

---

## 8. Recipes by Cuisine

Get all recipes for a specific cuisine.

**Endpoint**: `GET /recipes`

### Request Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `cuisine_id` | integer | Yes | - | Cuisine ID |
| `page` | integer | No | 1 | Page number |
| `per_page` | integer | No | 20 | Items per page (1-100) |

### Example Request

```bash
GET /api/cuisines/recipes?cuisine_id=1&page=1
```

### Example Response

```json
{
  "cuisine": {
    "id": 1,
    "name": "Italian",
    "slug": "italian",
    "description": "Traditional Italian cuisine..."
  },
  "recipes": {
    "items": [
      {
        "id": 1,
        "name": "Spaghetti Carbonara",
        "...": "..."
      }
    ],
    "curPage": 1,
    "itemsTotal": 10
  }
}
```

---

# Reviews API

Base path: `/api/reviews/`

---

## 9. Submit Review

Submit a review for a recipe. Reviews require approval before appearing publicly.

**Endpoint**: `POST /submit`

### Request Body

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `recipe_id` | integer | Yes | min: 1 | Recipe ID |
| `reviewer_name` | string | Yes | trim | Reviewer's name |
| `reviewer_email` | string | No | email, trim, lower | Reviewer's email |
| `rating` | integer | Yes | 1-5 | Star rating |
| `review_text` | string | No | trim | Review content |

### Example Request

```bash
POST /api/reviews/submit
Content-Type: application/json

{
  "recipe_id": 1,
  "reviewer_name": "John Doe",
  "reviewer_email": "john@example.com",
  "rating": 5,
  "review_text": "Amazing recipe! My family loved it. The instructions were clear and easy to follow."
}
```

### Example Response

```json
{
  "message": "Review submitted successfully and pending approval",
  "review": {
    "id": 123,
    "recipe_id": 1,
    "reviewer_name": "John Doe",
    "reviewer_email": "john@example.com",
    "rating": 5,
    "review_text": "Amazing recipe! My family loved it...",
    "is_approved": false,
    "is_verified_purchase": false,
    "helpful_count": 0,
    "created_at": "2025-12-06T00:30:00Z"
  }
}
```

### Review Workflow

1. ✅ Review submitted with `is_approved = false`
2. ⏳ Admin reviews and approves/rejects
3. ✅ Approved reviews appear in public listings
4. 📊 Recipe rating recalculated after approval

---

## 10. Get Recipe Reviews

Get reviews for a specific recipe.

**Endpoint**: `GET /list`

### Request Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `recipe_id` | integer | Yes | - | Recipe ID |
| `page` | integer | No | 1 | Page number |
| `per_page` | integer | No | 10 | Items per page (1-50) |
| `approved_only` | boolean | No | true | Show only approved reviews |

### Example Request

```bash
GET /api/reviews/list?recipe_id=1&approved_only=true
```

### Example Response

```json
{
  "items": [
    {
      "id": 123,
      "recipe_id": 1,
      "reviewer_name": "John Doe",
      "rating": 5,
      "review_text": "Amazing recipe!...",
      "is_approved": true,
      "helpful_count": 12,
      "created_at": "2025-12-06T00:30:00Z"
    }
  ],
  "curPage": 1,
  "itemsTotal": 12
}
```

---

# Ingredients API

Base path: `/api/ingredients/`

---

## 11. List Ingredients

Get all ingredients with filtering options.

**Endpoint**: `GET /list`

### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `page` | integer | No | Page number |
| `per_page` | integer | No | Items per page (1-100) |
| `category` | string | No | Filter by category |
| `search` | string | No | Search ingredient names |
| `is_vegetarian` | boolean | No | Filter vegetarian ingredients |
| `is_vegan` | boolean | No | Filter vegan ingredients |

### Example Request

```bash
GET /api/ingredients/list?category=vegetable&is_vegan=true
```

### Example Response

```json
{
  "items": [
    {
      "id": 1,
      "name": "Tomato",
      "slug": "tomato",
      "category": "vegetable",
      "is_vegetarian": true,
      "is_vegan": true,
      "is_gluten_free": true,
      "is_dairy_free": true
    }
  ],
  "itemsTotal": 15
}
```

### Ingredient Categories

- `vegetable`
- `fruit`
- `meat`
- `poultry`
- `seafood`
- `dairy`
- `grain`
- `legume`
- `herb`
- `spice`
- `oil`
- `condiment`
- `sweetener`

---

# Allergies API

Base path: `/api/allergies/`

---

## 12. List Allergies

Get all allergens.

**Endpoint**: `GET /list`

### Example Request

```bash
GET /api/allergies/list
```

### Example Response

```json
[
  {
    "id": 1,
    "name": "Peanuts",
    "slug": "peanuts",
    "description": "Peanut allergy can cause severe reactions",
    "severity": "severe",
    "created_at": "2025-12-05T22:00:00Z"
  },
  {
    "id": 2,
    "name": "Tree Nuts",
    "slug": "tree-nuts",
    "description": "Includes almonds, walnuts, cashews, and other tree nuts",
    "severity": "severe",
    "created_at": "2025-12-05T22:00:00Z"
  }
]
```

### Severity Levels

- `severe` - Life-threatening reactions possible
- `moderate` - Significant symptoms
- `mild` - Minor discomfort

---

# Code Examples

## JavaScript / Fetch API

### Get Trending Recipes

```javascript
async function getTrendingRecipes() {
  const response = await fetch(
    'https://your-instance.xano.io/api:recipes/trending?per_page=10'
  );
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  const data = await response.json();
  return data.items;
}

// Usage
getTrendingRecipes()
  .then(recipes => console.log(recipes))
  .catch(error => console.error('Error:', error));
```

### Search Recipes

```javascript
async function searchRecipes(query) {
  const params = new URLSearchParams({ query, per_page: 20 });
  
  const response = await fetch(
    `https://your-instance.xano.io/api:recipes/search?${params}`
  );
  
  const data = await response.json();
  return data.items;
}

// Usage
searchRecipes('pasta').then(recipes => {
  recipes.forEach(recipe => {
    console.log(`${recipe.name} - Rating: ${recipe.rating}`);
  });
});
```

### Submit Review

```javascript
async function submitReview(reviewData) {
  const response = await fetch(
    'https://your-instance.xano.io/api:reviews/submit',
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(reviewData)
    }
  );
  
  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.message);
  }
  
  return await response.json();
}

// Usage
submitReview({
  recipe_id: 1,
  reviewer_name: 'John Doe',
  reviewer_email: 'john@example.com',
  rating: 5,
  review_text: 'Excellent recipe!'
}).then(result => {
  console.log('Review submitted:', result.message);
});
```

---

## Python / Requests

### Get Recipe by Slug

```python
import requests

def get_recipe(slug):
    url = f"https://your-instance.xano.io/api:recipes/get_by_slug"
    params = {"slug": slug}
    
    response = requests.get(url, params=params)
    response.raise_for_status()
    
    return response.json()

# Usage
recipe = get_recipe("spaghetti-carbonara")
print(f"Recipe: {recipe['recipe']['name']}")
print(f"Ingredients: {len(recipe['ingredients'])}")
```

### Filter Recipes

```python
def get_vegan_italian_recipes():
    url = "https://your-instance.xano.io/api:recipes/list_recipes"
    params = {
        "cuisine_id": 1,
        "is_vegan": True,
        "per_page": 20
    }
    
    response = requests.get(url, params=params)
    response.raise_for_status()
    
    data = response.json()
    return data["items"]

# Usage
recipes = get_vegan_italian_recipes()
for recipe in recipes:
    print(f"{recipe['name']} - {recipe['total_time_minutes']} min")
```

---

## cURL

### Get Top Rated Recipes

```bash
curl -X GET "https://your-instance.xano.io/api:recipes/top_rated?min_rating=4.5&per_page=5"
```

### Submit Review

```bash
curl -X POST "https://your-instance.xano.io/api:reviews/submit" \
  -H "Content-Type: application/json" \
  -d '{
    "recipe_id": 1,
    "reviewer_name": "Jane Smith",
    "rating": 5,
    "review_text": "Perfect recipe!"
  }'
```

---

# Changelog

## Version 1.0 (December 2025)

### Added
- ✅ 12 API endpoints across 5 domains
- ✅ 60 sample recipes across 15 cuisines
- ✅ Trending system with weighted scoring
- ✅ Review submission and moderation
- ✅ Comprehensive filtering options
- ✅ Full-text search
- ✅ View tracking and analytics
- ✅ Background task for trending calculations

### Features
- Pagination on all list endpoints
- Dietary preference filtering
- Recipe statistics endpoint
- Ingredient and allergy information
- Cuisine-based browsing

---

## Support

For questions, issues, or feature requests:
- **Documentation**: This file
- **API Status**: Check Xano dashboard
- **Updates**: Monitor changelog section

---

## Best Practices

### Performance
- ✅ Use pagination for large datasets
- ✅ Cache responses when appropriate
- ✅ Filter results server-side rather than client-side
- ✅ Use specific fields rather than fetching all data

### Data Quality
- ✅ Validate input before submission
- ✅ Handle errors gracefully
- ✅ Provide meaningful error messages to users
- ✅ Log failed requests for debugging

### User Experience
- ✅ Show loading states during API calls
- ✅ Implement retry logic for failed requests
- ✅ Cache frequently accessed data
- ✅ Provide search suggestions

---

**End of Documentation**

*Last Updated: December 6, 2025*  
*API Version: 1.0*  
*Documentation Version: 1.0*
