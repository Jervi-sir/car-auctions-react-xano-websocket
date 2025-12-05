// Cuisine types for categorizing recipes
table cuisine {
  auth = false

  schema {
    int id
    text name filters=trim
    text slug filters=trim|lower
    text description? filters=trim
    image image_url?
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "slug", op: "asc"}]}
    {type: "btree", field: [{name: "name", op: "asc"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}