// Recipe reviews and ratings from users
table recipe_review {
  auth = false

  schema {
    int id
    int recipe_id {
      table = "recipe"
    }
  
    text reviewer_name filters=trim
    email reviewer_email? filters=trim|lower
    int rating filters=min:1|max:5
    text review_text? filters=trim
    image[] review_images
  
    // Moderation and verification
    bool is_approved?
  
    bool is_verified_purchase?
  
    // Engagement
    int helpful_count? filters=min:0
  
    timestamp created_at?=now
    timestamp updated_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "recipe_id", op: "asc"}]}
    {type: "btree", field: [{name: "rating", op: "desc"}]}
    {type: "btree", field: [{name: "is_approved", op: "asc"}]}
    {type: "btree", field: [{name: "helpful_count", op: "desc"}]}
    {
      type : "btree"
      field: [
        {name: "recipe_id", op: "asc"}
        {name: "created_at", op: "desc"}
      ]
    }
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}