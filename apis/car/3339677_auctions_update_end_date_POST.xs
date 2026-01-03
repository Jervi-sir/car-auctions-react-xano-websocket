query "auctions/update-end-date" verb=POST {
  api_group = "car"
  auth = "user"

  input {
    int car_auction_id
  }

  stack {
    var $x1 {
      value = now|add_secs_to_timestamp:60
    }
  
    db.edit car_auction {
      field_name = "id"
      field_value = $input.car_auction_id
      data = {auction_end: $x1}
    } as $car_auction1
  }

  response = $x1
}