// Get current user's profile
query "user/profile" verb=GET {
  auth = "user"

  input {
  }

  stack {
    // Get user
    db.get user {
      field_name = "id"
      field_value = $auth.id
    } as $user
  
    // Get auctions posted count
    db.query car_auction {
      where = $db.car_auction.created_by == $auth.id
      return = {type: "count"}
    } as $auctions_posted
  
    // Get auctions won count
    db.query car_auction {
      where = $db.car_auction.winning_bidder_id == $auth.id && $db.car_auction.is_sold
      return = {type: "count"}
    } as $auctions_won
  
    // Get total bids count
    db.query car_bid {
      where = $db.car_bid.bidder_id == $auth.id
      return = {type: "count"}
    } as $total_bids
  
    // Combine location from city and country
    !var $location {
      value = ```
        if ($var.user.city != null && $var.user.country != null) {
                $var.user.city + ", " + $var.user.country
              } else if ($var.user.city != null) {
                $var.user.city
              } else if ($var.user.country != null) {
                $var.user.country
              } else {
                null
              }
        ```
    }
  
    // Prepare response
    var $response_data {
      value = {
        id        : $user.id
        name      : $user.name
        email     : $user.email
        phone     : $user.phone
        country   : $country
        city      : $city
        created_at: $user.created_at
        statistics: {
          auctions_posted: $var.auctions_posted
          auctions_won   : $var.auctions_won
          total_bids     : $var.total_bids
        }
      }
    }
  
    !return {
      value = $response_data
    }
  }

  response = $response_data
  history = false
}