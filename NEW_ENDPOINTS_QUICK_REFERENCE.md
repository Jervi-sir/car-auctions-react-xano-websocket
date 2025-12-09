# API Quick Reference - New Endpoints

Quick reference guide for the newly added `my-auctions/*` and `user/*` endpoints.

## My Auctions Endpoints

All endpoints require authentication (`Authorization: Bearer {authToken}`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/my-auctions/my-posted` | Get user's posted auctions | ✅ |
| DELETE | `/my-auctions/auction_id` | Delete an auction | ✅ |
| POST | `/my-auctions/create` | Create new auction | ✅ |
| GET | `/my-auctions/auction_id/edit` | Get auction for editing | ✅ |
| PUT | `/my-auctions/auction_id` | Update auction | ✅ |
| GET | `/my-auctions/auction_id/stats` | Get auction statistics | ✅ |

### Quick Examples

#### Get My Posted Auctions
```javascript
GET /my-auctions/my-posted?page=1&per_page=20&status=active
```

#### Delete Auction
```javascript
DELETE /my-auctions/auction_id
Body: { "auction_id": 1 }
```

#### Create Auction
```javascript
POST /my-auctions/create
Body: {
  "title": "Car Title",
  "year": 2020,
  "make": "Ford",
  "model": "Mustang",
  "mileage_km": 50000,
  "fuel": "Gasoline",
  "transmission": "Manual",
  "location": "California",
  "starting_price": 45000,
  "auction_end": 1701320967890,
  "image_url": "https://...",
  "vin": "ABC123"
}
```

#### Update Auction
```javascript
PUT /my-auctions/auction_id
Body: {
  "auction_id": 1,
  "title": "Updated Title",
  "description": "Updated description"
}
```

#### Get Auction Stats
```javascript
GET /my-auctions/auction_id/stats?auction_id=1
```

---

## User Profile Endpoints

All endpoints require authentication (`Authorization: Bearer {authToken}`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/user/profile` | Get user profile | ✅ |
| PUT | `/user/profile` | Update user profile | ✅ |
| PUT | `/user/password` | Change password | ✅ |
| DELETE | `/user/account` | Delete account | ✅ |

### Quick Examples

#### Get User Profile
```javascript
GET /user/profile
```

#### Update Profile
```javascript
PUT /user/profile
Body: {
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "city": "New York",
  "country": "USA"
}
```

#### Change Password
```javascript
PUT /user/password
Body: {
  "current_password": "oldPass123",
  "new_password": "newPass456",
  "confirm_password": "newPass456"
}
```

#### Delete Account
```javascript
DELETE /user/account
Body: {
  "password": "userPassword",
  "confirmation": "DELETE"
}
```

---

## Common Response Codes

| Code | Meaning | Common Causes |
|------|---------|---------------|
| 200 | Success | Request completed successfully |
| 400 | Bad Request | Invalid input, validation failed |
| 401 | Unauthorized | Missing or invalid auth token |
| 403 | Forbidden | User doesn't have permission |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Cannot perform action (e.g., delete auction with bids) |

---

## Important Notes

### My Auctions
- **Delete**: Can only delete auctions with no bids
- **Update**: Cannot change `starting_price` or `currency` if bids exist
- **Update**: Can only extend `auction_end`, not shorten it
- **Update**: Cannot edit auctions that have ended
- **Stats**: Shows anonymized bidder names (e.g., "John D.")

### User Profile
- **Email**: Must be unique across all users
- **Password**: Minimum 8 characters
- **Delete Account**: Requires password and typing "DELETE" exactly
- **Delete Account**: Cannot delete if you have active auctions with bids

---

## Base URLs

- **Car API (My Auctions)**: `https://your-xano-instance.com/api:FnuTavOE`
- **User API (Profile)**: `https://your-xano-instance.com/api:4aZ5gqlM`

---

## Authentication Header Format

```javascript
headers: {
  'Authorization': `Bearer ${authToken}`
}
```

Get the `authToken` from:
- `/auth/signup` response
- `/auth/login` response
- Store in `localStorage.getItem('authToken')`

---

**Last Updated**: December 2025  
**API Version**: 1.0
