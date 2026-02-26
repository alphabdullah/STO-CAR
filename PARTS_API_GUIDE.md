# STO Car Marketplace - Parts Module API Guide

This guide provides information on how to integrate the Parts Marketplace module.

## Base URL
The backend is currently running on: `http://localhost:8000/api/v1`

---

## 1. Get All Parts
Fetch a list of available parts with optional filters.

- **Endpoint:** `GET /parts`
- **Authentication:** Not Required
- **Query Parameters:**
  - `page` (int): Page number for pagination
  - `category` (string): Filter by category
  - `condition` (string): `new`, `used`, or `refurbished`
  - `search` (string): Search in name, description, brand, or OEM number
  - `min_price` / `max_price` (float): Price filter

**Response Example:**
```json
{
  "success": true,
  "data": {
    "data": [
      {
        "id": "...",
        "name": "Brake Pad Set",
        "current_price": 250.0,
        "quantity": 10,
        "featured_image": "http://localhost:8000/storage/parts/pad.jpg",
        "company": {
          "id": 1,
          "name": "AutoParts Pro"
        }
      }
    ],
    "meta": { ... }
  }
}
```

---

## 2. Get Part Categories
Get a unique list of all part categories.

- **Endpoint:** `GET /parts/categories`
- **Authentication:** Not Required

---

## 3. Purchase a Part
Buy a specific part using wallet balance.

- **Endpoint:** `POST /parts/{id}/purchase`
- **Authentication:** Required (Sanctum Token)
- **Body:**
  ```json
  {
    "quantity": 2,
    "shipping_address": "123 Business St, Dubai, UAE"
  }
  ```

---

## 4. Favorites
Save parts for later.

- **Add to Favorites:** `POST /parts/{id}/favorite`
- **Remove from Favorites:** `DELETE /parts/{id}/favorite`
- **Get My Favorites:** `GET /favorite-parts`

---

## 5. My Listings (For Sellers/Admin)
- **Get My Parts:** `GET /my-parts`
- **Get My Sales:** `GET /my-sales`
- **Get My Purchases:** `GET /my-purchases`

---

## Implementation in Flutter
All these endpoints are already implemented in `lib/services/parts_service.dart` and integrated into the global state via `lib/state/parts_state.dart` using **GetX**.
