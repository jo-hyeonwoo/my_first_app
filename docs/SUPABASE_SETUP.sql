-- =============================================================================
-- TimeLevelUp Database Setup (Supabase SQL)
-- =============================================================================
-- This file contains SQL scripts to set up the database schema for TimeLevelUp
-- Run these scripts in Supabase SQL Editor to initialize the database

-- =============================================================================
-- 1. Create Tenants Table
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.tenants IS 'Multi-tenant organizations/academies';

-- =============================================================================
-- 2. Create Users Table
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL CHECK (role IN ('student', 'consultant', 'admin')),
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.users IS 'User profiles linked to Supabase Auth';
COMMENT ON COLUMN public.users.id IS 'UUID from Supabase Auth';
COMMENT ON COLUMN public.users.role IS 'User role: student, consultant, admin';

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_tenant_id ON public.users(tenant_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);

-- =============================================================================
-- 3. Enable RLS (Row Level Security)
-- =============================================================================
ALTER TABLE public.tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Allow public read access to tenants (for listing)
CREATE POLICY "Allow public read" ON public.tenants
  FOR SELECT USING (true);

-- Allow users to read their own record
CREATE POLICY "Allow users to read own record" ON public.users
  FOR SELECT USING (
    auth.uid() = id OR
    auth.uid()::text IN (SELECT id::text FROM public.users WHERE tenant_id = users.tenant_id AND role = 'admin')
  );

-- Allow authenticated users to update their own record
CREATE POLICY "Allow users to update own record" ON public.users
  FOR UPDATE USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- =============================================================================
-- 4. Insert Test Data (Replace UUIDs with real ones after auth creation)
-- =============================================================================

-- First, create test tenant
INSERT INTO public.tenants (name)
VALUES ('Test Academy')
ON CONFLICT DO NOTHING;

-- Get the tenant ID (update this with actual UUID after creation)
-- SELECT id FROM public.tenants WHERE name = 'Test Academy';

-- Insert test users AFTER creating them in Supabase Auth
-- Run this after creating auth users:
-- 1. Create user: student@test.com / password: 1234
-- 2. Create user: teacher@test.com / password: 1234
-- 3. Copy their UUIDs from auth.users and update below:

-- Example (REPLACE WITH ACTUAL UUIDs):
-- INSERT INTO public.users (id, email, name, role, tenant_id)
-- VALUES 
--   ('00000000-0000-0000-0000-000000000001', 'student@test.com', 'Kim Student', 'student', 'TENANT_UUID'),
--   ('00000000-0000-0000-0000-000000000002', 'teacher@test.com', 'Lee Teacher', 'consultant', 'TENANT_UUID')
-- ON CONFLICT DO NOTHING;

-- =============================================================================
-- Setup Instructions
-- =============================================================================
/*
MANUAL STEPS (since we can't create auth users via SQL):

1. Create Test Tenant:
   - Run the tenants INSERT above
   - Note the tenant UUID

2. Create Auth Users in Supabase Dashboard:
   - Go to Authentication > Users > Add user
   - Email: student@test.com, Password: 1234
   - Email: teacher@test.com, Password: 1234
   - Copy their UUIDs

3. Insert User Profiles:
   - Update the SQL INSERT with actual UUIDs and tenant_id
   - Run the INSERT statement

4. Update .env file with:
   - SUPABASE_URL: https://xxx.supabase.co
   - SUPABASE_ANON_KEY: xxx (from Project Settings > API Keys)

5. Test the app:
   - Run: flutter pub get && flutter run
   - Login with test credentials
*/

-- =============================================================================
-- 5. Create Students Table
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.students (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  school_name VARCHAR(255),
  grade INT,
  status VARCHAR(50) NOT NULL CHECK (status IN ('active', 'inactive')) DEFAULT 'active',
  primary_consultant_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  last_login_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.students IS 'Student profiles';
COMMENT ON COLUMN public.students.primary_consultant_id IS 'Consultant managing this student';

CREATE INDEX IF NOT EXISTS idx_students_tenant_id ON public.students(tenant_id);
CREATE INDEX IF NOT EXISTS idx_students_consultant_id ON public.students(primary_consultant_id);

-- =============================================================================
-- 6. Create Student Plans Table
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.student_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  plan_date DATE NOT NULL,
  title VARCHAR(255),
  type VARCHAR(50) NOT NULL CHECK (type IN ('study', 'review')),
  expected_minutes INT,
  status VARCHAR(50) NOT NULL CHECK (status IN ('pending', 'in_progress', 'completed', 'missed')) DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.student_plans IS 'Daily learning plans for students';
COMMENT ON COLUMN public.student_plans.type IS 'Study type: study or review';
COMMENT ON COLUMN public.student_plans.status IS 'Plan status: pending, in_progress, completed, missed';

CREATE INDEX IF NOT EXISTS idx_student_plans_student_id ON public.student_plans(student_id);
CREATE INDEX IF NOT EXISTS idx_student_plans_date ON public.student_plans(plan_date);
CREATE INDEX IF NOT EXISTS idx_student_plans_tenant_id ON public.student_plans(tenant_id);

-- =============================================================================
-- 7. Enable RLS for Students & Plans
-- =============================================================================
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_plans ENABLE ROW LEVEL SECURITY;

-- Students: Consultant can read their managed students
CREATE POLICY "Consultants can read managed students" ON public.students
  FOR SELECT USING (
    auth.uid() = primary_consultant_id OR
    auth.uid()::text IN (SELECT id::text FROM public.users WHERE tenant_id = students.tenant_id AND role = 'admin')
  );

-- Students: Students can read themselves
CREATE POLICY "Students can read self" ON public.students
  FOR SELECT USING (auth.uid() = id);

-- Plans: Students can read own plans
CREATE POLICY "Students can read own plans" ON public.student_plans
  FOR SELECT USING (
    student_id = (SELECT id FROM public.students WHERE id = student_plans.student_id LIMIT 1) AND
    auth.uid() = (SELECT id FROM public.students WHERE id = student_plans.student_id LIMIT 1)
  );

-- Plans: Consultants can read managed student plans
CREATE POLICY "Consultants can read managed student plans" ON public.student_plans
  FOR SELECT USING (
    student_id IN (SELECT id FROM public.students WHERE primary_consultant_id = auth.uid())
  );

-- =============================================================================
-- 8. Insert Test Data for Students and Plans
-- =============================================================================
-- 
-- INSTRUCTIONS:
-- 1. First, get your tenant ID:
--    SELECT id FROM public.tenants WHERE name = 'Test Academy';
--
-- 2. Get your consultant user ID:
--    SELECT id FROM public.users WHERE email = 'teacher@test.com';
--
-- 3. Replace TENANT_UUID and CONSULTANT_UUID in the queries below with actual UUIDs
--
-- 4. Uncomment and execute the INSERT statements

-- =============================================================================
-- 8a. Insert Test Students (2 students)
-- =============================================================================
/*
INSERT INTO public.students (tenant_id, name, school_name, grade, status, primary_consultant_id, last_login_at)
VALUES
  ('TENANT_UUID', '김철수', '서울고등학교', 2, 'active', 'CONSULTANT_UUID', NOW() - INTERVAL '2 hours'),
  ('TENANT_UUID', '이영희', '서울고등학교', 3, 'active', 'CONSULTANT_UUID', NOW() - INTERVAL '1 day')
ON CONFLICT DO NOTHING;
*/

-- Example test students (REPLACE UUIDs):
/*
-- First, get the student UUIDs:
-- SELECT id, name FROM public.students WHERE name IN ('김철수', '이영희');

-- Student 1 (김철수) - 3 plans
INSERT INTO public.student_plans (tenant_id, student_id, plan_date, title, type, expected_minutes, status)
VALUES
  ('TENANT_UUID', 'STUDENT_1_UUID', CURRENT_DATE, '수학 예제 풀기', 'study', 60, 'completed'),
  ('TENANT_UUID', 'STUDENT_1_UUID', CURRENT_DATE, '영어 단어 암기', 'study', 30, 'in_progress'),
  ('TENANT_UUID', 'STUDENT_1_UUID', CURRENT_DATE, '국어 복습', 'review', 45, 'pending')
ON CONFLICT DO NOTHING;

-- Student 2 (이영희) - 3 plans
INSERT INTO public.student_plans (tenant_id, student_id, plan_date, title, type, expected_minutes, status)
VALUES
  ('TENANT_UUID', 'STUDENT_2_UUID', CURRENT_DATE, '수학 모의고사', 'study', 120, 'completed'),
  ('TENANT_UUID', 'STUDENT_2_UUID', CURRENT_DATE, '영어 독해', 'study', 60, 'pending'),
  ('TENANT_UUID', 'STUDENT_2_UUID', CURRENT_DATE, '과학 정리', 'review', 45, 'pending')
ON CONFLICT DO NOTHING;
*/

-- =============================================================================
-- 9. Create Scores Table
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  exam_name VARCHAR(255) NOT NULL,
  exam_date DATE NOT NULL,
  subject VARCHAR(50) NOT NULL,
  raw_score INT NOT NULL,
  standard_score INT,
  grade VARCHAR(10),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.scores IS 'Student exam scores';
COMMENT ON COLUMN public.scores.exam_name IS 'Name of the exam (e.g., 3월 모의고사)';
COMMENT ON COLUMN public.scores.exam_date IS 'Date when the exam was taken';
COMMENT ON COLUMN public.scores.subject IS 'Subject name (e.g., 국어, 영어, 수학)';
COMMENT ON COLUMN public.scores.raw_score IS 'Raw score (점수)';
COMMENT ON COLUMN public.scores.standard_score IS 'Standard score (표준점수)';
COMMENT ON COLUMN public.scores.grade IS 'Grade level (등급)';

CREATE INDEX IF NOT EXISTS idx_scores_student_id ON public.scores(student_id);
CREATE INDEX IF NOT EXISTS idx_scores_exam_date ON public.scores(exam_date);
CREATE INDEX IF NOT EXISTS idx_scores_tenant_id ON public.scores(tenant_id);

-- =============================================================================
-- 10. Create Student Study Sessions Table
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.student_study_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  plan_id UUID NOT NULL REFERENCES public.student_plans(id) ON DELETE CASCADE,
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE,
  duration_seconds INT NOT NULL DEFAULT 0,
  status VARCHAR(50) NOT NULL CHECK (status IN ('initial', 'running', 'paused', 'completed')) DEFAULT 'initial',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.student_study_sessions IS 'Study session records from timer';
COMMENT ON COLUMN public.student_study_sessions.plan_id IS 'Reference to the plan being studied';
COMMENT ON COLUMN public.student_study_sessions.duration_seconds IS 'Total study duration in seconds';
COMMENT ON COLUMN public.student_study_sessions.status IS 'Session status: initial, running, paused, completed';

CREATE INDEX IF NOT EXISTS idx_study_sessions_student_id ON public.student_study_sessions(student_id);
CREATE INDEX IF NOT EXISTS idx_study_sessions_plan_id ON public.student_study_sessions(plan_id);
CREATE INDEX IF NOT EXISTS idx_study_sessions_start_time ON public.student_study_sessions(start_time);
CREATE INDEX IF NOT EXISTS idx_study_sessions_tenant_id ON public.student_study_sessions(tenant_id);

-- =============================================================================
-- 11. Enable RLS for Scores & Study Sessions
-- =============================================================================
ALTER TABLE public.scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_study_sessions ENABLE ROW LEVEL SECURITY;

-- Scores: Students can read own scores
CREATE POLICY "Students can read own scores" ON public.scores
  FOR SELECT USING (
    student_id IN (SELECT id FROM public.students WHERE id = scores.student_id AND auth.uid() = id)
  );

-- Scores: Consultants can read managed student scores
CREATE POLICY "Consultants can read managed student scores" ON public.scores
  FOR SELECT USING (
    student_id IN (SELECT id FROM public.students WHERE primary_consultant_id = auth.uid())
  );

-- Study Sessions: Students can read own sessions
CREATE POLICY "Students can read own sessions" ON public.student_study_sessions
  FOR SELECT USING (
    student_id IN (SELECT id FROM public.students WHERE id = student_study_sessions.student_id AND auth.uid() = id)
  );

-- Study Sessions: Consultants can read managed student sessions
CREATE POLICY "Consultants can read managed student sessions" ON public.student_study_sessions
  FOR SELECT USING (
    student_id IN (SELECT id FROM public.students WHERE primary_consultant_id = auth.uid())
  );

-- Study Sessions: Students can insert own sessions
CREATE POLICY "Students can insert own sessions" ON public.student_study_sessions
  FOR INSERT WITH CHECK (
    student_id IN (SELECT id FROM public.students WHERE id = student_study_sessions.student_id AND auth.uid() = id)
  );

-- =============================================================================
-- 12. Insert Test Data for Scores and Study Sessions
-- =============================================================================
-- Note: Replace STUDENT_1_UUID and TENANT_UUID with actual UUIDs

-- =============================================================================
-- 12a. Insert Test Scores (Student 1 - 김철수: 3월, 6월, 9월 모의고사)
-- =============================================================================
/*
INSERT INTO public.scores (tenant_id, student_id, exam_name, exam_date, subject, raw_score, standard_score, grade)
VALUES
  -- 3월 모의고사
  ('TENANT_UUID', 'STUDENT_1_UUID', '3월 모의고사', '2025-03-20', '국어', 85, 112, '3'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '3월 모의고사', '2025-03-20', '영어', 78, 105, '4'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '3월 모의고사', '2025-03-20', '수학', 92, 118, '2'),
  -- 6월 모의고사
  ('TENANT_UUID', 'STUDENT_1_UUID', '6월 모의고사', '2025-06-18', '국어', 88, 115, '2'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '6월 모의고사', '2025-06-18', '영어', 82, 110, '3'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '6월 모의고사', '2025-06-18', '수학', 95, 122, '1'),
  -- 9월 모의고사
  ('TENANT_UUID', 'STUDENT_1_UUID', '9월 모의고사', '2025-09-17', '국어', 90, 118, '2'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '9월 모의고사', '2025-09-17', '영어', 86, 114, '2'),
  ('TENANT_UUID', 'STUDENT_1_UUID', '9월 모의고사', '2025-09-17', '수학', 98, 125, '1')
ON CONFLICT DO NOTHING;
*/

-- =============================================================================
-- 12b. Insert Test Study Sessions (Student 1 - 김철수: 2 sessions)
-- =============================================================================
-- Note: Replace STUDENT_1_UUID, PLAN_UUID (any plan ID from student_plans), and TENANT_UUID
/*
-- Get a plan ID for testing:
-- SELECT id FROM public.student_plans WHERE student_id = 'STUDENT_1_UUID' LIMIT 1;

INSERT INTO public.student_study_sessions (tenant_id, student_id, plan_id, start_time, end_time, duration_seconds, status)
VALUES
  ('TENANT_UUID', 'STUDENT_1_UUID', 'PLAN_UUID', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '1 hour 50 minutes', 600, 'completed'),
  ('TENANT_UUID', 'STUDENT_1_UUID', 'PLAN_UUID', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '30 minutes', 1800, 'completed')
ON CONFLICT DO NOTHING;
*/
