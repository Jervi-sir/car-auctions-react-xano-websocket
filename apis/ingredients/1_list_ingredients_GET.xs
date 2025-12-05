// Get a paginated list of ingredients with filtering options
query ingredients verb=GET {
  input {
    // Page number for pagination
    int page?=1
  
    // Number of items per page (max 200)
    int per_page?=50 filters=min:1|max:200
  
    // Search term for ingredient name
    text search? filters=trim
  
    // Filter by category (vegetable, fruit, meat, seafood, dairy, grain, spice, herb, nut, legume, oil, condiment, sweetener, beverage, other)
    text category? filters=trim
  
    // Filter for vegetarian ingredients
    bool is_vegetarian?
  
    // Filter for vegan ingredients
    bool is_vegan?
  
    // Filter for gluten-free ingredients
    bool is_gluten_free?
  
    // Array of allergen names to exclude
    text[] exclude_allergens
  }

  stack {
    db.query ingredient {
      where = $db.ingredient.name includes? $input.search && $db.ingredient.category ==? $input.category && $db.ingredient.is_vegetarian ==? $input.is_vegetarian && $db.ingredient.is_vegan ==? $input.is_vegan && $db.ingredient.is_gluten_free ==? $input.is_gluten_free
      sort = {ingredient.name: "asc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $ingredients
  }

  response = $ingredients
  history = false
}