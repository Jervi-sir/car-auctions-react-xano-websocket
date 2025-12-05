table recipe_review {
  auth = false

  schema {
    // Unique identifier for the review
    int id
  
    // ID of the recipe being reviewed
    int recipe_id {
      table = "recipe"
    }
  
    // Name of the person reviewing (for public API, optional)
    text reviewer_name? filters=trim
  
    // Email of the reviewer (optional, for verification)
    text reviewer_email? filters=trim|lower {
      sensitive = true
    }
  
    // Rating given (1-5 stars)
    int rating filters=min:1|max:5
  
    // Text content of the review
    text review_text? filters=trim
  
    // Images uploaded with the review
    text[] images
  
    // Whether the reviewer actually made the recipe
    bool is_verified?
  
    // Whether the review has been approved for display
    bool is_approved?
  
    // Number of users who found this review helpful
    int helpful_count?
  
    // Any modifications the reviewer made to the recipe
    json modifications?
  
    // Timestamp when the review was submitted
    timestamp created_at?=now
  
    // Timestamp when the review was last updated
    timestamp updated_at?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "recipe_id", op: "asc"}]}
    {type: "btree", field: [{name: "rating", op: "desc"}]}
    {type: "btree", field: [{name: "is_approved", op: "asc"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
    {type: "btree", field: [{name: "helpful_count", op: "desc"}]}
    {type: "gin", field: [{name: "modifications"}]}
  ]
}