// List available auction cars
query "auctions/mine" verb=GET {
  api_group = "car"
  auth = "user"

  input {
    int page?=1 filters=min:1
    int per_page?=20 filters=min:1|max:100
    int user_id
  }

  stack {
    db.query car_auction {
      where = $db.car_auction.is_sold && $db.car_auction.winning_bidder_id == $input.user_id
      sort = {auction_end: "asc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $auctions
  
    var $response_data {
      value = {
        auctions   : $auctions.items
        page       : $auctions.page
        per_page   : $auctions.itemsPerPage
        total      : $auctions.itemsTotal
        total_pages: $auctions.pageTotal
      }
    }
  }

  response = $response_data
  history = false
}