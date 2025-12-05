table recipe_collection {
  auth = false

  schema {
    // Unique identifier for the collection
    int id
  
    // Name of the collection (e.g., 'Summer BBQ', 'Holiday Favorites')
    text name filters=trim
  
    // Description of the collection
    text description? filters=trim
  
    // URL-friendly slug for the collection
    text slug filters=trim
  
    // Cover image for the collection
    image cover_image?
  
    // Whether this collection is featured on the homepage
    bool is_featured?
  
    // Whether this collection is publicly visible
    bool is_public?=true
  
    // Number of times the collection has been viewed
    int view_count?
  
    // Timestamp when the collection was created
    timestamp created_at?=now
  
    // Timestamp when the collection was last updated
    timestamp updated_at?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "slug", op: "asc"}]}
    {type: "btree", field: [{name: "is_featured", op: "asc"}]}
    {type: "btree", field: [{name: "is_public", op: "asc"}]}
    {type: "btree", field: [{name: "view_count", op: "desc"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}