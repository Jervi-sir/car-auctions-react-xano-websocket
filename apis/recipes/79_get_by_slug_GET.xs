// Get a single recipe by slug with ingredients
query get_by_slug verb=GET {
  api_group = "recipes"

  input {
    text slug filters=trim|lower
  }

  stack {
    // Get recipe by slug
    db.query recipe {
      where = $db.recipe.slug == $input.slug && $db.recipe.is_published
      return = {type: "single"}
    } as $recipe
  
    // Validate recipe exists
    precondition ($recipe != null) {
      error_type = "notfound"
      error = "Recipe not found"
    }
  
    // Get recipe ingredients with details
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
        ingredient_name    : $db.ingredient.name
        ingredient_category: $db.ingredient.category
        is_vegetarian      : $db.ingredient.is_vegetarian
        is_vegan           : $db.ingredient.is_vegan
      }
    
      return = {type: "list"}
    } as $ingredients
  
    // Get cuisine info
    db.get cuisine {
      field_name = "id"
      field_value = $recipe.cuisine_id
    } as $cuisine
  
    // Log view to history
    db.add recipe_view_history {
      data = {
        recipe_id : $recipe.id
        viewer_ip : $env.ip
        user_agent: $env.user_agent
        referrer  : $env.referrer
        viewed_at : now
      }
    }
  
    // Update view count
    db.edit recipe {
      field_name = "id"
      field_value = $recipe.id
      data = {view_count: $recipe.view_count + 1}
    } as $updated_recipe
  
    // Prepare response
    var $response {
      value = {
        recipe     : $updated_recipe
        ingredients: $ingredients
        cuisine    : $cuisine
      }
    }
  }

  response = $response[""]
  history = false
}