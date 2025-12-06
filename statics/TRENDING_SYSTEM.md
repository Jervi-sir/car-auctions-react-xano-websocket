# Trending Recipe System Documentation

## Overview

The trending recipe system tracks recipe views and calculates trending scores to identify popular recipes. This system consists of three main components:

1. **`recipe.viewed_score`** - Column storing the calculated trending score
2. **`recipe_view_history`** - Table tracking individual recipe views
3. **Background Tasks** - Scheduled jobs to calculate trending scores

---

## Database Schema

### recipe.viewed_score Column

Located in `tables/4_recipe.xs`:

```xanoscript
decimal viewed_score?=0.0
// Trending score based on recent views
```

**Features**:
- Type: `decimal` (allows fractional scores)
- Default: `0.0`
- Indexed with `btree` for fast sorting (descending)
- Used to sort recipes by trending status

### recipe_view_history Table

Located in `tables/7_recipe_view_history.xs`:

**Purpose**: Track individual recipe view events for analytics and trending calculations

**Fields**:
- `id` - Primary key
- `recipe_id` - Foreign key to recipe
- `viewer_ip` - IP address (optional, for analytics)
- `user_agent` - Browser user agent (optional)
- `referrer` - Traffic source (optional)
- `viewed_at` - Timestamp of view (default: now)

**Indexes**:
- Composite index on `recipe_id` + `viewed_at` for efficient trending queries
- Index on `viewed_at` for time-based filtering

---

## Background Tasks

### 1. Basic Trending Score Task

**File**: `tasks/update_trending_scores.xs`

**Algorithm**: Simple view count in last 7 days

```
Trending Score = Number of views in last 7 days
```

**Schedule**: Runs daily at midnight UTC

**Use Case**: Simple, straightforward trending based on recent popularity

---

### 2. Advanced Trending Score Task

**File**: `tasks/update_trending_scores_advanced.xs`

**Algorithm**: Weighted time windows + rating multiplier

```
Weighted Views = (7-day views × 1) + (3-day views × 2) + (1-day views × 3)
Rating Multiplier = 1.0 + (recipe.rating × 0.1)
Trending Score = Weighted Views × Rating Multiplier
```

**Time Windows**:
- Last 7 days: Weight = 1x
- Last 3 days: Weight = 2x
- Last 1 day: Weight = 3x

**Rating Boost**:
- 0-star recipe: 1.0x multiplier
- 5-star recipe: 1.5x multiplier

**Schedule**: Runs every 6 hours for more frequent updates

**Use Case**: More sophisticated trending that favors recent views and highly-rated recipes

---

## How It Works

### Step 1: Track Views

When a user views a recipe, log the view in `recipe_view_history`:

```xanoscript
// In your get_recipe_by_slug API endpoint
db.add recipe_view_history {
  data = {
    recipe_id: $recipe.id
    viewer_ip: $request.ip
    user_agent: $request.user_agent
    referrer: $request.referrer
    viewed_at: now
  }
}
```

### Step 2: Calculate Trending Scores

The background task runs on schedule:

1. **Get all published recipes**
2. **For each recipe**:
   - Query `recipe_view_history` for recent views
   - Calculate trending score using chosen algorithm
   - Update `recipe.viewed_score`
3. **Log completion**

### Step 3: Query Trending Recipes

Use the `viewed_score` to get trending recipes:

```xanoscript
db.query recipe {
  where = $db.recipe.is_published
  sort = {recipe.viewed_score: "desc"}
  return = {
    type: "list"
    paging: {
      page: 1
      per_page: 10
    }
  }
} as $trending_recipes
```

---

## Trending Score Formulas

### Basic Formula

```
Score = Views(last 7 days)
```

**Pros**:
- Simple and easy to understand
- Fast to calculate
- Predictable results

**Cons**:
- Doesn't favor recent activity
- Doesn't consider recipe quality

---

### Advanced Formula

```
Weighted_Views = V7×1 + V3×2 + V1×3
Rating_Multiplier = 1.0 + (R × 0.1)
Score = Weighted_Views × Rating_Multiplier

Where:
- V7 = Views in last 7 days
- V3 = Views in last 3 days
- V1 = Views in last 1 day
- R = Recipe rating (0-5)
```

**Pros**:
- Favors recent activity (recency bias)
- Boosts high-quality recipes
- More dynamic and responsive

**Cons**:
- More complex to calculate
- Requires more database queries
- May need tuning

---

## Configuration

### Choosing a Task

You can use either task or both:

1. **Use Basic Task** if:
   - You want simple, predictable trending
   - Performance is a concern
   - You have many recipes (10,000+)

2. **Use Advanced Task** if:
   - You want sophisticated trending
   - You want to favor recent activity
   - You want to boost high-rated recipes
   - You have moderate recipe count (<10,000)

### Activating a Task

Set `active = true` in the task file:

```xanoscript
task update_trending_scores {
  active = true  // Change from false to true
  // ...
}
```

### Adjusting Schedule

Modify the `schedule` parameter:

```xanoscript
// Daily at midnight
schedule = [{starts_on: 2025-12-06 00:00:00+0000, freq: 86400}]

// Every 6 hours
schedule = [{starts_on: 2025-12-06 00:00:00+0000, freq: 21600}]

// Every hour
schedule = [{starts_on: 2025-12-06 00:00:00+0000, freq: 3600}]
```

---

## Customizing the Algorithm

### Adjusting Time Windows

Change the time windows in the advanced task:

```xanoscript
// Current: 7, 3, 1 days
var $window_7_days {
  value = now|transform_timestamp:"-7 days":"UTC"
}

// Example: 14, 7, 3 days
var $window_14_days {
  value = now|transform_timestamp:"-14 days":"UTC"
}
```

### Adjusting Weights

Modify the weight multipliers:

```xanoscript
// Current weights: 1x, 2x, 3x
var $weighted_views {
  value = $count_7_days + ($count_3_days * 2) + ($count_1_day * 3)
}

// Example: More aggressive recency bias (1x, 3x, 5x)
var $weighted_views {
  value = $count_7_days + ($count_3_days * 3) + ($count_1_day * 5)
}
```

### Adjusting Rating Multiplier

Change how ratings affect the score:

```xanoscript
// Current: 1.0 to 1.5 (10% per star)
var $rating_multiplier {
  value = 1.0 + ($recipe.rating * 0.1)
}

// Example: More aggressive boost (1.0 to 2.0, 20% per star)
var $rating_multiplier {
  value = 1.0 + ($recipe.rating * 0.2)
}
```

---

## API Endpoints

### Get Trending Recipes

```xanoscript
query trending_recipes verb=GET {
  input {
    int page?=1
    int per_page?=20 filters=min:1|max:100
  }
  
  stack {
    db.query recipe {
      where = $db.recipe.is_published
      sort = {recipe.viewed_score: "desc"}
      return = {
        type: "list"
        paging: {
          page: $input.page
          per_page: $input.per_page
          totals: true
        }
      }
    } as $trending_recipes
  }
  
  response = $trending_recipes
  history = false
}
```

### Log Recipe View

```xanoscript
// Add to your get_recipe_by_slug endpoint
db.add recipe_view_history {
  data = {
    recipe_id: $recipe.id
    viewer_ip: $request.ip
    user_agent: $request.user_agent
    referrer: $request.referrer
    viewed_at: now
  }
}

// Also increment view_count
db.edit recipe {
  field_name = "id"
  field_value = $recipe.id
  data = {
    view_count: $recipe.view_count + 1
  }
}
```

---

## Performance Considerations

### Indexing

The system uses these indexes for performance:

1. **recipe.viewed_score** - B-tree index (descending) for fast sorting
2. **recipe_view_history.recipe_id** - For filtering by recipe
3. **recipe_view_history.viewed_at** - For time-based filtering
4. **Composite index** on (recipe_id, viewed_at) - For trending queries

### Data Retention

Consider archiving old view history to keep table size manageable:

```xanoscript
// Delete views older than 30 days
db.query recipe_view_history {
  where = $db.recipe_view_history.viewed_at < $cutoff_date
  return = {type: "list"}
} as $old_views

foreach ($old_views) {
  each as $view {
    db.delete recipe_view_history {
      field_name = "id"
      field_value = $view.id
    }
  }
}
```

### Caching

Consider caching trending recipe results:

- Cache duration: 1-6 hours
- Invalidate on task completion
- Reduces database load for popular endpoints

---

## Monitoring

### Check Task Status

Monitor task execution in Xano dashboard:
- View task run history
- Check for errors
- Monitor execution time

### Verify Scores

Query recipes to verify scores are being updated:

```xanoscript
db.query recipe {
  where = $db.recipe.is_published
  sort = {recipe.viewed_score: "desc"}
  return = {
    type: "list"
    paging: {page: 1, per_page: 10}
  }
} as $top_trending
```

---

## Summary

✅ **`viewed_score` column** - Already exists in recipe table
✅ **`recipe_view_history` table** - Tracks individual views
✅ **Basic task** - Simple 7-day view count
✅ **Advanced task** - Weighted time windows + rating boost
✅ **Indexed** - Fast sorting and querying
✅ **Configurable** - Easy to adjust algorithm and schedule

**Next Steps**:
1. Choose which task to use (basic or advanced)
2. Set `active = true` in the chosen task
3. Add view tracking to your recipe detail endpoint
4. Create API endpoint to fetch trending recipes
5. Monitor and tune the algorithm as needed
