// Get bid history for a specific auction car
query "auctions/bids" verb=GET {
  api_group = "car"

  input {
    int car_auction_id
    int page?=1 filters=min:1
    int per_page?=50 filters=min:1|max:100
    bool valid_only?=true
  }

  stack {
    // Validate auction exists
    db.get car_auction {
      field_name = "id"
      field_value = $input.car_auction_id
    } as $auction
  
    precondition ($auction != null) {
      error_type = "notfound"
      error = "Auction car not found"
    }
  
    // Query bids with bidder info
    db.query car_bid {
      join = {
        user: {table: "user", where: $db.car_bid.bidder_id == $db.user.id}
      }
    
      where = $db.car_bid.car_auction_id == $input.car_auction_id && $db.car_bid.is_valid ==? $input.valid_only
      sort = {created_at: "desc"}
      eval = {
        bidder_name  : $db.user.name
        bidder_avatar: $db.user.avatar_url
      }
    
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $bids
  
    var $response_data {
      value = {
        car_auction_id: $input.car_auction_id
        auction_title : $auction.title
        bids          : $bids.items
        total         : $bids.itemsTotal
        page          : $bids.page
        per_page      : $bids.itemsPerPage
      }
    }
  }

  response = $response_data
  history = 100
}