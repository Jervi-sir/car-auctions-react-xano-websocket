// Main recipe table with full recipe information
table recipe {
  auth = false

  schema {
    int id
  
    // Basic information
    text name filters=trim
  
    text slug filters=trim|lower
    text description? filters=trim
    text instructions? filters=trim
  
    // Categorization
    int cuisine_id? {
      table = "cuisine"
    }
  
    enum difficulty? {
      values = ["easy", "medium", "hard", "expert"]
    }
  
    enum meal_type? {
      values = ["breakfast", "lunch", "dinner", "snack", "dessert", "appetizer"]
    }
  
    // Timing
    int prep_time_minutes? filters=min:0
  
    int cook_time_minutes? filters=min:0
    int total_time_minutes? filters=min:0
    int servings?=4 filters=min:1
  
    // Dietary information
    bool is_vegetarian?
  
    bool is_vegan?
    bool is_gluten_free?
    bool is_dairy_free?
  
    // Allergen relationships
    int[] allergy_ids {
      table = "allergy"
    }
  
    // Media
    image featured_image?
  
    image[] gallery_images
    video video_url?
  
    // Engagement metrics
    decimal rating? filters=min:0|max:5
  
    int review_count? filters=min:0
    int view_count? filters=min:0
    decimal viewed_score? filters=min:0
  
    // Publishing
    bool is_published?
  
    timestamp published_at?
  
    // Metadata
    json metadata?
  
    timestamp created_at?=now
    timestamp updated_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "slug", op: "asc"}]}
    {type: "btree", field: [{name: "name", op: "asc"}]}
    {type: "btree", field: [{name: "cuisine_id", op: "asc"}]}
    {type: "btree", field: [{name: "difficulty", op: "asc"}]}
    {type: "btree", field: [{name: "meal_type", op: "asc"}]}
    {type: "btree", field: [{name: "is_vegetarian", op: "asc"}]}
    {type: "btree", field: [{name: "is_vegan", op: "asc"}]}
    {type: "btree", field: [{name: "is_gluten_free", op: "asc"}]}
    {type: "btree", field: [{name: "is_dairy_free", op: "asc"}]}
    {type: "btree", field: [{name: "rating", op: "desc"}]}
    {type: "btree", field: [{name: "view_count", op: "desc"}]}
    {type: "btree", field: [{name: "viewed_score", op: "desc"}]}
    {type: "btree", field: [{name: "is_published", op: "asc"}]}
    {type: "btree", field: [{name: "published_at", op: "desc"}]}
    {type: "gin", field: [{name: "metadata"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}