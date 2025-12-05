// Recipe view history for tracking views and calculating trending scores
table recipe_view_history {
  auth = false

  schema {
    int id
    int recipe_id {
      table = "recipe"
    }
  
    // Analytics data
    text viewer_ip? filters=trim
  
    text user_agent? filters=trim
    text referrer? filters=trim
    timestamp viewed_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "recipe_id", op: "asc"}]}
    {type: "btree", field: [{name: "viewed_at", op: "desc"}]}
    {
      type : "btree"
      field: [
        {name: "recipe_id", op: "asc"}
        {name: "viewed_at", op: "desc"}
      ]
    }
  ]
}