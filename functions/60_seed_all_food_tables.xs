// Master seed function - Seeds all tables in correct dependency order
function seed_all_food_tables {
  input {
  }

  stack {
    debug.log {
      value = "Starting database seeding process..."
    }
  
    // Step 1: Seed cuisines (base table)
    function.run food_1_seed_cuisines as $cuisines_result
  
    debug.log {
      value = "Step 1/7: Cuisines seeded"
    }
  
    // Step 2: Seed allergies (base table)
    function.run food_2_seed_allergies as $allergies_result
  
    debug.log {
      value = "Step 2/7: Allergies seeded"
    }
  
    // Step 3: Seed ingredients (depends on allergies)
    function.run food_3_seed_ingredients as $ingredients_result
  
    debug.log {
      value = "Step 3/7: Ingredients seeded"
    }
  
    // Step 4: Seed recipes (depends on cuisines and allergies)
    function.run food_4_seed_recipes as $recipes_result
  
    debug.log {
      value = "Step 4/7: Recipes seeded"
    }
  
    // Step 5: Seed recipe ingredients (depends on recipes and ingredients)
    function.run food_5_seed_recipe_ingredients as $recipe_ingredients_result
  
    debug.log {
      value = "Step 5/7: Recipe ingredients seeded"
    }
  
    // Step 6: Seed recipe reviews (depends on recipes)
    function.run food_6_seed_recipe_reviews as $reviews_result
  
    debug.log {
      value = "Step 6/7: Recipe reviews seeded"
    }
  
    // Step 7: Seed recipe view history (depends on recipes)
    function.run food_7_seed_recipe_view_history as $view_history_result
  
    debug.log {
      value = "Step 7/7: Recipe view history seeded"
    }
  
    debug.log {
      value = "Database seeding completed successfully!"
    }
  
    // Prepare summary response
    var $summary {
      value = {
        success      : true
        message      : "All tables seeded successfully"
        tables_seeded: 7
        details      : {
          cuisines          : $cuisines_result
          allergies         : $allergies_result
          ingredients       : $ingredients_result
          recipes           : $recipes_result
          recipe_ingredients: $recipe_ingredients_result
          reviews           : $reviews_result
          view_history      : $view_history_result
        }
      }
    }
  }

  response = $summary
}