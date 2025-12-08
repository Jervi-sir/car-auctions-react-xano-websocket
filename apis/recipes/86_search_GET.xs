// Search recipes by name or description
query search verb=GET {
  input {
    text query filters=trim
    int page?=1 filters=min:1
    int per_page?=20 filters=min:1|max:100
  }

  stack {
    // Validate search query
    precondition ($input.query != null) {
      error_type = "inputerror"
      error = "Search query is required"
    }
  
    // Search recipes
    db.query recipe {
      where = $db.recipe.is_published && ($db.recipe.name includes $input.query || $db.recipe.description includes $input.query)
      sort = {recipe.rating: "desc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $results
  }

  response = $results
  history = false
}