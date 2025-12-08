// Background task to update recipe trending scores based on view history
// Runs every 24 hours to calculate viewed_score for each recipe
task update_trending_scores {
  stack {
    // Define time windows for trending calculation
    // Recent views are weighted more heavily
    var $now {
      value = now
    }
  
    var $window_7_days {
      value = $now
        |transform_timestamp:"-7 days":"UTC"
    }
  
    var $window_30_days {
      value = $now
        |transform_timestamp:"-30 days":"UTC"
    }
  
    // Get all published recipes
    db.query recipe {
      where = `$db.recipe.is_published`
      return = {type: "list"}
    } as $recipes
  
    debug.log {
      value = "Starting trending score update for recipes"
    }
  
    var $updated_count {
      value = 0
    }
  
    // Process each recipe
    foreach ($recipes) {
      each as $recipe {
        // Get views from last 7 days (higher weight)
        db.query recipe_view_history {
          where = $db.recipe_view_history.recipe_id == $recipe.id && $db.recipe_view_history.viewed_at >= $window_7_days
          return = {type: "list"}
        } as $recent_views
      
        // Get views from 7-30 days ago (lower weight)
        db.query recipe_view_history {
          where = $db.recipe_view_history.recipe_id == $recipe.id && $db.recipe_view_history.viewed_at >= $window_30_days && $db.recipe_view_history.viewed_at < $window_7_days
          return = {type: "list"}
        } as $older_views
      
        // Calculate trending score
        // Formula: (recent_views * 3) + (older_views * 1)
        // Recent views are weighted 3x more than older views
        var $recent_count {
          value = $recent_views|count
        }
      
        var $older_count {
          value = $older_views|count
        }
      
        var $trending_score {
          value = ($recent_count * 3) + $older_count
        }
      
        // Update recipe with new trending score
        db.edit recipe {
          field_name = "id"
          field_value = $recipe.id
          data = {viewed_score: $trending_score}
        }
      
        var $updated_count {
          value = $updated_count + 1
        }
      }
    }
  
    debug.log {
      value = "Trending scores updated for recipes"
    }
  
    debug.log {
      value = $updated_count
    }
  }

  schedule = [{starts_on: 2025-12-06 00:00:00+0000, freq: 86400}]
}