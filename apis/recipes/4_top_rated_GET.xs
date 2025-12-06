// Get top-rated recipes
query top_rated verb=GET {
  input {
    int page?=1 filters=min:1
    int per_page?=10 filters=min:1|max:50
    decimal min_rating?=4 filters=min:0|max:5
  }

  stack {
    // Query recipes with high ratings
    db.query recipe {
      where = $db.recipe.is_published && ($db.recipe.rating >= $input.min_rating)
      sort = {recipe.rating: "desc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $top_rated
  }

  response = $top_rated
  history = false
}