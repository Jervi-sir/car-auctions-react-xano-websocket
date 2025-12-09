// Create a new car auction listing
query "my-auctions/this-auction" verb=PUT {
  auth = "user"

  input {
    int auction_id?
  
    // Title of the car auction
    text title filters=trim
  
    // Manufacturing year
    int year
  
    // Mileage in kilometers
    int mileage_km
  
    // Fuel type
    text fuel filters=trim
  
    // Transmission type
    text transmission filters=trim
  
    // Location of the car
    text location filters=trim
  
    // Starting bid price
    decimal starting_price
  
    // Currency code
    text currency filters=trim|upper
  
    timestamp? auction_start?
  
    // Auction end time
    timestamp auction_end
  
    // Detailed description
    text description filters=trim
  
    // Engine details
    text engine filters=trim
  
    // Power in HP
    int power_hp
  
    // Exterior color
    text color filters=trim
  
    // List of features
    text[] features
  
    // Optional fields based on table schema
    text subtitle? filters=trim
  
    decimal reserve_price?
    file? image?
    text vin? filters=trim|upper
    int previous_owners?
    text condition_report? filters=trim
  }

  stack {
    // Generate slug from title and current timestamp to ensure uniqueness
    var $slug {
      value = ($input.title|to_lower|regex_replace:"/[^a-z0-9]+/" : "-") ~ "-" ~ (now|to_timestamp)
    }
  
    conditional {
      if ($input.image != null) {
        storage.create_image {
          value = $input.image
          access = "public"
          filename = ""
        } as $uploaded_image
      
        db.edit car_auction {
          field_name = "id"
          field_value = $input.auction_id
          data = {
            title           : $input.title
            subtitle        : $input.subtitle
            slug            : $slug
            year            : $input.year
            mileage_km      : $input.mileage_km
            fuel            : $input.fuel
            transmission    : $input.transmission
            location        : $input.location
            starting_price  : $input.starting_price
            reserve_price   : $input.reserve_price
            currency        : $input.currency
            auction_start   : $input.auction_start
            auction_end     : $input.auction_end
            engine          : $input.engine
            power_hp        : $input.power_hp
            color           : $input.color
            vin             : $input.vin
            previous_owners : $input.previous_owners
            description     : $input.description
            condition_report: $input.condition_report
            features        : $input.features
            updated_at      : now
            image_url       : $uploaded_image
          }
        } as $updated_auction
      }
    
      else {
        !return {
          value = ""
        }
      
        db.edit car_auction {
          field_name = "id"
          field_value = $input.auction_id
          data = {
            title           : $input.title
            subtitle        : $input.subtitle
            slug            : $slug
            year            : $input.year
            mileage_km      : $input.mileage_km
            fuel            : $input.fuel
            transmission    : $input.transmission
            location        : $input.location
            starting_price  : $input.starting_price
            reserve_price   : $input.reserve_price
            currency        : $input.currency
            auction_start   : $input.auction_start
            auction_end     : $input.auction_end
            engine          : $input.engine
            power_hp        : $input.power_hp
            color           : $input.color
            vin             : $input.vin
            previous_owners : $input.previous_owners
            description     : $input.description
            condition_report: $input.condition_report
            features        : $input.features
            updated_at      : now
          }
        } as $updated_auction
      }
    }
  }

  response = $updated_auction
}