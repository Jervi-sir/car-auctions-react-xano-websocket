// Get trending recipes based on recent views and high ratings
query "recipes/trending" verb=GET {
  input {
    // Number of trending recipes to return (max 50)
    int limit?=10 filters=min:1|max:50
  
    // Number of days to look back for trending calculation (default 7)
    int days?=7 filters=min:1|max:30
  }

  stack {
    var $cutoff_date {
      value = now
        |transform_timestamp:($input.days * -1 + " days")
    }
  
    db.query recipe {
      where = $db.recipe.is_published && $db.recipe.view_count > 0 && $db.recipe.rating >= 3.5
      sort = {recipe.view_count: "desc"}
      return = {
        type  : "list"
        paging: {page: 1, per_page: $input.limit, metadata: false}
      }
    } as $trending_recipes
  }

  response = $trending_recipes
  history = false
}