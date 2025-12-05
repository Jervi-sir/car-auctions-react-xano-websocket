table collection_recipe {
  auth = false

  schema {
    // Unique identifier for the collection-recipe relationship
    int id
  
    // ID of the collection
    int collection_id {
      table = "recipe_collection"
    }
  
    // ID of the recipe
    int recipe_id {
      table = "recipe"
    }
  
    // Order of the recipe within the collection
    int order_index?
  
    // Optional note about why this recipe is in the collection
    text note? filters=trim
  
    // Timestamp when the recipe was added to the collection
    timestamp added_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {
      type : "btree"
      field: [
        {name: "collection_id", op: "asc"}
        {name: "order_index", op: "asc"}
      ]
    }
    {type: "btree", field: [{name: "recipe_id", op: "asc"}]}
    {
      type : "btree|unique"
      field: [
        {name: "collection_id", op: "asc"}
        {name: "recipe_id", op: "asc"}
      ]
    }
  ]
}