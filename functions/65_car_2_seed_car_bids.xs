// Seed car_bid table with sample bids
function car_2_seed_car_bids {
  input {
  }

  stack {
    // Truncate table first
    db.truncate car_bid {
      reset = true
    }
  
    // Get first few car auctions and users for relationships
    db.query car_auction {
      return = {type: "list", paging: {page: 1, per_page: 5}}
    } as $auctions
  
    db.query user {
      return = {type: "list", paging: {page: 1, per_page: 8}}
    } as $users
  
    // Bids for Auction 1 (Porsche 911)
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.0.id
        bidder_id     : $users.items.0.id
        amount        : 155000
        currency      : "USD"
        is_winning    : false
        is_auto_bid   : false
        bid_source    : "web"
        is_valid      : true
        created_at    : now|add_secs_to_timestamp:-172800
      }
    }
  
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.0.id
        bidder_id     : $users.items.1.id
        amount        : 160000
        currency      : "USD"
        is_winning    : false
        is_auto_bid   : false
        bid_source    : "web"
        is_valid      : true
        created_at    : now|add_secs_to_timestamp:-86400
      }
    }
  
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.0.id
        bidder_id     : $users.items.2.id
        amount        : 165000
        currency      : "USD"
        is_winning    : true
        is_auto_bid   : false
        bid_source    : "mobile"
        is_valid      : true
        created_at    : now
      }
    }
  
    // Bids for Auction 2 (Ferrari F40)
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.1.id
        bidder_id     : $users.items.3.id
        amount        : 1250000
        currency      : "USD"
        is_winning    : false
        is_auto_bid   : false
        bid_source    : "web"
        is_valid      : true
        created_at    : now|add_secs_to_timestamp:-259200
      }
    }
  
    db.add car_bid {
      data = {
        car_auction_id     : $auctions.items.1.id
        bidder_id          : $users.items.4.id
        amount             : 1300000
        currency           : "USD"
        is_winning         : false
        is_auto_bid        : true
        max_auto_bid_amount: 1400000
        bid_source         : "web"
        is_valid           : true
        created_at         : now|add_secs_to_timestamp:-172800
      }
    }
  
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.1.id
        bidder_id     : $users.items.6.id
        amount        : 1350000
        currency      : "USD"
        is_winning    : true
        is_auto_bid   : false
        bid_source    : "web"
        is_valid      : true
        created_at    : now|add_secs_to_timestamp:-86400
      }
    }
  
    // Bids for Auction 3 (Mercedes 300SL)
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.2.id
        bidder_id     : $users.items.1.id
        amount        : 820000
        currency      : "USD"
        is_winning    : false
        is_auto_bid   : false
        bid_source    : "web"
        is_valid      : true
        created_at    : now|add_secs_to_timestamp:-86400
      }
    }
  
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.2.id
        bidder_id     : $users.items.5.id
        amount        : 850000
        currency      : "USD"
        is_winning    : true
        is_auto_bid   : false
        bid_source    : "mobile"
        is_valid      : true
        created_at    : now
      }
    }
  
    // Bids for Auction 4 (Lamborghini Countach)
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.3.id
        bidder_id     : $users.items.7.id
        amount        : 420000
        currency      : "USD"
        is_winning    : false
        is_auto_bid   : false
        bid_source    : "web"
        is_valid      : true
        created_at    : now|add_secs_to_timestamp:-345600
      }
    }
  
    db.add car_bid {
      data = {
        car_auction_id     : $auctions.items.3.id
        bidder_id          : $users.items.0.id
        amount             : 440000
        currency           : "USD"
        is_winning         : false
        is_auto_bid        : true
        max_auto_bid_amount: 480000
        bid_source         : "web"
        is_valid           : true
        created_at         : now|add_secs_to_timestamp:-259200
      }
    }
  
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.3.id
        bidder_id     : $users.items.3.id
        amount        : 460000
        currency      : "USD"
        is_winning    : true
        is_auto_bid   : false
        bid_source    : "web"
        is_valid      : true
        created_at    : now|add_secs_to_timestamp:-172800
      }
    }
  
    // Bids for Auction 5 (Jaguar E-Type)
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.4.id
        bidder_id     : $users.items.2.id
        amount        : 185000
        currency      : "USD"
        is_winning    : false
        is_auto_bid   : false
        bid_source    : "web"
        is_valid      : true
        created_at    : now|add_secs_to_timestamp:-86400
      }
    }
  
    db.add car_bid {
      data = {
        car_auction_id: $auctions.items.4.id
        bidder_id     : $users.items.4.id
        amount        : 195000
        currency      : "USD"
        is_winning    : true
        is_auto_bid   : false
        bid_source    : "mobile"
        is_valid      : true
        created_at    : now
      }
    }
  
    debug.log {
      value = "Seeded car_bid table successfully"
    }
  }

  response = {result: "Car bids seeded successfully", count: 13}
}