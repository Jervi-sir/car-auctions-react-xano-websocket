// Seed recipe_view_history table with sample view data
function food_7_seed_recipe_view_history {
  input {
  }

  stack {
    // Truncate table first
    db.truncate recipe_view_history {
      reset = true
    }
  
    // Simulate views for different recipes over time
    // Recipe 1: Spaghetti Carbonara - Popular
    db.add recipe_view_history {
      data = {
        recipe_id : 1
        viewer_ip : "192.168.1.100"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 1
        viewer_ip : "192.168.1.101"
        user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        referrer  : "https://facebook.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 1
        viewer_ip : "192.168.1.102"
        user_agent: "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)"
        referrer  : "https://pinterest.com"
        viewed_at : now
      }
    }
  
    // Recipe 2: Chicken Tacos - Very Popular
    db.add recipe_view_history {
      data = {
        recipe_id : 2
        viewer_ip : "192.168.1.103"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 2
        viewer_ip : "192.168.1.104"
        user_agent: "Mozilla/5.0 (Android 11; Mobile)"
        referrer  : "https://instagram.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 2
        viewer_ip : "192.168.1.105"
        user_agent: "Mozilla/5.0 (iPad; CPU OS 14_0 like Mac OS X)"
        referrer  : "https://twitter.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 2
        viewer_ip : "192.168.1.106"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    // Recipe 3: Vegetable Stir Fry
    db.add recipe_view_history {
      data = {
        recipe_id : 3
        viewer_ip : "192.168.1.107"
        user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 3
        viewer_ip : "192.168.1.108"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://bing.com"
        viewed_at : now
      }
    }
  
    // Recipe 4: Salmon Teriyaki - Most Popular
    db.add recipe_view_history {
      data = {
        recipe_id : 4
        viewer_ip : "192.168.1.109"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 4
        viewer_ip : "192.168.1.110"
        user_agent: "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)"
        referrer  : "https://pinterest.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 4
        viewer_ip : "192.168.1.111"
        user_agent: "Mozilla/5.0 (Android 11; Mobile)"
        referrer  : "https://facebook.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 4
        viewer_ip : "192.168.1.112"
        user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 4
        viewer_ip : "192.168.1.113"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://youtube.com"
        viewed_at : now
      }
    }
  
    // Recipe 5: Chicken Curry
    db.add recipe_view_history {
      data = {
        recipe_id : 5
        viewer_ip : "192.168.1.114"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 5
        viewer_ip : "192.168.1.115"
        user_agent: "Mozilla/5.0 (iPad; CPU OS 14_0 like Mac OS X)"
        referrer  : "https://instagram.com"
        viewed_at : now
      }
    }
  
    // Recipe 6: French Onion Soup
    db.add recipe_view_history {
      data = {
        recipe_id : 6
        viewer_ip : "192.168.1.116"
        user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    // Recipe 7: Pad Thai
    db.add recipe_view_history {
      data = {
        recipe_id : 7
        viewer_ip : "192.168.1.117"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 7
        viewer_ip : "192.168.1.118"
        user_agent: "Mozilla/5.0 (Android 11; Mobile)"
        referrer  : "https://tiktok.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 7
        viewer_ip : "192.168.1.119"
        user_agent: "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)"
        referrer  : "https://pinterest.com"
        viewed_at : now
      }
    }
  
    // Recipe 8: Greek Salad
    db.add recipe_view_history {
      data = {
        recipe_id : 8
        viewer_ip : "192.168.1.120"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 8
        viewer_ip : "192.168.1.121"
        user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
        referrer  : "https://facebook.com"
        viewed_at : now
      }
    }
  
    // Recipe 9: Classic Burger
    db.add recipe_view_history {
      data = {
        recipe_id : 9
        viewer_ip : "192.168.1.122"
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    db.add recipe_view_history {
      data = {
        recipe_id : 9
        viewer_ip : "192.168.1.123"
        user_agent: "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)"
        referrer  : "https://reddit.com"
        viewed_at : now
      }
    }
  
    // Recipe 10: Mediterranean Quinoa Bowl
    db.add recipe_view_history {
      data = {
        recipe_id : 10
        viewer_ip : "192.168.1.124"
        user_agent: "Mozilla/5.0 (Android 11; Mobile)"
        referrer  : "https://google.com"
        viewed_at : now
      }
    }
  
    debug.log {
      value = "Seeded recipe_view_history table successfully"
    }
  }

  response = {
    result: "Recipe view history seeded successfully"
    count : 25
  }
}