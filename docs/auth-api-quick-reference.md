# Authentication API Quick Reference

## Endpoints Summary

| Endpoint | Method | Description | Auth Required |
|----------|--------|-------------|---------------|
| `/auth/signup` | POST | Register new user | No |
| `/auth/login` | POST | Authenticate user | No |
| `/auth/me` | GET | Get current user profile | Yes |
| `/auth/profile` | PATCH | Update user profile | Yes |
| `/auth/change-password` | POST | Change user password | Yes |

## Quick Examples

### Signup
```bash
curl -X POST /auth/signup \
  -d '{"name":"John","email":"john@example.com","password":"pass123"}'
```

### Login
```bash
curl -X POST /auth/login \
  -d '{"email":"john@example.com","password":"pass123"}'
```

### Get Profile
```bash
curl -X GET "/auth/me?user_id=1"
```

### Update Profile
```bash
curl -X PATCH /auth/profile \
  -d '{"user_id":1,"name":"John Doe","city":"NYC"}'
```

### Change Password
```bash
curl -X POST /auth/change-password \
  -d '{"user_id":1,"current_password":"old","new_password":"new"}'
```

## Response Codes

- `200` - Success
- `400` - Bad Request (validation error)
- `401` - Unauthorized (invalid credentials)
- `403` - Forbidden (account inactive)
- `404` - Not Found (user doesn't exist)

## User Object Structure

```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "avatar_url": "https://...",
  "city": "New York",
  "country": "USA",
  "is_verified": true,
  "is_active": true,
  "total_bids": 5,
  "total_wins": 2,
  "total_spent": 15000.00,
  "created_at": "2025-12-07T19:00:00Z",
  "updated_at": "2025-12-07T20:00:00Z"
}
```

## Auth Token Structure

```json
{
  "user_id": 1,
  "email": "john@example.com",
  "login_at": "2025-12-07T20:00:00Z"
}
```

## Common Errors

### Email Already Registered
```json
{
  "error": true,
  "message": "Email already registered"
}
```

### Invalid Credentials
```json
{
  "error": true,
  "message": "Invalid email or password"
}
```

### Account Inactive
```json
{
  "error": true,
  "message": "Account is inactive. Please contact support."
}
```

### User Not Found
```json
{
  "error": true,
  "message": "User not found"
}
```

## Security Notes

- All passwords are hashed with bcrypt
- Email addresses are converted to lowercase
- Input is trimmed and validated
- Inactive accounts cannot login
- Password verification is secure
