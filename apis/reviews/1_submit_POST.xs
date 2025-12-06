// Submit a recipe review
query submit verb=POST {
  input {
    int recipe_id filters=min:1
    text reviewer_name filters=trim
    email reviewer_email? filters=trim|lower
    int rating filters=min:1|max:5
    text review_text? filters=trim
  }

  stack {
    // Validate recipe exists
    db.get recipe {
      field_name = "id"
      field_value = $input.recipe_id
    } as $recipe
  
    precondition ($recipe != null) {
      error_type = "notfound"
      error = "Recipe not found"
    }
  
    // Add review
    db.add recipe_review {
      data = {
        recipe_id           : $input.recipe_id
        reviewer_name       : $input.reviewer_name
        reviewer_email      : $input.reviewer_email
        rating              : $input.rating
        review_text         : $input.review_text
        review_images       : []
        is_approved         : false
        is_verified_purchase: false
        helpful_count       : 0
        created_at          : now
      }
    } as $new_review
  
    // Calculate new average rating
    db.query recipe_review {
      where = $db.recipe_review.recipe_id == $input.recipe_id && $db.recipe_review.is_approved
      return = {type: "list"}
    } as $all_reviews
  
    var $review_count {
      value = $all_reviews|count
    }
  
    // Update recipe review count
    db.edit recipe {
      field_name = "id"
      field_value = $input.recipe_id
      data = {review_count: $review_count + 1}
    }
  
    var $response {
      value = {
        message: "Review submitted successfully and pending approval"
        review : $new_review
      }
    }
  }

  response = $response.""
  history = false
}