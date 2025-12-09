// Delete an auction (only by owner)
query "my-auctions/delete" verb=DELETE {
  auth = "user"

  input {
    int auction_id
  }

  stack {
    // Get auction
    db.get car_auction {
      field_name = "id"
      field_value = $input.auction_id
    } as $auction
  
    // Validate auction exists
    precondition ($auction != null) {
      error_type = "notfound"
      error = "Auction not found"
    }
  
    db.del car_auction {
      field_name = "id"
      field_value = $input.auction_id
    }
  
    !db.del car_bid {
      field_name = "car_auction_id"
      field_value = $input.auction_id
    }
  
    !db.del car_watchlist {
      field_name = "car_auction_id"
      field_value = $input.auction_id
    }
  
    !db.del car_auction_view_history {
      field_name = "car_auction_id"
      field_value = $input.auction_id
    }
  
    // Check if auction has any bids
    !db.query car_bid {
      where = $db.car_bid.car_auction_id == $input.auction_id
      return = {type: "count"}
    } as $bid_count
  
    !conditional {
      if ($bid_count === 0) {
        throw {
          name = "message"
          value = "Cannot delete auction with existing bids"
        }
      }
    }
  
    // Delete related watchlist entries
    !db.query car_watchlist {
      where = $db.car_watchlist.car_auction_id == $input.auction_id
      return = {type: "list"}
    } as $watchlist_entries
  
    !return {
      value = $watchlist_entries
    }
  
    !foreach ($watchlist_entries) {
      each as $entry {
        db.del car_watchlist {
          field_name = "id"
          field_value = $entry.id
        }
      }
    }
  
    // Delete related view history
    !db.query car_auction_view_history {
      where = $db.car_auction_view_history.auction_car_id == $input.auction_id
      return = {type: "list"}
    } as $view_entries
  
    !foreach ($view_entries) {
      each as $view {
        db.del car_auction_view_history {
          field_name = "id"
          field_value = $view.id
        }
      }
    }
  }

  response = ""
  history = 100
}