# Phase 2: Supabase Integration Setup Guide

## Overview

This guide walks you through setting up Supabase for TimeLevelUp authentication and database integration. After following these steps, the app will use real Supabase authentication instead of mock credentials.

---

## Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up / log in
2. Click **"New Project"**
3. Fill in:
   - **Name**: `timelevelup` (or your choice)
   - **Database Password**: Choose a strong password (save this)
   - **Region**: Select closest region to your users (e.g., Singapore, Tokyo, or US)
4. Click **"Create new project"** and wait (5-10 minutes)

---

## Step 2: Get API Keys

Once project is created:

1. Click on your project name to open it
2. Go to **Settings** (gear icon) > **API**
3. You'll see:
   - **Project URL** (e.g., `https://xxxxxxxxxx.supabase.co`)
   - **Anon Key** (under "Project API keys")
4. Copy these values

---

## Step 3: Update `.env` File

In your Flutter project root, update `.env`:

```env
SUPABASE_URL=https://xxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

**⚠️ IMPORTANT**: 
- Never commit `.env` to git (it's in `.gitignore`)
- Each developer should have their own `.env` file
- For production, use GitHub Secrets or environment manager

---

## Step 4: Setup Database Schema

### 4a. Run SQL Setup in Supabase Editor

1. In Supabase Dashboard, go to **SQL Editor** (left sidebar)
2. Click **"New Query"**
3. Copy the entire content from `docs/SUPABASE_SETUP.sql`
4. Paste into the SQL Editor
5. Click **"Run"**

This creates:
- `tenants` table (for multi-tenant support)
- `users` table (linked to Supabase Auth)
- RLS (Row Level Security) policies

### 4b. Create Test Tenant

In the SQL Editor, run:

```sql
INSERT INTO public.tenants (name) VALUES ('Test Academy');
```

Then query to get the tenant UUID:

```sql
SELECT id FROM public.tenants WHERE name = 'Test Academy';
```

**Note this UUID** — you'll need it for the next step.

---

## Step 5: Create Test Users in Supabase Auth

1. Go to **Authentication** (left sidebar) > **Users**
2. Click **"Add user"**
3. Create first user:
   - **Email**: `student@test.com`
   - **Password**: `1234`
   - Click **"Send invite"** or **"Create user"**
4. After creation, the row shows the user's **UUID** on the right. **Copy this UUID.**
5. Repeat for second user:
   - **Email**: `teacher@test.com`
   - **Password**: `1234`
   - Copy this UUID too

---

## Step 6: Insert User Profiles

Go to **SQL Editor** and run:

```sql
-- Replace TENANT_UUID with the UUID you noted in Step 4b
-- Replace USER_UUID_1 and USER_UUID_2 with UUIDs from Step 5

INSERT INTO public.users (id, email, name, role, tenant_id)
VALUES 
  ('USER_UUID_1', 'student@test.com', 'Kim Student', 'student', 'TENANT_UUID'),
  ('USER_UUID_2', 'teacher@test.com', 'Lee Teacher', 'consultant', 'TENANT_UUID')
ON CONFLICT DO NOTHING;
```

**Example** (with placeholder UUIDs):
```sql
INSERT INTO public.users (id, email, name, role, tenant_id)
VALUES 
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'student@test.com', 'Kim Student', 'student', 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'),
  ('f1e2d3c4-b5a6-9876-5432-10fedcba9876', 'teacher@test.com', 'Lee Teacher', 'consultant', 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx')
ON CONFLICT DO NOTHING;
```

---

## Step 7: Test the App

### 7a. Install Dependencies

```bash
cd /path/to/my_first_app
flutter pub get
```

### 7b. Run the App

```bash
flutter run
```

### 7c. Test Login

1. App starts at **LoginScreen**
2. Try logging in:
   - **Email**: `student@test.com`
   - **Password**: `1234`
   - Expected: Navigates to **StudentHomeScreen** (오늘의 플랜)

3. Log out and try:
   - **Email**: `teacher@test.com`
   - **Password**: `1234`
   - Expected: Navigates to **ConsultantDashboardScreen** (담당 학생 목록)

---

## Troubleshooting

### Issue: `SUPABASE_URL not found` or `.env not loaded`

**Solution**:
- Ensure `.env` file exists in project root (not in `lib/` or elsewhere)
- Check `.env` format (no extra spaces):
  ```env
  SUPABASE_URL=https://xxx.supabase.co
  SUPABASE_ANON_KEY=xxx
  ```
- Rebuild app: `flutter clean && flutter pub get && flutter run`

### Issue: "Invalid credentials" on login

**Solution**:
- Verify `student@test.com` and `teacher@test.com` exist in Supabase Auth
- Verify user profiles exist in `public.users` table
- Check that password matches (should be `1234`)
- Verify tenant_id is correct in `public.users`

### Issue: "PostgreSQL error" or RLS policy errors

**Solution**:
- Check RLS policies in **Settings** > **Database** > **Security** > **Row Level Security**
- Policies should exist for `tenants` and `users` tables
- Re-run `SUPABASE_SETUP.sql` if policies are missing

### Issue: App crashes on `Supabase.initialize()`

**Solution**:
- Check that `SUPABASE_URL` is valid (should start with `https://` and end with `.supabase.co`)
- Check that `SUPABASE_ANON_KEY` is not empty
- Ensure `flutter_dotenv` dependency is in `pubspec.yaml`

---

## What Changed in Code

### Before (Phase 1 - Mock):
```dart
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return MockAuthRepository(); // ❌ Mock data
}
```

### After (Phase 2 - Real):
```dart
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return RealAuthRepository(); // ✅ Real Supabase
}
```

**All other code remains the same** — thanks to Repository Pattern! ✨

---

## Next Steps

After Supabase auth works, implement:
1. **RealStudentRepository** — Replace MockStudentRepository with Supabase queries
2. **RealPlanRepository** — Fetch plans from Supabase
3. **RealScoreRepository** — Fetch scores from Supabase
4. **RealTimerRepository** — Persist study sessions to Supabase

---

## Useful Supabase Links

- [Supabase Docs](https://supabase.com/docs)
- [SQL Reference](https://supabase.com/docs/guides/database)
- [Authentication](https://supabase.com/docs/guides/auth)
- [Flutter SDK](https://github.com/supabase/supabase-flutter)
