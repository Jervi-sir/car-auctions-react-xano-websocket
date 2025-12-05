table recipe_ingredient {
  auth = false

  schema {
    // Unique identifier for the recipe-ingredient relationship
    int id
  
    // ID of the recipe
    int recipe_id {
      table = "recipe"
    }
  
    // ID of the ingredient
    int ingredient_id {
      table = "ingredient"
    }
  
    // Quantity of the ingredient needed
    decimal quantity? filters=min:0
  
    // Unit of measurement (e.g., cups, tablespoons, grams, ounces)
    text unit? filters=trim
  
    // How the ingredient should be prepared (e.g., diced, minced, chopped)
    text preparation_note? filters=trim
  
    // Whether this ingredient is optional
    bool is_optional?
  
    // Order in which the ingredient appears in the recipe
    int order_index?
  
    // Timestamp when the relationship was created
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {
      type : "btree"
      field: [
        {name: "recipe_id", op: "asc"}
        {name: "order_index", op: "asc"}
      ]
    }
    {type: "btree", field: [{name: "ingredient_id", op: "asc"}]}
    {
      type : "btree|unique"
      field: [
        {name: "recipe_id", op: "asc"}
        {name: "ingredient_id", op: "asc"}
      ]
    }
  ]
}