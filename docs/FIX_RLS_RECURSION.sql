-- =============================================================================
-- Fix: RLS Policy Infinite Recursion Issue
-- =============================================================================
-- Problem: The users table RLS policy causes infinite recursion
-- Solution: Simplify the policy to avoid self-referencing queries

-- =============================================================================
-- Step 1: Drop the problematic policy
-- =============================================================================
DROP POLICY IF EXISTS "Allow users to read own record" ON public.users;

-- =============================================================================
-- Step 2: Create a simplified policy (no recursion)
-- =============================================================================
-- Users can only read their own record
CREATE POLICY "Allow users to read own record" ON public.users
  FOR SELECT USING (auth.uid() = id);

-- =============================================================================
-- Optional: If you need admin users to read all users in their tenant
-- Uncomment and run this instead (requires a different approach):
-- =============================================================================
-- Note: This would require checking admin status without querying users table
-- For now, we'll keep it simple: users can only read their own record

-- =============================================================================
-- Verification
-- =============================================================================
-- After running this, test by:
-- 1. Logging in as student@test.com
-- 2. Should be able to read own user record without recursion error

