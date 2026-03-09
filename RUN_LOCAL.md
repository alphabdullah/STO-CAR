# STO Car - Local Development (Windows)

Flutter UI aur Laravel backend ko Windows par local run karne ka tareeqa.

---

## Prerequisites

1. **XAMPP** – PHP aur MySQL ke liye (htdocs path se)
2. **Composer** – Laravel dependencies
3. **Flutter** – Flutter app
4. **Node.js** (optional) – Sirf agar backend ke saath Vite/queue chalaana ho

---

## Step 1: Backend (Laravel) Run karna

### Option A: Batch script se (simple)

```cmd
cd C:\xampp\htdocs\sto_car\backend
run-backend.bat
```

### Option B: Manual commands

```cmd
cd C:\xampp\htdocs\sto_car\backend

REM Pehli baar setup
copy .env.example .env
php artisan key:generate
composer install
php artisan migrate

REM Server start
php artisan serve --host=127.0.0.1 --port=8000
```

Backend chalu hone par: **http://127.0.0.1:8000**

---

## Step 2: Database (MySQL)

1. XAMPP Control Panel se **MySQL** start karo
2. `sto_car_db` database bana lo (ya .env mein jo naam hai)
3. Migrations run karo: `php artisan migrate`

---

## Step 3: Flutter UI Run karna

```cmd
cd C:\xampp\htdocs\Sto-UI
flutter pub get
flutter run -d windows
```

Ya kisi bhi device/emulator par:

```cmd
flutter run
```

---

## Connection Setup

| Mode      | Flutter baseUrl          | Use Case           |
|----------|---------------------------|--------------------|
| Debug    | `http://127.0.0.1:8000`  | Local development  |
| Release  | `https://updated.bidssync.com` | Production   |

Debug mode mein Flutter automatically local backend use karega.

---

## Agar Emulator/Physical Device Use Kar Rahe Ho

- **Android Emulator**: `api_endpoints.dart` mein `baseUrl` ko `http://10.0.2.2:8000` kar do
- **Physical Device**: Apne PC ka local IP use karo, masalan `http://192.168.1.100:8000`

---

## Quick Test

1. Backend: `http://127.0.0.1:8000/api/v1/auctions` browser mein open karo
2. Flutter: App run karo, login/register try karo

---

## Troubleshooting

| Issue                | Solution                                      |
|----------------------|-----------------------------------------------|
| Connection timeout   | Backend `php artisan serve` chal raha hai?    |
| 500 error            | `.env` sahi hai? `php artisan config:clear`   |
| CORS error           | Laravel CORS `*` allow karta hai, normally OK |
| MySQL connection     | XAMPP MySQL start karo, DB name match karo    |
