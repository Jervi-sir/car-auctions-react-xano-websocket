// Seed users table with sample bidders
function _seed_users {
  input {
  }

  stack {
    // Truncate table first
    db.truncate user {
      reset = true
    }
  
    // User 1 - Active bidder
    db.add user {
      data = {
        name       : "John Smith"
        email      : "john.smith@example.com"
        phone      : "+1-555-0101"
        is_verified: true
        is_active  : true
        total_bids : 0
        total_wins : 0
        total_spent: 0
        city       : "Los Angeles"
        country    : "USA"
        created_at : now
        updated_at : now
      }
    }
  
    // User 2 - Experienced bidder
    db.add user {
      data = {
        name       : "Sarah Johnson"
        email      : "sarah.johnson@example.com"
        phone      : "+1-555-0102"
        is_verified: true
        is_active  : true
        total_bids : 0
        total_wins : 0
        total_spent: 0
        city       : "New York"
        country    : "USA"
        created_at : now
        updated_at : now
      }
    }
  
    // User 3 - New user
    db.add user {
      data = {
        name       : "Michael Chen"
        email      : "michael.chen@example.com"
        phone      : "+1-555-0103"
        is_verified: true
        is_active  : true
        total_bids : 0
        total_wins : 0
        total_spent: 0
        city       : "San Francisco"
        country    : "USA"
        created_at : now
        updated_at : now
      }
    }
  
    // User 4 - International bidder
    db.add user {
      data = {
        name       : "Emma Wilson"
        email      : "emma.wilson@example.com"
        phone      : "+44-20-7946-0958"
        is_verified: true
        is_active  : true
        total_bids : 0
        total_wins : 0
        total_spent: 0
        city       : "London"
        country    : "UK"
        created_at : now
        updated_at : now
      }
    }
  
    // User 5 - Premium bidder
    db.add user {
      data = {
        name       : "David Martinez"
        email      : "david.martinez@example.com"
        phone      : "+1-555-0105"
        is_verified: true
        is_active  : true
        total_bids : 0
        total_wins : 0
        total_spent: 0
        city       : "Miami"
        country    : "USA"
        created_at : now
        updated_at : now
      }
    }
  
    // User 6 - Casual browser
    db.add user {
      data = {
        name       : "Lisa Anderson"
        email      : "lisa.anderson@example.com"
        is_verified: false
        is_active  : true
        total_bids : 0
        total_wins : 0
        total_spent: 0
        city       : "Chicago"
        country    : "USA"
        created_at : now
        updated_at : now
      }
    }
  
    // User 7 - European collector
    db.add user {
      data = {
        name       : "Hans Mueller"
        email      : "hans.mueller@example.com"
        phone      : "+49-30-12345678"
        is_verified: true
        is_active  : true
        total_bids : 0
        total_wins : 0
        total_spent: 0
        city       : "Berlin"
        country    : "Germany"
        created_at : now
        updated_at : now
      }
    }
  
    // User 8 - Asian market bidder
    db.add user {
      data = {
        name       : "Yuki Tanaka"
        email      : "yuki.tanaka@example.com"
        phone      : "+81-3-1234-5678"
        is_verified: true
        is_active  : true
        total_bids : 0
        total_wins : 0
        total_spent: 0
        city       : "Tokyo"
        country    : "Japan"
        created_at : now
        updated_at : now
      }
    }
  
    debug.log {
      value = "Seeded users table successfully"
    }
  }

  response = {result: "Users seeded successfully", count: 8}
}