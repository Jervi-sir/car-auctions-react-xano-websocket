// Get detailed auction car information by slug and log view
query "auctions/slug" verb=GET {
  api_group = "car"

  input {
    text slug?
    int user_id?
  }

  stack {
    // Get auction car by slug
    db.query car_auction {
      where = $db.car_auction.slug == $input.slug
      return = {type: "single"}
    } as $auction
  
    !return {
      value = $env.$http_headers
    }
  
    // Validate auction exists
    precondition ($auction != null) {
      error_type = "notfound"
      error = "Auction car not found"
    }
  
    // Get bid history for this auction
    db.query car_bid {
      where = $db.car_bid.car_auction_id == $auction.id && $db.car_bid.is_valid
      sort = {created_at: "desc"}
      return = {type: "list", paging: {page: 1, per_page: 50}}
    } as $bids
  
    // Log view to auction_view_history
    db.add car_auction_view_history {
      data = {
        car_auction_id: $auction.id
        user_id       : $auth.id
        ip_address    : $env.$remote_ip
        user_agent    : $env.$http_headers["User-Agent"]
        referrer      : $env.$http_headers.Referer
        view_source   : "web"
        created_at    : now
      }
    }
  
    // Increment view count
    db.edit car_auction {
      field_name = "id"
      field_value = $auction.id
      data = {total_views: $auction.total_views + 1, updated_at: now}
    }
  
    // Prepare response
    var $response_data {
      value = {
        id              : $auction.id
        title           : $auction.title
        subtitle        : $auction.subtitle
        slug            : $auction.slug
        image_url       : $auction.image_url
        gallery_images  : $auction.gallery_images
        year            : $auction.year
        mileage_km      : $auction.mileage_km
        fuel            : $auction.fuel
        transmission    : $auction.transmission
        location        : $auction.location
        starting_price  : $auction.starting_price
        current_price   : $auction.current_price
        reserve_price   : $auction.reserve_price
        currency        : $auction.currency
        auction_start   : $auction.auction_start
        auction_end     : $auction.auction_end
        is_active       : $auction.is_active
        is_sold         : $auction.is_sold
        specs           : {
          engine          : $auction.engine
          power_hp        : $auction.power_hp
          color           : $auction.color
          vin             : $auction.vin
          previous_owners : $auction.previous_owners
        }
        description     : $auction.description
        condition_report: $auction.condition_report
        features        : $auction.features
        total_bids      : $auction.total_bids
        total_views     : $auction.total_views + 1
        total_watchers  : $auction.total_watchers
        bids            : $bids.items
        created_at      : $auction.created_at
      }
    }
  }

  response = $response_data
  history = false
}