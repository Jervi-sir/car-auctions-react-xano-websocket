// Add or remove auction car from user's watchlist
query "watchlist/toggle" verb=POST {
  input {
    int user_id
    int auction_car_id
    bool notify_on_new_bid?=true
    bool notify_on_price_drop?=true
    bool notify_on_ending_soon?=true
  }

  stack {
    // Validate user exists
    db.get user {
      field_name = "id"
      field_value = $input.user_id
    } as $user
  
    precondition ($user != null) {
      error_type = "notfound"
      error = "User not found"
    }
  
    // Validate auction exists
    db.get "" {
      field_name = "id"
      field_value = $input.auction_car_id
    } as $auction
  
    precondition ($auction != null) {
      error_type = "notfound"
      error = "Auction car not found"
    }
  
    // Check if already in watchlist
    db.query car_watchlist {
      where = $db.car_watchlist.user_id == $input.user_id && $db.car_watchlist.auction_car_id == $input.auction_car_id
      return = {type: "single"}
    } as $existing_watchlist
  
    // Toggle logic using the ONLY supported conditional form
    conditional {
      if ($existing_watchlist != null) {
        // Remove from watchlist
        db.del car_watchlist {
          field_name = "id"
          field_value = $existing_watchlist.id
        }
      
        // Decrement watcher count
        db.edit "" {
          field_name = "id"
          field_value = $input.auction_car_id
          data = {total_watchers: $auction.total_watchers - 1}
        }
      
        var $action {
          value = "removed"
        }
      }
    
      else {
        // Add to watchlist
        db.add car_watchlist {
          data = {
            user_id              : $input.user_id
            auction_car_id       : $input.auction_car_id
            notify_on_new_bid    : $input.notify_on_new_bid
            notify_on_price_drop : $input.notify_on_price_drop
            notify_on_ending_soon: $input.notify_on_ending_soon
            created_at           : now
          }
        }
      
        // Increment watcher count
        db.edit "" {
          field_name = "id"
          field_value = $input.auction_car_id
          data = {total_watchers: $auction.total_watchers + 1}
        }
      
        var $action {
          value = "added"
        }
      }
    }
  
    // Prepare response
    var $response_data {
      value = {
        success       : true
        action        : $action
        user_id       : $input.user_id
        auction_car_id: $input.auction_car_id
        auction_title : $auction.title
      }
    }
  }

  response = $response_data
  history = false
}