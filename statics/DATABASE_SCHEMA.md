# Food, Recipe & Allergies Database Schema

## Overview

This database schema is designed for a production-ready public API that enables developers to fetch and filter recipes, ingredients, cuisines, and allergy information. The schema follows Xanoscript best practices with proper indexing, relationships, and data validation.

## Database Tables

### Table Relationship Hierarchy

The tables are prefixed with numbers (1-7) to indicate their dependency order:

```
1_cuisine (base)
2_allergy (base)
3_ingredient (depends on: allergy)
4_recipe (depends on: cuisine, allergy)
5_recipe_ingredient (junction: recipe ↔ ingredient)
6_recipe_review (depends on: recipe)
7_recipe_view_history (depends on: recipe)
```

---

## Table Definitions

### 1. `cuisine` - Cuisine Types

**Purpose**: Categorize recipes by cuisine type (e.g., Italian, Mexican, Asian)

**Key Fields**:
- `id` - Primary key
- `name` - Cuisine name (e.g., "Italian")
- `slug` - URL-friendly identifier (e.g., "italian")
- `description` - Optional description
- `image_url` - Optional cuisine image

**Indexes**:
- Primary key on `id`
- Unique index on `slug`
- Index on `name` for sorting

**Relationships**: Referenced by `recipe.cuisine_id`

---

### 2. `allergy` - Allergen Types

**Purpose**: Track allergen information (e.g., peanuts, dairy, gluten)

**Key Fields**:
- `id` - Primary key
- `name` - Allergen name (e.g., "Peanuts")
- `slug` - URL-friendly identifier (e.g., "peanuts")
- `description` - Optional description
- `severity` - Severity level (mild, moderate, severe)

**Indexes**:
- Primary key on `id`
- Unique index on `slug`
- Index on `name` for sorting

**Relationships**: 
- Referenced by `ingredient.allergy_ids` (many-to-many)
- Referenced by `recipe.allergy_ids` (many-to-many)

---

### 3. `ingredient` - Recipe Ingredients

**Purpose**: Store ingredient information with dietary and allergen data

**Key Fields**:
- `id` - Primary key
- `name` - Ingredient name (e.g., "Tomato")
- `slug` - URL-friendly identifier
- `category` - Category (vegetable, fruit, meat, dairy, etc.)
- `is_vegetarian`, `is_vegan`, `is_gluten_free`, `is_dairy_free` - Dietary flags
- `allergy_ids` - Array of allergy IDs (foreign key to `allergy`)
- `nutritional_info` - JSON field for nutritional data
- `image_url` - Optional ingredient image

**Indexes**:
- Primary key on `id`
- Unique index on `slug`
- Indexes on `name`, `category`, dietary flags
- GIN index on `nutritional_info` for JSON queries

**Relationships**: 
- References `allergy` table (many-to-many)
- Referenced by `recipe_ingredient.ingredient_id`

---

### 4. `recipe` - Main Recipe Table

**Purpose**: Store complete recipe information

**Key Fields**:

**Basic Info**:
- `id` - Primary key
- `name` - Recipe name
- `slug` - URL-friendly identifier
- `description` - Recipe description
- `instructions` - Cooking instructions

**Categorization**:
- `cuisine_id` - Foreign key to `cuisine`
- `difficulty` - Enum: easy, medium, hard, expert
- `meal_type` - Enum: breakfast, lunch, dinner, snack, dessert, appetizer

**Timing**:
- `prep_time_minutes` - Preparation time
- `cook_time_minutes` - Cooking time
- `total_time_minutes` - Total time
- `servings` - Number of servings (default: 4)

**Dietary Info**:
- `is_vegetarian`, `is_vegan`, `is_gluten_free`, `is_dairy_free` - Dietary flags
- `allergy_ids` - Array of allergy IDs

**Media**:
- `featured_image` - Main recipe image
- `gallery_images` - Array of additional images
- `video_url` - Optional video

**Engagement Metrics**:
- `rating` - Average rating (0-5)
- `review_count` - Total number of reviews
- `view_count` - Total views
- `viewed_score` - Trending score based on recent views

**Publishing**:
- `is_published` - Publication status
- `published_at` - Publication timestamp

**Metadata**:
- `metadata` - JSON field for additional flexible data
- `created_at`, `updated_at` - Timestamps

**Indexes**:
- Primary key on `id`
- Unique index on `slug`
- Indexes on all filterable fields (cuisine, difficulty, meal_type, ratings, etc.)
- GIN index on `metadata`

**Relationships**:
- References `cuisine` table
- References `allergy` table (many-to-many)
- Referenced by `recipe_ingredient`, `recipe_review`, `recipe_view_history`

---

### 5. `recipe_ingredient` - Recipe-Ingredient Junction

**Purpose**: Link recipes to ingredients with quantity and preparation details

**Key Fields**:
- `id` - Primary key
- `recipe_id` - Foreign key to `recipe`
- `ingredient_id` - Foreign key to `ingredient`
- `quantity` - Amount (e.g., "2", "1/2", "1.5")
- `unit` - Unit of measurement (cups, tablespoons, grams, etc.)
- `preparation_note` - Preparation instructions (chopped, diced, minced, etc.)
- `order_index` - Display order in recipe

**Indexes**:
- Primary key on `id`
- Index on `recipe_id`
- Index on `ingredient_id`
- Composite index on `recipe_id` + `order_index` for ordered retrieval

**Relationships**:
- References `recipe` table
- References `ingredient` table

---

### 6. `recipe_review` - Recipe Reviews & Ratings

**Purpose**: Store user reviews and ratings for recipes

**Key Fields**:
- `id` - Primary key
- `recipe_id` - Foreign key to `recipe`
- `reviewer_name` - Name of reviewer
- `reviewer_email` - Optional email (validated)
- `rating` - Rating (1-5 stars, validated)
- `review_text` - Optional review text
- `review_images` - Array of images from reviewer
- `is_approved` - Moderation flag
- `is_verified_purchase` - If user actually made the recipe
- `helpful_count` - Number of users who found this helpful

**Indexes**:
- Primary key on `id`
- Index on `recipe_id`
- Index on `rating` for sorting
- Index on `is_approved` for filtering
- Composite index on `recipe_id` + `created_at` for chronological retrieval

**Relationships**:
- References `recipe` table

---

### 7. `recipe_view_history` - Recipe View Tracking

**Purpose**: Track individual recipe views for trending calculations and analytics

**Key Fields**:
- `id` - Primary key
- `recipe_id` - Foreign key to `recipe`
- `viewer_ip` - IP address (for analytics)
- `user_agent` - Browser user agent
- `referrer` - Traffic source
- `viewed_at` - Timestamp of view

**Indexes**:
- Primary key on `id`
- Index on `recipe_id`
- Index on `viewed_at` for time-based queries
- Composite index on `recipe_id` + `viewed_at` for trending calculations

**Relationships**:
- References `recipe` table

**Usage**: This table enables:
- Trending recipe calculations (views in last 7 days)
- Traffic analytics
- Popular recipe identification
- View count tracking

---

## Data Relationships

### One-to-Many Relationships

1. **cuisine → recipe**: One cuisine can have many recipes
2. **recipe → recipe_ingredient**: One recipe has many ingredients
3. **recipe → recipe_review**: One recipe has many reviews
4. **recipe → recipe_view_history**: One recipe has many view records
5. **ingredient → recipe_ingredient**: One ingredient can be in many recipes

### Many-to-Many Relationships

1. **recipe ↔ ingredient**: Through `recipe_ingredient` junction table
2. **recipe ↔ allergy**: Via `recipe.allergy_ids` array
3. **ingredient ↔ allergy**: Via `ingredient.allergy_ids` array

---

## Key Features

### 1. **Dietary Filtering**
All recipes and ingredients have boolean flags for:
- Vegetarian
- Vegan
- Gluten-free
- Dairy-free

This enables fast filtering without complex joins.

### 2. **Allergen Tracking**
- Allergies are tracked at both ingredient and recipe levels
- Array-based relationships allow efficient "allergy-safe" queries
- Severity levels help prioritize allergen warnings

### 3. **Engagement Metrics**
- Real-time rating calculations
- View tracking for trending algorithms
- Review moderation system
- Helpful vote tracking on reviews

### 4. **Performance Optimization**
- Strategic indexing on all filterable fields
- Composite indexes for common query patterns
- GIN indexes for JSON fields
- Unique constraints on slugs for SEO-friendly URLs

### 5. **Flexible Metadata**
- JSON fields for extensibility
- Nutritional information storage
- Custom metadata per recipe

---

## API Use Cases

This schema supports the following API operations:

### Recipe Operations
- ✅ List recipes with pagination
- ✅ Filter by cuisine, difficulty, meal type
- ✅ Filter by dietary requirements (vegetarian, vegan, etc.)
- ✅ Filter by allergens (exclude recipes with specific allergens)
- ✅ Search recipes by name/description
- ✅ Get recipe details with ingredients
- ✅ Get trending recipes (based on recent views)
- ✅ Get top-rated recipes
- ✅ Get recipes by specific ingredients

### Ingredient Operations
- ✅ List ingredients with filtering
- ✅ Filter by category
- ✅ Filter by dietary flags
- ✅ Get ingredient details
- ✅ Find recipes using specific ingredients

### Review Operations
- ✅ Submit recipe reviews
- ✅ Get reviews for a recipe
- ✅ Filter reviews by rating
- ✅ Moderate reviews (approve/reject)

### Allergy Operations
- ✅ List all allergies
- ✅ Find allergy-safe recipes
- ✅ Get recipes excluding specific allergens

### Analytics Operations
- ✅ Track recipe views
- ✅ Calculate trending scores
- ✅ Generate view statistics

---

## Next Steps

With the database schema in place, the next phase involves:

1. **Create API Endpoints** - Build RESTful endpoints for all operations
2. **Implement Seeding Functions** - Populate tables with sample data
3. **Create API Group Definitions** - Organize endpoints into logical groups
4. **Add Validation Logic** - Implement business rules and constraints
5. **Build Trending Algorithm** - Create task to calculate trending scores
6. **Documentation** - Generate API documentation for developers

---

## Best Practices Applied

✅ **Proper Indexing**: All filterable and sortable fields are indexed
✅ **Foreign Key Relationships**: Explicit table references for data integrity
✅ **Input Validation**: Filters on all text inputs (trim, lower)
✅ **Range Validation**: Min/max constraints on ratings and numeric fields
✅ **Null Safety**: Optional fields marked with `?`
✅ **Default Values**: Sensible defaults for boolean and numeric fields
✅ **Timestamp Tracking**: Created/updated timestamps on all relevant tables
✅ **Unique Constraints**: Slugs are unique for SEO-friendly URLs
✅ **Composite Indexes**: Optimized for common query patterns
✅ **JSON Flexibility**: Metadata fields for extensibility
