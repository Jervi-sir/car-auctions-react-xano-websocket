query test verb=GET {
  auth = "user"

  input {
  }

  stack {
    var $x1 {
      value = false
    }
  
    precondition (`$x1` == false)
  }

  response = $x1
}