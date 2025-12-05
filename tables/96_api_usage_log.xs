table api_usage_log {
  auth = false

  schema {
    // Unique identifier for the API usage log entry
    int id
  
    // API key used for the request (if applicable)
    text api_key? filters=trim {
      sensitive = true
    }
  
    // API endpoint that was called
    text endpoint filters=trim
  
    // HTTP method used (GET, POST, etc.)
    text http_method filters=trim
  
    // Query parameters sent with the request
    json query_parameters?
  
    // HTTP response status code
    int response_status?
  
    // Response time in milliseconds
    int response_time_ms?
  
    // IP address of the requester
    text ip_address? filters=trim
  
    // User agent string from the request
    text user_agent? filters=trim
  
    // Number of records returned in the response
    int records_returned?
  
    // Whether the request resulted in an error
    bool is_error?
  
    // Error message if the request failed
    text error_message? filters=trim
  
    // Timestamp when the API call was made
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "api_key", op: "asc"}]}
    {type: "btree", field: [{name: "endpoint", op: "asc"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
    {type: "btree", field: [{name: "is_error", op: "asc"}]}
    {
      type : "btree"
      field: [{name: "response_status", op: "asc"}]
    }
    {type: "gin", field: [{name: "query_parameters"}]}
  ]
}