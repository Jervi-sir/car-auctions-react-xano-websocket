// Get reviews for a recipe
query list verb=GET {
  api_group = "reviews"

  input {
    int recipe_id filters=min:1
    int page?=1 filters=min:1
    int per_page?=10 filters=min:1|max:50
    bool approved_only?=true
  }

  stack {
    // Query reviews - filter by recipe_id and optionally by approval status
    db.query recipe_review {
      where = $db.recipe_review.recipe_id == $input.recipe_id && ($input.approved_only == false || $db.recipe_review.is_approved)
      sort = {recipe_review.created_at: "desc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $reviews
  }

  response = $reviews
  history = false
}