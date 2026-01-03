query "user/account" verb=DELETE {
  api_group = "user"
  auth = "user"

  input {
    text current_password? filters=trim
    text confirmation
  }

  stack {
    // Get current user
    db.get user {
      field_name = "id"
      field_value = $auth.id
    } as $user
  
    security.check_password {
      text_password = $input.current_password
      hash_password = $user.password
    } as $isValid
  
    precondition ($isValid) {
      error_type = "unauthorized"
      error = "Wrong password"
    }
  
    // Validate confirmation text
    precondition ($input.confirmation == "DELETE") {
      error_type = "inputerror"
      error = "Confirmation must be exactly 'DELETE'"
    }
  
    db.del user {
      field_name = "id"
      field_value = $auth.id
    }
  
    !return {
      value = $isValid
    }
  
    !db.query car_auction {
      where = $db.car_auction.created_by == $auth.id
      return = {type: "list"}
    } as $active_auctions
  
    !foreach ($active_auctions) {
      each as $auction {
        db.query car_bid {
          where = $db.car_bid.car_auction_id == $auction.id
          return = {type: "count"}
        } as $bid_count
      
        conditional {
          if ($bid_count > 0) {
            var $has_active_auctions_with_bids {
              value = true
            }
          }
        }
      
        // Delete user's bids
        db.query car_bid {
          where = $db.car_bid.bidder_id == $auth.id
          return = {type: "list"}
        } as $user_bids
      
        foreach ($user_bids) {
          each as $bid {
            db.del car_bid {
              field_name = "id"
              field_value = $bid.id
            }
          }
        }
      
        // Delete user's watchlist entries
        db.query car_watchlist {
          where = $db.car_watchlist.user_id == $auth.id
          return = {type: "list"}
        } as $watchlist_entries
      
        foreach ($watchlist_entries) {
          each as $entry {
            db.del car_watchlist {
              field_name = "id"
              field_value = $entry.id
            }
          }
        }
      
        // Delete user's view history
        db.query car_auction_view_history {
          where = $db.car_auction_view_history.user_id == $auth.id
          return = {type: "list"}
        } as $view_history
      
        foreach ($view_history) {
          each as $view {
            db.del car_auction_view_history {
              field_name = "id"
              field_value = $view.id
            }
          }
        }
      
        // End/cancel user's auctions (those without bids)
        db.query car_auction {
          where = $db.car_auction.created_by == $auth.id
          return = {type: "list"}
        } as $user_auctions
      
        foreach ($user_auctions) {
          each as $auction {
            // Check if auction has bids
            db.query car_bid {
              where = $db.car_bid.car_auction_id == $auction.id
              return = {type: "count"}
            } as $auction_bid_count
          
            conditional {
              if ($auction_bid_count == 0) {
                // Delete auction if no bids
                db.del car_auction {
                  field_name = "id"
                  field_value = $auction.id
                }
              }
            
              else {
                db.edit car_auction {
                  field_name = "id"
                  field_value = $auction.id
                  data = {is_active: false, updated_at: now}
                }
              }
            }
          }
        }
      
        // Prepare response
        var $response_data {
          value = {success: true, message: "Account deleted successfully"}
        }
      }
    }
  }

  response = "deleted successfully"
  history = 100
}