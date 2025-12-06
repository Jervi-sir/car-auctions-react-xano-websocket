// Get all published recipes with filtering and pagination
query list_recipes verb=GET {
  input {
    // Pagination
    int page?=1 filters=min:1
  
    int per_page?=20 filters=min:1|max:100
  
    // Filtering
    int cuisine_id? filters=min:1
  
    text difficulty?
    text meal_type?
    text search? filters=trim
  
    // Dietary filters
    bool is_vegetarian?
  
    bool is_vegan?
    bool is_gluten_free?
    bool is_dairy_free?
  
    // Sorting
    text sort_by?="created_at"
  
    text sort_order?=desc
  }

  stack {
    db.query recipe {
      where = $db.recipe.is_published && ($db.recipe.cuisine_id ==? $input.cuisine_id) && ($db.recipe.difficulty ==? $input.difficulty) && ($db.recipe.meal_type ==? $input.meal_type) && ($db.recipe.name includes? $input.search || $db.recipe.description includes? $input.search) && ($db.recipe.is_vegetarian ==? $input.is_vegetarian) && ($db.recipe.is_vegan ==? $input.is_vegan) && ($db.recipe.is_gluten_free ==? $input.is_gluten_free) && ($db.recipe.is_dairy_free ==? $input.is_dairy_free)
      sort = {recipe.created_at: "sort_order"}
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