// Place a bid on an auction car
query "bids/place" verb=POST {
  api_group = "car"
  auth = "user"

  input {
    int car_auction_id
    int bidder_id
    decimal amount filters=min:0
    bool is_auto_bid?
    decimal max_auto_bid_amount? filters=min:0
  }

  stack {
    // Get auction car
    db.get car_auction {
      field_name = "id"
      field_value = $input.car_auction_id
    } as $auction
  
    // Validate auction exists
    precondition ($auction != null) {
      error_type = "notfound"
      error = "Auction car not found"
    }
  
    // Validate auction is active
    precondition ($auction.is_active) {
      error_type = "inputerror"
      error = "Auction is not active"
    }
  
    // Validate auction hasn't ended
    precondition ($auction.auction_end > now) {
      error_type = "inputerror"
      error = "Auction has ended"
    }
  
    // Validate bid amount is higher than current price
    precondition ($input.amount > $auction.current_price) {
      error_type = "inputerror"
      error = "Bid amount must be higher than current price"
    }
  
    // Get bidder
    db.get "" {
      field_name = "id"
      field_value = $input.bidder_id
    } as $bidder
  
    // Validate bidder exists
    precondition ($bidder != null) {
      error_type = "notfound"
      error = "Bidder not found"
    }
  
    // Mark all previous bids as not winning
    db.query car_bid {
      where = $db.car_bid.car_auction_id == $input.car_auction_id && $db.car_bid.is_winning
      return = {type: "list"}
    } as $previous_winning_bids
  
    // Update previous winning bids
    foreach ($previous_winning_bids) {
      each as $prev_bid {
        db.edit car_bid {
          field_name = "id"
          field_value = $prev_bid.id
          data = {
            car_auction_id     : $input.car_auction_id
            bidder_id          : $input.bidder_id
            is_winning         : false
            is_auto_bid        : $input.is_auto_bid
            max_auto_bid_amount: $input.max_auto_bid_amount
          }
        }
      }
    }
  
    // Create new bid
    db.add car_bid {
      data = {
        car_auction_id     : $input.car_auction_id
        bidder_id          : $input.bidder_id
        amount             : $input.amount
        currency           : $auction.currency
        is_winning         : true
        is_auto_bid        : $input.is_auto_bid
        max_auto_bid_amount: $input.max_auto_bid_amount
        ip_address         : $env.ip
        user_agent         : $env.user_agent
        bid_source         : "web"
        is_valid           : true
        created_at         : now
      }
    } as $new_bid
  
    // Update auction car
    db.edit car_auction {
      field_name = "id"
      field_value = $input.car_auction_id
      data = {
        current_price: $input.amount
        total_bids   : $auction.total_bids + 1
        updated_at   : now
      }
    }
  
    // Update bidder stats
    db.edit "" {
      field_name = "id"
      field_value = $input.bidder_id
      data = {total_bids: $bidder.total_bids + 1, updated_at: now}
    }
  
    function.run broadcastBid {
      input = {auction_id: $input.car_auction_id, bid_id: $new_bid.id}
    }
  
    // Prepare response
    var $response_data {
      value = {
        success: true
        bid    : {
          id: $new_bid.id
          car_auction: $new_bid.car_auction
          bidder_id: $new_bid.bidder_id
          amount: $new_bid.amount
          currency: $new_bid.currency
          is_winning: $new_bid.is_winning
          created_at: $new_bid.created_at
        }
        auction: {
          id: $auction.id
          title: $auction.title
          current_price: $input.amount
          total_bids: $auction.total_bids + 1
        }
      }
    }
  }

  response = $response_data
  history = 100
}