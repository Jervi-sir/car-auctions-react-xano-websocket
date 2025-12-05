function "seed_data" {
  description = "Populate the database with fake data for testing"
  input {
    // No input needed
  }

  stack {
    // 1. Seed Cuisines
    var $cuisines {
      value = [
        {name: "Italian", region: "Europe", description: "Pasta, pizza, and wine"},
        {name: "Mexican", region: "North America", description: "Tacos, burritos, and spicy flavors"},
        {name: "Chinese", region: "Asia", description: "Rice, noodles, and stir-fry"},
        {name: "Japanese", region: "Asia", description: "Sushi, ramen, and fresh seafood"},
        {name: "Indian", region: "Asia", description: "Curry, spices, and naan"},
        {name: "French", region: "Europe", description: "Cheese, wine, and pastries"},
        {name: "Thai", region: "Asia", description: "Pad Thai, curry, and spicy soups"},
        {name: "American", region: "North America", description: "Burgers, fries, and BBQ"}
      ]
    }

    foreach ($cuisines) {
      each as $cuisine {
        // Check if cuisine exists
        db.query "cuisine" {
          where = $db.cuisine.name == $cuisine.name
          return = {type: "single"}
        } as $existing_cuisine

        conditional {
          if ($existing_cuisine == null) {
            db.add "cuisine" {
              data = $cuisine
            }
          }
        }
      }
    }

    // 2. Seed Allergies
    var $allergies {
      value = [
        {name: "Peanuts", severity: "severe"},
        {name: "Dairy", severity: "moderate"},
        {name: "Gluten", severity: "moderate"},
        {name: "Shellfish", severity: "life_threatening"},
        {name: "Soy", severity: "mild"},
        {name: "Eggs", severity: "moderate"},
        {name: "Tree Nuts", severity: "severe"},
        {name: "Fish", severity: "severe"}
      ]
    }

    foreach ($allergies) {
      each as $allergy {
        db.query "allergy" {
          where = $db.allergy.name == $allergy.name
          return = {type: "single"}
        } as $existing_allergy

        conditional {
          if ($existing_allergy == null) {
            db.add "allergy" {
              data = $allergy
            }
          }
        }
      }
    }

    // 3. Seed Ingredients
    var $ingredients {
      value = [
        {name: "Tomato", category: "vegetable", is_vegetarian: true, is_vegan: true, is_gluten_free: true},
        {name: "Chicken Breast", category: "meat", is_vegetarian: false, is_vegan: false, is_gluten_free: true},
        {name: "Mozzarella Cheese", category: "dairy", is_vegetarian: true, is_vegan: false, is_gluten_free: true},
        {name: "Pasta", category: "grain", is_vegetarian: true, is_vegan: true, is_gluten_free: false},
        {name: "Rice", category: "grain", is_vegetarian: true, is_vegan: true, is_gluten_free: true},
        {name: "Beef", category: "meat", is_vegetarian: false, is_vegan: false, is_gluten_free: true},
        {name: "Onion", category: "vegetable", is_vegetarian: true, is_vegan: true, is_gluten_free: true},
        {name: "Garlic", category: "vegetable", is_vegetarian: true, is_vegan: true, is_gluten_free: true},
        {name: "Olive Oil", category: "oil", is_vegetarian: true, is_vegan: true, is_gluten_free: true},
        {name: "Basil", category: "herb", is_vegetarian: true, is_vegan: true, is_gluten_free: true},
        {name: "Salmon", category: "seafood", is_vegetarian: false, is_vegan: false, is_gluten_free: true},
        {name: "Shrimp", category: "seafood", is_vegetarian: false, is_vegan: false, is_gluten_free: true},
        {name: "Egg", category: "dairy", is_vegetarian: true, is_vegan: false, is_gluten_free: true},
        {name: "Flour", category: "grain", is_vegetarian: true, is_vegan: true, is_gluten_free: false},
        {name: "Sugar", category: "sweetener", is_vegetarian: true, is_vegan: true, is_gluten_free: true},
        {name: "Milk", category: "dairy", is_vegetarian: true, is_vegan: false, is_gluten_free: true},
        {name: "Butter", category: "dairy", is_vegetarian: true, is_vegan: false, is_gluten_free: true},
        {name: "Potato", category: "vegetable", is_vegetarian: true, is_vegan: true, is_gluten_free: true},
        {name: "Carrot", category: "vegetable", is_vegetarian: true, is_vegan: true, is_gluten_free: true},
        {name: "Lettuce", category: "vegetable", is_vegetarian: true, is_vegan: true, is_gluten_free: true}
      ]
    }

    foreach ($ingredients) {
      each as $ingredient {
        db.query "ingredient" {
          where = $db.ingredient.name == $ingredient.name
          return = {type: "single"}
        } as $existing_ingredient

        conditional {
          if ($existing_ingredient == null) {
            db.add "ingredient" {
              data = $ingredient
            }
          }
        }
      }
    }

    // 4. Seed Recipes (Generate 50)
    db.query "cuisine" { return = {type: "list"} } as $all_cuisines
    db.query "ingredient" { return = {type: "list"} } as $all_ingredients
    db.query "allergy" { return = {type: "list"} } as $all_allergies

    var $recipe_count { value = 0 }
    
    // Loop 50 times
    for (50) {
      each as $i {
        var $random_cuisine {
          value = $all_cuisines|shuffle|first
        }
        
        var $random_ingredients {
          value = $all_ingredients|shuffle|slice:0:5
        }

        var $random_allergies {
          value = $all_allergies|shuffle|slice:0:2
        }

        var $recipe_name {
          value = "Recipe " ~ ($i + 1) ~ " - " ~ $random_cuisine.name ~ " Style"
        }

        var $slug {
          value = ($recipe_name|to_lower|replace:" ":"-"|replace:"--":"-") ~ "-" ~ (now|to_timestamp)
        }

        db.add "recipe" {
          data = {
            name: $recipe_name
            slug: $slug
            description: "A delicious " ~ $random_cuisine.name ~ " dish."
            instructions: ["Step 1: Prep ingredients", "Step 2: Cook", "Step 3: Serve"]
            prep_time_minutes: 15
            cook_time_minutes: 30
            total_time_minutes: 45
            servings: 4
            difficulty: "medium"
            cuisine_id: $random_cuisine.id
            allergy_ids: $random_allergies|map:$$.id
            is_vegetarian: true
            is_vegan: false
            is_gluten_free: false
            is_published: true
            rating: 4.5
            view_count: 0
            viewed_score: 0
          }
        } as $new_recipe

        // Add Recipe Ingredients
        foreach ($random_ingredients) {
          each as $ing {
            db.add "recipe_ingredient" {
              data = {
                recipe_id: $new_recipe.id
                ingredient_id: $ing.id
                quantity: 1
                unit: "cup"
                notes: "Chopped"
                order_index: 1
              }
            }
          }
        }
        
        var.update $recipe_count { value = $recipe_count + 1 }
      }
    }

    response = {
      message: "Database seeded successfully"
      recipes_created: $recipe_count
    }
  }
}
