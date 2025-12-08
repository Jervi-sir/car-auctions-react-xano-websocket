// Seed car_auction table with sample auction listings
function car_1_seed_car_auctions {
  input {
  }

  stack {
    db.truncate car_auction {
      reset = true
    }
  
    // --- 1. Porsche 911 ---
    db.add car_auction {
      data = {
        title            : "1973 Porsche 911 Carrera RS"
        subtitle         : "Matching Numbers, Fully Restored"
        slug             : "1973-porsche-911-carrera-rs"
        year             : 1973
        mileage_km       : 85000
        fuel             : "Petrol"
        transmission     : "Manual"
        location         : "Stuttgart, Germany"
        starting_price   : 150000
        current_price    : 150000
        reserve_price    : 200000
        currency         : "USD"
        auction_start    : now
        auction_end      : now|add_secs_to_timestamp:604800
        is_active        : true
        is_sold          : false
        engine           : "2.7L Flat-6"
        power_hp         : 210
        color            : "Grand Prix White"
        vin              : "9113600001"
        previous_owners  : 2
        description      : "Iconic 1973 Porsche 911 Carrera RS. Matching numbers. Fully restored."
        condition_report : "Excellent condition. Engine rebuild and fresh suspension."
        features         : ```
          [
            "Ducktail Spoiler",
            "Fuchs Wheels",
            "Sport Seats",
            "Original Interior",
          ]
          ```
        total_bids       : 0
        total_views      : 0
        total_watchers   : 0
        winning_bidder_id: 0
        created_at       : now
        updated_at       : now
        image_url        : ""
        gallery_images   : []
      }
    }
  
    // --- 2. Ferrari F40 ---
    db.add car_auction {
      data = {
        title           : "1991 Ferrari F40"
        subtitle        : "Rosso Corsa, Low Mileage"
        slug            : "1991-ferrari-f40"
        year            : 1991
        mileage_km      : 12000
        fuel            : "Petrol"
        transmission    : "Manual"
        location        : "Maranello, Italy"
        starting_price  : 1200000
        current_price   : 1200000
        reserve_price   : 1500000
        currency        : "USD"
        auction_start   : now
        auction_end     : now|add_secs_to_timestamp:864000
        is_active       : true
        is_sold         : false
        engine          : "2.9L Twin-Turbo V8"
        power_hp        : 478
        color           : "Rosso Corsa"
        vin             : "ZFFGJ34B000087654"
        previous_owners : 1
        description     : "Stunning Ferrari F40. Ultra-low mileage."
        condition_report: "Museum quality. All original panels."
        features        : ```
          [
            "Twin Turbo",
            "Carbon Fiber Body",
            "Racing Seats",
            "Original Tool Kit",
          ]
          ```
        total_bids      : 0
        total_views     : 0
        total_watchers  : 0
        created_at      : now
        updated_at      : now
      }
    }
  
    // --- 3. Mercedes-Benz 300SL ---
    db.add car_auction {
      data = {
        title           : "1955 Mercedes-Benz 300SL Gullwing"
        subtitle        : "Concours Condition, Matching Numbers"
        slug            : "1955-mercedes-300sl-gullwing"
        year            : 1955
        mileage_km      : 45000
        fuel            : "Petrol"
        transmission    : "Manual"
        location        : "Beverly Hills, USA"
        starting_price  : 800000
        current_price   : 800000
        reserve_price   : 1000000
        currency        : "USD"
        auction_start   : now
        auction_end     : now|add_secs_to_timestamp:432000
        is_active       : true
        is_sold         : false
        engine          : "3.0L Inline-6"
        power_hp        : 215
        color           : "Silver Metallic"
        vin             : "198.040.5500001"
        previous_owners : 3
        description     : "Concours restoration. Fully documented."
        condition_report: "Award-winning restoration."
        features        : ```
          [
            "Gullwing Doors",
            "Rudge Wheels",
            "Original Interior",
            "Luggage Set",
          ]
          ```
        total_bids      : 0
        total_views     : 0
        total_watchers  : 0
        created_at      : now
        updated_at      : now
      }
    }
  
    // --- 4. Lamborghini Countach ---
    db.add car_auction {
      data = {
        title           : "1985 Lamborghini Countach 5000 QV"
        subtitle        : "Bianco White, Original Paint"
        slug            : "1985-lamborghini-countach-5000qv"
        year            : 1985
        mileage_km      : 28000
        fuel            : "Petrol"
        transmission    : "Manual"
        location        : "Monaco"
        starting_price  : 400000
        current_price   : 400000
        reserve_price   : 500000
        currency        : "USD"
        auction_start   : now
        auction_end     : now|add_secs_to_timestamp:1209600
        is_active       : true
        is_sold         : false
        engine          : "5.2L V12"
        power_hp        : 455
        color           : "Bianco White"
        vin             : "ZA9C00500FLA12345"
        previous_owners : 2
        description     : "Iconic Countach in great condition."
        condition_report: "Original condition. Engine serviced."
        features        : ```
            [
              "Scissor Doors", 
              "Original Wheels", 
              "Period Radio", 
              "Tool Kit"
            ]
          ```
        total_bids      : 0
        total_views     : 0
        total_watchers  : 0
        created_at      : now
        updated_at      : now
      }
    }
  
    // --- 5. Jaguar E-Type ---
    db.add car_auction {
      data = {
        title           : "1967 Jaguar E-Type Series 1 Roadster"
        subtitle        : "British Racing Green, Restored"
        slug            : "1967-jaguar-e-type-series1"
        year            : 1967
        mileage_km      : 62000
        fuel            : "Petrol"
        transmission    : "Manual"
        location        : "London, UK"
        starting_price  : 180000
        current_price   : 180000
        reserve_price   : 220000
        currency        : "USD"
        auction_start   : now
        auction_end     : now|add_secs_to_timestamp:518400
        is_active       : true
        is_sold         : false
        engine          : "4.2L Inline-6"
        power_hp        : 265
        color           : "British Racing Green"
        vin             : "1E12345"
        previous_owners : 4
        description     : "Comprehensive restoration. Factory specs."
        condition_report: "Engine rebuilt. New chrome work."
        features        : ```
            [
              "Convertible Top",
              "Wire Wheels",
              "Original Gauges",
              "Leather Interior"
            ]
          ```
        total_bids      : 0
        total_views     : 0
        total_watchers  : 0
        created_at      : now
        updated_at      : now
      }
    }
  
    // --- 6. McLaren F1 ---
    db.add car_auction {
      data = {
        title           : "1994 McLaren F1"
        subtitle        : "One of the rarest hypercars ever"
        slug            : "1994-mclaren-f1"
        year            : 1994
        mileage_km      : 9700
        fuel            : "Petrol"
        transmission    : "Manual"
        location        : "London, UK"
        starting_price  : 14000000
        current_price   : 14000000
        reserve_price   : 18000000
        currency        : "USD"
        auction_start   : now
        auction_end     : now|add_secs_to_timestamp:691200
        is_active       : true
        is_sold         : false
        engine          : "6.1L BMW V12"
        power_hp        : 627
        color           : "Midnight Silver"
        vin             : "SA9AB5BA7R1041234"
        previous_owners : 1
        description     : "Ultra-rare McLaren F1 in impeccable condition."
        condition_report: "Collector-grade. Full maintenance records."
        features        : ```
            [
              "Central Driving Position",
              "Gold Foil Heat Shielding",
              "Carbon Fiber Body",
              "Original Tool Kit"
            ]
          ```
        total_bids      : 0
        total_views     : 0
        total_watchers  : 0
        created_at      : now
        updated_at      : now
      }
    }
  
    // --- 7. Toyota Supra MK4 ---
    db.add car_auction {
      data = {
        title           : "1998 Toyota Supra MK4 Twin Turbo"
        subtitle        : "6-Speed Manual, Highly Collectible"
        slug            : "1998-toyota-supra-mk4"
        year            : 1998
        mileage_km      : 54000
        fuel            : "Petrol"
        transmission    : "Manual"
        location        : "Tokyo, Japan"
        starting_price  : 95000
        current_price   : 95000
        reserve_price   : 130000
        currency        : "USD"
        auction_start   : now
        auction_end     : now|add_secs_to_timestamp:345600
        is_active       : true
        is_sold         : false
        engine          : "3.0L 2JZ Twin Turbo"
        power_hp        : 320
        color           : "Black"
        vin             : "JT2JA82J0W0012345"
        previous_owners : 2
        description     : "Legendary Supra MK4 with factory 6-speed."
        condition_report: "Excellent condition. No modifications."
        features        : ```
            [
              "6-Speed Manual",
              "Twin Turbo", 
              "Active Aero", 
              "Original Wheels"
            ]
          ```
        total_bids      : 0
        total_views     : 0
        total_watchers  : 0
        created_at      : now
        updated_at      : now
      }
    }
  
    // --- 8. Nissan GT-R R34 ---
    db.add car_auction {
      data = {
        title           : "1999 Nissan GT-R R34 V-Spec"
        subtitle        : "Iconic JDM legend"
        slug            : "1999-nissan-gtr-r34-vspec"
        year            : 1999
        mileage_km      : 68000
        fuel            : "Petrol"
        transmission    : "Manual"
        location        : "Osaka, Japan"
        starting_price  : 120000
        current_price   : 120000
        reserve_price   : 160000
        currency        : "USD"
        auction_start   : now
        auction_end     : now|add_secs_to_timestamp:432000
        is_active       : true
        is_sold         : false
        engine          : "RB26DETT"
        power_hp        : 330
        color           : "Bayside Blue"
        vin             : "BNR34-002345"
        previous_owners : 3
        description     : "Import-legal GT-R R34 V-Spec. Very clean."
        condition_report: "Minor wear, mechanically solid."
        features        : ```
            [
              "ATTESA AWD", 
              "V-Spec Aero", 
              "Brembo Brakes", 
              "Factory Recaros"
            ]
          ```
        total_bids      : 0
        total_views     : 0
        total_watchers  : 0
        created_at      : now
        updated_at      : now
      }
    }
  
    // --- 9. Bugatti Chiron ---
    db.add car_auction {
      data = {
        title           : "2019 Bugatti Chiron"
        subtitle        : "1500 HP Modern Hypercar"
        slug            : "2019-bugatti-chiron"
        year            : 2019
        mileage_km      : 3200
        fuel            : "Petrol"
        transmission    : "Automatic"
        location        : "Dubai, UAE"
        starting_price  : 2500000
        current_price   : 2500000
        reserve_price   : 3000000
        currency        : "USD"
        auction_start   : now
        auction_end     : now|add_secs_to_timestamp:259200
        is_active       : true
        is_sold         : false
        engine          : "8.0L Quad-Turbo W16"
        power_hp        : 1500
        color           : "Blue Carbon"
        vin             : "VF9SP3V37KM795123"
        previous_owners : 1
        description     : "One of the fastest cars ever built."
        condition_report: "Mint condition, full service history."
        features        : ```
            [
              "Carbon Fiber Body",
              "Active Aero",
              "Quad-Turbo W16",
              "Luxury Interior"
            ]
          ```
        total_bids      : 0
        total_views     : 0
        total_watchers  : 0
        created_at      : now
        updated_at      : now
      }
    }
  
    // --- 10. BMW M3 E30 ---
    db.add car_auction {
      data = {
        title           : "1990 BMW M3 E30"
        subtitle        : "Iconic homologation model"
        slug            : "1990-bmw-m3-e30"
        year            : 1990
        mileage_km      : 95000
        fuel            : "Petrol"
        transmission    : "Manual"
        location        : "Munich, Germany"
        starting_price  : 90000
        current_price   : 90000
        reserve_price   : 120000
        currency        : "USD"
        auction_start   : now
        auction_end     : now|add_secs_to_timestamp:345600
        is_active       : true
        is_sold         : false
        engine          : "2.3L S14"
        power_hp        : 192
        color           : "Alpine White"
        vin             : "WBSAK03000AE12345"
        previous_owners : 3
        description     : "Clean original BMW M3 E30. Very collectible."
        condition_report: "Excellent chassis. Strong engine."
        features        : ```
            [
              "Recaro Seats",
              "M Sport Suspension",
              "Limited Slip Differential",
              "Original Wheels"
            ]
          ```
        total_bids      : 0
        total_views     : 0
        total_watchers  : 0
        created_at      : now
        updated_at      : now
      }
    }
  
    debug.log {
      value = "Seeded 10 car auctions successfully"
    }
  }

  response = {result: "Car auctions seeded successfully", count: 10}
}