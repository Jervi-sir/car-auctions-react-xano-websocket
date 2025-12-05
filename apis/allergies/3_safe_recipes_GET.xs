// Find recipes that are safe for people with specific allergies
query "allergies/safe-recipes" verb=GET {
  input {
    // Array of allergy IDs to avoid
    int[] allergy_ids
  
    // Page number for pagination
    int page?=1
  
    // Number of items per page (max 100)
    int per_page?=20 filters=min:1|max:100
  
    // Filter by meal type (breakfast, lunch, dinner, snack, dessert, appetizer, beverage)
    text meal_type? filters=trim
  
    // Filter by difficulty level (easy, medium, hard, expert)
    text difficulty? filters=trim
  }

  stack {
    db.query recipe {
      where = $db.recipe.is_published && $db.recipe.allergy_ids not overlaps $input.allergy_ids && $db.recipe.meal_type ==? $input.meal_type && $db.recipe.difficulty ==? $input.difficulty
      sort = {recipe.rating: "desc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $safe_recipes
  }

  response = $safe_recipes
  history = false
}