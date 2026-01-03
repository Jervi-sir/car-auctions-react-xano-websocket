function broadcastBid {
  input {
    int auction_id
    int bid_id
  }

  stack {
    db.get car_bid {
      field_name = "id"
      field_value = $input.bid_id
    } as $new_bid
  
    db.get user {
      field_name = "id"
      field_value = $new_bid.bidder_id
    } as $bidder
  
    api.lambda {
      code = """
        const bid = $var.new_bid;
        const bidder = $var.bidder;
        
        return {
            action: "new_bid",
            payload: {
                id: bid.id,
                bidder_name: bidder.name,
                bidderAvatar: '', // bidder.avatar_url,
                amount: bid.amount,
                time: bid.created_at
            }
        };
        """
      timeout = 10
    } as $data_to_broadcast
  
    api.realtime_event {
      channel = "auctionSession/"|concat:$input.auction_id:""
      data = $data_to_broadcast
      auth_table = ""
      auth_id = ""
    }
  
    util.get_vars as $__all_vars
  }

  response = {
    new_bid          : $__all_vars|get:"new_bid":null
    bidder           : $__all_vars|get:"bidder":null
    data_to_broadcast: $__all_vars|get:"data_to_broadcast":null
  }

  history = 100
}