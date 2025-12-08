// Seed cuisines table with popular cuisine types
function food_1_seed_cuisines {
  input {
  }

  stack {
    // Truncate table first
    db.truncate cuisine {
      reset = true
    }
  
    // Italian
    db.add cuisine {
      data = {
        name       : "Italian"
        slug       : "italian"
        description: "Traditional Italian cuisine featuring pasta, pizza, and Mediterranean flavors"
        created_at : now
      }
    }
  
    // Mexican
    db.add cuisine {
      data = {
        name       : "Mexican"
        slug       : "mexican"
        description: "Vibrant Mexican cuisine with bold spices, tacos, and authentic flavors"
        created_at : now
      }
    }
  
    // Chinese
    db.add cuisine {
      data = {
        name       : "Chinese"
        slug       : "chinese"
        description: "Diverse Chinese cuisine with stir-fries, dumplings, and regional specialties"
        created_at : now
      }
    }
  
    // Japanese
    db.add cuisine {
      data = {
        name       : "Japanese"
        slug       : "japanese"
        description: "Traditional Japanese cuisine including sushi, ramen, and tempura"
        created_at : now
      }
    }
  
    // Indian
    db.add cuisine {
      data = {
        name       : "Indian"
        slug       : "indian"
        description: "Rich Indian cuisine with aromatic spices, curries, and tandoori dishes"
        created_at : now
      }
    }
  
    // French
    db.add cuisine {
      data = {
        name       : "French"
        slug       : "french"
        description: "Classic French cuisine with refined techniques and elegant flavors"
        created_at : now
      }
    }
  
    // Thai
    db.add cuisine {
      data = {
        name       : "Thai"
        slug       : "thai"
        description: "Flavorful Thai cuisine balancing sweet, sour, salty, and spicy"
        created_at : now
      }
    }
  
    // Greek
    db.add cuisine {
      data = {
        name       : "Greek"
        slug       : "greek"
        description: "Mediterranean Greek cuisine with fresh ingredients and olive oil"
        created_at : now
      }
    }
  
    // American
    db.add cuisine {
      data = {
        name       : "American"
        slug       : "american"
        description: "Classic American comfort food and regional specialties"
        created_at : now
      }
    }
  
    // Mediterranean
    db.add cuisine {
      data = {
        name       : "Mediterranean"
        slug       : "mediterranean"
        description: "Healthy Mediterranean diet with fresh vegetables, seafood, and grains"
        created_at : now
      }
    }
  
    debug.log {
      value = "Seeded cuisines table successfully"
    }
  }

  response = {result: "Cuisines seeded successfully", count: 10}
}