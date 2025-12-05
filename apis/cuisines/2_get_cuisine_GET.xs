// Get detailed information about a specific cuisine including recipes
query "cuisines/by-id" verb=GET {
  input {
    // Cuisine ID
    int id
  
    // Page number for recipes pagination
    int page?=1
  
    // Number of recipes per page (max 100)
    int per_page?=20 filters=min:1|max:100
  }

  stack {
    db.get cuisine {
      field_name = "id"
      field_value = $input.id
    } as $cuisine
  
    // Validate cuisine exists
    precondition ($cuisine != null) {
      error_type = "notfound"
      error = "Cuisine not found"
    }
  
    db.query recipe {
      where = $db.recipe.cuisine_id == $input.id && $db.recipe.is_published
      sort = {recipe.rating: "desc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $recipes
  
    var $response_data {
      value = {cuisine: $cuisine, recipes: $recipes}
    }
  }

  response = $response_data
  history = false
}