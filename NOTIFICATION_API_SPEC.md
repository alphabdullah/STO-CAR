# Notification Module – Complete API Specification

> **Purpose:** Jab bhi auction ke liye car list ho, users ko app par notification aaye.  
> **Audience:** UI Developer (Flutter) & Backend Developer (Laravel)

---

## 1. Overview

### Flow
1. **Backend:** Jab admin auction approve kare ya new auction create/approve ho → system sabhi relevant users ke liye notification record create kare
2. **Mobile App:** User notifications screen par list dekhe, tap par auction detail par navigate kare
3. **Optional:** Future mein FCM/Push notification bhi add ki ja sakti hai

### Base URL
- **Development:** `http://127.0.0.1:8000`
- **Production:** `https://updated.bidssync.com`

### API Prefix
```
/api/v1
```

### Authentication
Sabhi notification endpoints **Bearer Token** required karte hain (user logged in hona chahiye).

```
Authorization: Bearer {access_token}
Accept: application/json
Content-Type: application/json
```

---

## 2. Notification API Endpoints

### 2.1 Get User Notifications
**GET** `/api/v1/notifications`

User ke saare notifications fetch karta hai (latest first).

**Headers:**
| Key | Value |
|-----|-------|
| Authorization | Bearer {token} |
| Accept | application/json |

**Query Parameters (optional):**
| Param | Type | Description |
|-------|------|-------------|
| unread | string | `"true"` = sirf unread notifications |

**Success Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "title": "New Car Auction",
      "message": "2020 BMW 3 Series is now live for bidding!",
      "type": "auction",
      "created_at": "2026-03-08T10:30:00.000000Z",
      "is_read": false,
      "data": {
        "auction_id": "123",
        "car_make": "BMW",
        "car_model": "3 Series",
        "car_year": 2020
      }
    },
    {
      "id": "2",
      "title": "Outbid Alert",
      "message": "Someone outbid you on Toyota Camry auction.",
      "type": "auction",
      "created_at": "2026-03-08T09:15:00.000000Z",
      "is_read": true,
      "data": {
        "auction_id": "122"
      }
    }
  ]
}
```

**Error Response (401):**
```json
{
  "message": "Unauthenticated."
}
```

---

### 2.2 Get Unread Count
**GET** `/api/v1/notifications/unread-count`

App header/badge ke liye unread count.

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "count": 5
  }
}
```

---

### 2.3 Mark Notification as Read
**POST** `/api/v1/notifications/{id}/read`

Single notification ko read mark karta hai.

**URL:** `POST /api/v1/notifications/1/read`

**Success Response (200):**
```json
{
  "success": true,
  "message": "Notification marked as read"
}
```

---

### 2.4 Mark All Notifications as Read
**POST** `/api/v1/notifications/read-all`

Sabhi notifications ko read mark karta hai.

**Success Response (200):**
```json
{
  "success": true,
  "message": "All notifications marked as read"
}
```

---

### 2.5 Delete Notification
**DELETE** `/api/v1/notifications/{id}`

Ek notification delete karta hai.

**URL:** `DELETE /api/v1/notifications/1`

**Success Response (200):**
```json
{
  "success": true,
  "message": "Notification deleted"
}
```

---

### 2.6 Delete All Notifications
**DELETE** `/api/v1/notifications`

User ke saare notifications delete karta hai.

**Success Response (200):**
```json
{
  "success": true,
  "message": "All notifications deleted"
}
```

---

## 3. Notification Data Model (Backend)

Backend ko ye structure store/return karna chahiye:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string/int | ✓ | Unique notification ID |
| title | string | ✓ | Short title (e.g. "New Car Auction") |
| message | string | ✓ | Detailed message |
| type | string | ✓ | `auction`, `booking`, `wallet`, `verification`, `parts`, `system` |
| created_at | datetime (ISO 8601) | ✓ | e.g. `2026-03-08T10:30:00.000000Z` |
| is_read | boolean | ✓ | Default `false` |
| data | object | optional | Extra data; `auction_id` hone par UI `/auctions/{id}` par navigate karegi |

### Notification Types (Flutter expects)
| type | Use Case |
|------|----------|
| auction | Car listed, outbid, auction won, auction ending soon |
| booking | Booking approved/rejected/scheduled |
| wallet | Deposit, withdrawal, low balance |
| verification | Account verification status |
| parts | Parts marketplace updates |
| system | General system messages |

---

## 4. Auction-List Notification (Backend Logic)

**Jab car auction ke liye list/approve ho:**

1. **Trigger:** Admin auction approve kare **ya** new auction create/approve ho
2. **Action:** Sabhi active users (ya subscribed users) ke liye `notifications` table mein entry insert karo
3. **Payload Example:**
   - `title`: `"New Car Auction"`
   - `message`: `"{car_make} {car_model} ({car_year}) is now live for bidding!"`
   - `type`: `"auction"`
   - `data`: `{"auction_id": "123", "car_make": "BMW", "car_model": "3 Series", "car_year": 2020}`

**Pseudocode (Laravel):**
```php
// Auction approved / created event listener
public function whenAuctionApproved(Auction $auction) {
    $users = User::where('is_active', true)->pluck('id');
    foreach ($users as $userId) {
        Notification::create([
            'user_id' => $userId,
            'title' => 'New Car Auction',
            'message' => "{$auction->car_make} {$auction->car_model} ({$auction->car_year}) is now live for bidding!",
            'type' => 'auction',
            'data' => json_encode([
                'auction_id' => (string) $auction->id,
                'car_make' => $auction->car_make,
                'car_model' => $auction->car_model,
                'car_year' => $auction->car_year,
            ]),
        ]);
    }
}
```

---

## 5. UI Integration (Flutter – Already Implemented)

App mein already ye sab hai:

- **Route:** `/notifications`
- **Service:** `NotificationService` – API calls
- **State:** `NotificationState` – GetX
- **Screen:** `NotificationsScreen` – list + mark read + delete

**Action URL:** Agar `data.auction_id` present ho to tap par `/auctions/{auction_id}` par navigate hota hai.

---

## 6. Optional: Push Notifications (Future)

Agar baad mein **FCM / Firebase Cloud Messaging** add karni ho:

- Device token register karo: `POST /api/v1/notifications/register-device`  
  Body: `{ "fcm_token": "..." }`
- Backend jab notification create kare to FCM bhi fire kare taake user ko real-time push aaye

---

## 7. Summary for UI Developer

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/notifications` | GET | List notifications |
| `/api/v1/notifications?unread=true` | GET | Unread only |
| `/api/v1/notifications/unread-count` | GET | Badge count |
| `/api/v1/notifications/{id}/read` | POST | Mark one read |
| `/api/v1/notifications/read-all` | POST | Mark all read |
| `/api/v1/notifications/{id}` | DELETE | Delete one |
| `/api/v1/notifications` | DELETE | Delete all |

**Auth:** Har request par `Authorization: Bearer {token}` required.

---

*Document Version: 1.0 | Last Updated: March 2026*
