# Database Seeding Functions ✅

## Overview

All seed functions have been created to populate the database tables with realistic sample data. The functions are numbered (1-7) to match their corresponding tables, plus a master function (10) to seed all tables at once.

---

## Seed Functions Created

### Individual Seed Functions

#### 1️⃣ `1_seed_cuisines.xs`
**Seeds**: `cuisine` table  
**Dependencies**: None (base table)  
**Records Created**: 10 cuisines

**Cuisines Seeded**:
- Italian
- Mexican
- Chinese
- Japanese
- Indian
- French
- Thai
- Greek
- American
- Mediterranean

**Features**:
- Unique slugs for each cuisine
- Descriptive text for each cuisine type
- Truncates table before seeding (with reset)

---

#### 2️⃣ `2_seed_allergies.xs`
**Seeds**: `allergy` table  
**Dependencies**: None (base table)  
**Records Created**: 10 allergens

**Allergies Seeded**:
- Peanuts (severe)
- Tree Nuts (severe)
- Dairy (moderate)
- Eggs (moderate)
- Soy (moderate)
- Wheat (moderate)
- Fish (severe)
- Shellfish (severe)
- Sesame (moderate)
- Sulfites (mild)

**Features**:
- Severity levels assigned (mild, moderate, severe)
- Descriptions for each allergen
- Truncates table before seeding

---

#### 3️⃣ `3_seed_ingredients.xs`
**Seeds**: `ingredient` table  
**Dependencies**: `allergy` table  
**Records Created**: 20 ingredients

**Ingredients Seeded**:
- Vegetables: Tomato, Garlic, Onion, Bell Pepper
- Proteins: Chicken Breast, Salmon, Ground Beef, Eggs
- Dairy: Parmesan Cheese, Butter, Milk
- Grains: Pasta, Rice, All-Purpose Flour
- Herbs/Spices: Basil, Black Pepper, Salt
- Others: Olive Oil, Lemon, Sugar

**Features**:
- Complete dietary flags (vegetarian, vegan, gluten-free, dairy-free)
- Category assignment for each ingredient
- Allergy relationships (currently empty arrays, can be populated)
- Truncates table before seeding

---

#### 4️⃣ `4_seed_recipes.xs`
**Seeds**: `recipe` table  
**Dependencies**: `cuisine`, `allergy` tables  
**Records Created**: 10 recipes

**Recipes Seeded**:
1. Spaghetti Carbonara (Italian, Medium, Dinner)
2. Chicken Tacos (Mexican, Easy, Dinner)
3. Vegetable Stir Fry (Chinese, Easy, Dinner) - Vegan
4. Salmon Teriyaki (Japanese, Medium, Dinner)
5. Chicken Curry (Indian, Medium, Dinner)
6. French Onion Soup (French, Medium, Lunch)
7. Pad Thai (Thai, Medium, Dinner)
8. Greek Salad (Greek, Easy, Lunch) - Vegetarian
9. Classic Burger (American, Easy, Dinner)
10. Mediterranean Quinoa Bowl (Mediterranean, Easy, Lunch) - Vegan

**Features**:
- Complete recipe information (name, slug, description, instructions)
- Timing data (prep, cook, total time)
- Difficulty levels (easy, medium, hard)
- Meal types (breakfast, lunch, dinner, snack)
- Dietary flags
- Initial ratings (4.3 - 4.8)
- Published status set to true
- Truncates table before seeding

---

#### 5️⃣ `5_seed_recipe_ingredients.xs`
**Seeds**: `recipe_ingredient` junction table  
**Dependencies**: `recipe`, `ingredient` tables  
**Records Created**: ~40 ingredient links

**Features**:
- Links recipes to ingredients with quantities
- Includes measurement units (cups, tablespoons, pounds, etc.)
- Preparation notes (diced, minced, sliced, etc.)
- Order index for proper ingredient listing
- Each recipe has 3-5 ingredients
- Truncates table before seeding

**Example Relationships**:
- Spaghetti Carbonara → Pasta, Eggs, Parmesan Cheese
- Chicken Tacos → Chicken Breast, Onion, Garlic
- Greek Salad → Tomato, Onion, Olive Oil, Lemon

---

#### 6️⃣ `6_seed_recipe_reviews.xs`
**Seeds**: `recipe_review` table  
**Dependencies**: `recipe` table  
**Records Created**: 16 reviews

**Features**:
- Realistic reviewer names and emails
- Ratings from 4-5 stars
- Detailed review text
- All reviews approved for immediate display
- Helpful counts (3-15)
- Multiple reviews for popular recipes
- Truncates table before seeding

**Review Distribution**:
- Most recipes have 1-2 reviews
- Popular recipes (Salmon Teriyaki, Chicken Tacos) have more reviews
- Variety of perspectives and cooking tips

---

#### 7️⃣ `7_seed_recipe_view_history.xs`
**Seeds**: `recipe_view_history` table  
**Dependencies**: `recipe` table  
**Records Created**: 25 view records

**Features**:
- Simulated views from various IP addresses
- Different user agents (desktop, mobile, tablet)
- Various referrer sources (Google, Facebook, Pinterest, etc.)
- Distributed across all recipes
- More views for "trending" recipes
- Truncates table before seeding

**View Distribution**:
- Recipe 4 (Salmon Teriyaki): 5 views - Most popular
- Recipe 2 (Chicken Tacos): 4 views - Very popular
- Recipe 1 (Spaghetti Carbonara): 3 views - Popular
- Recipe 7 (Pad Thai): 3 views - Popular
- Other recipes: 1-2 views each

---

### Master Seed Function

#### 🎯 `10_seed_all_tables.xs`
**Seeds**: All tables in correct dependency order  
**Dependencies**: All individual seed functions

**Execution Order**:
1. `seed_cuisines` - Base table
2. `seed_allergies` - Base table
3. `seed_ingredients` - Depends on allergies
4. `seed_recipes` - Depends on cuisines & allergies
5. `seed_recipe_ingredients` - Depends on recipes & ingredients
6. `seed_recipe_reviews` - Depends on recipes
7. `seed_recipe_view_history` - Depends on recipes

**Features**:
- Calls all seed functions in correct order
- Progress logging for each step
- Returns comprehensive summary with all results
- Error handling (if any seed function fails, it will be logged)

**Response Format**:
```json
{
  "success": true,
  "message": "All tables seeded successfully",
  "tables_seeded": 7,
  "details": {
    "cuisines": {"result": "...", "count": 10},
    "allergies": {"result": "...", "count": 10},
    "ingredients": {"result": "...", "count": 20},
    "recipes": {"result": "...", "count": 10},
    "recipe_ingredients": {"result": "...", "count": 40},
    "reviews": {"result": "...", "count": 16},
    "view_history": {"result": "...", "count": 25}
  }
}
```

---

## How to Use

### Option 1: Seed All Tables at Once (Recommended)

Simply call the master seed function:

```
Call function: seed_all_tables
```

This will seed all 7 tables in the correct order with one function call.

### Option 2: Seed Tables Individually

Call each seed function in order:

```
1. Call function: seed_cuisines
2. Call function: seed_allergies
3. Call function: seed_ingredients
4. Call function: seed_recipes
5. Call function: seed_recipe_ingredients
6. Call function: seed_recipe_reviews
7. Call function: seed_recipe_view_history
```

**⚠️ Important**: You must seed in this order due to foreign key dependencies!

---

## Data Summary

| Table | Records | Key Features |
|-------|---------|--------------|
| `cuisine` | 10 | Popular world cuisines |
| `allergy` | 10 | Common allergens with severity |
| `ingredient` | 20 | Essential cooking ingredients |
| `recipe` | 10 | Diverse recipes across cuisines |
| `recipe_ingredient` | ~40 | Recipe-ingredient relationships |
| `recipe_review` | 16 | User reviews with ratings |
| `recipe_view_history` | 25 | Simulated view tracking |

**Total Records**: ~121 records across all tables

---

## Testing the Seeded Data

After seeding, you can test with these queries:

### Get All Cuisines
```xanoscript
db.query cuisine {
  return = {type: "list"}
}
```

### Get Published Recipes
```xanoscript
db.query recipe {
  where = $db.recipe.is_published
  return = {type: "list"}
}
```

### Get Recipe with Ingredients
```xanoscript
db.query recipe {
  where = $db.recipe.slug == "spaghetti-carbonara"
  return = {type: "single"}
} as $recipe

db.query recipe_ingredient {
  where = $db.recipe_ingredient.recipe_id == $recipe.id
  return = {type: "list"}
}
```

### Get Most Viewed Recipes
```xanoscript
db.query recipe_view_history {
  return = {type: "list"}
}
// Group by recipe_id to see view counts
```

---

## Customization

### Adding More Data

To add more records to any table:

1. **Edit the individual seed function** (e.g., `1_seed_cuisines.xs`)
2. **Add more `db.add` blocks** with your data
3. **Update the count** in the response
4. **Re-run the seed function**

### Modifying Existing Data

To change seeded data:

1. **Edit the seed function**
2. **Modify the `data` object** in the `db.add` block
3. **Re-run the seed function** (it will truncate and re-seed)

### Linking Allergens to Ingredients

Currently, `allergy_ids` arrays are empty. To link allergens:

1. **Edit `3_seed_ingredients.xs`**
2. **Query allergies** to get IDs
3. **Set `allergy_ids`** array with appropriate IDs

Example:
```xanoscript
// For peanuts ingredient
allergy_ids: [1]  // ID of peanuts allergy

// For milk ingredient
allergy_ids: [3]  // ID of dairy allergy
```

---

## Truncate Behavior

All seed functions use `db.truncate` with `reset = true`:

- **Deletes all existing records** in the table
- **Resets auto-increment** counter to 1
- **Ensures clean slate** for seeding
- **IDs start from 1** after seeding

⚠️ **Warning**: Running seed functions will delete all existing data in those tables!

---

## Next Steps

### 1. Run the Master Seed Function
Execute `seed_all_tables` to populate your database.

### 2. Verify Data
Check that all tables have been populated correctly.

### 3. Create Background Task
Build the trending score calculation task:
- Query `recipe_view_history` for recent views
- Calculate scores based on view counts
- Update `recipe.viewed_score` field

### 4. Build API Endpoints
Create public API endpoints to:
- List recipes with filtering
- Get recipe details
- Get trending recipes (sorted by `viewed_score`)
- Submit reviews
- Track views

---

## File Structure

```
functions/
├── 1_seed_cuisines.xs              ✅ 10 cuisines
├── 2_seed_allergies.xs             ✅ 10 allergies
├── 3_seed_ingredients.xs           ✅ 20 ingredients
├── 4_seed_recipes.xs               ✅ 10 recipes
├── 5_seed_recipe_ingredients.xs    ✅ ~40 links
├── 6_seed_recipe_reviews.xs        ✅ 16 reviews
├── 7_seed_recipe_view_history.xs   ✅ 25 views
└── 10_seed_all_tables.xs           ✅ Master function
```

---

## Troubleshooting

### Issue: Foreign Key Errors
**Solution**: Ensure you seed in the correct order (1→2→3→4→5→6→7)

### Issue: Duplicate Slug Errors
**Solution**: Truncate is enabled, but if you're adding data manually, ensure unique slugs

### Issue: Function Not Found
**Solution**: Make sure all individual seed functions are deployed before calling `seed_all_tables`

### Issue: Timeout on Large Datasets
**Solution**: Seed tables individually instead of using master function

---

## Production Considerations

### Before Production
- [ ] Review and customize seeded data
- [ ] Add more realistic data (images, videos)
- [ ] Link allergens to ingredients properly
- [ ] Add more recipes for variety
- [ ] Test all foreign key relationships

### For Production
- [ ] Create separate seed functions for production vs. development
- [ ] Add data validation before seeding
- [ ] Implement error handling in seed functions
- [ ] Log seeding operations for audit trail
- [ ] Consider seeding from external data sources (CSV, JSON)

---

## Ready to Seed! 🌱

Your database seeding system is complete and ready to use. Simply call `seed_all_tables` to populate your entire database with realistic sample data!

**Total Functions Created**: 8 seed functions  
**Total Records**: ~121 records  
**Execution Time**: < 5 seconds (estimated)

The seeded data provides a solid foundation for testing your API endpoints and demonstrating the trending recipe system! 🚀
