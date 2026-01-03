// User watchlist for tracking favorite auction cars
table car_watchlist {
  auth = false

  schema {
    int id
  
    // Relations
    int user_id
  
    int car_auction_id {
      table = "car_auction"
    }
  
    // Notification preferences
    bool notify_on_new_bid?=true
  
    bool notify_on_price_drop?=true
    bool notify_on_ending_soon?=true
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "user_id", op: "asc"}]}
    {type: "btree", field: [{name: "car_auction_id", op: "asc"}]}
    {
      type : "btree|unique"
      field: [
        {name: "user_id", op: "asc"}
        {name: "car_auction_id", op: "asc"}
      ]
    }
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}