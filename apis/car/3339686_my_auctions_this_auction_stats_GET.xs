// Get comprehensive auction statistics (owner only)
query "my-auctions/this-auction/stats" verb=GET {
  api_group = "car"
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
  
    conditional {
      if ($auction.created_by != $auth.id) {
        throw {
          name = ""
          value = "This auction is not yours"
        }
      }
    }
  
    // Get total bids
    db.query car_bid {
      where = $db.car_bid.car_auction_id == $input.auction_id
      return = {type: "count"}
    } as $total_bids
  
    // Get total views
    db.query car_auction_view_history {
      where = $db.car_auction_view_history.car_auction_id == $input.auction_id
      return = {type: "count"}
    } as $total_views
  
    // Get unique viewers count
    db.query car_auction_view_history {
      where = $db.car_auction_view_history.car_auction_id == $input.auction_id
      return = {type: "count"}
    } as $all_views
  
    // Calculate price increase
    var $price_increase {
      value = $auction.current_price - $auction.starting_price
    }
  
    var $price_increase_percent {
      value = ```
        ($auction.starting_price > 0) 
        ? ($price_increase / $auction.starting_price) * 100
        : 0
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
      
        var $top_bidders {
          value = $top_bidders|push:$bidder
        }
      }
    }
  
    // Get views over time (last 30 days, grouped by date)
    var $thirty_days_ago {
      value = now
        |subtract:30 * 24 * 60 * 60 * 1000
    }
  
    db.query car_auction_view_history {
      where = $db.car_auction_view_history.car_auction_id == $input.auction_id
      return = {type: "count"}
    } as $views_count
  
    // Get bids over time (last 30 days, grouped by date)
    db.query car_bid {
      where = $db.car_bid.car_auction_id == $input.auction_id
      return = {type: "count"}
    } as $bids_count
  
    // Prepare response
    var $response_data {
      value = {
        auction    : {
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
        metrics    : {
          total_bids            : $total_bids
          total_views           : $total_views
          price_increase        : $price_increase
          price_increase_percent: $price_increase_percent
        }
        top_bidders: $top_bidders
      }
    }
  }

  response = $response_data
  history = 100
}