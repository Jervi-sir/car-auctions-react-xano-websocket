query get_user verb=GET {
  input {
    text id? filters=trim
  }

  stack {
  }

  response = {user: "user"}
}