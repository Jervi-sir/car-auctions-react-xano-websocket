// Get auction details for editing (owner only)
query "my-auctions/this-auction/edit" verb=GET {
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
      if ($auction.created_by == $auth.id) {
      }
    }
  
    // Prepare response
    var $response_data {
      value = `$var.auction`
    }
  }

  response = $response_data
  history = 100
}