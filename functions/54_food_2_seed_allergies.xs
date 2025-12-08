// Seed allergies table with common allergens
function food_2_seed_allergies {
  input {
  }

  stack {
    // Truncate table first
    db.truncate allergy {
      reset = true
    }
  
    // Peanuts
    db.add allergy {
      data = {
        name       : "Peanuts"
        slug       : "peanuts"
        description: "Peanut allergy can cause severe reactions"
        severity   : "severe"
        created_at : now
      }
    }
  
    // Tree Nuts
    db.add allergy {
      data = {
        name       : "Tree Nuts"
        slug       : "tree-nuts"
        description: "Includes almonds, walnuts, cashews, and other tree nuts"
        severity   : "severe"
        created_at : now
      }
    }
  
    // Dairy
    db.add allergy {
      data = {
        name       : "Dairy"
        slug       : "dairy"
        description: "Milk and dairy product allergies"
        severity   : "moderate"
        created_at : now
      }
    }
  
    // Eggs
    db.add allergy {
      data = {
        name       : "Eggs"
        slug       : "eggs"
        description: "Egg allergy common in children"
        severity   : "moderate"
        created_at : now
      }
    }
  
    // Soy
    db.add allergy {
      data = {
        name       : "Soy"
        slug       : "soy"
        description: "Soybean and soy product allergies"
        severity   : "moderate"
        created_at : now
      }
    }
  
    // Wheat
    db.add allergy {
      data = {
        name       : "Wheat"
        slug       : "wheat"
        description: "Wheat and gluten allergies"
        severity   : "moderate"
        created_at : now
      }
    }
  
    // Fish
    db.add allergy {
      data = {
        name       : "Fish"
        slug       : "fish"
        description: "Finned fish allergies"
        severity   : "severe"
        created_at : now
      }
    }
  
    // Shellfish
    db.add allergy {
      data = {
        name       : "Shellfish"
        slug       : "shellfish"
        description: "Shrimp, crab, lobster, and other shellfish"
        severity   : "severe"
        created_at : now
      }
    }
  
    // Sesame
    db.add allergy {
      data = {
        name       : "Sesame"
        slug       : "sesame"
        description: "Sesame seed allergies"
        severity   : "moderate"
        created_at : now
      }
    }
  
    // Sulfites
    db.add allergy {
      data = {
        name       : "Sulfites"
        slug       : "sulfites"
        description: "Preservatives found in dried fruits and wine"
        severity   : "mild"
        created_at : now
      }
    }
  
    debug.log {
      value = "Seeded allergies table successfully"
    }
  }

  response = {result: "Allergies seeded successfully", count: 10}
}