query "auctions/restore" verb=POST {
  api_group = "car"

  input {
    int car_auction_id
  }

  stack {
    var $new_date {
      value = now|add_secs_to_timestamp:18000
    }
  
    db.edit car_auction {
      field_name = "id"
      field_value = $input.car_auction_id
      data = {
        auction_end      : $new_date
        is_active        : true
        is_sold          : false
        winning_bidder_id: null
      }
    } as $car_auction1
  }

  response = $new_date
}