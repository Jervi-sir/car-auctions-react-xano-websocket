// Get user's posted auctions
query "my-auctions/my-posted" verb=GET {
  auth = "user"

  input {
    int page?=1 filters=min:1
    int per_page?=20 filters=min:1|max:100
    text status?=all
  }

  stack {
    // Query auctions
    db.query car_auction {
      where = $db.car_auction.created_by == $auth.id
      sort = {created_at: "desc"}
      return = {
        type  : "list"
        paging: {
          page    : $input.page
          per_page: $input.per_page
          totals  : true
        }
      }
    } as $auctions
  
    // Prepare response
    var $response_data {
      value = {
        auctions   : $auctions.items
        total      : $auctions.itemsTotal
        page       : $auctions.page
        per_page   : $auctions.itemsPerPage
        total_pages: $auctions.pageTotal
      }
    }
  }

  response = $response_data
  history = 100
}