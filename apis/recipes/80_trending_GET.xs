// Get trending recipes based on viewed_score
query trending verb=GET {
  api_group = "recipes"

  input {
    int page?=1 filters=min:1
    int per_page?=10 filters=min:1|max:50
  }

  stack {
    // Query recipes sorted by viewed_score
    db.query recipe {
      where = `$db.recipe.is_published`
      sort = {recipe.viewed_score: "desc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $trending
  }

  response = $trending
  history = false
}