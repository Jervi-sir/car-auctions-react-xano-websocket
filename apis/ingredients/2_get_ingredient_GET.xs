// Get detailed information about a specific ingredient by ID
query "ingredients/by-id" verb=GET {
  input {
    // Ingredient ID
    int id
  }

  stack {
    db.get ingredient {
      field_name = "id"
      field_value = $input.id
    } as $ingredient
  
    // Validate ingredient exists
    precondition ($ingredient != null) {
      error_type = "notfound"
      error = "Ingredient not found"
    }
  
    db.query recipe_ingredient {
      join = {
        recipe: {
          table: "recipe"
          where: $db.recipe_ingredient.recipe_id == $db.recipe.id
        }
      }
    
      where = $db.recipe_ingredient.ingredient_id == $input.id && $db.recipe.is_published
      eval = {
        recipe_id    : $db.recipe.id
        recipe_name  : $db.recipe.name
        recipe_slug  : $db.recipe.slug
        recipe_rating: $db.recipe.rating
        recipe_images: $db.recipe.images
      }
    
      return = {type: "list", paging: {page: 1, per_page: 10, totals: true}}
    } as $recipes_using_ingredient
  
    var $recipes_with_image {
      value = []
    }
  
    foreach ($recipes_using_ingredient) {
      each as $item {
        var $mapped_item {
          value = {
            recipe_id    : $item.recipe_id
            recipe_name  : $item.recipe_name
            recipe_slug  : $item.recipe_slug
            recipe_rating: $item.recipe_rating
            recipe_image : ($item.recipe_images|first) ?? null
          }
        }
      
        var.update $recipes_with_image {
          value = $recipes_with_image|push:$mapped_item
        }
      }
    }
  
    var $response_data {
      value = {ingredient: $ingredient, recipes: $recipes_with_image}
    }
  }

  response = $response_data
  history = false
}