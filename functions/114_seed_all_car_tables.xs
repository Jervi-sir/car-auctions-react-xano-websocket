// Master seed function - Seeds all tables in correct dependency order
function seed_all_car_tables {
  input {
  }

  stack {
    debug.log {
      value = "Starting database seeding process..."
    }
  
    // Step 1: Seed car auction
    function.run car_1_seed_car_auctions as $car_auctions
  
    debug.log {
      value = "Step 1/7: Car auction seeded"
    }
  
    // Step 2: Seed car bids
    function.run car_2_seed_car_bids as $car_bids
  
    debug.log {
      value = "Step 2/7: Car Bids seeded"
    }
  
    // Step 3: Seed car watchlist
    function.run car_3_seed_car_watchlist as $car_watchlist
  
    debug.log {
      value = "Step 3/7: Car Watchlist seeded"
    }
  
    // Step 4: Seed recipes (depends on cuisines and allergies)
    function.run car_4_seed_car_auction_view_history as $car_auction_view_history
  
    debug.log {
      value = "Step 4/7: Car Auction View History seeded"
    }
  
    debug.log {
      value = "Database seeding completed successfully!"
    }
  
    // Prepare summary response
    var $summary {
      value = {
        success      : true
        message      : "All tables seeded successfully"
        tables_seeded: 7
        details      : {
          car_auctions  : $car_auctions
          car_bids      : $car_bids
          car_watchlist : $car_watchlist
          car_auction_view_history  : $car_auction_view_history
        }
      }
    }
  }

  response = $summary
}