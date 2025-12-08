// Get recipes by cuisine
query recipes verb=GET {
  input {
    int cuisine_id filters=min:1
    int page?=1 filters=min:1
    int per_page?=20 filters=min:1|max:100
  }

  stack {
    // Validate cuisine exists
    db.get cuisine {
      field_name = "id"
      field_value = $input.cuisine_id
    } as $cuisine
  
    precondition ($cuisine != null) {
      error_type = "notfound"
      error = "Cuisine not found"
    }
  
    // Query recipes for this cuisine
    db.query recipe {
      where = $db.recipe.is_published && ($db.recipe.cuisine_id == $input.cuisine_id)
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
  
    var $response {
      value = {cuisine: $cuisine, recipes: $recipes}
    }
  }

  response = $response.""
  history = false
}