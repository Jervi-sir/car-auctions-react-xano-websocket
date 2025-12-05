// Recipe ingredients with dietary and allergen information
table ingredient {
  auth = false

  schema {
    int id
    text name filters=trim
    text slug filters=trim|lower
    text description? filters=trim
    enum category? {
      values = [
        "vegetable"
        "fruit"
        "meat"
        "poultry"
        "seafood"
        "dairy"
        "grain"
        "legume"
        "nut"
        "spice"
        "herb"
        "oil"
        "condiment"
        "sweetener"
        "other"
      ]
    }
  
    // Dietary flags
    bool is_vegetarian?
  
    bool is_vegan?
    bool is_gluten_free?
    bool is_dairy_free?
  
    // Allergen relationships
    int[] allergy_ids {
      table = "allergy"
    }
  
    // Nutritional information (flexible JSON)
    json nutritional_info?
  
    image image_url?
    timestamp created_at?=now
    timestamp updated_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "slug", op: "asc"}]}
    {type: "btree", field: [{name: "name", op: "asc"}]}
    {type: "btree", field: [{name: "category", op: "asc"}]}
    {type: "btree", field: [{name: "is_vegetarian", op: "asc"}]}
    {type: "btree", field: [{name: "is_vegan", op: "asc"}]}
    {type: "btree", field: [{name: "is_gluten_free", op: "asc"}]}
    {type: "btree", field: [{name: "is_dairy_free", op: "asc"}]}
    {type: "gin", field: [{name: "nutritional_info"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}