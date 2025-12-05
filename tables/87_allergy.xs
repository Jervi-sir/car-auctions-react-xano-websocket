table allergy {
  auth = false

  schema {
    // Unique identifier for the allergy
    int id
  
    // Name of the allergy (e.g., Peanuts, Dairy, Gluten)
    text name filters=trim
  
    // Detailed description of the allergy
    text description? filters=trim
  
    // Severity level of the allergic reaction
    enum severity? {
      values = ["mild", "moderate", "severe", "life_threatening"]
    }
  
    // Common symptoms associated with this allergy
    text[] common_symptoms
  
    // Alternative names or related allergens
    text[] alternative_names?
  
    // Timestamp when the allergy was added to the system
    timestamp created_at?=now
  
    // Timestamp when the allergy information was last updated
    timestamp updated_at?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "name", op: "asc"}]}
    {type: "btree", field: [{name: "severity", op: "asc"}]}
  ]
}