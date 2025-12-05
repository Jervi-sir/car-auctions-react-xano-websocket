// Get a list of all allergies with optional filtering by severity
query allergies verb=GET {
  input {
    // Filter by severity level (mild, moderate, severe, life_threatening)
    text severity? filters=trim
  
    // Search term for allergy name
    text search? filters=trim
  }

  stack {
    var $where_clause {
      value = true
    }
  
    conditional {
      if ($input.search != null && ($input.search|strlen) > 0) {
        var.update $where_clause {
          value = $where_clause && $db.allergy.name includes $input.search
        }
      }
    }
  
    var $final_where {
      value = $where_clause && $db.allergy.severity ==? $input.severity
    }
  
    db.query allergy {
      where = `$final_where`
      sort = {allergy.name: "asc"}
      return = {type: "list"}
    } as $allergies
  }

  response = $allergies
  history = false
}