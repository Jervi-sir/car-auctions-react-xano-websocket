// Seed recipes table with sample recipes
function food_4_seed_recipes {
  input {
  }

  stack {
    // Truncate table first
    db.truncate recipe {
      reset = true
    }
  
    // Get cuisine IDs
    db.query cuisine {
      return = {type: "list"}
    } as $cuisines
  
    // Spaghetti Carbonara (Italian)
    db.add recipe {
      data = {
        name              : "Spaghetti Carbonara"
        slug              : "spaghetti-carbonara"
        description       : "Classic Italian pasta dish with eggs, cheese, and pancetta"
        instructions      : "Cook pasta. Fry pancetta. Mix eggs and cheese. Combine all ingredients while hot."
        cuisine_id        : 1
        difficulty        : "medium"
        meal_type         : "dinner"
        prep_time_minutes : 10
        cook_time_minutes : 20
        total_time_minutes: 30
        servings          : 4
        is_vegetarian     : false
        is_vegan          : false
        is_gluten_free    : false
        is_dairy_free     : false
        allergy_ids       : []
        rating            : 4.5
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    // Chicken Tacos (Mexican)
    db.add recipe {
      data = {
        name              : "Chicken Tacos"
        slug              : "chicken-tacos"
        description       : "Flavorful chicken tacos with fresh toppings"
        instructions      : "Season and cook chicken. Warm tortillas. Assemble tacos with toppings."
        cuisine_id        : 2
        difficulty        : "easy"
        meal_type         : "dinner"
        prep_time_minutes : 15
        cook_time_minutes : 15
        total_time_minutes: 30
        servings          : 4
        is_vegetarian     : false
        is_vegan          : false
        is_gluten_free    : true
        is_dairy_free     : false
        allergy_ids       : []
        rating            : 4.7
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    // Vegetable Stir Fry (Chinese)
    db.add recipe {
      data = {
        name              : "Vegetable Stir Fry"
        slug              : "vegetable-stir-fry"
        description       : "Quick and healthy vegetable stir fry with soy sauce"
        instructions      : "Chop vegetables. Heat wok. Stir fry vegetables. Add sauce."
        cuisine_id        : 3
        difficulty        : "easy"
        meal_type         : "dinner"
        prep_time_minutes : 15
        cook_time_minutes : 10
        total_time_minutes: 25
        servings          : 4
        is_vegetarian     : true
        is_vegan          : true
        is_gluten_free    : false
        is_dairy_free     : true
        allergy_ids       : []
        rating            : 4.3
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    // Salmon Teriyaki (Japanese)
    db.add recipe {
      data = {
        name              : "Salmon Teriyaki"
        slug              : "salmon-teriyaki"
        description       : "Glazed salmon with homemade teriyaki sauce"
        instructions      : "Make teriyaki sauce. Marinate salmon. Grill or pan-fry salmon."
        cuisine_id        : 4
        difficulty        : "medium"
        meal_type         : "dinner"
        prep_time_minutes : 20
        cook_time_minutes : 15
        total_time_minutes: 35
        servings          : 4
        is_vegetarian     : false
        is_vegan          : false
        is_gluten_free    : false
        is_dairy_free     : true
        allergy_ids       : []
        rating            : 4.8
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    // Chicken Curry (Indian)
    db.add recipe {
      data = {
        name              : "Chicken Curry"
        slug              : "chicken-curry"
        description       : "Aromatic Indian chicken curry with spices"
        instructions      : "Toast spices. Cook onions and garlic. Add chicken and tomatoes. Simmer with cream."
        cuisine_id        : 5
        difficulty        : "medium"
        meal_type         : "dinner"
        prep_time_minutes : 20
        cook_time_minutes : 40
        total_time_minutes: 60
        servings          : 6
        is_vegetarian     : false
        is_vegan          : false
        is_gluten_free    : true
        is_dairy_free     : false
        allergy_ids       : []
        rating            : 4.6
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    // French Onion Soup (French)
    db.add recipe {
      data = {
        name              : "French Onion Soup"
        slug              : "french-onion-soup"
        description       : "Classic French soup with caramelized onions and cheese"
        instructions      : "Caramelize onions. Add broth and wine. Top with bread and cheese. Broil until golden."
        cuisine_id        : 6
        difficulty        : "medium"
        meal_type         : "lunch"
        prep_time_minutes : 15
        cook_time_minutes : 60
        total_time_minutes: 75
        servings          : 4
        is_vegetarian     : true
        is_vegan          : false
        is_gluten_free    : false
        is_dairy_free     : false
        allergy_ids       : []
        rating            : 4.4
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    // Pad Thai (Thai)
    db.add recipe {
      data = {
        name              : "Pad Thai"
        slug              : "pad-thai"
        description       : "Popular Thai stir-fried noodles with peanuts"
        instructions      : "Soak noodles. Prepare sauce. Stir fry ingredients. Add noodles and sauce."
        cuisine_id        : 7
        difficulty        : "medium"
        meal_type         : "dinner"
        prep_time_minutes : 20
        cook_time_minutes : 15
        total_time_minutes: 35
        servings          : 4
        is_vegetarian     : false
        is_vegan          : false
        is_gluten_free    : true
        is_dairy_free     : true
        allergy_ids       : []
        rating            : 4.7
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    // Greek Salad (Greek)
    db.add recipe {
      data = {
        name              : "Greek Salad"
        slug              : "greek-salad"
        description       : "Fresh Mediterranean salad with feta cheese"
        instructions      : "Chop vegetables. Make dressing. Toss salad. Top with feta and olives."
        cuisine_id        : 8
        difficulty        : "easy"
        meal_type         : "lunch"
        prep_time_minutes : 15
        cook_time_minutes : 0
        total_time_minutes: 15
        servings          : 4
        is_vegetarian     : true
        is_vegan          : false
        is_gluten_free    : true
        is_dairy_free     : false
        allergy_ids       : []
        rating            : 4.5
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    // Classic Burger (American)
    db.add recipe {
      data = {
        name              : "Classic Burger"
        slug              : "classic-burger"
        description       : "Juicy American-style beef burger"
        instructions      : "Form patties. Season beef. Grill burgers. Toast buns. Assemble with toppings."
        cuisine_id        : 9
        difficulty        : "easy"
        meal_type         : "dinner"
        prep_time_minutes : 10
        cook_time_minutes : 15
        total_time_minutes: 25
        servings          : 4
        is_vegetarian     : false
        is_vegan          : false
        is_gluten_free    : false
        is_dairy_free     : false
        allergy_ids       : []
        rating            : 4.6
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    // Mediterranean Quinoa Bowl (Mediterranean)
    db.add recipe {
      data = {
        name              : "Mediterranean Quinoa Bowl"
        slug              : "mediterranean-quinoa-bowl"
        description       : "Healthy quinoa bowl with vegetables and tahini"
        instructions      : "Cook quinoa. Roast vegetables. Prepare tahini dressing. Assemble bowl."
        cuisine_id        : 10
        difficulty        : "easy"
        meal_type         : "lunch"
        prep_time_minutes : 15
        cook_time_minutes : 30
        total_time_minutes: 45
        servings          : 4
        is_vegetarian     : true
        is_vegan          : true
        is_gluten_free    : true
        is_dairy_free     : true
        allergy_ids       : []
        rating            : 4.4
        review_count      : 0
        view_count        : 0
        viewed_score      : 0
        is_published      : true
        published_at      : now
        created_at        : now
      }
    }
  
    debug.log {
      value = "Seeded recipes table successfully"
    }
  }

  response = {result: "Recipes seeded successfully", count: 10}
}