// Get a paginated list of published recipes with advanced filtering options including dietary restrictions, allergies, cuisine, difficulty, meal type, and cooking time
query recipes verb=GET {
  input {
    // Page number for pagination
    int page?=1
  
    // Number of items per page (max 100)
    int per_page?=20 filters=min:1|max:100
  
    // Search term for recipe name or description
    text search? filters=trim
  
    // Filter by cuisine ID
    int cuisine_id?
  
    // Filter by difficulty level (easy, medium, hard, expert)
    text difficulty? filters=trim
  
    // Filter by meal type (breakfast, lunch, dinner, snack, dessert, appetizer, beverage)
    text meal_type? filters=trim
  
    // Filter for vegetarian recipes
    bool is_vegetarian?
  
    // Filter for vegan recipes
    bool is_vegan?
  
    // Filter for gluten-free recipes
    bool is_gluten_free?
  
    // Filter for dairy-free recipes
    bool is_dairy_free?
  
    // Maximum total cooking time in minutes
    int max_time_minutes? filters=min:0
  
    // Minimum average rating (0-5)
    decimal min_rating? filters=min:0|max:5
  
    // Array of allergen names to exclude
    text[] exclude_allergens
  
    // Sort field (created_at, rating, view_count, total_time_minutes)
    text sort_by?="created_at" filters=trim
  
    // Sort order (asc or desc)
    text sort_order?=desc filters=trim
  }

  stack {
    db.query recipe {
      where = $db.recipe.is_published && ($db.recipe.name includes? $input.search || $db.recipe.description includes? $input.search) && $db.recipe.cuisine_id ==? $input.cuisine_id && $db.recipe.difficulty ==? $input.difficulty && $db.recipe.meal_type ==? $input.meal_type && $db.recipe.is_vegetarian ==? $input.is_vegetarian && $db.recipe.is_vegan ==? $input.is_vegan && $db.recipe.is_gluten_free ==? $input.is_gluten_free && $db.recipe.is_dairy_free ==? $input.is_dairy_free && $db.recipe.total_time_minutes <=? $input.max_time_minutes && $db.recipe.rating >=? $input.min_rating
      sort = {recipe.created_at: "desc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $recipes
  }

  response = $recipes
  history = false
}