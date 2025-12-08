// User table for bidders and general users
table user {
  auth = true

  schema {
    int id
    text name filters=trim
    text email filters=trim|lower
    password password
    text phone? filters=trim
    image avatar_url?
  
    // User verification and status
    bool is_verified?
  
    bool is_active?=true
  
    // User stats
    int total_bids? filters=min:0
  
    int total_wins? filters=min:0
    decimal total_spent? filters=min:0
  
    // Location
    text city? filters=trim
  
    text country? filters=trim
    timestamp created_at?=now
    timestamp updated_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "email", op: "asc"}]}
    {type: "btree", field: [{name: "name", op: "asc"}]}
    {type: "btree", field: [{name: "is_active", op: "asc"}]}
    {type: "btree", field: [{name: "total_bids", op: "desc"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}