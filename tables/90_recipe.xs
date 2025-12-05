table recipe {
  auth = false

  schema {
    // Unique identifier for the recipe
    int id
  
    // Name of the recipe
    text name filters=trim
  
    // Brief description of the recipe
    text description filters=trim
  
    // Step-by-step cooking instructions
    text[] instructions
  
    // Preparation time in minutes
    int prep_time_minutes? filters=min:0
  
    // Cooking time in minutes
    int cook_time_minutes? filters=min:0
  
    // Total time (prep + cook) in minutes
    int total_time_minutes? filters=min:0
  
    // Number of servings the recipe yields
    int servings? filters=min:1
  
    // Difficulty level of the recipe
    enum difficulty? {
      values = ["easy", "medium", "hard", "expert"]
    }
  
    // Cuisine type of the recipe
    int cuisine_id? {
      table = "cuisine"
    }
  
    // Allergens present in this recipe
    int[] allergy_ids {
      table = "allergy"
    }
  
    // Whether the recipe is vegetarian
    bool is_vegetarian?
  
    // Whether the recipe is vegan
    bool is_vegan?
  
    // Whether the recipe is gluten-free
    bool is_gluten_free?
  
    // Whether the recipe is dairy-free
    bool is_dairy_free?
  
    // Type of meal
    enum meal_type? {
      values = [
        "breakfast"
        "lunch"
        "dinner"
        "snack"
        "dessert"
        "appetizer"
        "beverage"
      ]
    
    }
  
    // Nutritional information per serving
    json nutritional_info?
  
    // Images of the recipe and final dish
    image[] images
  
    // Video tutorial for the recipe
    video video_url?
  
    // Tags for categorization and search (e.g., quick, healthy, comfort-food)
    text[] tags
  
    // Number of times the recipe has been viewed
    int view_count?
  
    // Score calculated based on recent views for trending algorithm
    decimal viewed_score?
  
    // Average rating of the recipe (0-5 stars)
    decimal rating? filters=min:0|max:5
  
    // Number of ratings received
    int rating_count?
  
    // Whether the recipe is published and visible to the public
    bool is_published?
  
    // URL-friendly slug for the recipe
    text slug filters=trim
  
    // Timestamp when the recipe was created
    timestamp created_at?=now
  
    // Timestamp when the recipe was last updated
    timestamp updated_at?
  
    // Timestamp when the recipe was published
    timestamp published_at?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "slug", op: "asc"}]}
    {type: "btree", field: [{name: "cuisine_id", op: "asc"}]}
    {type: "btree", field: [{name: "difficulty", op: "asc"}]}
    {type: "btree", field: [{name: "meal_type", op: "asc"}]}
    {type: "btree", field: [{name: "is_vegetarian", op: "asc"}]}
    {type: "btree", field: [{name: "is_vegan", op: "asc"}]}
    {type: "btree", field: [{name: "is_gluten_free", op: "asc"}]}
    {type: "btree", field: [{name: "is_published", op: "asc"}]}
    {type: "btree", field: [{name: "rating", op: "desc"}]}
    {type: "btree", field: [{name: "view_count", op: "desc"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
    {
      type : "btree"
      field: [{name: "total_time_minutes", op: "asc"}]
    }
    {type: "gin", field: [{name: "nutritional_info"}]}
  ]
}