// Get all ingredients with filtering
query list verb=GET {
  api_group = "ingredients"

  input {
    int page?=1 filters=min:1
    int per_page?=50 filters=min:1|max:100
    text category?
    text search? filters=trim
    bool is_vegetarian?
    bool is_vegan?
  }

  stack {
    db.query ingredient {
      where = $db.ingredient.category ==? $input.category && $db.ingredient.name includes $input.search && $db.ingredient.is_vegetarian ==? $input.is_vegetarian && $db.ingredient.is_vegan ==? $input.is_vegan
      sort = {ingredient.name: "asc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $ingredients
  }

  response = $ingredients
  history = false
}