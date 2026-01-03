// Individual bids placed on auction cars
table car_bid {
  auth = false

  schema {
    int id
  
    // Relations
    int car_auction_id {
      table = "car_auction"
    }
  
    int bidder_id {
      table = ""
    }
  
    // Bid details
    decimal amount filters=min:0
  
    text currency?=USD
  
    // Bid status
    bool is_winning?
  
    bool is_auto_bid?
    decimal max_auto_bid_amount? filters=min:0
  
    // Bid metadata
    text ip_address? filters=trim
  
    text user_agent? filters=trim
    text bid_source?=web
  
    // Validation
    bool is_valid?=true
  
    text invalid_reason? filters=trim
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "car_auction_id", op: "asc"}]}
    {type: "btree", field: [{name: "bidder_id", op: "asc"}]}
    {type: "btree", field: [{name: "amount", op: "desc"}]}
    {type: "btree", field: [{name: "is_winning", op: "asc"}]}
    {type: "btree", field: [{name: "is_valid", op: "asc"}]}
    {
      type : "btree"
      field: [
        {name: "car_auction_id", op: "asc"}
        {name: "created_at", op: "desc"}
      ]
    }
    {
      type : "btree"
      field: [
        {name: "car_auction_id", op: "asc"}
        {name: "amount", op: "desc"}
      ]
    }
    {
      type : "btree"
      field: [
        {name: "bidder_id", op: "asc"}
        {name: "created_at", op: "desc"}
      ]
    }
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}