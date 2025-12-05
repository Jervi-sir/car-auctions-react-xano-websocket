// Get a list of all available ingredient categories with counts
query "ingredients/categories" verb=GET {
  input {
  }

  stack {
    db.query ingredient {
      return = {type: "list"}
    } as $all_ingredients
  
    var $categories {
      value = [
        "vegetable"
        "fruit"
        "meat"
        "seafood"
        "dairy"
        "grain"
        "spice"
        "herb"
        "nut"
        "legume"
        "oil"
        "condiment"
        "sweetener"
        "beverage"
        "other"
      ]
    }
  
    var $category_counts {
      value = $categories
        |map:```
          {
            category: $this
            count: ($all_ingredients|filter:$this.category == $parent.this)|count
          }
          ```
    }
  }

  response = $category_counts
  history = false
}