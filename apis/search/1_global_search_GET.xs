// Global search across recipes, ingredients, cuisines, and allergies
query search verb=GET {
  input {
    // Search query term
    text query filters=trim
  
    // Types to search (recipes, ingredients, cuisines, allergies)
    text[] types?
  
    // Maximum results per type (max 50)
    int limit?=10 filters=min:1|max:50
  }

  stack {
    // Validate search query length
    precondition (($input.query|strlen) >= 2) {
      error_type = "inputerror"
      error = "Search query must be at least 2 characters long"
    }
  
    var $results {
      value = {}
    }
  
    conditional {
      if ($input.types|in:"recipes") {
        db.query recipe {
          where = ($db.recipe.name includes $input.query || $db.recipe.description includes $input.query || $db.recipe.tags contains $input.query) && $db.recipe.is_published
          sort = {recipe.rating: "desc"}
          return = {
            type  : "list"
            paging: {page: 1, per_page: $input.limit, metadata: false}
          }
        } as $recipe_results
      
        var.update $results {
          value = $results|set:"recipes":$recipe_results
        }
      }
    }
  
    conditional {
      if ($input.types|in:"ingredients") {
        db.query ingredient {
          where = $db.ingredient.name includes $input.query || $db.ingredient.alternative_names contains $input.query
          sort = {ingredient.name: "asc"}
          return = {
            type  : "list"
            paging: {page: 1, per_page: $input.limit, metadata: false}
          }
        } as $ingredient_results
      
        var.update $results {
          value = $results
            |set:"ingredients":$ingredient_results
        }
      }
    }
  
    conditional {
      if ($input.types|in:"cuisines") {
        db.query cuisine {
          where = $db.cuisine.name includes $input.query || $db.cuisine.region includes $input.query
          sort = {cuisine.name: "asc"}
          return = {
            type  : "list"
            paging: {page: 1, per_page: $input.limit, metadata: false}
          }
        } as $cuisine_results
      
        var.update $results {
          value = $results|set:"cuisines":$cuisine_results
        }
      }
    }
  
    conditional {
      if ($input.types|in:"allergies") {
        db.query allergy {
          where = $db.allergy.name includes $input.query || $db.allergy.alternative_names contains $input.query
          sort = {allergy.name: "asc"}
          return = {
            type  : "list"
            paging: {page: 1, per_page: $input.limit, metadata: false}
          }
        } as $allergy_results
      
        var.update $results {
          value = $results|set:"allergies":$allergy_results
        }
      }
    }
  
    var $response_data {
      value = {query: $input.query, results: $results}
    }
  }

  response = $response_data
  history = false
}