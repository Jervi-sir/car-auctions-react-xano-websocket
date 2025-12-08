// User registration/signup endpoint
query "auth/signup" verb=POST {
  input {
    text name filters=trim
    text email filters=trim|lower
    text password filters=trim
    text phone? filters=trim
    text city? filters=trim
    text country? filters=trim
  }

  stack {
    db.get user {
      field_name = "email"
      field_value = $input.email
    } as $existing_user
  
    precondition ("user" != null) {
      error_type = "accessdenied"
      error = "This account is already in use"
    }
  
    db.add user {
      data = {
        name       : $input.name
        email      : $input.email
        password   : $input.password
        phone      : $input.phone
        is_verified: false
        is_active  : "1"
        total_bids : 0
        total_wins : 0
        total_spent: 0
        city       : $input.city
        country    : $input.country
        created_at : "now"
        updated_at : "now"
        avatar_url : ""
      }
    } as $user
  
    security.create_auth_token {
      table = "user"
      extras = {}
      expiration = 86400
      id = $user.id
    } as $authToken
  }

  response = {authToken: $authToken}
  history = false
}