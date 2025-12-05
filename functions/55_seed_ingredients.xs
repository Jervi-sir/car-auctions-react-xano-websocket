// Seed ingredients table with common cooking ingredients
function seed_ingredients {
  input {
  }

  stack {
    // Truncate table first
    db.truncate ingredient {
      reset = true
    }
  
    // Get allergy IDs for reference
    db.query allergy {
      return = {type: "list"}
    } as $allergies
  
    // Tomato
    db.add ingredient {
      data = {
        name          : "Tomato"
        slug          : "tomato"
        description   : "Fresh red tomatoes"
        category      : "vegetable"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Chicken Breast
    db.add ingredient {
      data = {
        name          : "Chicken Breast"
        slug          : "chicken-breast"
        description   : "Boneless skinless chicken breast"
        category      : "poultry"
        is_vegetarian : false
        is_vegan      : false
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Garlic
    db.add ingredient {
      data = {
        name          : "Garlic"
        slug          : "garlic"
        description   : "Fresh garlic cloves"
        category      : "vegetable"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Olive Oil
    db.add ingredient {
      data = {
        name          : "Olive Oil"
        slug          : "olive-oil"
        description   : "Extra virgin olive oil"
        category      : "oil"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Onion
    db.add ingredient {
      data = {
        name          : "Onion"
        slug          : "onion"
        description   : "Yellow onions"
        category      : "vegetable"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Pasta
    db.add ingredient {
      data = {
        name          : "Pasta"
        slug          : "pasta"
        description   : "Dried pasta noodles"
        category      : "grain"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: false
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Cheese (Parmesan)
    db.add ingredient {
      data = {
        name          : "Parmesan Cheese"
        slug          : "parmesan-cheese"
        description   : "Grated parmesan cheese"
        category      : "dairy"
        is_vegetarian : true
        is_vegan      : false
        is_gluten_free: true
        is_dairy_free : false
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Rice
    db.add ingredient {
      data = {
        name          : "Rice"
        slug          : "rice"
        description   : "White or brown rice"
        category      : "grain"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Salmon
    db.add ingredient {
      data = {
        name          : "Salmon"
        slug          : "salmon"
        description   : "Fresh salmon fillet"
        category      : "seafood"
        is_vegetarian : false
        is_vegan      : false
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Bell Pepper
    db.add ingredient {
      data = {
        name          : "Bell Pepper"
        slug          : "bell-pepper"
        description   : "Red, yellow, or green bell peppers"
        category      : "vegetable"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Basil
    db.add ingredient {
      data = {
        name          : "Basil"
        slug          : "basil"
        description   : "Fresh basil leaves"
        category      : "herb"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Eggs
    db.add ingredient {
      data = {
        name          : "Eggs"
        slug          : "eggs"
        description   : "Fresh chicken eggs"
        category      : "dairy"
        is_vegetarian : true
        is_vegan      : false
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Butter
    db.add ingredient {
      data = {
        name          : "Butter"
        slug          : "butter"
        description   : "Unsalted butter"
        category      : "dairy"
        is_vegetarian : true
        is_vegan      : false
        is_gluten_free: true
        is_dairy_free : false
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Black Pepper
    db.add ingredient {
      data = {
        name          : "Black Pepper"
        slug          : "black-pepper"
        description   : "Ground black pepper"
        category      : "spice"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Salt
    db.add ingredient {
      data = {
        name          : "Salt"
        slug          : "salt"
        description   : "Sea salt or table salt"
        category      : "spice"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Lemon
    db.add ingredient {
      data = {
        name          : "Lemon"
        slug          : "lemon"
        description   : "Fresh lemons"
        category      : "fruit"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Flour
    db.add ingredient {
      data = {
        name          : "All-Purpose Flour"
        slug          : "all-purpose-flour"
        description   : "Wheat flour for baking"
        category      : "grain"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: false
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Sugar
    db.add ingredient {
      data = {
        name          : "Sugar"
        slug          : "sugar"
        description   : "Granulated white sugar"
        category      : "sweetener"
        is_vegetarian : true
        is_vegan      : true
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Milk
    db.add ingredient {
      data = {
        name          : "Milk"
        slug          : "milk"
        description   : "Whole milk"
        category      : "dairy"
        is_vegetarian : true
        is_vegan      : false
        is_gluten_free: true
        is_dairy_free : false
        allergy_ids   : []
        created_at    : now
      }
    }
  
    // Beef
    db.add ingredient {
      data = {
        name          : "Ground Beef"
        slug          : "ground-beef"
        description   : "Ground beef for cooking"
        category      : "meat"
        is_vegetarian : false
        is_vegan      : false
        is_gluten_free: true
        is_dairy_free : true
        allergy_ids   : []
        created_at    : now
      }
    }
  
    debug.log {
      value = "Seeded ingredients table successfully"
    }
  }

  response = {result: "Ingredients seeded successfully", count: 20}
}