// Finalize auction and determine winner when auction ends
query "auctions/finalize" verb=POST {
  api_group = "car"

  input {
    int car_auction_id
  }

  stack {
    // Get auction details
    db.get car_auction {
      field_name = "id"
      field_value = $input.car_auction_id
    } as $auction
  
    // Validate auction exists
    precondition ($auction != null) {
      error_type = "notfound"
      error = "Auction car not found"
    }
  
    // Validate auction has ended
    precondition ($auction.auction_end < now) {
      error_type = "inputerror"
      error = "Auction has not ended yet"
    }
  
    // Validate auction is still active (not already finalized)
    precondition ($auction.is_active) {
      error_type = "inputerror"
      error = "Auction has already been finalized"
    }
  
    // Get the highest valid bid (winner)
    db.query car_bid {
      where = $db.car_bid.car_auction_id == $input.car_auction_id && $db.car_bid.is_valid
      sort = {amount: "desc", created_at: "asc"}
      return = {type: "single"}
    } as $winning_bid
  
    // Check if reserve price was met (if set)
    conditional {
      if ($winning_bid != null) {
        // Check if reserve price exists and was met
        conditional {
          if ($auction.reserve_price != null) {
            !return {
              value = $winning_bid
            }
          
            precondition ($winning_bid.amount >= $auction.current_price) {
              error_type = "inputerror"
              error = "Reserve price not met. Auction ended without sale."
            }
          
            // Reserve met - mark as sold
            db.edit car_auction {
              field_name = "id"
              field_value = $input.car_auction_id
              data = {
                is_active        : false
                is_sold          : true
                winning_bidder_id: $winning_bid.bidder_id
                updated_at       : now
              }
            }
          
            // Update winner's statistics
            db.get user {
              field_name = "id"
              field_value = $winning_bid.bidder_id
            } as $winner
          
            db.edit user {
              field_name = "id"
              field_value = $winning_bid.bidder_id
              data = {
                total_wins : $winner.total_wins + 1
                total_spent: $winner.total_spent + $winning_bid.amount
                updated_at : now
              }
            }
          
            var $sale_status {
              value = "sold"
            }
          
            var $winner_info {
              value = {
                bidder_id     : $winning_bid.bidder_id
                bidder_name   : $winner.name
                winning_amount: $winning_bid.amount
                currency      : $winning_bid.currency
              }
            }
          }
        
          else {
            // No reserve price - mark as sold
            db.edit car_auction {
              field_name = "id"
              field_value = $input.car_auction_id
              data = {
                is_active        : false
                is_sold          : true
                winning_bidder_id: $winning_bid.bidder_id
                updated_at       : now
              }
            }
          
            // Update winner's statistics
            db.get user {
              field_name = "id"
              field_value = $winning_bid.bidder_id
            } as $winner
          
            db.edit user {
              field_name = "id"
              field_value = $winning_bid.bidder_id
              data = {
                total_wins : $winner.total_wins + 1
                total_spent: $winner.total_spent + $winning_bid.amount
                updated_at : now
              }
            }
          
            var $sale_status {
              value = "sold"
            }
          
            var $winner_info {
              value = {
                bidder_id     : $winning_bid.bidder_id
                bidder_name   : $winner.name
                winning_amount: $winning_bid.amount
                currency      : $winning_bid.currency
              }
            }
          }
        }
      }
    
      else {
        // No bids - mark auction as ended without sale
        db.edit car_auction {
          field_name = "id"
          field_value = $input.car_auction_id
          data = {is_active: false, is_sold: false, updated_at: now}
        }
      
        var $sale_status {
          value = "no_bids"
        }
      
        var $winner_info {
          value = null
        }
      }
    }
  
    // Prepare response
    var $response_data {
      value = {
        success      : true
        auction_id   : $input.car_auction_id
        auction_title: $auction.title
        status       : $sale_status
        auction_end  : $auction.auction_end
        total_bids   : $auction.total_bids
        final_price  : $auction.current_price
        reserve_price: $auction.reserve_price
        reserve_met  : $winning_bid != null && ($auction.reserve_price == null || $winning_bid.amount >= $auction.reserve_price)
        winner       : $winner_info
      }
    }
  }

  response = $response_data
  history = 100
}