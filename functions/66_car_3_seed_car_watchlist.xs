// Seed car_watchlist table with user favorites
function car_3_seed_car_watchlist {
  input {
  }

  stack {
    // Truncate table first
    db.truncate car_watchlist {
      reset = true
    }
  
    // Get car auctions and users for relationships
    db.query car_auction {
      return = {type: "list", paging: {page: 1, per_page: 5}}
    } as $auctions
  
    db.query user {
      return = {type: "list", paging: {page: 1, per_page: 8}}
    } as $users
  
    // User 1 watching Porsche and Ferrari
    db.add car_watchlist {
      data = {
        user_id              : $users.items.0.id
        car_auction_id       : $auctions.items.0.id
        notify_on_new_bid    : true
        notify_on_price_drop : true
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-432000
      }
    }
  
    db.add car_watchlist {
      data = {
        user_id              : $users.items.0.id
        car_auction_id       : $auctions.items.1.id
        notify_on_new_bid    : true
        notify_on_price_drop : false
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-345600
      }
    }
  
    // User 2 watching Mercedes and Jaguar
    db.add car_watchlist {
      data = {
        user_id              : $users.items.1.id
        car_auction_id       : $auctions.items.2.id
        notify_on_new_bid    : true
        notify_on_price_drop : true
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-259200
      }
    }
  
    db.add car_watchlist {
      data = {
        user_id              : $users.items.1.id
        car_auction_id       : $auctions.items.4.id
        notify_on_new_bid    : false
        notify_on_price_drop : true
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-172800
      }
    }
  
    // User 3 watching Lamborghini
    db.add car_watchlist {
      data = {
        user_id              : $users.items.2.id
        car_auction_id       : $auctions.items.3.id
        notify_on_new_bid    : true
        notify_on_price_drop : true
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-518400
      }
    }
  
    // User 4 watching Ferrari and Mercedes
    db.add car_watchlist {
      data = {
        user_id              : $users.items.3.id
        car_auction_id       : $auctions.items.1.id
        notify_on_new_bid    : true
        notify_on_price_drop : true
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-345600
      }
    }
  
    db.add car_watchlist {
      data = {
        user_id              : $users.items.3.id
        car_auction_id       : $auctions.items.2.id
        notify_on_new_bid    : true
        notify_on_price_drop : false
        notify_on_ending_soon: false
        created_at           : now|add_secs_to_timestamp:-259200
      }
    }
  
    // User 5 watching Porsche and Lamborghini
    db.add car_watchlist {
      data = {
        user_id              : $users.items.4.id
        car_auction_id       : $auctions.items.0.id
        notify_on_new_bid    : false
        notify_on_price_drop : true
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-172800
      }
    }
  
    db.add car_watchlist {
      data = {
        user_id              : $users.items.4.id
        car_auction_id       : $auctions.items.3.id
        notify_on_new_bid    : true
        notify_on_price_drop : true
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-86400
      }
    }
  
    // User 6 watching Jaguar
    db.add car_watchlist {
      data = {
        user_id              : $users.items.5.id
        car_auction_id       : $auctions.items.4.id
        notify_on_new_bid    : true
        notify_on_price_drop : true
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-86400
      }
    }
  
    // User 7 watching Ferrari
    db.add car_watchlist {
      data = {
        user_id              : $users.items.6.id
        car_auction_id       : $auctions.items.1.id
        notify_on_new_bid    : true
        notify_on_price_drop : true
        notify_on_ending_soon: false
        created_at           : now|add_secs_to_timestamp:-432000
      }
    }
  
    // User 8 watching Mercedes and Porsche
    db.add car_watchlist {
      data = {
        user_id              : $users.items.7.id
        car_auction_id       : $auctions.items.2.id
        notify_on_new_bid    : true
        notify_on_price_drop : true
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-259200
      }
    }
  
    db.add car_watchlist {
      data = {
        user_id              : $users.items.7.id
        car_auction_id       : $auctions.items.0.id
        notify_on_new_bid    : false
        notify_on_price_drop : false
        notify_on_ending_soon: true
        created_at           : now|add_secs_to_timestamp:-172800
      }
    }
  
    debug.log {
      value = "Seeded car_watchlist table successfully"
    }
  }

  response = {result: "Car watchlist seeded successfully", count: 13}
}