table ingredient {
  auth = false

  schema {
    // Unique identifier for the ingredient
    int id
  
    // Name of the ingredient
    text name filters=trim
  
    // Description of the ingredient
    text description? filters=trim
  
    // Category of the ingredient
    enum category? {
      values = [
        "vegetable"
        "fruit"
        "meat"
        "seafood"
        "dairy"
        "grain"
        "spice"
        "herb"
        "nut"
        "legume"
        "oil"
        "condiment"
        "sweetener"
        "beverage"
        "other"
      ]
    
    }
  
    // Nutritional information (calories, protein, carbs, fats, vitamins, etc.)
    json nutritional_info?
  
    // Allergens associated with this ingredient
    int[] allergy_ids {
      table = "allergy"
    }
  
    // Whether the ingredient is vegetarian
    bool is_vegetarian?=true
  
    // Whether the ingredient is vegan
    bool is_vegan?
  
    // Whether the ingredient is gluten-free
    bool is_gluten_free?=true
  
    // Alternative names or translations of the ingredient
    text[] alternative_names?
  
    // Image of the ingredient
    image image_url?
  
    // Timestamp when the ingredient was added
    timestamp created_at?=now
  
    // Timestamp when the ingredient was last updated
    timestamp updated_at?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "name", op: "asc"}]}
    {type: "btree", field: [{name: "category", op: "asc"}]}
    {type: "btree", field: [{name: "is_vegetarian", op: "asc"}]}
    {type: "btree", field: [{name: "is_vegan", op: "asc"}]}
    {type: "btree", field: [{name: "is_gluten_free", op: "asc"}]}
    {type: "gin", field: [{name: "nutritional_info"}]}
  ]
}