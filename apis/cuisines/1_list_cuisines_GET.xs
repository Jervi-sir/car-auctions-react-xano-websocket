// Get a list of all cuisines with optional region filtering
query cuisines verb=GET {
  input {
    // Filter by geographic region
    text region? filters=trim
  
    // Search term for cuisine name
    text search? filters=trim
  }

  stack {
    var $where_clause {
      value = true
    }
  
    conditional {
      if ($input.search != null && ($input.search|strlen) > 0) {
        var.update $where_clause {
          value = $where_clause && $db.cuisine.name includes $input.search
        }
      }
    }
  
    var $final_where {
      value = $where_clause && $db.cuisine.region ==? $input.region
    }
  
    db.query cuisine {
      where = `$final_where`
      sort = {cuisine.name: "asc"}
      return = {type: "list"}
    } as $cuisines
  }

  response = $cuisines
  history = false
}