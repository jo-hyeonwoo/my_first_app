# Development Roadmap — TimeLevelUp (Flutter)

This TODO divides work into Phase 1 (Mock-data development) and Phase 2 (Supabase integration).

Phase 1 — Mock-data driven (deliver working UI + Repo pattern)

- Students Dashboard

  - [x] Domain Layer (Entity, Repository Interface, Usecase) 정의
  - [x] Data Layer (DTO, `MockStudentRepository` 구현)
  - [x] Presentation Layer (Riverpod Provider, UI Screen, Widget)

- Plans (1730Timetable & Student Plans)

  - [x] Domain Layer (Plan/PlanGroup entities, Repository interfaces, usecases)
  - [x] Data Layer (DTO, `MockPlanRepository` 구현)
  - [x] Presentation Layer (Providers, Plan list screen, Plan detail/edit screen)

- Timer / Study Session

* - [x] Domain Layer (StudySession entity, usecases: start/stop/save)
* - [x] Data Layer (Mock session persistence)
* - [x] Presentation Layer (Timer widget, session flow, session list)

- Scores / Reports

* - [x] Domain Layer (Score entity, report generation usecase)
* - [x] Data Layer (Mock scores, sample report JSON)
* - [x] Presentation Layer (Score list, graphs placeholder)

- Auth & Multi-tenant basics (local mock)

  - [x] Domain Layer (User/Tenant entities, AuthRepository interface, AuthException)
  - [x] Data Layer (MockAuthRepository with 2 test users: student@test.com, teacher@test.com)
  - [x] Presentation Layer (LoginScreen with quick-login buttons, AuthNotifier provider)
  - [x] Router Redirect Logic (redirect /login on unauthenticated, /home on authenticated)

- Shared / Core
  - [ ] Domain Layer (common enums, failures)
  - [ ] Data Layer (DTO converters, sample fixtures)
  - [ ] Presentation Layer (global providers, theme provider)

**✅ Phase 1 Complete** — All features implemented with mock data

Phase 2 — Supabase integration (swap MockRepository -> RealRepository)

- Database & Auth

  - [x] Add supabase_flutter and flutter_dotenv dependencies
  - [x] Create .env file with Supabase URL and Anon Key
  - [x] Implement `RealAuthRepository` with Supabase auth + user table query
  - [x] Switch authRepositoryProvider to use RealAuthRepository
  - [x] Write SQL setup guide (SUPABASE_SETUP.sql and SUPABASE_SETUP_GUIDE.md)
  - [x] Add RLS-safe queries (tenant_id) and migrate seed data
  - [x] Wire Supabase Auth session refresh and persistence

- Auth Persistence & Session Restoration

  - [x] Create SplashScreen for initial loading
  - [x] Implement `getCurrentUser()` in AuthRepository interface
  - [x] Implement session restoration in `RealAuthRepository`
  - [x] Update `AuthProvider` to automatically restore session on app start
  - [x] Update Router with `/splash` as initial location
  - [x] Implement automatic navigation based on auth state

- Repository Implementations (Mock → Real)

  - [x] Students: Implement `RealStudentRepository` with Supabase queries
  - [x] Plans: Implement `RealPlanRepository` with Supabase queries
  - [x] Scores: Implement `RealScoreRepository` with Supabase queries
  - [x] Timer: Implement `RealTimerRepository` with Supabase insert (first Insert operation)

- Database Schema Expansion

  - [x] Create `students` table with RLS policies
  - [x] Create `student_plans` table with RLS policies
  - [x] Create `scores` table with RLS policies
  - [x] Create `student_study_sessions` table with RLS policies
  - [x] Add test data insertion queries for all tables

- Provider Updates (DI Switching)

  - [x] Switch `studentRepositoryProvider` to use RealStudentRepository
  - [x] Switch `planRepositoryProvider` to use RealPlanRepository
  - [x] Switch `scoreRepositoryProvider` to use RealScoreRepository
  - [x] Switch `timerRepositoryProvider` to use RealTimerRepository

- Background jobs & AI

  - [x] Integrate AI backend endpoints (OpenAI/LLM) for plan recommendations
  - [x] Implement OpenAI Plan Service for AI-powered plan generation
  - [x] Implement Gemini Plan Service for AI-powered plan generation
  - [x] Create Hybrid AI Architecture with Factory pattern
  - [x] Create Plan Generation UI with preview and save functionality
  - [x] Add AI Plan Generation buttons to home screens
  - [ ] Implement server-side plan generation functions (supabase functions or separate service) - Optional enhancement

- Production concerns
  - [x] Add Sentry, monitoring, and telemetry
  - [x] Robust JSON parsing for AI responses (markdown code block handling)
  - [x] Global error handling with Sentry integration
  - [x] CI: build/test on GitHub Actions, publish artifacts

Notes / Conventions

- Follow Clean Architecture: `features/<feature>/{presentation,domain,data}`.
- Keep `Mock*Repository` implementations under `data/repositories/mock_*`.
- Use Riverpod (codegen) for providers; keep providers in `presentation/providers`.
- Use Freezed + json_serializable for domain entities and DTOs.
- Always require `tenantId` in repository methods to encourage multi-tenant safety.

When ready to proceed, tell me which feature to scaffold next (e.g., Students list, Timer UI, or Plan generator).
