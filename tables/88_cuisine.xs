table cuisine {
  auth = false

  schema {
    // Unique identifier for the cuisine type
    int id
  
    // Name of the cuisine (e.g., Italian, Chinese, Mexican)
    text name filters=trim
  
    // Description of the cuisine and its characteristics
    text description? filters=trim
  
    // Geographic region or country of origin
    text region? filters=trim
  
    // Common ingredients used in this cuisine
    text[] popular_ingredients
  
    // Representative image for the cuisine
    image image_url?
  
    // Timestamp when the cuisine was added
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "name", op: "asc"}]}
    {type: "btree", field: [{name: "region", op: "asc"}]}
  ]
}