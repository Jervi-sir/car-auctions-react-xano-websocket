// Get all cuisines
query list verb=GET {
  api_group = "cuisines"

  input {
  }

  stack {
    // Get all cuisines
    db.query cuisine {
      sort = {cuisine.name: "asc"}
      return = {type: "list"}
    } as $cuisines
  }

  response = $cuisines
  history = false
}