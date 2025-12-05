// Seed recipe_review table with sample reviews
function seed_recipe_reviews {
  input {
  }

  stack {
    // Truncate table first
    db.truncate recipe_review {
      reset = true
    }
  
    // Reviews for Recipe 1: Spaghetti Carbonara
    db.add recipe_review {
      data = {
        recipe_id           : 1
        reviewer_name       : "Maria Romano"
        reviewer_email      : "maria@example.com"
        rating              : 5
        review_text         : "Absolutely authentic! Just like my nonna used to make. The key is to work quickly when mixing the eggs."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 12
        created_at          : now
      }
    }
  
    db.add recipe_review {
      data = {
        recipe_id           : 1
        reviewer_name       : "John Smith"
        reviewer_email      : "john@example.com"
        rating              : 4
        review_text         : "Great recipe! I added some peas for extra color and nutrition."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 5
        created_at          : now
      }
    }
  
    // Reviews for Recipe 2: Chicken Tacos
    db.add recipe_review {
      data = {
        recipe_id           : 2
        reviewer_name       : "Carlos Martinez"
        reviewer_email      : "carlos@example.com"
        rating              : 5
        review_text         : "Perfect tacos! The seasoning is spot on. My family loved them."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 8
        created_at          : now
      }
    }
  
    db.add recipe_review {
      data = {
        recipe_id           : 2
        reviewer_name       : "Sarah Johnson"
        reviewer_email      : "sarah@example.com"
        rating              : 4
        review_text         : "Delicious and easy to make. I used corn tortillas instead of flour."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 3
        created_at          : now
      }
    }
  
    // Reviews for Recipe 3: Vegetable Stir Fry
    db.add recipe_review {
      data = {
        recipe_id           : 3
        reviewer_name       : "Emily Chen"
        reviewer_email      : "emily@example.com"
        rating              : 4
        review_text         : "Healthy and tasty! I added tofu for extra protein."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 6
        created_at          : now
      }
    }
  
    // Reviews for Recipe 4: Salmon Teriyaki
    db.add recipe_review {
      data = {
        recipe_id           : 4
        reviewer_name       : "Yuki Tanaka"
        reviewer_email      : "yuki@example.com"
        rating              : 5
        review_text         : "The teriyaki sauce is amazing! Better than store-bought."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 15
        created_at          : now
      }
    }
  
    db.add recipe_review {
      data = {
        recipe_id           : 4
        reviewer_name       : "David Lee"
        reviewer_email      : "david@example.com"
        rating              : 5
        review_text         : "Restaurant quality at home. The salmon was perfectly cooked."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 9
        created_at          : now
      }
    }
  
    // Reviews for Recipe 5: Chicken Curry
    db.add recipe_review {
      data = {
        recipe_id           : 5
        reviewer_name       : "Priya Sharma"
        reviewer_email      : "priya@example.com"
        rating              : 5
        review_text         : "Reminds me of home! The spice blend is perfect."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 11
        created_at          : now
      }
    }
  
    db.add recipe_review {
      data = {
        recipe_id           : 5
        reviewer_name       : "Michael Brown"
        reviewer_email      : "michael@example.com"
        rating              : 4
        review_text         : "Very flavorful. I reduced the heat a bit for my kids."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 4
        created_at          : now
      }
    }
  
    // Reviews for Recipe 6: French Onion Soup
    db.add recipe_review {
      data = {
        recipe_id           : 6
        reviewer_name       : "Pierre Dubois"
        reviewer_email      : "pierre@example.com"
        rating              : 4
        review_text         : "Classic French comfort food. Takes time but worth it!"
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 7
        created_at          : now
      }
    }
  
    // Reviews for Recipe 7: Pad Thai
    db.add recipe_review {
      data = {
        recipe_id           : 7
        reviewer_name       : "Somchai Wong"
        reviewer_email      : "somchai@example.com"
        rating              : 5
        review_text         : "Authentic taste! Just like the street food in Bangkok."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 13
        created_at          : now
      }
    }
  
    db.add recipe_review {
      data = {
        recipe_id           : 7
        reviewer_name       : "Lisa Anderson"
        reviewer_email      : "lisa@example.com"
        rating              : 4
        review_text         : "Great recipe! I added extra peanuts because I love them."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 5
        created_at          : now
      }
    }
  
    // Reviews for Recipe 8: Greek Salad
    db.add recipe_review {
      data = {
        recipe_id           : 8
        reviewer_name       : "Nikos Papadopoulos"
        reviewer_email      : "nikos@example.com"
        rating              : 5
        review_text         : "Simple and delicious. Use good quality olive oil and feta!"
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 10
        created_at          : now
      }
    }
  
    // Reviews for Recipe 9: Classic Burger
    db.add recipe_review {
      data = {
        recipe_id           : 9
        reviewer_name       : "Tom Wilson"
        reviewer_email      : "tom@example.com"
        rating              : 5
        review_text         : "Best burger recipe! The patties were juicy and flavorful."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 14
        created_at          : now
      }
    }
  
    db.add recipe_review {
      data = {
        recipe_id           : 9
        reviewer_name       : "Jennifer Davis"
        reviewer_email      : "jennifer@example.com"
        rating              : 4
        review_text         : "Great basic burger. I added bacon and avocado."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 6
        created_at          : now
      }
    }
  
    // Reviews for Recipe 10: Mediterranean Quinoa Bowl
    db.add recipe_review {
      data = {
        recipe_id           : 10
        reviewer_name       : "Anna Rossi"
        reviewer_email      : "anna@example.com"
        rating              : 4
        review_text         : "Healthy and filling! Perfect for meal prep."
        review_images       : []
        is_approved         : true
        is_verified_purchase: false
        helpful_count       : 8
        created_at          : now
      }
    }
  
    debug.log {
      value = "Seeded recipe_review table successfully"
    }
  }

  response = {
    result: "Recipe reviews seeded successfully"
    count : 16
  }
}