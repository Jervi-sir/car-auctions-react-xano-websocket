addon allergy_format {
  input {
    int id?
  }

  stack {
    db.query "" {
      return = {type: "list"}
    }
  }
}