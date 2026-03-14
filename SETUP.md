# Today In History - Setup Guide

This guide walks you through setting up the Today In History iOS app from the generated code.

## Prerequisites

- macOS with Xcode 15+ installed
- Apple Developer Account (for Sign in with Apple and StoreKit)
- Supabase account (free tier works)
- Node.js 18+ (for Supabase CLI)

---

## Step 1: Create Xcode Project

1. Open Xcode and create a new project:
   - iOS → App
   - Product Name: `TodayInHistory`
   - Team: Your Apple Developer Team
   - Organization Identifier: `com.yourname`
   - Interface: SwiftUI
   - Language: Swift

2. Set deployment target to **iOS 15.0**

3. Copy the contents of `TodayInHistory/` into your Xcode project:
   - Drag the folders (App, Features, Core, etc.) into the project navigator
   - Make sure "Copy items if needed" is checked
   - Add to target: TodayInHistory

---

## Step 2: Add Swift Package Dependencies

In Xcode: File → Add Package Dependencies

Add these packages:

```
https://github.com/supabase/supabase-swift
  - Version: 2.0.0 or later
  - Products: Supabase

https://github.com/onevcat/Kingfisher
  - Version: 7.0.0 or later
  - Products: Kingfisher

https://github.com/getsentry/sentry-cocoa
  - Version: 8.0.0 or later
  - Products: Sentry
```

---

## Step 3: Configure Capabilities

In Xcode, select your target → Signing & Capabilities:

1. **Sign in with Apple**
   - Click "+ Capability"
   - Add "Sign in with Apple"

2. **Background Modes**
   - Click "+ Capability"
   - Add "Background Modes"
   - Check "Background fetch"

3. **Push Notifications** (optional)
   - Click "+ Capability"
   - Add "Push Notifications"

---

## Step 4: Create CoreData Model

1. File → New → File → Data Model
2. Name it `TodayInHistory.xcdatamodeld`
3. Add entity `CachedFact` with these attributes:

| Attribute | Type |
|-----------|------|
| id | UUID |
| date | Date |
| region | String |
| setNumber | Integer 16 |
| topic | String |
| title | String |
| summary | String |
| fullContent | String |
| imageURL | String (Optional) |
| sourceURL | String |
| cachedAt | Date |

---

## Step 5: Set Up Supabase

### 5.1 Create Project

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Note your:
   - Project URL (e.g., `https://xxxxx.supabase.co`)
   - Anon Key (safe for client)
   - Service Role Key (keep secret!)

### 5.2 Run Database Schema

1. Go to SQL Editor in Supabase dashboard
2. Copy contents of `supabase/migrations/001_initial_schema.sql`
3. Run the migration

### 5.3 Enable Authentication

1. Go to Authentication → Providers
2. Enable "Apple" provider
3. Configure with your Apple Developer credentials:
   - Service ID
   - Team ID
   - Key ID
   - Private Key

### 5.4 Enable pg_cron

1. Go to Database → Extensions
2. Enable `pg_cron`
3. Run the cron job setup from the migration file (uncomment and run)

---

## Step 6: Deploy Edge Functions

### Install Supabase CLI

```bash
npm install -g supabase
```

### Link and Deploy

```bash
cd /path/to/Today-In-History

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref YOUR_PROJECT_ID

# Deploy functions
supabase functions deploy generate-facts
supabase functions deploy validate-receipt
```

### Set Function Secrets (for validate-receipt)

```bash
# If using App Store Server API:
supabase secrets set APP_STORE_CONNECT_KEY="your-key"
supabase secrets set APP_STORE_CONNECT_KEY_ID="your-key-id"
supabase secrets set APP_STORE_CONNECT_ISSUER_ID="your-issuer-id"
```

---

## Step 7: Update App Configuration

Edit `TodayInHistory/App/Config.swift`:

```swift
// Replace with your values:
static let supabaseURL = URL(string: "https://YOUR_PROJECT_ID.supabase.co")!
static let supabaseAnonKey = "YOUR_ANON_KEY"
static let sentryDSN = "YOUR_SENTRY_DSN"
```

---

## Step 8: Create Asset Catalog Colors

In `Assets.xcassets`, create these Color Sets:

| Name | Light | Dark |
|------|-------|------|
| Background | #FFFFFF | #000000 |
| CardBackground | #F5F5F5 | #1C1C1E |
| PrimaryText | #000000 | #FFFFFF |
| SecondaryText | #666666 | #8E8E93 |
| Accent | #007AFF | #007AFF |
| ProGold | #FFD700 | #FFD700 |
| NorthAmerica | #3B82F6 | #3B82F6 |
| Europe | #6366F1 | #6366F1 |
| Asia | #EF4444 | #EF4444 |
| Africa | #F97316 | #F97316 |
| SouthAmerica | #22C55E | #22C55E |

---

## Step 9: Configure StoreKit

### In App Store Connect:

1. Create two subscription products:
   - `com.todayinhistory.pro.monthly`
   - `com.todayinhistory.pro.yearly`

### For Testing:

1. In Xcode: Product → Scheme → Edit Scheme
2. Add StoreKit Configuration File for testing
3. Add your subscription products to the config

---

## Step 10: Add Sentry

1. Create account at [sentry.io](https://sentry.io)
2. Create iOS project
3. Copy DSN to `Config.swift`

---

## Step 11: Generate Initial Facts

Test the fact generation:

```bash
# Invoke the function manually
curl -X POST \
  'https://YOUR_PROJECT_ID.supabase.co/functions/v1/generate-facts' \
  -H 'Authorization: Bearer YOUR_SERVICE_ROLE_KEY'
```

---

## Step 12: Build and Run

1. Select your target device/simulator
2. Build and run (⌘R)
3. The app should launch with onboarding

---

## Troubleshooting

### "No facts available"

- Check Supabase logs for Edge Function errors
- Verify the `generate-facts` function is deployed
- Run the function manually to generate test data

### "Authentication failed"

- Verify Sign in with Apple is configured in both Xcode and Supabase
- Check Apple Developer credentials in Supabase Auth settings

### "Purchases not working"

- Ensure StoreKit products are created in App Store Connect
- Use StoreKit Testing configuration in Xcode
- Check `validate-receipt` function is deployed

---

## Next Steps

1. Complete the UI views in `Features/` (see implementation plan)
2. Add placeholder images to `Resources/`
3. Configure TestFlight for beta testing
4. Submit to App Store!

---

*Setup guide generated by Hogwarts Framework*
