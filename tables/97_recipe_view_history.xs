table recipe_view_history {
  auth = false

  schema {
    // Unique identifier for the view history record
    int id
  
    // ID of the recipe that was viewed
    int recipe_id {
      table = "recipe"
    }
  
    // Timestamp when the recipe was viewed
    timestamp viewed_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "recipe_id", op: "asc"}]}
    {type: "btree", field: [{name: "viewed_at", op: "desc"}]}
  ]
}