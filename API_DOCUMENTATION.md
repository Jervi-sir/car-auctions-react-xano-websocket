# Car Auction API Documentation

Complete API documentation for the Car Auction platform with React + Axios integration examples.

## Table of Contents

- [Authentication](#authentication)
- [User API Endpoints](#user-api-endpoints)
- [Car Auction API Endpoints](#car-auction-api-endpoints)
- [My Auctions API Endpoints](#my-auctions-api-endpoints)
- [User Profile API Endpoints](#user-profile-api-endpoints)
- [React + Axios Setup](#react--axios-setup)
- [Error Handling](#error-handling)

---

## Authentication

All authenticated endpoints require a bearer token in the Authorization header.

### Base URLs

- **User API**: `https://your-xano-instance.com/api:4aZ5gqlM`
- **Car API**: `https://your-xano-instance.com/api:FnuTavOE`

---

## User API Endpoints

### 1. Sign Up (Register)

Create a new user account and receive an authentication token.

**Endpoint**: `POST /auth/signup`

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securePassword123",
  "phone": "+1234567890",
  "city": "New York",
  "country": "USA"
}
```

**Response**:
```json
{
  "authToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**React + Axios Example**:
```javascript
import axios from 'axios';

const signup = async (userData) => {
  try {
    const response = await axios.post(
      'https://your-xano-instance.com/api:4aZ5gqlM/auth/signup',
      {
        name: userData.name,
        email: userData.email,
        password: userData.password,
        phone: userData.phone,
        city: userData.city,
        country: userData.country
      }
    );
    
    // Store auth token
    localStorage.setItem('authToken', response.data.authToken);
    
    return response.data;
  } catch (error) {
    console.error('Signup error:', error.response?.data);
    throw error;
  }
};
```

---

### 2. Login

Authenticate an existing user and receive an authentication token.

**Endpoint**: `POST /auth/login`

**Request Body**:
```json
{
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response**:
```json
{
  "authToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**React + Axios Example**:
```javascript
const login = async (email, password) => {
  try {
    const response = await axios.post(
      'https://your-xano-instance.com/api:4aZ5gqlM/auth/login',
      {
        email,
        password
      }
    );
    
    // Store auth token
    localStorage.setItem('authToken', response.data.authToken);
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 403) {
      throw new Error('Invalid credentials');
    }
    throw error;
  }
};
```

---

### 3. Get Current User (Me)

Retrieve the authenticated user's information.

**Endpoint**: `GET /auth/me`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Response**:
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": 1701234567890
}
```

**React + Axios Example**:
```javascript
const getCurrentUser = async () => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.get(
      'https://your-xano-instance.com/api:4aZ5gqlM/auth/me',
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 401) {
      // Token expired or invalid
      localStorage.removeItem('authToken');
      throw new Error('Session expired. Please login again.');
    }
    throw error;
  }
};
```

---

## Car Auction API Endpoints

### 1. List Auctions

Get a paginated list of active car auctions.

**Endpoint**: `GET /auctions/list`

**Query Parameters**:
- `page` (optional, default: 1) - Page number
- `per_page` (optional, default: 20, max: 100) - Items per page

**Example Request**:
```
GET /auctions/list?page=1&per_page=20
```

**Response**:
```json
{
  "auctions": [
    {
      "id": 1,
      "title": "1967 Ford Mustang Fastback",
      "subtitle": "Classic American Muscle",
      "slug": "1967-ford-mustang-fastback",
      "image_url": "https://...",
      "year": 1967,
      "mileage_km": 85000,
      "fuel": "Gasoline",
      "transmission": "Manual",
      "location": "California, USA",
      "starting_price": 45000,
      "current_price": 52000,
      "currency": "USD",
      "auction_start": 1701234567890,
      "auction_end": 1701320967890,
      "is_active": true,
      "is_sold": false,
      "total_bids": 12,
      "total_views": 456,
      "total_watchers": 23
    }
  ],
  "page": 1,
  "per_page": 20,
  "total": 150,
  "total_pages": 8
}
```

**React + Axios Example**:
```javascript
const getAuctions = async (page = 1, perPage = 20) => {
  try {
    const response = await axios.get(
      'https://your-xano-instance.com/api:FnuTavOE/auctions/list',
      {
        params: {
          page,
          per_page: perPage
        }
      }
    );
    
    return response.data;
  } catch (error) {
    console.error('Error fetching auctions:', error);
    throw error;
  }
};
```

---

### 2. Get Auction by Slug

Get detailed information about a specific auction car.

**Endpoint**: `GET /auctions/slug`

**Query Parameters**:
- `slug` (required) - Unique slug identifier for the auction
- `user_id` (optional) - User ID for view tracking

**Example Request**:
```
GET /auctions/slug?slug=1967-ford-mustang-fastback&user_id=1
```

**Response**:
```json
{
  "id": 1,
  "title": "1967 Ford Mustang Fastback",
  "subtitle": "Classic American Muscle",
  "slug": "1967-ford-mustang-fastback",
  "image_url": "https://...",
  "gallery_images": ["https://...", "https://..."],
  "year": 1967,
  "mileage_km": 85000,
  "fuel": "Gasoline",
  "transmission": "Manual",
  "location": "California, USA",
  "starting_price": 45000,
  "current_price": 52000,
  "reserve_price": 55000,
  "currency": "USD",
  "auction_start": 1701234567890,
  "auction_end": 1701320967890,
  "is_active": true,
  "is_sold": false,
  "specs": {
    "engine": "V8 4.7L",
    "power_hp": 271,
    "color": "Highland Green",
    "vin": "7R02C123456",
    "previous_owners": 2
  },
  "description": "Stunning example of the iconic...",
  "condition_report": "Excellent condition with...",
  "features": ["Air Conditioning", "Power Steering", "Disc Brakes"],
  "total_bids": 12,
  "total_views": 457,
  "total_watchers": 23,
  "bids": [
    {
      "id": 45,
      "bidder_id": 5,
      "amount": 52000,
      "currency": "USD",
      "is_winning": true,
      "created_at": 1701318000000
    }
  ],
  "created_at": 1701000000000
}
```

**React + Axios Example**:
```javascript
const getAuctionBySlug = async (slug, userId = null) => {
  try {
    const response = await axios.get(
      'https://your-xano-instance.com/api:FnuTavOE/auctions/slug',
      {
        params: {
          slug,
          ...(userId && { user_id: userId })
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 404) {
      throw new Error('Auction not found');
    }
    throw error;
  }
};
```

---

### 3. Get Auction Bids

Get bid history for a specific auction.

**Endpoint**: `GET /auctions/bids`

**Query Parameters**:
- `car_auction_id` (required) - Auction ID
- `page` (optional, default: 1) - Page number
- `per_page` (optional, default: 50, max: 100) - Items per page
- `valid_only` (optional, default: true) - Show only valid bids

**Example Request**:
```
GET /auctions/bids?car_auction_id=1&page=1&per_page=50&valid_only=true
```

**Response**:
```json
{
  "car_auction_id": 1,
  "auction_title": "1967 Ford Mustang Fastback",
  "bids": [
    {
      "id": 45,
      "bidder_id": 5,
      "bidder_name": "Jane Smith",
      "bidder_avatar": "https://...",
      "amount": 52000,
      "currency": "USD",
      "is_winning": true,
      "is_auto_bid": false,
      "created_at": 1701318000000
    }
  ],
  "total": 12,
  "page": 1,
  "per_page": 50
}
```

**React + Axios Example**:
```javascript
const getAuctionBids = async (auctionId, page = 1, perPage = 50) => {
  try {
    const response = await axios.get(
      'https://your-xano-instance.com/api:FnuTavOE/auctions/bids',
      {
        params: {
          car_auction_id: auctionId,
          page,
          per_page: perPage,
          valid_only: true
        }
      }
    );
    
    return response.data;
  } catch (error) {
    console.error('Error fetching bids:', error);
    throw error;
  }
};
```

---

### 4. Place Bid

Place a bid on an auction car.

**Endpoint**: `POST /bids/place`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Request Body**:
```json
{
  "car_auction_id": 1,
  "bidder_id": 5,
  "amount": 53000,
  "is_auto_bid": false,
  "max_auto_bid_amount": 55000
}
```

**Response**:
```json
{
  "success": true,
  "bid": {
    "id": 46,
    "car_auction": 1,
    "bidder_id": 5,
    "amount": 53000,
    "currency": "USD",
    "is_winning": true,
    "created_at": 1701319000000
  },
  "auction": {
    "id": 1,
    "title": "1967 Ford Mustang Fastback",
    "current_price": 53000,
    "total_bids": 13
  }
}
```

**React + Axios Example**:
```javascript
const placeBid = async (auctionId, bidderId, amount, isAutoBid = false, maxAutoBid = null) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.post(
      'https://your-xano-instance.com/api:FnuTavOE/bids/place',
      {
        car_auction_id: auctionId,
        bidder_id: bidderId,
        amount: amount,
        is_auto_bid: isAutoBid,
        ...(maxAutoBid && { max_auto_bid_amount: maxAutoBid })
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.data?.error) {
      throw new Error(error.response.data.error);
    }
    throw error;
  }
};
```

---

### 5. Toggle Watchlist

Add or remove an auction from the user's watchlist.

**Endpoint**: `POST /watchlist/toggle`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Request Body**:
```json
{
  "user_id": 5,
  "auction_car_id": 1,
  "notify_on_new_bid": true,
  "notify_on_price_drop": true,
  "notify_on_ending_soon": true
}
```

**Response**:
```json
{
  "success": true,
  "action": "added",
  "user_id": 5,
  "auction_car_id": 1,
  "auction_title": "1967 Ford Mustang Fastback"
}
```

**React + Axios Example**:
```javascript
const toggleWatchlist = async (userId, auctionId, notifications = {}) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.post(
      'https://your-xano-instance.com/api:FnuTavOE/watchlist/toggle',
      {
        user_id: userId,
        auction_car_id: auctionId,
        notify_on_new_bid: notifications.newBid ?? true,
        notify_on_price_drop: notifications.priceDrop ?? true,
        notify_on_ending_soon: notifications.endingSoon ?? true
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    console.error('Error toggling watchlist:', error);
    throw error;
  }
};
```

---

### 6. Get Watchlist

Get the user's watchlist of auctions.

**Endpoint**: `GET /watchlist/list`

**Query Parameters**:
- `user_id` (required) - User ID
- `page` (optional, default: 1) - Page number
- `per_page` (optional, default: 20, max: 100) - Items per page
- `active_only` (optional, default: true) - Show only active auctions

**Example Request**:
```
GET /watchlist/list?user_id=5&page=1&per_page=20&active_only=true
```

**Response**:
```json
{
  "user_id": 5,
  "watchlist": [
    {
      "watchlist_id": 12,
      "auction": {
        "id": 1,
        "title": "1967 Ford Mustang Fastback",
        "current_price": 53000,
        "auction_end": 1701320967890
      },
      "notifications": {
        "notify_on_new_bid": true,
        "notify_on_price_drop": true,
        "notify_on_ending_soon": true
      },
      "added_at": 1701200000000
    }
  ],
  "total": 5,
  "page": 1,
  "per_page": 20
}
```

**React + Axios Example**:
```javascript
const getWatchlist = async (userId, page = 1, perPage = 20, activeOnly = true) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.get(
      'https://your-xano-instance.com/api:FnuTavOE/watchlist/list',
      {
        params: {
          user_id: userId,
          page,
          per_page: perPage,
          active_only: activeOnly
        },
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    console.error('Error fetching watchlist:', error);
    throw error;
  }
};
```

---

### 7. Finalize Auction

Finalize an auction when it ends, determine the winner, and update the auction status. This endpoint should be triggered from the frontend when the auction timer reaches zero.

**Endpoint**: `POST /auctions/finalize`

**Request Body**:
```json
{
  "car_auction_id": 1
}
```

**Response (Successful Sale)**:
```json
{
  "success": true,
  "auction_id": 1,
  "auction_title": "1967 Ford Mustang Fastback",
  "status": "sold",
  "auction_end": 1701320967890,
  "total_bids": 12,
  "final_price": 53000,
  "reserve_price": 55000,
  "reserve_met": false,
  "winner": {
    "bidder_id": 5,
    "bidder_name": "Jane Smith",
    "winning_amount": 53000,
    "currency": "USD"
  }
}
```

**Response (No Bids)**:
```json
{
  "success": true,
  "auction_id": 1,
  "auction_title": "1967 Ford Mustang Fastback",
  "status": "no_bids",
  "auction_end": 1701320967890,
  "total_bids": 0,
  "final_price": 45000,
  "reserve_price": 55000,
  "reserve_met": false,
  "winner": null
}
```

**Possible Status Values**:
- `"sold"` - Auction ended with a winning bid (reserve met if applicable)
- `"no_bids"` - Auction ended with no bids placed

**Error Responses**:
- Auction not found (404)
- Auction has not ended yet (400)
- Auction already finalized (400)
- Reserve price not met (400)

**React + Axios Example**:
```javascript
const finalizeAuction = async (auctionId) => {
  try {
    const response = await axios.post(
      'https://your-xano-instance.com/api:FnuTavOE/auctions/finalize',
      {
        car_auction_id: auctionId
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.data?.error) {
      throw new Error(error.response.data.error);
    }
    throw error;
  }
};
```

**React Component Example with Countdown Timer**:
```javascript
import React, { useState, useEffect } from 'react';
import auctionService from '../services/auctionService';

function AuctionCountdown({ auction }) {
  const [timeRemaining, setTimeRemaining] = useState(null);
  const [isFinalized, setIsFinalized] = useState(false);
  const [finalizeResult, setFinalizeResult] = useState(null);

  useEffect(() => {
    const calculateTimeRemaining = () => {
      const now = Date.now();
      const end = auction.auction_end;
      const remaining = end - now;

      if (remaining <= 0) {
        setTimeRemaining(0);
        // Auto-finalize when timer reaches zero
        if (!isFinalized && auction.is_active) {
          handleFinalize();
        }
        return;
      }

      setTimeRemaining(remaining);
    };

    calculateTimeRemaining();
    const interval = setInterval(calculateTimeRemaining, 1000);

    return () => clearInterval(interval);
  }, [auction, isFinalized]);

  const handleFinalize = async () => {
    try {
      const result = await auctionService.finalizeAuction(auction.id);
      setIsFinalized(true);
      setFinalizeResult(result);
      
      // Show winner notification
      if (result.status === 'sold') {
        alert(`Auction won by ${result.winner.bidder_name} for $${result.winner.winning_amount.toLocaleString()}!`);
      } else {
        alert('Auction ended with no bids.');
      }
    } catch (error) {
      console.error('Error finalizing auction:', error);
    }
  };

  const formatTime = (ms) => {
    if (ms <= 0) return 'Auction Ended';
    
    const seconds = Math.floor((ms / 1000) % 60);
    const minutes = Math.floor((ms / (1000 * 60)) % 60);
    const hours = Math.floor((ms / (1000 * 60 * 60)) % 24);
    const days = Math.floor(ms / (1000 * 60 * 60 * 24));

    if (days > 0) {
      return `${days}d ${hours}h ${minutes}m`;
    }
    return `${hours}h ${minutes}m ${seconds}s`;
  };

  return (
    <div className="auction-countdown">
      <h3>{formatTime(timeRemaining)}</h3>
      {isFinalized && finalizeResult && (
        <div className="finalize-result">
          <p>Status: {finalizeResult.status}</p>
          {finalizeResult.winner && (
            <p>Winner: {finalizeResult.winner.bidder_name}</p>
          )}
        </div>
      )}
    </div>
  );
}

export default AuctionCountdown;
```

---

## My Auctions API Endpoints

These endpoints allow users to manage their posted auctions.

### 1. Get My Posted Auctions

Get a paginated list of auctions posted by the authenticated user.

**Endpoint**: `GET /my-auctions/my-posted`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Query Parameters**:
- `page` (optional, default: 1, min: 1) - Page number
- `per_page` (optional, default: 20, min: 1, max: 100) - Items per page
- `status` (optional, default: "all") - Filter by status: "all", "active", or "ended"

**Example Request**:
```
GET /my-auctions/my-posted?page=1&per_page=20&status=active
```

**Response**:
```json
{
  "auctions": [
    {
      "id": 1,
      "title": "1967 Ford Mustang Fastback",
      "subtitle": "Classic American Muscle",
      "slug": "1967-ford-mustang-fastback",
      "image_url": "https://...",
      "year": 1967,
      "mileage_km": 85000,
      "fuel": "Gasoline",
      "transmission": "Manual",
      "location": "California, USA",
      "starting_price": 45000,
      "current_price": 52000,
      "currency": "USD",
      "auction_start": 1701234567890,
      "auction_end": 1701320967890,
      "is_active": true,
      "is_sold": false,
      "total_bids": 12,
      "total_views": 456,
      "total_watchers": 23,
      "created_by": 5,
      "created_at": 1701000000000
    }
  ],
  "total": 15,
  "page": 1,
  "per_page": 20,
  "total_pages": 1
}
```

**React + Axios Example**:
```javascript
const getMyPostedAuctions = async (page = 1, perPage = 20, status = 'all') => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.get(
      'https://your-xano-instance.com/api:FnuTavOE/my-auctions/my-posted',
      {
        params: {
          page,
          per_page: perPage,
          status
        },
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 401) {
      throw new Error('Authentication required');
    }
    throw error;
  }
};
```

---

### 2. Delete Auction

Delete an auction (only if owned by the user and has no bids).

**Endpoint**: `DELETE /my-auctions/auction_id`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Request Body**:
```json
{
  "auction_id": 1
}
```

**Response (Success)**:
```json
{
  "success": true,
  "message": "Auction deleted successfully"
}
```

**Error Responses**:
- `404` - Auction not found
- `403` - User doesn't own this auction
- `409` - Cannot delete auction with existing bids

**React + Axios Example**:
```javascript
const deleteAuction = async (auctionId) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.delete(
      'https://your-xano-instance.com/api:FnuTavOE/my-auctions/auction_id',
      {
        data: {
          auction_id: auctionId
        },
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 409) {
      throw new Error('Cannot delete auction with existing bids');
    }
    if (error.response?.status === 403) {
      throw new Error('You do not have permission to delete this auction');
    }
    throw error;
  }
};
```

---

### 3. Create Auction

Create a new auction listing.

**Endpoint**: `POST /my-auctions/create`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Request Body**:
```json
{
  "title": "1967 Ford Mustang Fastback",
  "subtitle": "Classic American Muscle",
  "year": 1967,
  "make": "Ford",
  "model": "Mustang",
  "mileage_km": 85000,
  "fuel": "Gasoline",
  "transmission": "Manual",
  "location": "California, USA",
  "starting_price": 45000,
  "currency": "USD",
  "auction_end": 1701320967890,
  "description": "Stunning example of the iconic...",
  "image_url": "https://...",
  "engine": "V8 4.7L",
  "power_hp": 271,
  "color": "Highland Green",
  "vin": "7R02C123456",
  "previous_owners": 2,
  "condition_report": "Excellent condition with...",
  "features": ["Air Conditioning", "Power Steering", "Disc Brakes"]
}
```

**Required Fields**:
- `title` (text, trimmed)
- `year` (integer, min: 1900, max: 2100)
- `make` (text, trimmed)
- `model` (text, trimmed)
- `mileage_km` (integer, min: 0)
- `fuel` (text, trimmed)
- `transmission` (text, trimmed)
- `location` (text, trimmed)
- `starting_price` (decimal, min: 0)
- `auction_end` (timestamp, must be in the future)
- `image_url` (text)
- `vin` (text, trimmed)

**Optional Fields**:
- `subtitle`, `currency` (default: "USD"), `description`, `engine`, `power_hp`, `color`, `previous_owners`, `condition_report`, `features`

**Response**:
```json
{
  "success": true,
  "message": "Auction created successfully",
  "auction": {
    "id": 1,
    "slug": "1967-ford-mustang-fastback-1701234567890",
    "title": "1967 Ford Mustang Fastback",
    "subtitle": "Classic American Muscle",
    "image_url": "https://...",
    "year": 1967,
    "make": "Ford",
    "model": "Mustang",
    "mileage_km": 85000,
    "fuel": "Gasoline",
    "transmission": "Manual",
    "location": "California, USA",
    "starting_price": 45000,
    "current_price": 45000,
    "currency": "USD",
    "auction_end": 1701320967890,
    "description": "Stunning example of the iconic...",
    "is_active": true,
    "created_at": 1701234567890,
    "created_by": 5
  }
}
```

**React + Axios Example**:
```javascript
const createAuction = async (auctionData) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.post(
      'https://your-xano-instance.com/api:FnuTavOE/my-auctions/create',
      {
        title: auctionData.title,
        subtitle: auctionData.subtitle,
        year: auctionData.year,
        make: auctionData.make,
        model: auctionData.model,
        mileage_km: auctionData.mileage_km,
        fuel: auctionData.fuel,
        transmission: auctionData.transmission,
        location: auctionData.location,
        starting_price: auctionData.starting_price,
        currency: auctionData.currency || 'USD',
        auction_end: auctionData.auction_end,
        description: auctionData.description,
        image_url: auctionData.image_url,
        engine: auctionData.engine,
        power_hp: auctionData.power_hp,
        color: auctionData.color,
        vin: auctionData.vin,
        previous_owners: auctionData.previous_owners,
        condition_report: auctionData.condition_report,
        features: auctionData.features
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.data?.error) {
      throw new Error(error.response.data.error);
    }
    throw error;
  }
};
```

---

### 4. Get Auction for Editing

Get auction details for editing (owner only).

**Endpoint**: `GET /my-auctions/auction_id/edit`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Query Parameters**:
- `auction_id` (required) - Auction ID

**Example Request**:
```
GET /my-auctions/auction_id/edit?auction_id=1
```

**Response**:
```json
{
  "id": 1,
  "slug": "1967-ford-mustang-fastback-1701234567890",
  "title": "1967 Ford Mustang Fastback",
  "subtitle": "Classic American Muscle",
  "image_url": "https://...",
  "year": 1967,
  "mileage_km": 85000,
  "fuel": "Gasoline",
  "transmission": "Manual",
  "location": "California, USA",
  "starting_price": 45000,
  "current_price": 52000,
  "currency": "USD",
  "auction_end": 1701320967890,
  "description": "Stunning example of the iconic...",
  "engine": "V8 4.7L",
  "power_hp": 271,
  "color": "Highland Green",
  "vin": "7R02C123456",
  "previous_owners": 2,
  "condition_report": "Excellent condition with...",
  "features": ["Air Conditioning", "Power Steering", "Disc Brakes"],
  "is_active": true,
  "created_at": 1701234567890,
  "created_by": 5
}
```

**Error Responses**:
- `404` - Auction not found
- `403` - User doesn't own this auction

**React + Axios Example**:
```javascript
const getAuctionForEdit = async (auctionId) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.get(
      'https://your-xano-instance.com/api:FnuTavOE/my-auctions/auction_id/edit',
      {
        params: {
          auction_id: auctionId
        },
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 403) {
      throw new Error('You do not have permission to edit this auction');
    }
    if (error.response?.status === 404) {
      throw new Error('Auction not found');
    }
    throw error;
  }
};
```

---

### 5. Update Auction

Update an existing auction (owner only, with restrictions if bids exist).

**Endpoint**: `PUT /my-auctions/auction_id`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Request Body**:
```json
{
  "auction_id": 1,
  "title": "Updated Title",
  "subtitle": "Updated Subtitle",
  "year": 1967,
  "make": "Ford",
  "model": "Mustang",
  "mileage_km": 85000,
  "fuel": "Gasoline",
  "transmission": "Manual",
  "location": "California, USA",
  "auction_end": 1701420967890,
  "description": "Updated description...",
  "image_url": "https://...",
  "gallery_images": ["https://...", "https://..."],
  "engine": "V8 4.7L",
  "power_hp": 271,
  "color": "Highland Green",
  "previous_owners": 2,
  "condition_report": "Updated condition report...",
  "features": ["Air Conditioning", "Power Steering"]
}
```

**Required Fields**:
- `auction_id` (integer)

**Optional Fields** (all other fields are optional):
- All fields from create auction are optional
- Only provided fields will be updated

**Restrictions**:
- Cannot edit auctions that have ended
- Cannot change `starting_price` or `currency` if bids exist
- Can only extend `auction_end`, not shorten it

**Response**:
```json
{
  "success": true,
  "message": "Auction updated successfully",
  "auction": {
    "id": 1,
    "title": "Updated Title",
    "subtitle": "Updated Subtitle",
    "updated_at": 1701234567890
  }
}
```

**Error Responses**:
- `404` - Auction not found
- `403` - User doesn't own this auction or auction has ended
- `409` - Cannot change restricted fields when bids exist

**React + Axios Example**:
```javascript
const updateAuction = async (auctionId, updates) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.put(
      'https://your-xano-instance.com/api:FnuTavOE/my-auctions/auction_id',
      {
        auction_id: auctionId,
        ...updates
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 409) {
      throw new Error(error.response.data.error || 'Cannot update auction with existing bids');
    }
    if (error.response?.status === 403) {
      throw new Error('Cannot edit an auction that has ended');
    }
    throw error;
  }
};
```

---

### 6. Get Auction Statistics

Get comprehensive statistics for an auction (owner only).

**Endpoint**: `GET /my-auctions/auction_id/stats`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Query Parameters**:
- `auction_id` (required) - Auction ID

**Example Request**:
```
GET /my-auctions/auction_id/stats?auction_id=1
```

**Response**:
```json
{
  "auction": {
    "id": 1,
    "slug": "1967-ford-mustang-fastback",
    "title": "1967 Ford Mustang Fastback",
    "subtitle": "Classic American Muscle",
    "image_url": "https://...",
    "starting_price": 45000,
    "current_price": 52000,
    "currency": "USD",
    "is_active": true,
    "auction_end": 1701320967890,
    "created_at": 1701234567890
  },
  "metrics": {
    "total_bids": 12,
    "total_views": 456,
    "unique_viewers": 234,
    "watchlist_count": 23,
    "price_increase": 7000,
    "price_increase_percent": 15.56
  },
  "top_bidders": [
    {
      "user_id": 5,
      "name": "Jane D.",
      "bid_amount": 52000,
      "bid_time": 1701318000000,
      "rank": 1
    },
    {
      "user_id": 8,
      "name": "John S.",
      "bid_amount": 51000,
      "bid_time": 1701317000000,
      "rank": 2
    }
  ],
  "views_over_time": [
    {
      "date": "2025-12-01",
      "views": 45
    },
    {
      "date": "2025-12-02",
      "views": 67
    }
  ],
  "bids_over_time": [
    {
      "date": "2025-12-01",
      "bids": 3
    },
    {
      "date": "2025-12-02",
      "bids": 5
    }
  ]
}
```

**Error Responses**:
- `404` - Auction not found
- `403` - User doesn't own this auction

**React + Axios Example**:
```javascript
const getAuctionStats = async (auctionId) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.get(
      'https://your-xano-instance.com/api:FnuTavOE/my-auctions/auction_id/stats',
      {
        params: {
          auction_id: auctionId
        },
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 403) {
      throw new Error('You do not have permission to view statistics for this auction');
    }
    throw error;
  }
};
```

**React Component Example with Charts**:
```javascript
import React, { useState, useEffect } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';

function AuctionStatsPage({ auctionId }) {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const data = await getAuctionStats(auctionId);
        setStats(data);
      } catch (error) {
        console.error('Error fetching stats:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchStats();
  }, [auctionId]);

  if (loading) return <div>Loading...</div>;
  if (!stats) return <div>No data available</div>;

  return (
    <div className="auction-stats">
      <h1>{stats.auction.title}</h1>
      
      <div className="metrics-grid">
        <div className="metric">
          <h3>Total Bids</h3>
          <p>{stats.metrics.total_bids}</p>
        </div>
        <div className="metric">
          <h3>Total Views</h3>
          <p>{stats.metrics.total_views}</p>
        </div>
        <div className="metric">
          <h3>Unique Viewers</h3>
          <p>{stats.metrics.unique_viewers}</p>
        </div>
        <div className="metric">
          <h3>Watchers</h3>
          <p>{stats.metrics.watchlist_count}</p>
        </div>
        <div className="metric">
          <h3>Price Increase</h3>
          <p>${stats.metrics.price_increase.toLocaleString()} ({stats.metrics.price_increase_percent.toFixed(2)}%)</p>
        </div>
      </div>

      <div className="top-bidders">
        <h2>Top Bidders</h2>
        <table>
          <thead>
            <tr>
              <th>Rank</th>
              <th>Bidder</th>
              <th>Amount</th>
              <th>Time</th>
            </tr>
          </thead>
          <tbody>
            {stats.top_bidders.map(bidder => (
              <tr key={bidder.user_id}>
                <td>{bidder.rank}</td>
                <td>{bidder.name}</td>
                <td>${bidder.bid_amount.toLocaleString()}</td>
                <td>{new Date(bidder.bid_time).toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="charts">
        <h2>Views Over Time</h2>
        <LineChart width={600} height={300} data={stats.views_over_time}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="date" />
          <YAxis />
          <Tooltip />
          <Legend />
          <Line type="monotone" dataKey="views" stroke="#8884d8" />
        </LineChart>

        <h2>Bids Over Time</h2>
        <LineChart width={600} height={300} data={stats.bids_over_time}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="date" />
          <YAxis />
          <Tooltip />
          <Legend />
          <Line type="monotone" dataKey="bids" stroke="#82ca9d" />
        </LineChart>
      </div>
    </div>
  );
}

export default AuctionStatsPage;
```

---

## User Profile API Endpoints

These endpoints allow users to manage their profile and account.

### 1. Get User Profile

Get the authenticated user's profile with statistics.

**Endpoint**: `GET /user/profile`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Response**:
```json
{
  "id": 5,
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "location": "New York, USA",
  "avatar_url": "https://...",
  "created_at": 1701000000000,
  "statistics": {
    "auctions_posted": 15,
    "auctions_won": 3,
    "total_bids": 47
  }
}
```

**React + Axios Example**:
```javascript
const getUserProfile = async () => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.get(
      'https://your-xano-instance.com/api:4aZ5gqlM/user/profile',
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 401) {
      throw new Error('Authentication required');
    }
    throw error;
  }
};
```

---

### 2. Update User Profile

Update the authenticated user's profile information.

**Endpoint**: `PUT /user/profile`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "phone": "+1234567890",
  "city": "New York",
  "country": "USA",
  "avatar_url": "https://..."
}
```

**All Fields Are Optional**:
- `name` (text, trimmed, min 2 characters)
- `email` (text, trimmed, lowercase, must be unique)
- `phone` (text, trimmed)
- `city` (text, trimmed)
- `country` (text, trimmed)
- `avatar_url` (text)

**Response**:
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "user": {
    "id": 5,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "phone": "+1234567890",
    "location": "New York, USA",
    "avatar_url": "https://...",
    "updated_at": 1701234567890
  }
}
```

**Error Responses**:
- `400` - Name must be at least 2 characters
- `409` - Email address is already in use

**React + Axios Example**:
```javascript
const updateUserProfile = async (profileData) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.put(
      'https://your-xano-instance.com/api:4aZ5gqlM/user/profile',
      {
        name: profileData.name,
        email: profileData.email,
        phone: profileData.phone,
        city: profileData.city,
        country: profileData.country,
        avatar_url: profileData.avatar_url
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 409) {
      throw new Error('Email address is already in use');
    }
    if (error.response?.data?.error) {
      throw new Error(error.response.data.error);
    }
    throw error;
  }
};
```

---

### 3. Change Password

Change the authenticated user's password.

**Endpoint**: `PUT /user/password`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Request Body**:
```json
{
  "current_password": "oldPassword123",
  "new_password": "newSecurePassword456",
  "confirm_password": "newSecurePassword456"
}
```

**Required Fields**:
- `current_password` (password)
- `new_password` (password, min 8 characters)
- `confirm_password` (password, must match new_password)

**Validations**:
- Current password must be correct
- New password must be at least 8 characters
- New password and confirm password must match
- New password must be different from current password

**Response**:
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

**Error Responses**:
- `401` - Current password is incorrect
- `400` - New password must be at least 8 characters
- `400` - Passwords do not match
- `400` - New password must be different from current password

**React + Axios Example**:
```javascript
const changePassword = async (currentPassword, newPassword, confirmPassword) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.put(
      'https://your-xano-instance.com/api:4aZ5gqlM/user/password',
      {
        current_password: currentPassword,
        new_password: newPassword,
        confirm_password: confirmPassword
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 401) {
      throw new Error('Current password is incorrect');
    }
    if (error.response?.data?.error) {
      throw new Error(error.response.data.error);
    }
    throw error;
  }
};
```

---

### 4. Delete Account

Permanently delete the authenticated user's account.

**Endpoint**: `DELETE /user/account`

**Headers**:
```
Authorization: Bearer {authToken}
```

**Request Body**:
```json
{
  "password": "userPassword123",
  "confirmation": "DELETE"
}
```

**Required Fields**:
- `password` (password) - User's current password for verification
- `confirmation` (text) - Must be exactly "DELETE"

**Validations**:
- Password must be correct
- Confirmation must be exactly "DELETE"
- Cannot delete account with active auctions that have bids

**What Gets Deleted**:
- User's bids
- User's watchlist entries
- User's view history
- User's auctions (if no bids exist)
- User's auctions are deactivated (if bids exist)

**Response**:
```json
{
  "success": true,
  "message": "Account deleted successfully"
}
```

**Error Responses**:
- `401` - Incorrect password
- `400` - Confirmation must be exactly 'DELETE'
- `409` - Cannot delete account with active auctions that have bids

**React + Axios Example**:
```javascript
const deleteAccount = async (password, confirmation) => {
  try {
    const token = localStorage.getItem('authToken');
    
    const response = await axios.delete(
      'https://your-xano-instance.com/api:4aZ5gqlM/user/account',
      {
        data: {
          password: password,
          confirmation: confirmation
        },
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    // Clear local storage and redirect
    localStorage.removeItem('authToken');
    
    return response.data;
  } catch (error) {
    if (error.response?.status === 409) {
      throw new Error('Cannot delete account with active auctions that have bids');
    }
    if (error.response?.status === 401) {
      throw new Error('Incorrect password');
    }
    if (error.response?.data?.error) {
      throw new Error(error.response.data.error);
    }
    throw error;
  }
};
```

**React Component Example with Confirmation Dialog**:
```javascript
import React, { useState } from 'react';

function DeleteAccountForm() {
  const [password, setPassword] = useState('');
  const [confirmation, setConfirmation] = useState('');
  const [showConfirmDialog, setShowConfirmDialog] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (confirmation !== 'DELETE') {
      setError('Please type DELETE to confirm');
      return;
    }

    setShowConfirmDialog(true);
  };

  const confirmDelete = async () => {
    try {
      await deleteAccount(password, confirmation);
      // Redirect to home page
      window.location.href = '/';
    } catch (error) {
      setError(error.message);
      setShowConfirmDialog(false);
    }
  };

  return (
    <div className="delete-account-form">
      <h2>Delete Account</h2>
      <p className="warning">
        This action is permanent and cannot be undone. All your data will be deleted.
      </p>

      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label>Password</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label>Type "DELETE" to confirm</label>
          <input
            type="text"
            value={confirmation}
            onChange={(e) => setConfirmation(e.target.value)}
            placeholder="DELETE"
            required
          />
        </div>

        {error && <div className="error">{error}</div>}

        <button type="submit" className="btn-danger">
          Delete Account
        </button>
      </form>

      {showConfirmDialog && (
        <div className="modal">
          <div className="modal-content">
            <h3>Are you absolutely sure?</h3>
            <p>This will permanently delete your account and all associated data.</p>
            <div className="modal-actions">
              <button onClick={() => setShowConfirmDialog(false)}>Cancel</button>
              <button onClick={confirmDelete} className="btn-danger">
                Yes, Delete My Account
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default DeleteAccountForm;
```

---

## React + Axios Setup

### 1. Install Dependencies

```bash
npm install axios
```

### 2. Create API Configuration

Create a file `src/config/api.js`:

```javascript
import axios from 'axios';

// Base URLs
export const USER_API_BASE = 'https://your-xano-instance.com/api:4aZ5gqlM';
export const CAR_API_BASE = 'https://your-xano-instance.com/api:FnuTavOE';

// Create axios instances
export const userAPI = axios.create({
  baseURL: USER_API_BASE,
  headers: {
    'Content-Type': 'application/json'
  }
});

export const carAPI = axios.create({
  baseURL: CAR_API_BASE,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Add request interceptor to include auth token
const addAuthInterceptor = (apiInstance) => {
  apiInstance.interceptors.request.use(
    (config) => {
      const token = localStorage.getItem('authToken');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => {
      return Promise.reject(error);
    }
  );
};

// Add response interceptor for error handling
const addResponseInterceptor = (apiInstance) => {
  apiInstance.interceptors.response.use(
    (response) => response,
    (error) => {
      if (error.response?.status === 401) {
        // Token expired or invalid
        localStorage.removeItem('authToken');
        window.location.href = '/login';
      }
      return Promise.reject(error);
    }
  );
};

// Apply interceptors
addAuthInterceptor(userAPI);
addAuthInterceptor(carAPI);
addResponseInterceptor(userAPI);
addResponseInterceptor(carAPI);
```

### 3. Create Auth Service

Create a file `src/services/authService.js`:

```javascript
import { userAPI } from '../config/api';

class AuthService {
  // Sign up
  async signup(userData) {
    try {
      const response = await userAPI.post('/auth/signup', userData);
      this.setAuthToken(response.data.authToken);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Login
  async login(email, password) {
    try {
      const response = await userAPI.post('/auth/login', { email, password });
      this.setAuthToken(response.data.authToken);
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Get current user
  async getCurrentUser() {
    try {
      const response = await userAPI.get('/auth/me');
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Logout
  logout() {
    this.removeAuthToken();
    window.location.href = '/login';
  }

  // Token management
  setAuthToken(token) {
    localStorage.setItem('authToken', token);
  }

  getAuthToken() {
    return localStorage.getItem('authToken');
  }

  removeAuthToken() {
    localStorage.removeItem('authToken');
  }

  isAuthenticated() {
    return !!this.getAuthToken();
  }

  // Error handling
  handleError(error) {
    if (error.response?.data?.error) {
      return new Error(error.response.data.error);
    }
    return error;
  }
}

export default new AuthService();
```

### 4. Create Auction Service

Create a file `src/services/auctionService.js`:

```javascript
import { carAPI } from '../config/api';

class AuctionService {
  // Get auctions list
  async getAuctions(page = 1, perPage = 20) {
    try {
      const response = await carAPI.get('/auctions/list', {
        params: { page, per_page: perPage }
      });
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Get auction by slug
  async getAuctionBySlug(slug, userId = null) {
    try {
      const response = await carAPI.get('/auctions/slug', {
        params: { slug, ...(userId && { user_id: userId }) }
      });
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Get auction bids
  async getAuctionBids(auctionId, page = 1, perPage = 50) {
    try {
      const response = await carAPI.get('/auctions/bids', {
        params: {
          car_auction_id: auctionId,
          page,
          per_page: perPage,
          valid_only: true
        }
      });
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Place bid
  async placeBid(auctionId, bidderId, amount, isAutoBid = false, maxAutoBid = null) {
    try {
      const response = await carAPI.post('/bids/place', {
        car_auction_id: auctionId,
        bidder_id: bidderId,
        amount,
        is_auto_bid: isAutoBid,
        ...(maxAutoBid && { max_auto_bid_amount: maxAutoBid })
      });
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Toggle watchlist
  async toggleWatchlist(userId, auctionId, notifications = {}) {
    try {
      const response = await carAPI.post('/watchlist/toggle', {
        user_id: userId,
        auction_car_id: auctionId,
        notify_on_new_bid: notifications.newBid ?? true,
        notify_on_price_drop: notifications.priceDrop ?? true,
        notify_on_ending_soon: notifications.endingSoon ?? true
      });
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Get watchlist
  async getWatchlist(userId, page = 1, perPage = 20, activeOnly = true) {
    try {
      const response = await carAPI.get('/watchlist/list', {
        params: {
          user_id: userId,
          page,
          per_page: perPage,
          active_only: activeOnly
        }
      });
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Finalize auction
  async finalizeAuction(auctionId) {
    try {
      const response = await carAPI.post('/auctions/finalize', {
        car_auction_id: auctionId
      });
      return response.data;
    } catch (error) {
      throw this.handleError(error);
    }
  }

  // Error handling
  handleError(error) {
    if (error.response?.data?.error) {
      return new Error(error.response.data.error);
    }
    return error;
  }
}

export default new AuctionService();
```

### 5. Usage in React Components

#### Login Component Example

```javascript
import React, { useState } from 'react';
import authService from '../services/authService';

function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await authService.login(email, password);
      // Redirect to dashboard
      window.location.href = '/dashboard';
    } catch (err) {
      setError(err.message || 'Login failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleLogin}>
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
      {error && <p className="error">{error}</p>}
      <button type="submit" disabled={loading}>
        {loading ? 'Logging in...' : 'Login'}
      </button>
    </form>
  );
}

export default Login;
```

#### Auction List Component Example

```javascript
import React, { useState, useEffect } from 'react';
import auctionService from '../services/auctionService';

function AuctionList() {
  const [auctions, setAuctions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  useEffect(() => {
    fetchAuctions();
  }, [page]);

  const fetchAuctions = async () => {
    setLoading(true);
    setError('');

    try {
      const data = await auctionService.getAuctions(page, 20);
      setAuctions(data.auctions);
      setTotalPages(data.total_pages);
    } catch (err) {
      setError(err.message || 'Failed to load auctions');
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <h1>Car Auctions</h1>
      <div className="auction-grid">
        {auctions.map((auction) => (
          <div key={auction.id} className="auction-card">
            <img src={auction.image_url} alt={auction.title} />
            <h3>{auction.title}</h3>
            <p>{auction.subtitle}</p>
            <p>Current Price: ${auction.current_price.toLocaleString()}</p>
            <p>Bids: {auction.total_bids}</p>
          </div>
        ))}
      </div>
      <div className="pagination">
        <button 
          onClick={() => setPage(p => Math.max(1, p - 1))}
          disabled={page === 1}
        >
          Previous
        </button>
        <span>Page {page} of {totalPages}</span>
        <button 
          onClick={() => setPage(p => Math.min(totalPages, p + 1))}
          disabled={page === totalPages}
        >
          Next
        </button>
      </div>
    </div>
  );
}

export default AuctionList;
```

#### Place Bid Component Example

```javascript
import React, { useState } from 'react';
import auctionService from '../services/auctionService';

function BidForm({ auctionId, currentPrice, userId }) {
  const [amount, setAmount] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess(false);
    setLoading(true);

    try {
      const bidAmount = parseFloat(amount);
      
      if (bidAmount <= currentPrice) {
        throw new Error('Bid must be higher than current price');
      }

      await auctionService.placeBid(auctionId, userId, bidAmount);
      setSuccess(true);
      setAmount('');
    } catch (err) {
      setError(err.message || 'Failed to place bid');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h3>Place Your Bid</h3>
      <p>Current Price: ${currentPrice.toLocaleString()}</p>
      <input
        type="number"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        placeholder="Enter bid amount"
        min={currentPrice + 1}
        step="100"
        required
      />
      {error && <p className="error">{error}</p>}
      {success && <p className="success">Bid placed successfully!</p>}
      <button type="submit" disabled={loading}>
        {loading ? 'Placing Bid...' : 'Place Bid'}
      </button>
    </form>
  );
}

export default BidForm;
```

---

## Error Handling

### Common Error Responses

#### 400 - Input Error
```json
{
  "error_type": "inputerror",
  "error": "Bid amount must be higher than current price"
}
```

#### 401 - Unauthorized
```json
{
  "error_type": "unauthorized",
  "error": "Authentication required"
}
```

#### 403 - Access Denied
```json
{
  "error_type": "accessdenied",
  "error": "Invalid credentials"
}
```

#### 404 - Not Found
```json
{
  "error_type": "notfound",
  "error": "Auction car not found"
}
```

### Global Error Handler

```javascript
// src/utils/errorHandler.js
export const handleAPIError = (error) => {
  if (error.response) {
    // Server responded with error
    const { status, data } = error.response;
    
    switch (status) {
      case 400:
        return data.error || 'Invalid request';
      case 401:
        localStorage.removeItem('authToken');
        window.location.href = '/login';
        return 'Session expired. Please login again.';
      case 403:
        return data.error || 'Access denied';
      case 404:
        return data.error || 'Resource not found';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return data.error || 'An error occurred';
    }
  } else if (error.request) {
    // Request made but no response
    return 'Network error. Please check your connection.';
  } else {
    // Something else happened
    return error.message || 'An unexpected error occurred';
  }
};
```

---

## Best Practices

### 1. Token Storage

**Recommended**: Use `localStorage` for web apps (as shown in examples)

```javascript
// Store token
localStorage.setItem('authToken', token);

// Retrieve token
const token = localStorage.getItem('authToken');

// Remove token
localStorage.removeItem('authToken');
```

**Alternative**: Use `sessionStorage` for more security (token expires when browser closes)

```javascript
sessionStorage.setItem('authToken', token);
```

### 2. Token Expiration

Tokens expire after 24 hours (86400 seconds). Implement token refresh or re-authentication:

```javascript
const checkTokenExpiration = () => {
  const token = localStorage.getItem('authToken');
  if (!token) return false;
  
  // Decode JWT to check expiration (requires jwt-decode library)
  try {
    const decoded = jwtDecode(token);
    const currentTime = Date.now() / 1000;
    
    if (decoded.exp < currentTime) {
      localStorage.removeItem('authToken');
      return false;
    }
    return true;
  } catch (error) {
    return false;
  }
};
```

### 3. Protected Routes

```javascript
import React from 'react';
import { Navigate } from 'react-router-dom';
import authService from '../services/authService';

function ProtectedRoute({ children }) {
  if (!authService.isAuthenticated()) {
    return <Navigate to="/login" replace />;
  }
  
  return children;
}

export default ProtectedRoute;
```

### 4. Request Cancellation

For components that unmount before requests complete:

```javascript
useEffect(() => {
  const controller = new AbortController();
  
  const fetchData = async () => {
    try {
      const response = await axios.get('/api/data', {
        signal: controller.signal
      });
      setData(response.data);
    } catch (error) {
      if (axios.isCancel(error)) {
        console.log('Request cancelled');
      }
    }
  };
  
  fetchData();
  
  return () => controller.abort();
}, []);
```

---

## Rate Limiting

Currently, there are no explicit rate limits documented. However, implement client-side throttling for frequent operations:

```javascript
import { debounce } from 'lodash';

// Debounce search requests
const debouncedSearch = debounce(async (query) => {
  const results = await searchAuctions(query);
  setSearchResults(results);
}, 300);
```

---

## Support

For API issues or questions:
- Check error messages in responses
- Verify authentication tokens are valid
- Ensure request parameters match documentation
- Check network connectivity

---

**Last Updated**: December 2025  
**API Version**: 1.0
