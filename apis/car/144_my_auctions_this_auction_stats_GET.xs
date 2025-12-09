// Get comprehensive auction statistics (owner only)
query "my-auctions/this-auction/stats" verb=GET {
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
  
    // Validate user owns this auction
    precondition ($auction.created_by == $auth.id) {
      error_type = "forbidden"
      error = "You don't have permission to view statistics for this auction"
    }
  
    // Get total bids
    db.query car_bid {
      where = $db.car_bid.car_auction_id == $input.auction_id
      return = {type: "count"}
    } as $total_bids
  
    // Get total views
    db.query car_auction_view_history {
      where = $db.car_auction_view_history.auction_car_id == $input.auction_id
      return = {type: "count"}
    } as $total_views
  
    // Get unique viewers count
    db.query car_auction_view_history {
      where = $db.car_auction_view_history.auction_car_id == $input.auction_id
      return = {type: "list"}
    } as $all_views
  
    var $unique_viewers {
      value = ```
        $all_views.filter {
                type = "array"
                array = {
                  operation = "unique"
                  field = "user_id"
                }
              }.length
        ```
    }
  
    // Get watchlist count
    db.query car_watchlist {
      where = $db.car_watchlist.car_auction_id == $input.auction_id
      return = {type: "count"}
    } as $watchlist_count
  
    // Calculate price increase
    var $price_increase {
      value = $auction.current_price - $auction.starting_price
    }
  
    var $price_increase_percent {
      value = ```
        if ($auction.starting_price > 0) {
                ($price_increase / $auction.starting_price) * 100
              } else {
                0
              }
        ```
    }
  
    // Get top bidders (top 10)
    db.query car_bid {
      where = $db.car_bid.car_auction_id == $input.auction_id && $db.car_bid.is_valid
      sort = {amount: "desc"}
      return = {type: "list", paging: {page: 1, per_page: 10}}
    } as $top_bids
  
    // Prepare top bidders with anonymized names
    var $top_bidders {
      value = []
    }
  
    var $rank {
      value = 0
    }
  
    foreach ($top_bids.items) {
      each as $bid {
        var $rank {
          value = $rank + 1
        }
      
        // Get bidder info
        db.get user {
          field_name = "id"
          field_value = $bid.bidder_id
        } as $bidder
      
        // Anonymize name (e.g., "John Doe" -> "John D.")
        var $anonymized_name {
          value = ```
            if ($bidder != null && $bidder.name != null) {
                        $bidder.name.filter {
                          type = "text"
                          text = {
                            operation = "split"
                            delimiter = " "
                          }
                        }.filter {
                          type = "array"
                          array = {
                            operation = "map"
                            expression = if ($index == 0) {$item} else {$item.filter {type: "text", text: {operation: "substring", start: 0, length: 1}} + "."}
                          }
                        }.filter {
                          type = "array"
                          array = {
                            operation = "join"
                            delimiter = " "
                          }
                        }
                      } else {
                        "Anonymous"
                      }
            ```
        }
      
        var $top_bidders {
          value = ```
            $top_bidders.filter {
                        type = "array"
                        array = {
                          operation = "append"
                          item = {
                            user_id   : $bid.bidder_id
                            name      : $anonymized_name
                            bid_amount: $bid.amount
                            bid_time  : $bid.created_at
                            rank      : $rank
                          }
                        }
                      }
            ```
        }
      }
    }
  
    // Get views over time (last 30 days, grouped by date)
    var $thirty_days_ago {
      value = now - (30 * 24 * 60 * 60 * 1000)
    }
  
    db.query car_auction_view_history {
      where = $db.car_auction_view_history.auction_car_id == $input.auction_id && $db.car_auction_view_history.created_at >= $thirty_days_ago
      return = {type: "list"}
    } as $recent_views
  
    // Group views by date
    var $views_by_date {
      value = {}
    }
  
    foreach ($recent_views) {
      each as $view {
        var $date_key {
          value = ```
            $view.created_at.filter {
                        type = "timestamp"
                        timestamp = {
                          operation = "format"
                          format = "Y-m-d"
                        }
                      }
            ```
        }
      
        var $current_count {
          value = if ($views_by_date[$date_key] != null) {$views_by_date[$date_key]} else {0}
        }
      
        var $views_by_date {
          value = ```
            $views_by_date.filter {
                        type = "object"
                        object = {
                          operation = "set"
                          key = $date_key
                          value = $current_count + 1
                        }
                      }
            ```
        }
      }
    }
  
    // Convert to array format
    var $views_over_time {
      value = []
    }
  
    foreach ($views_by_date) {
      each as $date_entry {
        var $views_over_time {
          value = ```
            $views_over_time.filter {
                        type = "array"
                        array = {
                          operation = "append"
                          item = {
                            date : $key
                            views: $value
                          }
                        }
                      }
            ```
        }
      }
    }
  
    // Get bids over time (last 30 days, grouped by date)
    db.query car_bid {
      where = $db.car_bid.car_auction_id == $input.auction_id && $db.car_bid.created_at >= $thirty_days_ago
      return = {type: "list"}
    } as $recent_bids
  
    // Group bids by date
    var $bids_by_date {
      value = {}
    }
  
    foreach ($recent_bids) {
      each as $bid {
        var $date_key {
          value = ```
            $bid.created_at.filter {
                        type = "timestamp"
                        timestamp = {
                          operation = "format"
                          format = "Y-m-d"
                        }
                      }
            ```
        }
      
        var $current_count {
          value = if ($bids_by_date[$date_key] != null) {$bids_by_date[$date_key]} else {0}
        }
      
        var $bids_by_date {
          value = ```
            $bids_by_date.filter {
                        type = "object"
                        object = {
                          operation = "set"
                          key = $date_key
                          value = $current_count + 1
                        }
                      }
            ```
        }
      }
    }
  
    // Convert to array format
    var $bids_over_time {
      value = []
    }
  
    foreach ($bids_by_date) {
      each as $date_entry {
        var $bids_over_time {
          value = ```
            $bids_over_time.filter {
                        type = "array"
                        array = {
                          operation = "append"
                          item = {
                            date: $key
                            bids: $value
                          }
                        }
                      }
            ```
        }
      }
    }
  
    // Prepare response
    var $response_data {
      value = {
        auction        : {
          id            : $auction.id
          slug          : $auction.slug
          title         : $auction.title
          subtitle      : $auction.subtitle
          image_url     : $auction.image_url
          starting_price: $auction.starting_price
          current_price : $auction.current_price
          currency      : $auction.currency
          is_active     : $auction.is_active
          auction_end   : $auction.auction_end
          created_at    : $auction.created_at
        }
        metrics        : {
          total_bids            : $total_bids
          total_views           : $total_views
          unique_viewers        : $unique_viewers
          watchlist_count       : $watchlist_count
          price_increase        : $price_increase
          price_increase_percent: $price_increase_percent
        }
        top_bidders    : $top_bidders
        views_over_time: $views_over_time
        bids_over_time : $bids_over_time
      }
    }
  }

  response = $response_data
  history = false
}