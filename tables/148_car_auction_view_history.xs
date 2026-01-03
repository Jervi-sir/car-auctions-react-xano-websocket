// Track views of auction car listings for analytics
table car_auction_view_history {
  auth = false

  schema {
    int id
  
    // Relations
    int car_auction_id {
      table = "car_auction"
    }
  
    int user_id? {
      table = ""
    }
  
    // View metadata
    text ip_address? filters=trim
  
    text user_agent? filters=trim
    text referrer? filters=trim
    text view_source?=web
  
    // Session tracking
    text session_id? filters=trim
  
    int view_duration_seconds? filters=min:0
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "car_auction_id", op: "asc"}]}
    {type: "btree", field: [{name: "user_id", op: "asc"}]}
    {type: "btree", field: [{name: "session_id", op: "asc"}]}
    {
      type : "btree"
      field: [
        {name: "car_auction_id", op: "asc"}
        {name: "created_at", op: "desc"}
      ]
    }
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}