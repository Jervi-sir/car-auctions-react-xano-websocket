# Database Seeding Functions

This document describes the individual seed functions created for each table in the Food Recipe API.

## Overview

Each table has its own dedicated seed function, prefixed with numbers (3-9) to indicate execution order. There's also a master function (10) that orchestrates seeding all tables in the correct sequence.

## Seed Functions

### 3_seed_cuisines.xs
**Purpose**: Seeds the `cuisine` table with 10 popular cuisine types

**Data Created**:
- Italian
- Mexican
- Chinese
- Indian
- Japanese
- French
- Thai
- Mediterranean
- American
- Middle Eastern

**Records**: 10 cuisines

---

### 4_seed_allergies.xs
**Purpose**: Seeds the `allergy` table with common allergens

**Data Created**:
- Peanuts (severe)
- Tree Nuts (severe)
- Dairy (moderate)
- Eggs (moderate)
- Soy (moderate)
- Wheat/Gluten (moderate)
- Fish (severe)
- Shellfish (severe)
- Sesame (moderate)
- Sulfites (mild)

**Records**: 10 allergies with severity levels

---

### 5_seed_ingredients.xs
**Purpose**: Seeds the `ingredient` table with common cooking ingredients

**Data Created**: 20 ingredients including:
- Vegetables (tomato, garlic, onion, bell pepper)
- Proteins (chicken breast, salmon, shrimp, ground beef, eggs)
- Grains (pasta, rice, flour)
- Dairy (mozzarella, butter, parmesan)
- Oils & Condiments (olive oil, soy sauce)
- Herbs & Spices (basil, ginger)
- Alternatives (coconut milk)

**Features**:
- Dietary flags (vegetarian, vegan, gluten-free, dairy-free)
- Category classification
- Allergy associations (ready for linking)

**Records**: 20 ingredients

---

### 6_seed_recipes.xs
**Purpose**: Seeds the `recipe` table with diverse recipes from different cuisines

**Data Created**: 10 complete recipes:
1. Spaghetti Carbonara (Italian)
2. Chicken Tikka Masala (Indian)
3. Pad Thai (Thai)
4. Margherita Pizza (Italian)
5. Beef Tacos (Mexican)
6. California Sushi Rolls (Japanese)
7. Greek Salad (Mediterranean)
8. Kung Pao Chicken (Chinese)
9. Classic Hummus (Middle Eastern)
10. Fluffy Pancakes (American)

**Features**:
- Complete instructions
- Timing information (prep, cook, total)
- Difficulty levels
- Meal types
- Dietary flags
- Initial ratings
- Published status

**Records**: 10 recipes

---

### 7_seed_recipe_ingredients.xs
**Purpose**: Seeds the `recipe_ingredient` junction table linking recipes to ingredients

**Data Created**:
- Ingredient lists for all 10 recipes
- Quantities and units
- Preparation notes (chopped, diced, minced, etc.)
- Order index for proper display

**Features**:
- Realistic ingredient quantities
- Proper measurement units
- Preparation instructions
- Ordered ingredient lists

**Records**: ~30 recipe-ingredient relationships

---

### 8_seed_recipe_reviews.xs
**Purpose**: Seeds the `recipe_review` table with realistic user reviews

**Data Created**:
- 21 reviews across all recipes
- Varied ratings (4-5 stars)
- Detailed review text
- Reviewer information
- Helpful counts

**Features**:
- Authentic review content
- Mix of verified and unverified reviews
- All reviews pre-approved
- Varied helpful counts (9-42)
- Realistic reviewer names and emails

**Records**: 21 reviews

---

### 9_seed_recipe_view_history.xs
**Purpose**: Seeds the `recipe_view_history` table for trending calculations

**Data Created**:
- 26 view records across different recipes
- Varied view counts to simulate trending:
  - Margherita Pizza: 7 views (most trending)
  - Chicken Tikka Masala: 5 views
  - Classic Hummus: 4 views
  - Spaghetti Carbonara: 3 views
  - Greek Salad: 3 views
  - Pad Thai: 2 views
  - Fluffy Pancakes: 2 views
  - Beef Tacos: 1 view

**Features**:
- Realistic IP addresses
- Various user agents (browsers, devices)
- Different referrer sources
- Timestamp data for trending algorithm

**Records**: 26 view history entries

---

### 10_seed_all_tables.xs
**Purpose**: Simplified seed function for base tables (cuisines and allergies)

**Note**: Due to Xanoscript limitations (functions cannot call other functions), this only seeds the base tables. For complete seeding, run the individual functions in order (see below).

**Seeds**:
- Cuisines (10 records)
- Allergies (10 records)

---

## Usage

### Important: Seeding Order

**Xanoscript functions cannot call other functions**, so you must run each seed function individually in the correct dependency order:

### Step-by-Step Seeding Process

Run these functions **in this exact order**:

1. **Base Tables** (no dependencies):
   ```
   3_seed_cuisines
   4_seed_allergies
   ```

2. **Ingredients** (depends on allergies):
   ```
   5_seed_ingredients
   ```

3. **Recipes** (depends on cuisines and allergies):
   ```
   6_seed_recipes
   ```

4. **Recipe Relationships** (depends on recipes and ingredients):
   ```
   7_seed_recipe_ingredients
   ```

5. **Recipe Reviews** (depends on recipes):
   ```
   8_seed_recipe_reviews
   ```

6. **Recipe View History** (depends on recipes):
   ```
   9_seed_recipe_view_history
   ```

### Quick Start Option

If you only want to seed the base tables quickly, you can run:
```
10_seed_all_tables
```

This seeds cuisines and allergies only. You'll still need to run functions 5-9 individually for complete data.

---

## Data Truncation

**Important**: Each seed function truncates its table before seeding:

```xanoscript
db.truncate [table_name] {
  reset = true
}
```

This means:
- ✅ All existing data is removed
- ✅ Auto-increment IDs are reset
- ✅ Safe to run multiple times
- ⚠️ All previous data will be lost

---

## Dependencies

The seed functions must be run in order due to foreign key relationships:

```
Base Tables (no dependencies):
├── 3_seed_cuisines
└── 4_seed_allergies

Dependent Tables:
├── 5_seed_ingredients (needs: allergies)
├── 6_seed_recipes (needs: cuisines, allergies)
├── 7_seed_recipe_ingredients (needs: recipes, ingredients)
├── 8_seed_recipe_reviews (needs: recipes)
└── 9_seed_recipe_view_history (needs: recipes)
```

The master function `10_seed_all_tables` handles this automatically.

---

## Testing the API

After seeding, you can test various API endpoints:

### List Recipes
```
GET /recipes
```

### Get Recipe by Slug
```
GET /recipe/margherita-pizza
```

### Filter by Cuisine
```
GET /recipes?cuisine_id=1
```

### Get Trending Recipes
```
GET /recipes/trending
```

### Search Recipes
```
GET /recipes?search=chicken
```

---

## Summary Statistics

After running `seed_all_tables`, you'll have:

| Table | Records |
|-------|---------|
| Cuisines | 10 |
| Allergies | 10 |
| Ingredients | 20 |
| Recipes | 10 |
| Recipe Ingredients | ~30 |
| Recipe Reviews | 21 |
| Recipe View History | 26 |

**Total**: ~127 records across all tables

---

## Notes

1. **Realistic Data**: All seed data is production-ready with realistic values
2. **Dietary Flags**: Properly set on ingredients and recipes
3. **Trending Data**: View history creates realistic trending patterns
4. **Reviews**: Authentic review content with varied ratings
5. **Relationships**: All foreign keys properly linked
6. **Slugs**: SEO-friendly slugs for all recipes and cuisines

---

## Next Steps

After seeding:
1. ✅ Test API endpoints
2. ✅ Run trending score calculation task
3. ✅ Verify data relationships
4. ✅ Test filtering and search
5. ✅ Validate review aggregations
