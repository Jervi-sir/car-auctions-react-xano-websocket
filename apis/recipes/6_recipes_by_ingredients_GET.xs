// Find recipes that can be made with specified ingredients
query "recipes/by-ingredients" verb=GET {
  input {
    // Array of ingredient IDs to search for
    int[] ingredient_ids
  
    // If true, recipe must contain ALL ingredients; if false, recipe must contain ANY of the ingredients
    bool match_all?
  
    // Page number for pagination
    int page?=1
  
    // Number of items per page (max 100)
    int per_page?=20 filters=min:1|max:100
  }

  stack {
    db.query recipe_ingredient {
      where = $db.recipe_ingredient.ingredient_id contains $input.ingredient_ids
      return = {type: "list"}
    } as $matching_recipe_ingredients
  
    var $recipe_ids {
      value = $matching_recipe_ingredients|map:$this.recipe_id|unique
    }
  
    db.query recipe {
      where = $db.recipe.id contains $recipe_ids && $db.recipe.is_published
      sort = {recipe.rating: "desc"}
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