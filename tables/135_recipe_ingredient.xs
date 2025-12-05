// Junction table linking recipes to ingredients with quantity details
table recipe_ingredient {
  auth = false

  schema {
    int id
    int recipe_id {
      table = "recipe"
    }
  
    int ingredient_id {
      table = "ingredient"
    }
  
    text quantity? filters=trim
    enum unit? {
      values = [
        "cup"
        "cups"
        "tablespoon"
        "tablespoons"
        "teaspoon"
        "teaspoons"
        "gram"
        "grams"
        "kilogram"
        "kilograms"
        "ounce"
        "ounces"
        "pound"
        "pounds"
        "milliliter"
        "milliliters"
        "liter"
        "liters"
        "piece"
        "pieces"
        "pinch"
        "to taste"
        "whole"
        "slice"
        "slices"
      ]
    }
  
    text preparation_note? filters=trim
    int order_index? filters=min:0
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "recipe_id", op: "asc"}]}
    {type: "btree", field: [{name: "ingredient_id", op: "asc"}]}
    {
      type : "btree"
      field: [
        {name: "recipe_id", op: "asc"}
        {name: "order_index", op: "asc"}
      ]
    }
  ]
}