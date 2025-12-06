# Xanoscript Language Syntax & Logic Reference

This document provides a comprehensive reference for Xanoscript syntax and logic patterns based on the codebase analysis.

---

## Table of Contents
1. [File Types & Structure](#file-types--structure)
2. [Table Definitions](#table-definitions)
3. [API Queries](#api-queries)
4. [Functions](#functions)
5. [Tasks](#tasks)
6. [Addons](#addons)
7. [API Groups](#api-groups)
8. [Data Types](#data-types)
9. [Filters](#filters)
10. [Operators](#operators)
11. [Database Operations](#database-operations)
12. [Variables](#variables)
13. [Control Flow](#control-flow)
14. [Common Patterns](#common-patterns)

---

## File Types & Structure

Xanoscript uses `.xs` file extensions and supports the following top-level constructs:

- **Tables**: `table [name] { ... }`
- **API Queries**: `query [name] verb=[HTTP_VERB] { ... }`
- **Functions**: `function [name] { ... }`
- **Tasks**: `task [name] { ... }`
- **Addons**: `addon [name] { ... }`
- **API Groups**: `api_group [name] { ... }`

---

## Table Definitions

### Basic Structure

```xanoscript
table [table_name] {
  auth = [true|false]
  
  schema {
    // Field definitions
  }
  
  index = [
    // Index definitions
  ]
}
```

### Field Definitions

#### Basic Field Syntax
```xanoscript
[type] [field_name][?] [filters=...] [={default_value}]
```

- `?` = Optional field
- `filters=` = Apply filters to the field
- `=` = Set default value

#### Field Types

**Primitive Types:**
```xanoscript
int id                              // Integer
text name                           // Text/String
bool is_active                      // Boolean
decimal price                       // Decimal number
timestamp created_at                // Timestamp
image image_url                     // Image
video video_url                     // Video
email user_email                    // Email
json metadata                       // JSON object
```

**Array Types:**
```xanoscript
text[] tags                         // Array of text
int[] category_ids                  // Array of integers
image[] gallery                     // Array of images
```

**Enum Types:**
```xanoscript
enum difficulty? {
  values = ["easy", "medium", "hard", "expert"]
}

enum meal_type? {
  values = [
    "breakfast"
    "lunch"
    "dinner"
    "snack"
  ]
}
```

#### Foreign Keys

```xanoscript
int cuisine_id? {
  table = "cuisine"
}

int[] allergy_ids {
  table = "allergy"
}
```

#### Field Options

```xanoscript
// Sensitive data (hidden in logs)
text password {
  sensitive = true
}

// Default values
timestamp created_at?=now
int view_count?=0
bool is_active?=true
```

### Filters on Fields

```xanoscript
text name filters=trim
text email filters=trim|lower
int age filters=min:0|max:120
decimal rating filters=min:0|max:5
int quantity filters=min:1
```

### Index Definitions

```xanoscript
index = [
  // Primary key
  {type: "primary", field: [{name: "id"}]}
  
  // Unique index
  {type: "btree|unique", field: [{name: "email", op: "asc"}]}
  
  // Regular index
  {type: "btree", field: [{name: "created_at", op: "desc"}]}
  
  // Composite index
  {
    type: "btree"
    field: [
      {name: "recipe_id", op: "asc"}
      {name: "order_index", op: "asc"}
    ]
  }
  
  // GIN index for JSON
  {type: "gin", field: [{name: "metadata"}]}
]
```

**Index Types:**
- `primary` - Primary key
- `btree` - B-tree index
- `btree|unique` - Unique B-tree index
- `gin` - Generalized Inverted Index (for JSON, arrays)

**Sort Operations:**
- `asc` - Ascending
- `desc` - Descending

---

## API Queries

### Basic Structure

```xanoscript
// Comment describing the endpoint
query [endpoint_path] verb=[GET|POST|PUT|DELETE|PATCH] {
  input {
    // Input parameters
  }
  
  stack {
    // Logic steps
  }
  
  response = [variable]
  history = [true|false]
}
```

### Input Parameters

```xanoscript
input {
  // Required parameter
  int recipe_id
  
  // Optional with default
  int page?=1
  
  // With filters
  text search? filters=trim
  email user_email? filters=trim|lower
  
  // With validation filters
  int per_page?=20 filters=min:1|max:100
  int rating filters=min:1|max:5
  
  // Arrays
  int[] ingredient_ids
  text[] tags
}
```

### Stack (Logic Block)

The `stack` contains the sequential logic of the query:

```xanoscript
stack {
  // Database query
  db.query recipe {
    where = $db.recipe.is_published
    return = {type: "list"}
  } as $recipes
  
  // Variable assignment
  var $total {
    value = $recipes|count
  }
  
  // Conditional validation
  precondition ($recipe != null) {
    error_type = "notfound"
    error = "Recipe not found"
  }
  
  // Response preparation
  var $response_data {
    value = {
      recipes: $recipes
      total: $total
    }
  }
}
```

### Response

```xanoscript
response = $response_data
history = false  // or true
```

---

## Functions

### Basic Structure

```xanoscript
function [function_name] {
  input {
    // Input parameters (optional)
  }
  
  stack {
    // Function logic
  }
  
  response = [return_value]
}
```

### Example

```xanoscript
function seeder_recipes {
  input {
    // No inputs needed
  }
  
  stack {
    db.truncate recipe {
      reset = true
    }
    
    db.query cuisine {
      return = {type: "list"}
    } as $all_cuisines
    
    // More logic...
  }
  
  response = {result: "Recipes seeded."}
}
```

---

## Tasks

### Basic Structure

```xanoscript
// Description of the task
task [task_name] {
  active = [true|false]
  
  stack {
    // Task logic
  }
  
  schedule = [{starts_on: [datetime], freq: [seconds]}]
}
```

### Example

```xanoscript
task update_trending_scores {
  active = false
  
  stack {
    var $window_start {
      value = now
        |transform_timestamp:"-7 days":"UTC"
    }
    
    db.query recipe {
      return = {type: "list"}
    } as $recipes
    
    foreach ($recipes) {
      each as $recipe {
        // Update logic
      }
    }
    
    debug.log {
      value = "Updated trending scores"
    }
  }
  
  schedule = [{starts_on: 2025-01-01 00:00:00+0000, freq: 86400}]
}
```

**Schedule Format:**
- `starts_on` - Start datetime in format: `YYYY-MM-DD HH:MM:SS+ZZZZ`
- `freq` - Frequency in seconds (86400 = 24 hours)

---

## Addons

### Basic Structure

```xanoscript
addon [addon_name] {
  input {
    // Input parameters
  }
  
  stack {
    // Addon logic
  }
}
```

---

## API Groups

### Basic Structure

```xanoscript
// Description of the API group
api_group [group_name] {
  canonical = "[unique_id]"
}
```

### Example

```xanoscript
// Public API for recipe management and discovery
api_group recipes {
  canonical = "GNqnKofF"
}
```

---

## Data Types

### Primitive Types

| Type | Description | Example |
|------|-------------|---------|
| `int` | Integer | `42`, `0`, `-10` |
| `text` | String | `"Hello"`, `"Recipe name"` |
| `bool` | Boolean | `true`, `false` |
| `decimal` | Decimal number | `3.14`, `0.5` |
| `timestamp` | Date/time | `now`, `2025-01-01 00:00:00+0000` |
| `image` | Image URL/reference | - |
| `video` | Video URL/reference | - |
| `email` | Email address | `"user@example.com"` |
| `json` | JSON object | `{key: "value"}` |

### Array Types

```xanoscript
text[]      // Array of strings
int[]       // Array of integers
image[]     // Array of images
```

### Special Values

```xanoscript
null        // Null value
now         // Current timestamp
```

---

## Filters

### Common Filters

```xanoscript
trim                    // Trim whitespace
lower                   // Convert to lowercase
upper                   // Convert to uppercase
min:[value]             // Minimum value
max:[value]             // Maximum value
min:[value]|max:[value] // Range validation
```

### Filter Chains

Filters are chained with `|`:

```xanoscript
text email filters=trim|lower
int age filters=min:0|max:120
```

### Pipe Filters (on values)

```xanoscript
$recipes|count                          // Count items
$recipes|map:$this.id                   // Map to field
$recipes|map:$this.id|unique            // Map and get unique
$value|transform_timestamp:"-7 days"    // Transform timestamp
```

---

## Operators

### Comparison Operators

```xanoscript
==          // Equal
!=          // Not equal
>           // Greater than
>=          // Greater than or equal
<           // Less than
<=          // Less than or equal
```

### Conditional Operators

```xanoscript
==?         // Equal if value exists (null-safe)
!=?         // Not equal if value exists
>=?         // Greater than or equal if exists
<=?         // Less than or equal if exists
```

### Logical Operators

```xanoscript
&&          // AND
||          // OR
!           // NOT
```

### String Operators

```xanoscript
includes    // String contains (case-sensitive)
includes?   // String contains if value exists
```

### Array Operators

```xanoscript
contains        // Array contains value
not overlaps    // Arrays don't overlap
overlaps        // Arrays overlap
```

### Concatenation

```xanoscript
+           // String/number concatenation
~           // String concatenation (alternative)
```

---

## Database Operations

### db.query

Query records from a table:

```xanoscript
db.query [table_name] {
  where = [condition]
  sort = {[table].[field]: "[asc|desc]"}
  return = {
    type: "[single|list]"
    paging: {
      page: [number]
      per_page: [number]
      totals: [true|false]
      metadata: [true|false]
    }
  }
} as $variable
```

**Examples:**

```xanoscript
// Simple query
db.query recipe {
  where = $db.recipe.is_published
  return = {type: "list"}
} as $recipes

// With pagination
db.query recipe {
  where = $db.recipe.cuisine_id == $input.cuisine_id
  sort = {recipe.created_at: "desc"}
  return = {
    type: "list"
    paging: {
      page: $input.page
      per_page: $input.per_page
      totals: true
    }
  }
} as $recipes

// Single record
db.query recipe {
  where = $db.recipe.slug == $input.slug
  return = {type: "single"}
} as $recipe

// Complex where clause
db.query recipe {
  where = $db.recipe.is_published 
    && ($db.recipe.name includes? $input.search 
        || $db.recipe.description includes? $input.search)
    && $db.recipe.cuisine_id ==? $input.cuisine_id
    && $db.recipe.rating >= 3.5
  sort = {recipe.rating: "desc"}
  return = {type: "list"}
} as $recipes
```

### db.query with JOIN

```xanoscript
db.query recipe_ingredient {
  join = {
    ingredient: {
      table: "ingredient"
      where: $db.recipe_ingredient.ingredient_id == $db.ingredient.id
    }
  }
  
  where = $db.recipe_ingredient.recipe_id == $recipe.id
  sort = {recipe_ingredient.order_index: "asc"}
  
  eval = {
    ingredient_name: $db.ingredient.name
    ingredient_category: $db.ingredient.category
    is_vegetarian: $db.ingredient.is_vegetarian
  }
  
  return = {type: "list"}
} as $ingredients
```

### db.get

Get a single record by field:

```xanoscript
db.get [table_name] {
  field_name = "[field]"
  field_value = [value]
} as $variable
```

**Example:**

```xanoscript
db.get recipe {
  field_name = "id"
  field_value = $input.recipe_id
} as $recipe
```

### db.add

Insert a new record:

```xanoscript
db.add [table_name] {
  data = {
    field1: value1
    field2: value2
  }
} as $variable
```

**Example:**

```xanoscript
db.add recipe_review {
  data = {
    recipe_id: $input.recipe_id
    reviewer_name: $input.reviewer_name
    rating: $input.rating
    review_text: $input.review_text
    is_approved: false
    created_at: now
  }
} as $new_review
```

### db.edit

Update an existing record:

```xanoscript
db.edit [table_name] {
  field_name = "[field]"
  field_value = [value]
  data = {
    field1: new_value1
    field2: new_value2
  }
} as $variable
```

**Example:**

```xanoscript
db.edit recipe {
  field_name = "id"
  field_value = $recipe.id
  data = {
    view_count: $recipe.view_count + 1
    viewed_score: $new_score
  }
} as $updated_recipe
```

### db.delete

Delete records:

```xanoscript
db.delete [table_name] {
  field_name = "[field]"
  field_value = [value]
}
```

### db.truncate

Truncate (clear) a table:

```xanoscript
db.truncate [table_name] {
  reset = [true|false]  // Reset auto-increment
}
```

**Example:**

```xanoscript
db.truncate recipe {
  reset = true
}
```

---

## Variables

### Variable Declaration

```xanoscript
var $variable_name {
  value = [expression]
}
```

**Examples:**

```xanoscript
// Simple value
var $total {
  value = 100
}

// From expression
var $count {
  value = $recipes|count
}

// Object
var $response_data {
  value = {
    recipes: $recipes
    total: $total
    page: $input.page
  }
}

// Array
var $recipe_ids {
  value = $matching_recipes|map:$this.id|unique
}

// Timestamp manipulation
var $window_start {
  value = now
    |transform_timestamp:"-7 days":"UTC"
}

// String concatenation
var $message {
  value = "Hello " + $user.name
}
```

### Variable References

```xanoscript
$variable_name              // Variable
$input.field_name           // Input parameter
$db.table_name.field_name   // Database field reference
$this.field_name            // Current item in map/foreach
$$                          // Current item in map (shorthand)
$$.field_name               // Field of current item in map
```

---

## Control Flow

### precondition

Validate conditions and throw errors:

```xanoscript
precondition ([condition]) {
  error_type = "[error_type]"
  error = "[error_message]"
}
```

**Error Types:**
- `"notfound"` - Resource not found (404)
- `"inputerror"` - Invalid input (400)
- `"unauthorized"` - Unauthorized (401)
- `"forbidden"` - Forbidden (403)

**Examples:**

```xanoscript
// Check if record exists
precondition ($recipe != null) {
  error_type = "notfound"
  error = "Recipe not found"
}

// Check multiple conditions
precondition ($recipe != null && $recipe.is_published) {
  error_type = "inputerror"
  error = "Recipe not found or not published"
}
```

### foreach

Iterate over arrays:

```xanoscript
foreach ([array]) {
  each as $item {
    // Logic for each item
  }
}
```

**Examples:**

```xanoscript
// Simple foreach
foreach ($recipes) {
  each as $recipe {
    db.edit recipe {
      field_name = "id"
      field_value = $recipe.id
      data = {view_count: $recipe.view_count + 1}
    }
  }
}

// Nested foreach
foreach ($manual_recipes) {
  each as $recipe_def {
    var $indices {
      value = $recipe_def.ing_indices
    }
    
    foreach ($indices) {
      each as $idx {
        var $ingredient {
          value = $all_ingredients[$idx]
        }
        
        db.add recipe_ingredient {
          data = {
            recipe_id: $new_recipe.id
            ingredient_id: $ingredient.id
          }
        }
      }
    }
  }
}
```

### return (in foreach)

Return a value from foreach iteration:

```xanoscript
foreach ($items) {
  each as $item {
    // Logic
    
    return {
      value = "some value"
    }
  }
}
```

---

## Common Patterns

### Pagination Pattern

```xanoscript
query recipes verb=GET {
  input {
    int page?=1
    int per_page?=20 filters=min:1|max:100
  }
  
  stack {
    db.query recipe {
      where = $db.recipe.is_published
      sort = {recipe.created_at: "desc"}
      return = {
        type: "list"
        paging: {
          page: $input.page
          per_page: $input.per_page
          totals: true
        }
      }
    } as $recipes
  }
  
  response = $recipes
  history = false
}
```

### Search Pattern

```xanoscript
input {
  text search? filters=trim
}

stack {
  db.query recipe {
    where = $db.recipe.name includes? $input.search 
      || $db.recipe.description includes? $input.search
    return = {type: "list"}
  } as $results
}
```

### Filtering Pattern

```xanoscript
input {
  int cuisine_id?
  text difficulty?
  bool is_vegetarian?
  decimal min_rating?
}

stack {
  db.query recipe {
    where = $db.recipe.is_published
      && $db.recipe.cuisine_id ==? $input.cuisine_id
      && $db.recipe.difficulty ==? $input.difficulty
      && $db.recipe.is_vegetarian ==? $input.is_vegetarian
      && $db.recipe.rating >=? $input.min_rating
    return = {type: "list"}
  } as $recipes
}
```

### Join Pattern

```xanoscript
db.query recipe_ingredient {
  join = {
    ingredient: {
      table: "ingredient"
      where: $db.recipe_ingredient.ingredient_id == $db.ingredient.id
    }
  }
  
  where = $db.recipe_ingredient.recipe_id == $recipe.id
  
  eval = {
    ingredient_name: $db.ingredient.name
    quantity: $db.recipe_ingredient.quantity
    unit: $db.recipe_ingredient.unit
  }
  
  return = {type: "list"}
} as $ingredients
```

### Array Filtering Pattern

```xanoscript
// Find recipes containing specific ingredients
db.query recipe_ingredient {
  where = $db.recipe_ingredient.ingredient_id contains $input.ingredient_ids
  return = {type: "list"}
} as $matching_ingredients

var $recipe_ids {
  value = $matching_ingredients|map:$this.recipe_id|unique
}

db.query recipe {
  where = $db.recipe.id contains $recipe_ids
  return = {type: "list"}
} as $recipes
```

### Array Exclusion Pattern

```xanoscript
// Find recipes that don't contain certain allergens
db.query recipe {
  where = $db.recipe.allergy_ids not overlaps $input.allergy_ids
  return = {type: "list"}
} as $safe_recipes
```

### Increment Pattern

```xanoscript
db.edit recipe {
  field_name = "id"
  field_value = $recipe.id
  data = {
    view_count: $recipe.view_count + 1
  }
} as $updated_recipe
```

### Timestamp Calculation Pattern

```xanoscript
var $cutoff_date {
  value = now
    |transform_timestamp:"-7 days":"UTC"
}

db.query recipe_view_history {
  where = $db.recipe_view_history.viewed_at >= $cutoff_date
  return = {type: "list"}
} as $recent_views
```

### Response Building Pattern

```xanoscript
var $response_data {
  value = {
    success: true
    data: $recipes
    pagination: {
      page: $input.page
      per_page: $input.per_page
      total: $recipes.total
    }
  }
}

response = $response_data
```

### Validation Pattern

```xanoscript
db.get recipe {
  field_name = "id"
  field_value = $input.recipe_id
} as $recipe

precondition ($recipe != null && $recipe.is_published) {
  error_type = "notfound"
  error = "Recipe not found or not published"
}
```

### Seeding Pattern

```xanoscript
function seed_data {
  stack {
    // Truncate existing data
    db.truncate table_name {
      reset = true
    }
    
    // Create manual data array
    var $items {
      value = [
        {name: "Item 1", slug: "item-1"},
        {name: "Item 2", slug: "item-2"}
      ]
    }
    
    // Insert each item
    foreach ($items) {
      each as $item {
        db.add table_name {
          data = {
            name: $item.name
            slug: $item.slug
          }
        } as $new_item
      }
    }
  }
  
  response = {result: "Data seeded"}
}
```

---

## Best Practices

### 1. Always Use Null-Safe Operators for Optional Filters

```xanoscript
// Good
where = $db.recipe.cuisine_id ==? $input.cuisine_id

// Bad (will fail if cuisine_id is null)
where = $db.recipe.cuisine_id == $input.cuisine_id
```

### 2. Validate Input Before Processing

```xanoscript
precondition ($input.recipe_id != null) {
  error_type = "inputerror"
  error = "Recipe ID is required"
}
```

### 3. Use Descriptive Variable Names

```xanoscript
// Good
var $trending_recipes { ... }

// Bad
var $tr { ... }
```

### 4. Add Comments for Complex Logic

```xanoscript
// Calculate trending score based on views in last 7 days
var $window_start {
  value = now|transform_timestamp:"-7 days":"UTC"
}
```

### 5. Set history=false for Read Operations

```xanoscript
query recipes verb=GET {
  // ...
  response = $recipes
  history = false  // Don't log read operations
}
```

### 6. Use Proper Index Types

```xanoscript
// Use btree for sortable fields
{type: "btree", field: [{name: "created_at", op: "desc"}]}

// Use gin for JSON/array fields
{type: "gin", field: [{name: "metadata"}]}

// Use unique for unique constraints
{type: "btree|unique", field: [{name: "email", op: "asc"}]}
```

### 7. Apply Filters to Input Parameters

```xanoscript
input {
  text email filters=trim|lower
  int age filters=min:0|max:120
  text search? filters=trim
}
```

### 8. Use Proper Error Types

```xanoscript
// Not found
precondition ($recipe != null) {
  error_type = "notfound"
  error = "Recipe not found"
}

// Invalid input
precondition ($input.rating >= 1 && $input.rating <= 5) {
  error_type = "inputerror"
  error = "Rating must be between 1 and 5"
}
```

---

## Common Mistakes to Avoid

### ❌ Using `$$` Outside of map

```xanoscript
// Wrong
foreach ($items) {
  each as $item {
    var $id { value = $$.id }  // ❌
  }
}

// Correct
foreach ($items) {
  each as $item {
    var $id { value = $item.id }  // ✅
  }
}
```

### ❌ Using `includes` on Arrays

```xanoscript
// Wrong
where = $db.recipe.tags includes $input.tag  // ❌

// Correct
where = $db.recipe.tags contains $input.tag  // ✅
```

### ❌ Forgetting Optional Operators

```xanoscript
// Wrong - fails if search is null
where = $db.recipe.name includes $input.search  // ❌

// Correct
where = $db.recipe.name includes? $input.search  // ✅
```

### ❌ Using Wrong Return Type

```xanoscript
// Wrong - expecting single but might get multiple
db.query recipe {
  where = $db.recipe.is_published
  return = {type: "single"}  // ❌
} as $recipes

// Correct
db.query recipe {
  where = $db.recipe.is_published
  return = {type: "list"}  // ✅
} as $recipes
```

### ❌ Not Handling Null Values

```xanoscript
// Wrong
precondition ($recipe.is_published) {  // ❌ Fails if recipe is null
  error_type = "inputerror"
  error = "Recipe not published"
}

// Correct
precondition ($recipe != null && $recipe.is_published) {  // ✅
  error_type = "inputerror"
  error = "Recipe not found or not published"
}
```

---

## Summary

This knowledge base covers the essential syntax and patterns for Xanoscript development:

- **Tables**: Define database schemas with proper types, filters, and indexes
- **APIs**: Create RESTful endpoints with input validation and response handling
- **Functions**: Reusable logic blocks for seeding and utilities
- **Tasks**: Scheduled background jobs
- **Database Operations**: Query, add, edit, delete, and truncate operations
- **Control Flow**: Conditionals, loops, and error handling
- **Best Practices**: Null-safety, validation, proper indexing, and error handling

Use this reference when developing Xanoscript applications to ensure correct syntax and optimal patterns.
