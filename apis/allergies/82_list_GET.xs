// Get all allergies
query list verb=GET {
  api_group = "allergies"

  input {
  }

  stack {
    // Get all allergies
    db.query allergy {
      sort = {allergy.name: "asc"}
      return = {type: "list"}
    } as $allergies
  }

  response = $allergies
  history = false
}