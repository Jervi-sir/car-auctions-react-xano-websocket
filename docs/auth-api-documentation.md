# User Authentication API Documentation

This document provides comprehensive documentation for the User Authentication API endpoints.

## Table of Contents
- [Overview](#overview)
- [Authentication Flow](#authentication-flow)
- [API Endpoints](#api-endpoints)
  - [Signup](#1-signup)
  - [Login](#2-login)
  - [Get Current User](#3-get-current-user)
  - [Update Profile](#4-update-profile)
  - [Change Password](#5-change-password)
- [Error Handling](#error-handling)
- [Security Best Practices](#security-best-practices)

## Overview

The User Authentication API provides secure endpoints for user registration, login, profile management, and password changes. All passwords are hashed using bcrypt for security.

## Authentication Flow

1. **Registration**: User signs up with email, password, and profile information
2. **Login**: User authenticates with email and password
3. **Token Management**: Upon successful login, an auth token is returned
4. **Authenticated Requests**: Include `user_id` in subsequent requests to access protected endpoints

## API Endpoints

### 1. Signup

Register a new user account.

**Endpoint**: `POST /auth/signup`

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "SecurePassword123!",
  "phone": "+1234567890",
  "city": "New York",
  "country": "USA"
}
```

**Required Fields**:
- `name` (string): User's full name
- `email` (string): Valid email address (must be unique)
- `password` (string): User's password (will be hashed)

**Optional Fields**:
- `phone` (string): Contact phone number
- `city` (string): User's city
- `country` (string): User's country

**Success Response** (200):
```json
{
  "success": true,
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "phone": "+1234567890",
    "city": "New York",
    "country": "USA",
    "is_verified": false,
    "is_active": true,
    "created_at": "2025-12-07T19:00:00Z"
  },
  "auth_token": {
    "user_id": 1,
    "email": "john.doe@example.com",
    "created_at": "2025-12-07T19:00:00Z"
  }
}
```

**Error Response** (400):
```json
{
  "error": true,
  "message": "Email already registered"
}
```

**Code Examples**:

**JavaScript (Fetch)**:
```javascript
const signup = async (userData) => {
  const response = await fetch('https://api.example.com/auth/signup', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData)
  });
  
  const data = await response.json();
  
  if (data.success) {
    // Store auth token
    localStorage.setItem('authToken', JSON.stringify(data.auth_token));
    localStorage.setItem('user', JSON.stringify(data.user));
  }
  
  return data;
};

// Usage
const newUser = {
  name: "John Doe",
  email: "john.doe@example.com",
  password: "SecurePassword123!",
  phone: "+1234567890",
  city: "New York",
  country: "USA"
};

signup(newUser).then(data => console.log(data));
```

**Python**:
```python
import requests

def signup(user_data):
    response = requests.post(
        'https://api.example.com/auth/signup',
        json=user_data
    )
    
    data = response.json()
    
    if data.get('success'):
        # Store auth token (example using session)
        session['auth_token'] = data['auth_token']
        session['user'] = data['user']
    
    return data

# Usage
new_user = {
    "name": "John Doe",
    "email": "john.doe@example.com",
    "password": "SecurePassword123!",
    "phone": "+1234567890",
    "city": "New York",
    "country": "USA"
}

result = signup(new_user)
print(result)
```

**cURL**:
```bash
curl -X POST https://api.example.com/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john.doe@example.com",
    "password": "SecurePassword123!",
    "phone": "+1234567890",
    "city": "New York",
    "country": "USA"
  }'
```

---

### 2. Login

Authenticate a user and receive an auth token.

**Endpoint**: `POST /auth/login`

**Request Body**:
```json
{
  "email": "john.doe@example.com",
  "password": "SecurePassword123!"
}
```

**Required Fields**:
- `email` (string): User's email address
- `password` (string): User's password

**Success Response** (200):
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "phone": "+1234567890",
    "avatar_url": null,
    "city": "New York",
    "country": "USA",
    "is_verified": false,
    "is_active": true,
    "total_bids": 5,
    "total_wins": 2,
    "total_spent": 15000.00,
    "created_at": "2025-12-07T19:00:00Z"
  },
  "auth_token": {
    "user_id": 1,
    "email": "john.doe@example.com",
    "login_at": "2025-12-07T20:00:00Z"
  }
}
```

**Error Responses**:

**Invalid Credentials** (401):
```json
{
  "error": true,
  "message": "Invalid email or password"
}
```

**Inactive Account** (403):
```json
{
  "error": true,
  "message": "Account is inactive. Please contact support."
}
```

**Code Examples**:

**JavaScript (Fetch)**:
```javascript
const login = async (email, password) => {
  const response = await fetch('https://api.example.com/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ email, password })
  });
  
  const data = await response.json();
  
  if (data.success) {
    // Store auth token
    localStorage.setItem('authToken', JSON.stringify(data.auth_token));
    localStorage.setItem('user', JSON.stringify(data.user));
  }
  
  return data;
};

// Usage
login("john.doe@example.com", "SecurePassword123!")
  .then(data => console.log(data))
  .catch(error => console.error(error));
```

**Python**:
```python
import requests

def login(email, password):
    response = requests.post(
        'https://api.example.com/auth/login',
        json={
            "email": email,
            "password": password
        }
    )
    
    data = response.json()
    
    if data.get('success'):
        # Store auth token
        session['auth_token'] = data['auth_token']
        session['user'] = data['user']
    
    return data

# Usage
result = login("john.doe@example.com", "SecurePassword123!")
print(result)
```

**cURL**:
```bash
curl -X POST https://api.example.com/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "SecurePassword123!"
  }'
```

---

### 3. Get Current User

Retrieve the authenticated user's profile information.

**Endpoint**: `GET /auth/me`

**Query Parameters**:
- `user_id` (integer, required): The authenticated user's ID

**Success Response** (200):
```json
{
  "success": true,
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "phone": "+1234567890",
    "avatar_url": "https://example.com/avatars/user1.jpg",
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
}
```

**Error Responses**:

**User Not Found** (404):
```json
{
  "error": true,
  "message": "User not found"
}
```

**Inactive Account** (403):
```json
{
  "error": true,
  "message": "Account is inactive"
}
```

**Code Examples**:

**JavaScript (Fetch)**:
```javascript
const getCurrentUser = async (userId) => {
  const response = await fetch(
    `https://api.example.com/auth/me?user_id=${userId}`,
    {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      }
    }
  );
  
  return await response.json();
};

// Usage
const authToken = JSON.parse(localStorage.getItem('authToken'));
getCurrentUser(authToken.user_id)
  .then(data => console.log(data.user));
```

**Python**:
```python
import requests

def get_current_user(user_id):
    response = requests.get(
        f'https://api.example.com/auth/me',
        params={'user_id': user_id}
    )
    
    return response.json()

# Usage
auth_token = session.get('auth_token')
result = get_current_user(auth_token['user_id'])
print(result['user'])
```

**cURL**:
```bash
curl -X GET "https://api.example.com/auth/me?user_id=1" \
  -H "Content-Type: application/json"
```

---

### 4. Update Profile

Update the authenticated user's profile information.

**Endpoint**: `PATCH /auth/profile`

**Request Body**:
```json
{
  "user_id": 1,
  "name": "John Smith",
  "phone": "+1987654321",
  "city": "Los Angeles",
  "country": "USA",
  "avatar_url": "https://example.com/avatars/new-avatar.jpg"
}
```

**Required Fields**:
- `user_id` (integer): The authenticated user's ID

**Optional Fields** (at least one should be provided):
- `name` (string): Updated name
- `phone` (string): Updated phone number
- `city` (string): Updated city
- `country` (string): Updated country
- `avatar_url` (image): Updated avatar URL

**Success Response** (200):
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "user": {
    "id": 1,
    "name": "John Smith",
    "email": "john.doe@example.com",
    "phone": "+1987654321",
    "avatar_url": "https://example.com/avatars/new-avatar.jpg",
    "city": "Los Angeles",
    "country": "USA",
    "is_verified": true,
    "is_active": true,
    "total_bids": 5,
    "total_wins": 2,
    "total_spent": 15000.00,
    "created_at": "2025-12-07T19:00:00Z",
    "updated_at": "2025-12-07T21:00:00Z"
  }
}
```

**Error Response** (404):
```json
{
  "error": true,
  "message": "User not found"
}
```

**Code Examples**:

**JavaScript (Fetch)**:
```javascript
const updateProfile = async (userId, updates) => {
  const response = await fetch('https://api.example.com/auth/profile', {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      user_id: userId,
      ...updates
    })
  });
  
  const data = await response.json();
  
  if (data.success) {
    // Update stored user data
    localStorage.setItem('user', JSON.stringify(data.user));
  }
  
  return data;
};

// Usage
const authToken = JSON.parse(localStorage.getItem('authToken'));
const updates = {
  name: "John Smith",
  city: "Los Angeles"
};

updateProfile(authToken.user_id, updates)
  .then(data => console.log(data));
```

**Python**:
```python
import requests

def update_profile(user_id, updates):
    response = requests.patch(
        'https://api.example.com/auth/profile',
        json={
            'user_id': user_id,
            **updates
        }
    )
    
    data = response.json()
    
    if data.get('success'):
        session['user'] = data['user']
    
    return data

# Usage
auth_token = session.get('auth_token')
updates = {
    "name": "John Smith",
    "city": "Los Angeles"
}

result = update_profile(auth_token['user_id'], updates)
print(result)
```

**cURL**:
```bash
curl -X PATCH https://api.example.com/auth/profile \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "name": "John Smith",
    "city": "Los Angeles"
  }'
```

---

### 5. Change Password

Change the authenticated user's password.

**Endpoint**: `POST /auth/change-password`

**Request Body**:
```json
{
  "user_id": 1,
  "current_password": "SecurePassword123!",
  "new_password": "NewSecurePassword456!"
}
```

**Required Fields**:
- `user_id` (integer): The authenticated user's ID
- `current_password` (string): User's current password
- `new_password` (string): New password to set

**Success Response** (200):
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

**Error Responses**:

**User Not Found** (404):
```json
{
  "error": true,
  "message": "User not found"
}
```

**Incorrect Current Password** (401):
```json
{
  "error": true,
  "message": "Current password is incorrect"
}
```

**Code Examples**:

**JavaScript (Fetch)**:
```javascript
const changePassword = async (userId, currentPassword, newPassword) => {
  const response = await fetch('https://api.example.com/auth/change-password', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      user_id: userId,
      current_password: currentPassword,
      new_password: newPassword
    })
  });
  
  return await response.json();
};

// Usage
const authToken = JSON.parse(localStorage.getItem('authToken'));
changePassword(
  authToken.user_id,
  "SecurePassword123!",
  "NewSecurePassword456!"
).then(data => {
  if (data.success) {
    alert('Password changed successfully!');
  }
});
```

**Python**:
```python
import requests

def change_password(user_id, current_password, new_password):
    response = requests.post(
        'https://api.example.com/auth/change-password',
        json={
            'user_id': user_id,
            'current_password': current_password,
            'new_password': new_password
        }
    )
    
    return response.json()

# Usage
auth_token = session.get('auth_token')
result = change_password(
    auth_token['user_id'],
    "SecurePassword123!",
    "NewSecurePassword456!"
)
print(result)
```

**cURL**:
```bash
curl -X POST https://api.example.com/auth/change-password \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "current_password": "SecurePassword123!",
    "new_password": "NewSecurePassword456!"
  }'
```

---

## Error Handling

All endpoints follow a consistent error response format:

```json
{
  "error": true,
  "message": "Description of the error"
}
```

### Common HTTP Status Codes

- **200 OK**: Request successful
- **400 Bad Request**: Invalid input or validation error
- **401 Unauthorized**: Authentication failed
- **403 Forbidden**: Account inactive or access denied
- **404 Not Found**: Resource not found
- **500 Internal Server Error**: Server error

### Error Handling Best Practices

1. **Always check the response status code** before processing data
2. **Display user-friendly error messages** from the API response
3. **Implement retry logic** for network errors
4. **Log errors** for debugging purposes
5. **Handle edge cases** like network timeouts

**Example Error Handling (JavaScript)**:
```javascript
const handleApiCall = async (apiFunction) => {
  try {
    const response = await apiFunction();
    
    if (response.error) {
      // Handle API error
      console.error('API Error:', response.message);
      alert(response.message);
      return null;
    }
    
    return response;
  } catch (error) {
    // Handle network error
    console.error('Network Error:', error);
    alert('Network error. Please try again.');
    return null;
  }
};
```

---

## Security Best Practices

### Password Requirements

Implement strong password requirements on the client side:
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- At least one special character

**Example Password Validation (JavaScript)**:
```javascript
const validatePassword = (password) => {
  const minLength = 8;
  const hasUpperCase = /[A-Z]/.test(password);
  const hasLowerCase = /[a-z]/.test(password);
  const hasNumber = /\d/.test(password);
  const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
  
  return password.length >= minLength &&
         hasUpperCase &&
         hasLowerCase &&
         hasNumber &&
         hasSpecialChar;
};
```

### Token Management

1. **Store tokens securely**:
   - Use `httpOnly` cookies for web applications
   - Use secure storage for mobile apps
   - Never store tokens in localStorage for production (use sessionStorage or cookies)

2. **Implement token expiration**:
   - Set reasonable expiration times
   - Implement refresh token mechanism
   - Clear tokens on logout

3. **Validate tokens on every request**:
   - Check token validity
   - Verify user status (active/inactive)

### HTTPS Only

- **Always use HTTPS** in production
- Never send passwords or tokens over HTTP
- Implement HSTS (HTTP Strict Transport Security)

### Rate Limiting

Implement rate limiting to prevent brute force attacks:
- Limit login attempts per IP address
- Implement account lockout after failed attempts
- Add CAPTCHA after multiple failed attempts

### Input Validation

- Validate all input on both client and server side
- Sanitize user input to prevent injection attacks
- Use parameterized queries for database operations

### Additional Security Measures

1. **Email Verification**: Implement email verification for new accounts
2. **Two-Factor Authentication (2FA)**: Add optional 2FA for enhanced security
3. **Password Reset**: Implement secure password reset flow with time-limited tokens
4. **Session Management**: Implement proper session timeout and logout
5. **Audit Logging**: Log all authentication events for security monitoring

---

## Complete Integration Example

Here's a complete example of integrating the authentication API in a React application:

```javascript
// authService.js
class AuthService {
  constructor(baseURL) {
    this.baseURL = baseURL;
  }

  async signup(userData) {
    const response = await fetch(`${this.baseURL}/auth/signup`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(userData)
    });
    
    const data = await response.json();
    
    if (data.success) {
      this.setAuthData(data);
    }
    
    return data;
  }

  async login(email, password) {
    const response = await fetch(`${this.baseURL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });
    
    const data = await response.json();
    
    if (data.success) {
      this.setAuthData(data);
    }
    
    return data;
  }

  async getCurrentUser() {
    const authToken = this.getAuthToken();
    
    if (!authToken) {
      return null;
    }
    
    const response = await fetch(
      `${this.baseURL}/auth/me?user_id=${authToken.user_id}`,
      {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
      }
    );
    
    return await response.json();
  }

  async updateProfile(updates) {
    const authToken = this.getAuthToken();
    
    const response = await fetch(`${this.baseURL}/auth/profile`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        user_id: authToken.user_id,
        ...updates
      })
    });
    
    const data = await response.json();
    
    if (data.success) {
      this.setUser(data.user);
    }
    
    return data;
  }

  async changePassword(currentPassword, newPassword) {
    const authToken = this.getAuthToken();
    
    const response = await fetch(`${this.baseURL}/auth/change-password`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        user_id: authToken.user_id,
        current_password: currentPassword,
        new_password: newPassword
      })
    });
    
    return await response.json();
  }

  setAuthData(data) {
    sessionStorage.setItem('authToken', JSON.stringify(data.auth_token));
    sessionStorage.setItem('user', JSON.stringify(data.user));
  }

  setUser(user) {
    sessionStorage.setItem('user', JSON.stringify(user));
  }

  getAuthToken() {
    const token = sessionStorage.getItem('authToken');
    return token ? JSON.parse(token) : null;
  }

  getUser() {
    const user = sessionStorage.getItem('user');
    return user ? JSON.parse(user) : null;
  }

  isAuthenticated() {
    return !!this.getAuthToken();
  }

  logout() {
    sessionStorage.removeItem('authToken');
    sessionStorage.removeItem('user');
  }
}

export default new AuthService('https://api.example.com');
```

**Usage in React Component**:
```javascript
import React, { useState } from 'react';
import authService from './authService';

function LoginForm() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    const result = await authService.login(email, password);

    if (result.error) {
      setError(result.message);
    } else {
      // Redirect to dashboard
      window.location.href = '/dashboard';
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {error && <div className="error">{error}</div>}
      
      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        placeholder="Email"
        required
      />
      
      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="Password"
        required
      />
      
      <button type="submit">Login</button>
    </form>
  );
}

export default LoginForm;
```

---

## Changelog

### Version 1.0.0 (2025-12-07)
- Initial release
- Added signup endpoint
- Added login endpoint
- Added get current user endpoint
- Added update profile endpoint
- Added change password endpoint
- Implemented bcrypt password hashing
- Added comprehensive error handling
- Added security best practices documentation
