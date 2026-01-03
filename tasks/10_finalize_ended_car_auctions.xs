task finalize_ended_car_auctions {
  active = false

  stack {
    // Get current timestamp
    var $now {
      value = now
    }
  
    debug.log {
      value = "Starting auction finalization check"
    }
  
    // Find all active auctions that have ended but haven't been finalized
    db.query car_auction {
      where = $db.car_auction.is_active && $db.car_auction.auction_end <= $now && $db.car_auction.is_sold == null
      sort = {car_auction.auction_end: "asc"}
      return = {type: "list"}
    } as $ended_auctions
  
    var $processed_count {
      value = 0
    }
  
    var $finalized_count {
      value = 0
    }
  
    // Process each ended auction
    foreach ($ended_auctions) {
      each as $auction {
        debug.log {
          value = "Processing auction ID: " + $auction.id
        }
      
        // Find the highest valid bid for this auction
        db.query car_bid {
          where = $db.car_bid.car_auction_id == $auction.id && $db.car_bid.is_valid
          sort = {car_bid.amount: "desc"}
          return = {type: "list", paging: {page: 1, per_page: 1}}
        } as $highest_bids
      
        // Increment processed auctions
        var.update $processed_count {
          value = $processed_count + 1
        }
      
        // Check if there are any bids
        conditional {
          if (($highest_bids|count) > 0) {
            // Get the highest bid
            var $winning_bid {
              value = $highest_bids|first
            }
          
            // Check if reserve price was met (if set)
            var $reserve_met {
              value = $auction.reserve_price == null || $winning_bid.amount >= $auction.reserve_price
            }
          
            conditional {
              if (`$reserve_met`) {
                // Update auction with winner
                db.edit car_auction {
                  field_name = "id"
                  field_value = $auction.id
                  data = {
                    winning_bidder_id: $winning_bid.bidder_id
                    is_sold          : true
                    is_active        : false
                    current_price    : $winning_bid.amount
                    updated_at       : $now
                  }
                }
              
                // Mark the winning bid
                db.edit car_bid {
                  field_name = "id"
                  field_value = $winning_bid.id
                  data = {is_winning: true}
                }
              
                debug.log {
                  value = "Auction " + $auction.id + " sold to bidder " + $winning_bid.bidder_id + " for " + $winning_bid.amount
                }
              
                var.update $finalized_count {
                  value = $finalized_count + 1
                }
              }
            
              else {
                // Reserve price not met - mark as unsold
                db.edit car_auction {
                  field_name = "id"
                  field_value = $auction.id
                  data = {is_sold: false, is_active: false, updated_at: $now}
                }
              
                debug.log {
                  value = "Auction " + $auction.id + " ended without meeting reserve price"
                }
              }
            }
          }
        
          else {
            // No bids - mark auction as ended without sale
            db.edit car_auction {
              field_name = "id"
              field_value = $auction.id
              data = {is_sold: false, is_active: false, updated_at: $now}
            }
          
            debug.log {
              value = "Auction " + $auction.id + " ended with no bids"
            }
          }
        }
      }
    }
  
    debug.log {
      value = "Auction finalization complete"
    }
  
    debug.log {
      value = "Processed: " + $processed_count + " auctions"
    }
  
    debug.log {
      value = "Finalized with winner: " + $finalized_count + " auctions"
    }
  }

  schedule = [{starts_on: 2025-12-08 02:33:07+0000, freq: 3600}]
}