// Auction car listings with specifications and bidding info
table auction_car {
  auth = false

  schema {
    int id
    text title filters=trim
    text subtitle? filters=trim
    text slug filters=trim|lower
    image image_url
    image[] gallery_images
  
    // Basic car info
    int year filters=min:1900|max:2100
  
    int mileage_km filters=min:0
    text fuel filters=trim
    text transmission filters=trim
    text location filters=trim
  
    // Pricing
    decimal starting_price filters=min:0
  
    decimal current_price filters=min:0
    decimal reserve_price? filters=min:0
    text currency?=USD
  
    // Auction timing
    timestamp auction_start?=now
  
    timestamp auction_end
    bool is_active?=true
    bool is_sold?
  
    // Car specifications
    text engine? filters=trim
  
    int power_hp? filters=min:0
    text color? filters=trim
    text vin filters=trim
    int previous_owners? filters=min:0
  
    // Additional details
    text description? filters=trim
  
    text condition_report? filters=trim
    text[] features
  
    // Stats
    int total_bids? filters=min:0
  
    int total_views? filters=min:0
    int total_watchers? filters=min:0
  
    // Winner info (nullable until sold)
    int winning_bidder_id? {
      table = "user"
    }
  
    timestamp created_at?=now
    timestamp updated_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "slug", op: "asc"}]}
    {type: "btree|unique", field: [{name: "vin", op: "asc"}]}
    {type: "btree", field: [{name: "is_active", op: "asc"}]}
    {type: "btree", field: [{name: "is_sold", op: "asc"}]}
    {type: "btree", field: [{name: "current_price", op: "desc"}]}
    {type: "btree", field: [{name: "auction_end", op: "asc"}]}
    {type: "btree", field: [{name: "year", op: "desc"}]}
    {type: "btree", field: [{name: "total_bids", op: "desc"}]}
    {type: "btree", field: [{name: "total_views", op: "desc"}]}
    {
      type : "btree"
      field: [
        {name: "is_active", op: "asc"}
        {name: "auction_end", op: "asc"}
      ]
    }
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}