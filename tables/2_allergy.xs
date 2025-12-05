// Allergen types for tracking food allergies
table allergy {
  auth = false

  schema {
    int id
    text name filters=trim
    text slug filters=trim|lower
    text description? filters=trim
    enum severity? {
      values = ["mild", "moderate", "severe"]
    }
  
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "slug", op: "asc"}]}
    {type: "btree", field: [{name: "name", op: "asc"}]}
    {type: "btree", field: [{name: "severity", op: "asc"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}