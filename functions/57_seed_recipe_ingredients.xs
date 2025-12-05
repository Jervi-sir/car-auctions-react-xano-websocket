// Seed recipe_ingredient junction table
function seed_recipe_ingredients {
  input {
  }

  stack {
    // Truncate table first
    db.truncate recipe_ingredient {
      reset = true
    }
  
    // Recipe 1: Spaghetti Carbonara ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 1
        ingredient_id   : 6
        quantity        : "1"
        unit            : "pound"
        preparation_note: "spaghetti"
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 1
        ingredient_id   : 12
        quantity        : "4"
        unit            : "whole"
        preparation_note: "beaten"
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 1
        ingredient_id   : 7
        quantity        : "1"
        unit            : "cup"
        preparation_note: "grated"
        order_index     : 3
        created_at      : now
      }
    }
  
    // Recipe 2: Chicken Tacos ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 2
        ingredient_id   : 2
        quantity        : "1"
        unit            : "pound"
        preparation_note: "diced"
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 2
        ingredient_id   : 5
        quantity        : "1"
        unit            : "whole"
        preparation_note: "diced"
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 2
        ingredient_id   : 3
        quantity        : "2"
        unit            : "teaspoons"
        preparation_note: "minced"
        order_index     : 3
        created_at      : now
      }
    }
  
    // Recipe 3: Vegetable Stir Fry ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 3
        ingredient_id   : 10
        quantity        : "2"
        unit            : "whole"
        preparation_note: "sliced"
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 3
        ingredient_id   : 5
        quantity        : "1"
        unit            : "whole"
        preparation_note: "sliced"
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 3
        ingredient_id   : 3
        quantity        : "3"
        unit            : "teaspoons"
        preparation_note: "minced"
        order_index     : 3
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 3
        ingredient_id   : 4
        quantity        : "2"
        unit            : "tablespoons"
        preparation_note: ""
        order_index     : 4
        created_at      : now
      }
    }
  
    // Recipe 4: Salmon Teriyaki ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 4
        ingredient_id   : 9
        quantity        : "4"
        unit            : "pieces"
        preparation_note: "fillets"
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 4
        ingredient_id   : 3
        quantity        : "2"
        unit            : "teaspoons"
        preparation_note: "minced"
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 4
        ingredient_id   : 18
        quantity        : "2"
        unit            : "tablespoons"
        preparation_note: ""
        order_index     : 3
        created_at      : now
      }
    }
  
    // Recipe 5: Chicken Curry ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 5
        ingredient_id   : 2
        quantity        : "2"
        unit            : "pounds"
        preparation_note: "cubed"
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 5
        ingredient_id   : 1
        quantity        : "4"
        unit            : "whole"
        preparation_note: "diced"
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 5
        ingredient_id   : 5
        quantity        : "2"
        unit            : "whole"
        preparation_note: "diced"
        order_index     : 3
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 5
        ingredient_id   : 3
        quantity        : "4"
        unit            : "teaspoons"
        preparation_note: "minced"
        order_index     : 4
        created_at      : now
      }
    }
  
    // Recipe 6: French Onion Soup ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 6
        ingredient_id   : 5
        quantity        : "4"
        unit            : "whole"
        preparation_note: "sliced thin"
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 6
        ingredient_id   : 13
        quantity        : "2"
        unit            : "tablespoons"
        preparation_note: ""
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 6
        ingredient_id   : 7
        quantity        : "1"
        unit            : "cup"
        preparation_note: "grated"
        order_index     : 3
        created_at      : now
      }
    }
  
    // Recipe 7: Pad Thai ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 7
        ingredient_id   : 8
        quantity        : "8"
        unit            : "ounces"
        preparation_note: "rice noodles"
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 7
        ingredient_id   : 2
        quantity        : "8"
        unit            : "ounces"
        preparation_note: "sliced"
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 7
        ingredient_id   : 3
        quantity        : "3"
        unit            : "teaspoons"
        preparation_note: "minced"
        order_index     : 3
        created_at      : now
      }
    }
  
    // Recipe 8: Greek Salad ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 8
        ingredient_id   : 1
        quantity        : "4"
        unit            : "whole"
        preparation_note: "chopped"
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 8
        ingredient_id   : 5
        quantity        : "1"
        unit            : "whole"
        preparation_note: "sliced"
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 8
        ingredient_id   : 4
        quantity        : "3"
        unit            : "tablespoons"
        preparation_note: ""
        order_index     : 3
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 8
        ingredient_id   : 16
        quantity        : "1"
        unit            : "whole"
        preparation_note: "juiced"
        order_index     : 4
        created_at      : now
      }
    }
  
    // Recipe 9: Classic Burger ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 9
        ingredient_id   : 20
        quantity        : "1.5"
        unit            : "pounds"
        preparation_note: ""
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 9
        ingredient_id   : 5
        quantity        : "1"
        unit            : "whole"
        preparation_note: "sliced"
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 9
        ingredient_id   : 1
        quantity        : "2"
        unit            : "whole"
        preparation_note: "sliced"
        order_index     : 3
        created_at      : now
      }
    }
  
    // Recipe 10: Mediterranean Quinoa Bowl ingredients
    db.add recipe_ingredient {
      data = {
        recipe_id       : 10
        ingredient_id   : 8
        quantity        : "1"
        unit            : "cup"
        preparation_note: "quinoa, uncooked"
        order_index     : 1
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 10
        ingredient_id   : 1
        quantity        : "2"
        unit            : "whole"
        preparation_note: "diced"
        order_index     : 2
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 10
        ingredient_id   : 10
        quantity        : "1"
        unit            : "whole"
        preparation_note: "diced"
        order_index     : 3
        created_at      : now
      }
    }
  
    db.add recipe_ingredient {
      data = {
        recipe_id       : 10
        ingredient_id   : 4
        quantity        : "3"
        unit            : "tablespoons"
        preparation_note: ""
        order_index     : 4
        created_at      : now
      }
    }
  
    debug.log {
      value = "Seeded recipe_ingredient table successfully"
    }
  }

  response = {
    result: "Recipe ingredients seeded successfully"
    count : 40
  }
}