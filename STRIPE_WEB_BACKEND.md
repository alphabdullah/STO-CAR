# Stripe Checkout for Web – Backend + UI

Backend aur Flutter UI dono complete hain.

## Backend (Laravel)

**Folder:** `backend_stripe_reference/`

1. **StripeCheckoutController.php** – copy karo apne Laravel project mein
2. **README.md** – step-by-step setup
3. **routes_example.php** – routes ka example

Copy karke apni Laravel app mein integrate karo. Details: `backend_stripe_reference/README.md`

## Flutter UI (done)

- Web: Deposit tap → Stripe Checkout new tab mein open
- Payment complete → wapas /wallet?payment=success → balance refresh
- Android/iOS: Payment Sheet (pehle jaisa)
- Windows: "Use mobile app" message

## Endpoint

```
POST /api/v1/payments/stripe/checkout-session
Body: { amount, success_url, cancel_url }
Response: { success: true, data: { url: "https://checkout.stripe.com/..." } }
```

## Webhook

Stripe Dashboard → Webhooks → `checkout.session.completed` add karo, URL:
`https://your-domain.com/api/v1/stripe/webhook`
