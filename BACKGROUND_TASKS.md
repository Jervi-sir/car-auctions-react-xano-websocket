# Background Tasks Documentation

## Overview

Background tasks automate recurring operations in your Xano application. These tasks run on a schedule and perform maintenance, calculations, or data processing operations.

---

## Task: Update Trending Scores

**File**: `tasks/1_update_trending_scores.xs`

### Purpose

Calculates and updates the `viewed_score` field for all published recipes based on their view history. This score is used to determine which recipes are currently trending.

### Schedule

- **Frequency**: Every 24 hours (86400 seconds)
- **Start Date**: 2025-12-06 00:00:00 UTC
- **Status**: Active

### How It Works

#### 1. **Time Windows**

The task uses two time windows to calculate the trending score:

- **Recent Window**: Last 7 days
- **Older Window**: 7-30 days ago

#### 2. **Trending Score Formula**

```
trending_score = (recent_views × 3) + (older_views × 1)
```

**Weighting Logic**:
- Recent views (last 7 days) are weighted **3x** more heavily
- Older views (7-30 days) have standard weight
- This ensures that recipes with recent activity rank higher

#### 3. **Processing Steps**

For each published recipe:

1. Query view history from last 7 days
2. Query view history from 7-30 days ago
3. Count views in each window
4. Calculate weighted score
5. Update `recipe.viewed_score` field

### Example Calculation

**Recipe A**:
- Recent views (last 7 days): 50
- Older views (7-30 days): 30
- **Trending Score**: (50 × 3) + (30 × 1) = **180**

**Recipe B**:
- Recent views (last 7 days): 20
- Older views (7-30 days): 100
- **Trending Score**: (20 × 3) + (100 × 1) = **160**

Even though Recipe B has more total views, Recipe A ranks higher because its views are more recent.

---

## Configuration

### Activating/Deactivating

To enable or disable the task:

```xanoscript
task update_trending_scores {
  active = true  // Set to false to disable
  // ...
}
```

### Changing Schedule

To modify the frequency:

```xanoscript
schedule = [{
  starts_on: 2025-12-06 00:00:00+0000,  // Start date/time
  freq: 86400  // Frequency in seconds
}]
```

**Common Frequencies**:
- Every hour: `3600`
- Every 6 hours: `21600`
- Every 12 hours: `43200`
- Every 24 hours: `86400` (current)
- Every week: `604800`

### Adjusting Weighting

To change how recent vs. older views are weighted, modify the formula:

```xanoscript
var $trending_score {
  value = ($recent_count * 3) + ($older_count * 1)
  //       ^^^^^^^^^^^^^^^^     ^^^^^^^^^^^^^^^^
  //       Recent weight (3x)   Older weight (1x)
}
```

**Example Adjustments**:
- More aggressive recency: `($recent_count * 5) + ($older_count * 1)`
- Less aggressive recency: `($recent_count * 2) + ($older_count * 1)`
- Equal weighting: `($recent_count * 1) + ($older_count * 1)`

### Changing Time Windows

To adjust the time windows:

```xanoscript
// Recent window (currently 7 days)
var $window_7_days {
  value = $now|transform_timestamp:"-7 days":"UTC"
}

// Older window (currently 30 days)
var $window_30_days {
  value = $now|transform_timestamp:"-30 days":"UTC"
}
```

**Example Adjustments**:
- Shorter recent window: `"-3 days"`
- Longer recent window: `"-14 days"`
- Extended older window: `"-60 days"`

---

## Monitoring

### Debug Logs

The task logs its progress:

1. **Start**: "Starting trending score update for recipes"
2. **Completion**: "Trending scores updated for recipes"
3. **Count**: Number of recipes updated

### Verification Query

To verify the task is working, check trending scores:

```sql
SELECT id, name, viewed_score, view_count
FROM recipe
WHERE is_published = true
ORDER BY viewed_score DESC
LIMIT 10;
```

### Manual Execution

To manually trigger the task (for testing):

1. Go to Xano dashboard
2. Navigate to Tasks
3. Find `update_trending_scores`
4. Click "Run Now"

---

## Performance Considerations

### Current Implementation

- Processes all published recipes
- Makes 2 queries per recipe (recent + older views)
- Updates each recipe individually

### Optimization Tips

For large datasets (1000+ recipes):

1. **Batch Processing**: Process recipes in batches
2. **Conditional Updates**: Only update if score changed significantly
3. **Incremental Calculation**: Store previous scores and calculate deltas

### Expected Performance

| Recipes | Avg Views/Recipe | Estimated Time |
|---------|------------------|----------------|
| 100 | 50 | < 5 seconds |
| 500 | 100 | < 30 seconds |
| 1000 | 200 | < 60 seconds |
| 5000 | 500 | < 5 minutes |

---

## Integration with APIs

### Trending Recipes Endpoint

The calculated scores are used by:

**`GET /api/recipes/trending`**

```xanoscript
db.query recipe {
  where = $db.recipe.is_published
  sort = {recipe.viewed_score: "desc"}  // Uses the calculated score
  return = {type: "list"}
}
```

### View Tracking

Views are logged by:

**`GET /api/recipes/get_by_slug`**

```xanoscript
db.add recipe_view_history {
  data = {
    recipe_id: $recipe.id
    viewer_ip: $env.ip
    user_agent: $env.user_agent
    referrer: $env.referrer
    viewed_at: now
  }
}
```

---

## Troubleshooting

### Task Not Running

**Check**:
1. `active = true` in task definition
2. Schedule is set correctly
3. Start date is in the past
4. Task is deployed to server

### Scores Not Updating

**Check**:
1. View history table has data
2. Recipes are published (`is_published = true`)
3. Views are within the time windows
4. Debug logs for errors

### Incorrect Scores

**Verify**:
1. Time window calculations
2. Weighting formula
3. View history data quality
4. Timezone settings (should be UTC)

---

## Future Enhancements

### Potential Improvements

1. **Rating Integration**: Factor in recipe ratings
   ```xanoscript
   value = ($recent_count * 3) + ($older_count * 1) + ($recipe.rating * 10)
   ```

2. **Review Count**: Consider number of reviews
   ```xanoscript
   value = ($recent_count * 3) + ($recipe.review_count * 2)
   ```

3. **Decay Factor**: Gradually reduce older scores
   ```xanoscript
   value = ($recent_count * 3) + ($older_count * 0.5)
   ```

4. **Category-Specific**: Calculate separate scores per cuisine
5. **User Engagement**: Weight authenticated user views higher
6. **Completion Rate**: Track if users finish reading recipes

---

## Summary

✅ **Task Created**: `1_update_trending_scores.xs`  
✅ **Schedule**: Every 24 hours  
✅ **Status**: Active  
✅ **Purpose**: Calculate trending scores from view history  
✅ **Formula**: Recent views weighted 3x more than older views  

The trending system is now fully automated and will keep recipe rankings fresh! 🚀
