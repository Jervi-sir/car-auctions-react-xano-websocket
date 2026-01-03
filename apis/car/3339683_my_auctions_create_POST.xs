// Create a new car auction listing with detailed specifications
query "my-auctions/create" verb=POST {
  api_group = "car"
  auth = "user"

  input {
    // Title of the auction listing
    text title? filters=trim
  
    // Subtitle of the listing
    text subtitle? filters=trim
  
    // Manufacturing year
    int year?
  
    // Mileage in KM
    int mileage_km?
  
    // Fuel type
    text fuel?
  
    // Transmission type
    text transmission?
  
    // Physical location of the car
    text location
  
    // Starting bid price
    decimal starting_price
  
    // Minimum price to sell
    decimal reserve_price?
  
    // Currency code
    text currency?=USD
  
    // Start time of the auction
    timestamp auction_start?
  
    // End time of the auction
    timestamp auction_end
  
    // Detailed description
    text description?
  
    // Vehicle Identification Number
    text vin? filters=trim|upper
  
    // Number of previous owners
    int previous_owners?
  
    // New fields as per plan
    // Exterior and interior colors
    text[] colors?
  
    // Engine type
    enum engine?
  
    // Engine power in horsepower
    int power_hp?
  
    // Detailed condition report
    text condition_report?
  
    // List of car features
    text[] features?
  
    file? image?
  }

  stack {
    // Generate a unique slug based on title and current timestamp
    var $slug {
      value = ($input.title|to_lower|replace:" ":"-") ~ "-" ~ (now|to_timestamp)
    }
  
    storage.create_image {
      value = $input.image
      access = "public"
      filename = ""
    } as $uploaded_image
  
    db.add car_auction {
      data = {
        title            : $input.title
        subtitle         : $input.subtitle
        slug             : $slug
        year             : $input.year
        mileage_km       : $input.mileage_km
        fuel             : $input.fuel
        transmission     : $input.transmission
        location         : $input.location
        starting_price   : $input.starting_price
        current_price    : $input.starting_price
        reserve_price    : $input.reserve_price
        currency         : $input.currency
        auction_start    : $input.auction_start
        auction_end      : $input.auction_end
        is_active        : true
        is_sold          : false
        engine           : $input.engine
        power_hp         : $input.power_hp
        color            : ""
        vin              : $input.vin
        previous_owners  : $input.previous_owners
        description      : $input.description
        condition_report : $input.condition_report
        features         : $input.features
        total_bids       : 0
        total_views      : 0
        total_watchers   : 0
        winning_bidder_id: null
        created_by       : $auth.id
        created_at       : now
        updated_at       : now
        image_url        : $uploaded_image
        gallery_images   : null
      }
    } as $new_auction
  }

  response = $new_auction
}