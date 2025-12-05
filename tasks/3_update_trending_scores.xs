// Update the viewed_score for all recipes based on views in the last 7 days. Runs every 24 hours.
task update_trending_scores {
  stack {
    // Calculate timestamp for 7 days ago
    var $window_start {
      value = now
        |transform_timestamp:"-7 days":"UTC"
    }
  
    // Get all recipes
    db.query recipe {
      return = {type: "list"}
    } as $recipes
  
    foreach ($recipes) {
      each as $recipe {
        // Count views in the last 7 days
        db.query recipe_view_history {
          where = $db.recipe_view_history.recipe_id == $recipe.id && $db.recipe_view_history.viewed_at >= $window_start
          return = {type: "list"}
        } as $views
      
        var $score {
          value = $views|count
        }
      
        db.edit recipe {
          field_name = "id"
          field_value = $recipe.id
          data = {viewed_score: $score}
        }
      }
    }
  
    debug.log {
      value = "Updated trending scores for " ~ ($recipes|count) ~ " recipes."
    }
  }

  schedule = [{starts_on: 2025-01-01 00:00:00+0000, freq: 86400}]
}