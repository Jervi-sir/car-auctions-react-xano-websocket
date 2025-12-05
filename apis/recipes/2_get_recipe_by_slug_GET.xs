// Get a single recipe by its slug with full details including ingredients, reviews, and nutritional information
query "recipes/by-slug" verb=GET {
  input {
    // URL-friendly slug of the recipe
    text slug filters=trim
  }

  stack {
    db.query recipe {
      where = $db.recipe.slug == $input.slug && $db.recipe.is_published
      return = {type: "single"}
    } as $recipe
  
    // Validate recipe exists and is published
    precondition ($recipe != null) {
      error_type = "notfound"
      error = "Recipe not found or not published"
    }
  
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
        ingredient_image   : $db.ingredient.image_url
        is_vegetarian      : $db.ingredient.is_vegetarian
        is_vegan           : $db.ingredient.is_vegan
        is_gluten_free     : $db.ingredient.is_gluten_free
      }
    
      return = {type: "list"}
    } as $ingredients
  
    db.query recipe_review {
      where = $db.recipe_review.recipe_id == $recipe.id && $db.recipe_review.is_approved
      sort = {recipe_review.created_at: "desc"}
      return = {type: "list", paging: {page: 1, per_page: 10, totals: true}}
    } as $reviews
  
    db.edit recipe {
      field_name = "id"
      field_value = $recipe.id
      data = {view_count: $recipe.view_count + 1}
    } as $updated_recipe
  
    // Log the view in history for trending calculation
    db.add recipe_view_history {
      data = {recipe_id: $recipe.id, viewed_at: "now"}
    }
  
    var $response_data {
      value = {
        recipe     : $updated_recipe
        ingredients: $ingredients
        reviews    : $reviews
      }
    }
  }

  response = $response_data
  history = false
}