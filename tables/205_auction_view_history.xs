// Track views of auction car listings for analytics
table auction_view_history {
  auth = false

  schema {
    int id
    
    // Relations
    int auction_car_id {
      table = "auction_car"
    }
    int user_id? {
      table = "user"
    }
    
    // View metadata
    text ip_address? filters=trim
    text user_agent? filters=trim
    text referrer? filters=trim
    text view_source?="web" // web, mobile, email, social
    
    // Session tracking
    text session_id? filters=trim
    int view_duration_seconds? filters=min:0
    
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "auction_car_id", op: "asc"}]}
    {type: "btree", field: [{name: "user_id", op: "asc"}]}
    {type: "btree", field: [{name: "session_id", op: "asc"}]}
    {
      type : "btree"
      field: [
        {name: "auction_car_id", op: "asc"}
        {name: "created_at", op: "desc"}
      ]
    }
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}
