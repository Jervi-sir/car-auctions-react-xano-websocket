// Get detailed information about a specific allergy including affected ingredients and recipes
query "allergies/by-id" verb=GET {
  input {
    // Allergy ID
    int id
  }

  stack {
    db.get allergy {
      field_name = "id"
      field_value = $input.id
    } as $allergy
  
    // Validate allergy exists
    precondition ($allergy != null) {
      error_type = "notfound"
      error = "Allergy not found"
    }
  
    db.query ingredient {
      where = $db.ingredient.allergy_ids contains $input.id
      return = {type: "list", paging: {page: 1, per_page: 50, totals: true}}
    } as $affected_ingredients
  
    db.query recipe {
      where = $db.recipe.allergy_ids contains $input.id && $db.recipe.is_published
      return = {type: "list", paging: {page: 1, per_page: 20, totals: true}}
    } as $affected_recipes
  
    var $response_data {
      value = {
        allergy             : $allergy
        affected_ingredients: $affected_ingredients
        affected_recipes    : $affected_recipes
      }
    }
  }

  response = $response_data
  history = false
}