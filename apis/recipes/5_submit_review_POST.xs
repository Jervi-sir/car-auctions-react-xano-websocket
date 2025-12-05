// Submit a review for a recipe
query "recipes/reviews" verb=POST {
  input {
    // ID of the recipe to review
    int recipe_id
  
    // Name of the reviewer
    text reviewer_name filters=trim
  
    // Email of the reviewer (optional)
    email reviewer_email? filters=trim|lower
  
    // Rating from 1 to 5 stars
    int rating filters=min:1|max:5
  
    // Review text content
    text review_text? filters=trim
  
    // Any modifications made to the recipe
    json modifications?
  }

  stack {
    db.get recipe {
      field_name = "id"
      field_value = $input.recipe_id
    } as $recipe
  
    // Validate recipe exists and is published
    precondition ($recipe != null && $recipe.is_published) {
      error_type = "inputerror"
      error = "Recipe not found or not published"
    }
  
    db.add recipe_review {
      data = {
        recipe_id     : $input.recipe_id
        reviewer_name : $input.reviewer_name
        reviewer_email: $input.reviewer_email
        rating        : $input.rating
        review_text   : $input.review_text
        modifications : $input.modifications
        is_verified   : false
        is_approved   : false
        helpful_count : 0
        created_at    : now
      }
    } as $new_review
  
    var $response_data {
      value = {
        success  : true
        review_id: $new_review.id
        message  : "Review submitted successfully and is pending approval"
        review   : $new_review
      }
    }
  }

  response = $response_data
  history = false
}