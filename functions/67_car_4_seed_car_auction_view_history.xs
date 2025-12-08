// Seed car_auction_view_history table with view tracking data
function car_4_seed_car_auction_view_history {
  input {
  }

  stack {
    // Truncate table first
    db.truncate car_auction_view_history {
      reset = true
    }
  
    // Get car auctions and users for relationships
    db.query car_auction {
      return = {type: "list", paging: {page: 1, per_page: 5}}
    } as $auctions
  
    db.query user {
      return = {type: "list", paging: {page: 1, per_page: 8}}
    } as $users
  
    // Views for Auction 1 (Porsche 911) - Most popular
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.0.id
        user_id              : $users.items.0.id
        ip_address           : "192.168.1.100"
        user_agent           : "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer             : "https://google.com"
        view_source          : "web"
        session_id           : "session_001"
        view_duration_seconds: 245
        created_at           : now|add_secs_to_timestamp:-604800
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.0.id
        user_id              : $users.items.1.id
        ip_address           : "192.168.1.101"
        user_agent           : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        referrer             : "https://google.com"
        view_source          : "web"
        session_id           : "session_002"
        view_duration_seconds: 180
        created_at           : now|add_secs_to_timestamp:-518400
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.0.id
        user_id              : $users.items.2.id
        ip_address           : "192.168.1.102"
        user_agent           : "Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X)"
        view_source          : "mobile"
        session_id           : "session_003"
        view_duration_seconds: 320
        created_at           : now|add_secs_to_timestamp:-432000
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.0.id
        ip_address           : "192.168.1.103"
        user_agent           : "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        view_source          : "web"
        session_id           : "session_004"
        view_duration_seconds: 95
        created_at           : now|add_secs_to_timestamp:-345600
      }
    }
  
    // Views for Auction 2 (Ferrari F40) - High interest
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.1.id
        user_id              : $users.items.3.id
        ip_address           : "192.168.1.104"
        user_agent           : "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer             : "https://ferrarichat.com"
        view_source          : "web"
        session_id           : "session_005"
        view_duration_seconds: 450
        created_at           : now|add_secs_to_timestamp:-518400
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.1.id
        user_id              : $users.items.4.id
        ip_address           : "192.168.1.105"
        user_agent           : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        view_source          : "web"
        session_id           : "session_006"
        view_duration_seconds: 380
        created_at           : now|add_secs_to_timestamp:-432000
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.1.id
        user_id              : $users.items.6.id
        ip_address           : "192.168.1.106"
        user_agent           : "Mozilla/5.0 (iPad; CPU OS 14_7_1 like Mac OS X)"
        view_source          : "mobile"
        session_id           : "session_007"
        view_duration_seconds: 290
        created_at           : now|add_secs_to_timestamp:-345600
      }
    }
  
    // Views for Auction 3 (Mercedes 300SL)
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.2.id
        user_id              : $users.items.1.id
        ip_address           : "192.168.1.107"
        user_agent           : "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        view_source          : "web"
        session_id           : "session_008"
        view_duration_seconds: 210
        created_at           : now|add_secs_to_timestamp:-432000
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.2.id
        user_id              : $users.items.5.id
        ip_address           : "192.168.1.108"
        user_agent           : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        referrer             : "https://benzworld.org"
        view_source          : "web"
        session_id           : "session_009"
        view_duration_seconds: 340
        created_at           : now|add_secs_to_timestamp:-259200
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.2.id
        user_id              : $users.items.7.id
        ip_address           : "192.168.1.109"
        user_agent           : "Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X)"
        view_source          : "mobile"
        session_id           : "session_010"
        view_duration_seconds: 155
        created_at           : now|add_secs_to_timestamp:-172800
      }
    }
  
    // Views for Auction 4 (Lamborghini Countach)
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.3.id
        user_id              : $users.items.2.id
        ip_address           : "192.168.1.110"
        user_agent           : "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        view_source          : "web"
        session_id           : "session_011"
        view_duration_seconds: 275
        created_at           : now|add_secs_to_timestamp:-518400
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.3.id
        user_id              : $users.items.4.id
        ip_address           : "192.168.1.111"
        user_agent           : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        referrer             : "https://lamborghini-talk.com"
        view_source          : "web"
        session_id           : "session_012"
        view_duration_seconds: 420
        created_at           : now|add_secs_to_timestamp:-345600
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.3.id
        ip_address           : "192.168.1.112"
        user_agent           : "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        view_source          : "web"
        session_id           : "session_013"
        view_duration_seconds: 125
        created_at           : now|add_secs_to_timestamp:-259200
      }
    }
  
    // Views for Auction 5 (Jaguar E-Type)
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.4.id
        user_id              : $users.items.1.id
        ip_address           : "192.168.1.113"
        user_agent           : "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        view_source          : "web"
        session_id           : "session_014"
        view_duration_seconds: 190
        created_at           : now|add_secs_to_timestamp:-432000
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.4.id
        user_id              : $users.items.5.id
        ip_address           : "192.168.1.114"
        user_agent           : "Mozilla/5.0 (iPad; CPU OS 14_7_1 like Mac OS X)"
        view_source          : "mobile"
        session_id           : "session_015"
        view_duration_seconds: 230
        created_at           : now|add_secs_to_timestamp:-259200
      }
    }
  
    db.add car_auction_view_history {
      data = {
        car_auction_id       : $auctions.items.4.id
        user_id              : $users.items.0.id
        ip_address           : "192.168.1.115"
        user_agent           : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        referrer             : "https://jaguarforums.com"
        view_source          : "web"
        session_id           : "session_016"
        view_duration_seconds: 310
        created_at           : now|add_secs_to_timestamp:-86400
      }
    }
  
    debug.log {
      value = "Seeded car_auction_view_history table successfully"
    }
  }

  response = {
    result: "Car auction view history seeded successfully"
    count : 16
  }
}