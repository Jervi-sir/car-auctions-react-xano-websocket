// Get recipe statistics
query stats verb=GET {
  input {
    int recipe_id filters=min:1
  }

  stack {
    // Get recipe
    db.get recipe {
      field_name = "id"
      field_value = $input.recipe_id
    } as $recipe
  
    precondition ($recipe != null) {
      error_type = "notfound"
      error = "Recipe not found"
    }
  
    // Get view count from last 7 days
    var $window_start {
      value = now
        |transform_timestamp:"-7 days":"UTC"
    }
  
    db.query recipe_view_history {
      where = $db.recipe_view_history.recipe_id == $input.recipe_id && ($db.recipe_view_history.viewed_at >= $window_start)
      return = {type: "list"}
    } as $recent_views
  
    // Get total reviews
    db.query recipe_review {
      where = $db.recipe_review.recipe_id == $input.recipe_id && $db.recipe_review.is_approved
      return = {type: "list"}
    } as $reviews
  
    var $stats {
      value = {
        recipe_id        : $recipe.id
        recipe_name      : $recipe.name
        total_views      : $recipe.view_count
        views_last_7_days: $recent_views|count
        total_reviews    : $reviews|count
        average_rating   : $recipe.rating
        viewed_score     : $recipe.viewed_score
      }
    }
  }

  response = $stats
  history = false
}