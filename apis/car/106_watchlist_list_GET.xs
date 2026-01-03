// Get user's watchlist
query "watchlist/list" verb=GET {
  api_group = "car"

  input {
    int user_id
    int page?=1 filters=min:1
    int per_page?=20 filters=min:1|max:100
    bool active_only?=true
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
  
    // Build watchlist query depending on active_only
    conditional {
      if ($input.active_only) {
        // Only active + not sold auctions
        db.query car_watchlist {
          join = {
            auction_car: {
              table: ""
              where: $db.car_watchlist.auction_car_id == $db.auction_car.id && $db.auction_car.is_active && ($db.auction_car.is_sold != true)
            }
          }
        
          where = $db.car_watchlist.user_id == $input.user_id
          sort = {created_at: "desc"}
          eval = {added_at: $db.car_watchlist.created_at}
          return = {
            type  : "list"
            paging: {
              page    : $input.page
              per_page: $input.per_page
              totals  : true
            }
          }
        } as $watchlist
      }
    
      else {
        // All auctions, regardless of status
        db.query car_watchlist {
          join = {
            auction_car: {
              table: ""
              where: $db.car_watchlist.auction_car_id == $db.auction_car.id
            }
          }
        
          where = $db.car_watchlist.user_id == $input.user_id
          sort = {created_at: "desc"}
          eval = {added_at: $db.car_watchlist.created_at}
          return = {
            type  : "list"
            paging: {
              page    : $input.page
              per_page: $input.per_page
              totals  : true
            }
          }
        } as $watchlist
      }
    }
  
    // Prepare response (items already formatted in eval)
    var $response_data {
      value = {
        user_id  : $input.user_id
        watchlist: $watchlist.items
        total    : $watchlist.itemsTotal
        page     : $watchlist.page
        per_page : $watchlist.itemsPerPage
      }
    }
  }

  response = $response_data
  history = false
}