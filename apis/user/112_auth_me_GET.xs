// Get the user record belonging to the authentication token
query "auth/me" verb=GET {
  api_group = "user"

  input {
  }

  stack {
    db.get "" {
      field_name = "id"
      field_value = $auth.id
      output = ["id", "created_at", "name", "email"]
    } as $user
  }

  response = $user
}