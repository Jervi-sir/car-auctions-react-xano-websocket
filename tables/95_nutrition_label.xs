table nutrition_label {
  auth = false

  schema {
    // Unique identifier for the nutrition label
    int id
  
    // ID of the recipe this nutrition label belongs to
    int recipe_id {
      table = "recipe"
    }
  
    // Serving size amount
    decimal serving_size?
  
    // Unit for serving size (e.g., cup, piece, gram)
    text serving_unit? filters=trim
  
    // Calories per serving
    decimal calories? filters=min:0
  
    // Total fat in grams
    decimal total_fat_g? filters=min:0
  
    // Saturated fat in grams
    decimal saturated_fat_g? filters=min:0
  
    // Trans fat in grams
    decimal trans_fat_g? filters=min:0
  
    // Cholesterol in milligrams
    decimal cholesterol_mg? filters=min:0
  
    // Sodium in milligrams
    decimal sodium_mg? filters=min:0
  
    // Total carbohydrates in grams
    decimal total_carbohydrates_g? filters=min:0
  
    // Dietary fiber in grams
    decimal dietary_fiber_g? filters=min:0
  
    // Total sugars in grams
    decimal total_sugars_g? filters=min:0
  
    // Added sugars in grams
    decimal added_sugars_g? filters=min:0
  
    // Protein in grams
    decimal protein_g? filters=min:0
  
    // Vitamins and minerals content (Vitamin D, Calcium, Iron, Potassium, etc.)
    json vitamins_minerals?
  
    // Timestamp when the nutrition label was created
    timestamp created_at?=now
  
    // Timestamp when the nutrition label was last updated
    timestamp updated_at?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {
      type : "btree|unique"
      field: [{name: "recipe_id", op: "asc"}]
    }
    {type: "btree", field: [{name: "calories", op: "asc"}]}
    {type: "btree", field: [{name: "protein_g", op: "desc"}]}
    {type: "gin", field: [{name: "vitamins_minerals"}]}
  ]
}