// Get top-rated recipes with minimum rating threshold
query "recipes/top-rated" verb=GET {
  input {
    // Number of recipes to return (max 100)
    int limit?=20 filters=min:1|max:100
  
    // Minimum rating threshold (default 4.0)
    decimal min_rating?=4 filters=min:0|max:5
  
    // Minimum number of ratings required (default 5)
    int min_rating_count?=5 filters=min:1
  }

  stack {
    db.query recipe {
      where = $db.recipe.is_published && $db.recipe.rating >= $input.min_rating && $db.recipe.rating_count >= $input.min_rating_count
      sort = {recipe.rating: "desc"}
      return = {
        type  : "list"
        paging: {page: 1, per_page: $input.limit, metadata: false}
      }
    } as $top_rated_recipes
  }

  response = $top_rated_recipes
  history = false
}