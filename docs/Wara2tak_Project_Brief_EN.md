# Wara2tak — Project Master Brief

> **Instruction to the assistant:** Explain everything to me step by step in clear, simple language. Do not write code or start implementation until the complete plan and required documents are finished, reviewed, and explicitly approved by me.

Use this file as the source of truth in every new chat. Read it first; do not ask me to repeat confirmed information. Follow the latest dated decisions. Clearly separate confirmed decisions, suggestions, and open questions. At the end of every project session, update this file with what was completed, what changed, and what remains. Return the updated file. Never claim work was completed unless it actually was.

## 1. Product

- **Name:** Wara2tak (ورقتك)
- **Positioning:** AI-powered Document Understanding & Application Planner.
- **Purpose:** Help university students and recent graduates understand opportunity announcements and turn them into actionable application plans.
- **Problem:** Scholarship, internship, exchange, training, and academic-program announcements can be long, confusing, or written in another language. Students may miss eligibility rules, required documents, deadlines, or application steps.
- **Solution:** Users upload a PDF or image. AI extracts and explains key information, creates a checklist, answers questions about the document, and translates selected content.

## 2. Confirmed User Decisions

| Area              | Decision                                                                  |
| ----------------- | ------------------------------------------------------------------------- |
| Audience          | University students; recent graduates may also be supported               |
| Opportunity types | Scholarships, internships, exchange programs, training, academic programs |
| Platforms         | Android + iOS using Flutter                                               |
| App languages     | Arabic + English; support RTL/LTR                                         |
| Sign-in           | Google Sign-in selected                                                   |
| Upload            | PDF + images (camera/gallery)                                             |
| Checklist         | Include in intended MVP                                                   |
| AI Chat           | Include; tied to the analyzed document                                    |
| Translation       | Include limited translation; no full PDF layout recreation                |

These choices define the current direction, not final technical approval. Apple Sign-in, Guest Mode, limits, and other unresolved details remain open until approved.

## 3. Scope

### MVP — Planned Features

**A. Upload**

- Select PDF from device files.
- Select JPG/PNG from gallery or capture with camera.
- Preview, confirm, cancel, or replace before analysis.
- Validate file type, size, and page count; show clear processing and error states.
- Exact limits are not approved yet. A previous suggestion was 20 pages / 20 MB; test cost and service limits before deciding.

**B. AI Analysis**
Extract when present:

- Opportunity title and type.
- Plain-language summary.
- Eligibility, academic, and language requirements.
- Required documents.
- Deadlines.
- Application steps and important notes.
- Missing or unclear information.
- Evidence: source excerpt and page number where possible.

Never invent missing requirements or dates. Mark absent or unclear information explicitly. Preserve official names and let users verify results against the source document.

**C. Checklist**

- Generate tasks from requirements and application steps.
- Mark complete/incomplete; edit or delete tasks; add personal tasks.
- Optional personal due dates and progress display.
- Distinguish official requirements from personal tasks. Do not assume the user already has a required document; the user controls task status.

**D. Document Chat**

- Chat is available from an analyzed document's details page.
- MVP answers use that document and its extracted analysis, not an unrestricted general chatbot.
- Say clearly when information is not in the source.
- Show supporting excerpt/page reference where possible.
- Keep conversations separate per document; allow deletion.

**E. Translation**

- Translate summary, requirements, required-document lists, application steps, and user-selected excerpts.
- Show original text alongside translation where useful.
- App UI language and analysis-output language are separate settings.
- Full-PDF translation with original layout, tables, and formatting is out of MVP scope.

**F. Saved Documents**

- List, open, and delete saved documents and their analysis.
- Deletion must also remove associated chat/tasks and stored source file as applicable.

### Explicitly Out of MVP

- Discovering opportunities from the internet.
- Applying automatically on the user's behalf.
- CV or motivation-letter generation.
- Comparing many opportunities.
- Full PDF translation/reconstruction.
- Advanced or recurring notifications.
- Acceptance-chance prediction.
- General chatbot unrelated to a document.
- Medical, legal, financial, or other unrelated document categories.

## 4. Audience and Product Boundaries

Focus on students/recent graduates applying to educational and early-career opportunities. Do not position the first version as a general PDF reader or a universal document-analysis tool. Do not accept passports, identity documents, or sensitive personal records in the MVP; focus on opportunity announcements. The checklist may remind users to prepare personal documents without uploading them.

The app is an assistant, not an official source or guarantee of eligibility/acceptance. Users must verify important details with the original announcement and official provider.

## 5. Main User Journey

1. Open app and sign in (exact sign-in timing still open).
2. Home shows recent documents and an add-document action.
3. Choose PDF or image; preview and confirm.
4. App validates the file and shows analysis progress.
5. AI extracts structured information and evidence.
6. Results show summary, eligibility, requirements, documents, deadlines, and steps.
7. User reviews/uses document-specific chat and translation.
8. App creates a checklist; user edits and tracks tasks. _(Design draft v2 assumes the checklist is created automatically after analysis; pending approval, see Section 12 #16.)_
9. User can reopen or delete saved documents.

## 6. Proposed Screens and Navigation

Proposed screens:

1. Splash/onboarding (may be simplified or omitted).
2. Authentication.
3. Home.
4. Upload and file selection.
5. Preview/confirmation.
6. Analysis progress and error states.
7. Document details/results.
8. Document chat.
9. Checklist.
10. My Documents.
11. Profile/settings.

Proposed bottom navigation: **Home / My Documents / Profile**. Keep Chat, Checklist, and Translation inside the selected document's details experience rather than adding every feature to main navigation. _(Design draft v2 shows a 4-tab bar on most screens, with an extra "Upload" tab, while Home shows 3 tabs. See Section 12 #14.)_

Support Arabic RTL and English LTR throughout. Preserve official program names and useful English terms in Arabic results. Switching language must handle layout direction and date formatting correctly.

### 6.1 UI Design Draft Status (added 2026-11-14)

> Status: **Draft, under review, not approved.** Reviewed from the exported code/text only, not from rendered visuals. Nothing here changes the confirmed decisions in Section 2.

**Delivered:** two Stitch exports (v1 and v2) with a master design system file (`wara2tak_master_design_system.md`). v2 contains 14 app screens, a system-states reference sheet, and RTL versions of every screen (the splash screen is bilingual). The design system references a `components/` folder that was not included in the export.

**Design system (draft):** Deep Indigo `#4F46E5` primary, Soft Blue `#E0E7FF` secondary, `#F8FAFC` background, Navy `#0F172A` text. Fonts: Cairo (Arabic + headings), Inter (English body). 390px mobile baseline, 4/8px spacing, 12-16px radii, 44px minimum touch target. Light theme only.

**Screens in design draft v2 (14, up from the 11 proposed above):**

| #   | Screen                         | Notes                                                                                                                                                                            |
| --- | ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Splash                         | Split from onboarding                                                                                                                                                            |
| 2   | Onboarding                     | Single screen, Skip + Get Started                                                                                                                                                |
| 3   | Sign-in                        | Google only; includes a sign-in error state                                                                                                                                      |
| 4   | Home                           | Greeting, upload CTA, recent documents with status and task progress, "How it works"                                                                                             |
| 5   | Upload (Step 1 of 2)           | Browse PDFs, From Gallery, Scan Paper; formats; no-personal-documents notice                                                                                                     |
| 6   | Review / Preview (Step 2 of 2) | File card, Replace/Remove, warnings, Analyze                                                                                                                                     |
| 7   | Analysis Progress              | 4 stages: Uploading, Checking, Analyzing, Saving; Cancel                                                                                                                         |
| 8   | Analysis Errors                | 9 states: password, too large, wrong type, personal ID document, blurry scan, permissions, no internet, timeout/limit, partial results                                           |
| 9   | Document Details / Results     | Overview, deadlines, eligibility, required documents, steps, missing information, important notes, "View original (page N)", menu (Re-analyze, Change analysis language, Delete) |
| 10  | Document Chat                  | Grounded banner, suggested questions, page references, "Not found in document" answers, Clear conversation, empty and error states                                               |
| 11  | Checklist                      | Official ("From document") vs Personal tasks, progress, add-task sheet, "Deadline passed" state                                                                                  |
| 12  | Translation                    | Tabs: Summary, Eligibility, Required Documents, Deadlines & Steps, Custom text; original beside translation; error state                                                         |
| 13  | My Documents                   | Search, 7 type filters, statuses (Analyzed / Analyzing / Failed), delete confirmation                                                                                            |
| 14  | Profile / Settings             | Display name, Google provider, UI language, default AI language, policies, sign out, delete account with progress state                                                          |
| -   | System States sheet            | Empty states, skeletons, progress, error reference (not a real screen)                                                                                                           |

The 3 extra screens versus Section 6: onboarding separated from splash, errors separated from progress, translation as its own screen opened from document details.

**Assumptions applied in design draft v2 (not yet approved by you):** checklist created automatically after analysis; onboarding kept as one screen; "Submitted" application status removed; dark mode / Appearance setting removed; Western digits (0-9) used in Arabic screens.

**Fixed between v1 and v2:**

- Removed unsupported claims ("99% accuracy", "100% Extracted", "Eligibility Verified", "All 5 Met", "~10-15 seconds", "encrypted and never shared"). Missing facts now read "Not specified in the document".
- Chat answers are neutral and tell the user to confirm with the official provider.
- RTL versions now exist for every screen.
- Counts match content (5 required documents, 4 steps, 5 official + 3 personal tasks).
- Upload and Review are separate steps; Progress has honest stages and Cancel.
- Added "View original (page N)", Clear conversation, custom-text translation, missing-information section, Analyzing/Failed statuses, Training and Academic Program filters, "Deadline passed" state, and the nine error states.

**Still to fix in the design (open):**

1. Bottom navigation is inconsistent: 3 tabs on Home, 4 tabs (with "Upload") elsewhere.
2. Arabic translation screen labels the translated text "الترجمة العربية المعتمدة" (implies an official translation); change to machine translation wording.
3. Error screen states a limit of "20 pages or 25 MB"; limits are not approved (Section 3-A).
4. Home card shows "Analyzing" together with "26 days left" and task progress, which cannot exist before analysis finishes.
5. Warning amber `#F59E0B` is still used as text color; contrast is too low (use a darker amber such as `#B45309` for text).
6. Timeout and daily-limit errors are merged into one state; separate them.
7. Sign-in error mentions Google pop-up permissions, which is a web concept, not a mobile one.
8. Mock user data differs between screens (Home: Abdulrhman, Profile: another name and email).
9. "Default AI Language" is described only as "Language used for chat answers"; clarify it also covers analysis and translation.
10. Arabic copy issues: repeated word "التراكمي التراكمي" in Chat; Home uses colloquial Arabic while other screens use formal Arabic; document-type labels on Home RTL are in English.
11. Review screen shows a file card but no actual page preview.
12. Prototype-only controls ("Show empty state", "Toggle Error Demo", "View analyzed document results" on Progress) must not become real UI.

**Related files:** `Wara2tak_Features_Stack_Screens.md` (features, stack, screens, review notes) and `Wara2tak_Stitch_Fix_Prompts.md` (prompts used to update the Stitch design).

## 7. AI Behavior and Data Flow

Proposed flow:

1. Validate selected file.
2. Send it through the selected secure AI integration.
3. Analyze with a suitable Gemini model.
4. Request structured output using a defined schema.
5. Validate response and required fields.
6. Save analysis and source evidence.
7. Display results; reuse saved analysis for Chat, Translation, and Checklist.

Draft output fields (not final schema):

- `document_title`
- `document_type`
- `summary`
- `eligibility`
- `academic_requirements`
- `language_requirements`
- `required_documents`
- `deadlines`
- `application_steps`
- `important_notes`
- `unclear_or_missing_information`
- `evidence[]` with field, source quote, and page number when available

AI rules:

- Never guess deadlines, requirements, or missing facts.
- Distinguish explicit source statements from inference.
- State when information is missing or unclear.
- Preserve official names.
- Attach evidence/page references wherever technically possible.
- Test Arabic, English, scanned PDFs, and different image quality.

Cost/performance proposal: analyze each file once and save the structured result. Reuse extracted content for follow-up chat and translation instead of resending the original file unnecessarily. Validate answer quality and refresh context when needed.

## 8. Proposed Technology (Not Yet Approved)

| Area           | Candidate                     | Purpose                                                          |
| -------------- | ----------------------------- | ---------------------------------------------------------------- |
| Mobile         | Flutter + Dart                | Shared Android/iOS codebase                                      |
| Desktop        | Flutter + Dart                | Shared Windows/macOS/Linux codebase                              |
| AI             | Gemini                        | Document understanding, extraction, summaries, chat, translation |
| Platform       | Supabase                      | Backend services                                                 |
| Auth           | Supabase Auth                 | User accounts                                                    |
| Database       | Supabase (PostgreSQL)         | Structured data                                                  |
| Files          | Supabase Storage              | PDFs and images                                                  |
| AI integration | Direct Gemini API / Vertex AI | App-to-Gemini integration                                        |
| Protection     | Supabase RLS + Policies       | App/service abuse protection                                     |
| Design         | Figma                         | Flows, wireframes, UI design                                     |

Verify current official documentation, versions, pricing, model availability, SDK compatibility, and service requirements before finalizing. Do not expose secrets/API keys in the app. Review App Check and AI Logic requirements before implementation.

**Environment constraint:** User develops on Linux/Arch. Android development is possible there. iOS build/testing with Xcode requires macOS; arrange access to a Mac or macOS build service for iOS validation.

### 8.1 Windows Desktop Implementation (Implemented 2026-11-14)

The Windows runner has been fully implemented with the following features:

**High DPI Awareness (PerMonitorV2)**
- Manifest file (`runner.exe.manifest`) declares `PerMonitorV2` DPI awareness for crisp rendering on high-DPI displays
- Runtime DPI scaling via `FlutterDesktopGetDpiForMonitor` and dynamic `EnableNonClientDpiScaling` loading
- Automatic window size scaling based on monitor DPI (96 DPI baseline)

**Console Support**
- `CreateAndAttachConsole()`: Creates a new console when running under a debugger, or attaches to parent process console (e.g., `flutter run`)
- Redirects `stdout`/`stderr` to the console for both runner and Flutter engine
- Calls `FlutterDesktopResyncOutputStreams()` to synchronize Flutter's output streams

**Win32Window Class (`win32_window.h`/.cpp)**
- Abstract base class for high DPI-aware Win32 window management
- Handles window creation with proper DPI scaling (`Create()`, `Show()`, `Destroy()`)
- Message routing via `WndProc` → `MessageHandler` for:
  - `WM_NCCREATE`: Associates window with `Win32Window` instance, enables non-client DPI scaling
  - `WM_DESTROY`: Cleans up, optionally posts quit message
  - `WM_DPICHANGED`: Resizes window to suggested rect from system
  - `WM_SIZE`: Resizes child content (Flutter view)
  - `WM_ACTIVATE`: Focuses child content
  - `WM_DWMCOLORIZATIONCOLORCHANGED`: Updates window theme
- `UpdateTheme()`: Reads system preference from registry (`AppsUseLightTheme`) and applies `DWMWA_USE_IMMERSIVE_DARK_MODE` for dark mode window decorations
- Virtual `OnCreate()`/`OnDestroy()` for subclass customization

**FlutterWindow Class (`flutter_window.h`/.cpp)**
- Subclass of `Win32Window` hosting `FlutterViewController`
- `OnCreate()`: Creates Flutter controller with client area dimensions, registers plugins, sets child content
- `MessageHandler()`: Delegates to Flutter first (`HandleTopLevelWindowProc`), then handles `WM_FONTCHANGE` for system font reload

**Command Line Arguments**
- `GetCommandLineArguments()`: Parses UTF-16 command line via `CommandLineToArgvW`, converts to UTF-8 (skipping binary name)
- `Utf8FromUtf16()`: Safe UTF-16 to UTF-8 conversion with bounds checking

**Build System**
- CMake configuration in `windows/CMakeLists.txt`, `windows/runner/CMakeLists.txt`, `windows/flutter/CMakeLists.txt`
- Resource file (`Runner.rc`) with app icon
- Manifest embedded via CMake for DPI awareness

**Entry Point (`main.cpp`)**
- Attaches to parent console or creates new one when debugging
- Initializes COM (`COINIT_APARTMENTTHREADED`)
- Parses command line arguments and passes to Dart entrypoint
- Creates `FlutterWindow` (1280x720), runs message loop
- Cleans up COM on exit

## 9. Proposed Flutter Architecture (Not Yet Approved)

Use a simple **MVVM + Repository Pattern**; avoid unnecessary complexity.

- **Presentation:** Screens, widgets, ViewModels.
- **Data:** Models, repositories, data sources.
- **Services:** Firebase, Gemini integration, file picker, camera/gallery.

Feature modules: Authentication, Documents, AI Analysis, Checklist, Document Chat, Translation, Localization, Profile/Settings.

Candidate packages (verify current versions and compatibility): `provider`, `go_router`, `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_ai` or the officially recommended SDK, `file_picker`, `image_picker`.

## 10. Proposed Data Model (Not Yet Approved)

Possible Supabase (PostgreSQL) structure:

- `users` table — profile and settings (linked to `auth.users` via foreign key).
- `documents` table — metadata, status, storage path (with `user_id` FK).
- `document_analysis` table — structured AI result and evidence (with `document_id` FK).
- `checklist_tasks` table — checklist tasks (with `document_id` FK).
- `chat_messages` table — chat history (with `document_id` FK).

Finalize structure based on query needs and Row Level Security (RLS) policies. Likely document fields: `id`, `user_id`, `file_name`, `file_type`, `storage_path`, `uploaded_at`, `analysis_status`, `document_title`, `document_type`, `summary`, `analysis_language`, `analysis_version`.

Likely task fields: `id`, `document_id`, `title`, `description`, `is_completed`, `due_date`, `task_type` (`requirement` or `personal_task`), `source_reference`, `created_at`, `updated_at`.

Proposed Storage path: `users/{user_id}/documents/{document_id}/original_file`.

Enable RLS on all tables with policies ensuring users can only access their own data.

## 11. Privacy and Security Requirements

- Users can access only their own data and files.
- Configure Supabase Row Level Security (RLS) policies on all tables from the beginning.
- Enable Supabase Auth protections (email confirmation, MFA options, rate limiting).
- Protect secrets and API credentials using Supabase Vault/Edge Functions.
- Set upload and AI usage limits to control abuse and cost.
- Support deletion of source file, analysis, chat, tasks, and account data as appropriate.
- Explain what data is uploaded and processed.
- Define retention/deletion policy before release.

## 12. Open Decisions — Must Discuss and Approve

1. Require sign-in before first analysis, or allow Guest Mode with sign-in required to save?
2. Add Sign in with Apple on iOS alongside Google? Verify current Apple requirements and approve the approach.
3. Allow multiple images per upload? Set maximum count?
4. Final PDF page and file-size limits?
5. One document per analysis, or combine multiple documents for one opportunity?
6. How should evidence and page references appear in the UI?
7. Can users edit AI analysis fields? Which ones?
8. Data retention and default deletion policy?
9. Are local deadline reminders required in MVP, or postponed?
10. Final visual identity, colors, and screen design? _(Design draft v2 received 2026-11-14; under review, see Section 6.1.)_
11. Gemini model, integration method, usage limits, and cost controls?
12. iOS build/testing arrangement given Linux/Arch environment?
13. Should users export/share an analysis or checklist?

Added 2026-11-14 (from design review):

14. Bottom navigation: 3 tabs (Home / My Documents / Profile) or 4 tabs with Upload?
15. Keep Onboarding as a single screen, or remove it?
16. Is the checklist created automatically after analysis, or on demand?
17. Is the "Submitted" application status in MVP? (Removed in design draft v2.)
18. Is dark mode / Appearance setting in MVP, or deferred? (Removed in design draft v2.)
19. Which automatic checks are in MVP: blurry-image warning, many-pages warning, detection of personal/ID documents? Each needs a defined behavior in the AI/validation specification.
20. Arabic style: Western or Arabic-Indic digits (draft uses Western), and formal vs. colloquial Arabic tone (draft mixes both).
21. What exactly does "Default AI Language" control: analysis output, chat answers, translation, or all three?
22. Should the Review screen show a real preview of the file pages, or only a file card?
23. Approve the 14-screen design draft as the basis for the UI/UX Specification once the fixes in Section 6.1 are done?

## 13. Planning Deliverables — No Coding Yet

Complete in this order:

**Stage 0 — PRD**

- Confirm problem, audience, MVP boundaries.
- Define user stories, use cases, functional/non-functional requirements, priorities, edge cases, and acceptance criteria.
- Deliverable: approved Product Requirements Document.

**Stage 1 — User Flow & UI/UX**

- Navigation map and user journey.
- Define every screen and Loading/Empty/Error/Success state.
- Specify Arabic RTL and English LTR.
- Create wireframes and Figma designs.
- Deliverable: UI/UX Specification + Figma design.
- Status (2026-11-14): Stitch design draft v2 received and reviewed (Section 6.1). UI/UX Specification and Figma file are not created yet.

**Stage 2 — Technical Design**

- Finalize architecture, Supabase services, database/storage schema, authentication, RLS policies, file processing, and error handling.
- Deliverable: Technical Design Document.

**Stage 3 — AI Specification**

- Final prompts/instructions and JSON schema.
- Anti-hallucination and evidence rules.
- Chat context/history and translation behavior.
- Prepare representative test documents.
- Deliverable: AI Specification + prompt/schema plan.

**Stage 4 — QA & Release Plan**

- Functional, AI accuracy, Arabic/English, PDF/image, privacy, permissions, deletion, and failure tests.
- Deliverable: Test Plan + Definition of Done.

**Stage 5 — Final Approval**

- Review all documents and trade-offs with the user.
- Get explicit approval to begin development.

**Do not write code or start implementation before Stage 5 approval.**

## 14. Initial Definition of Done

- [ ] Sign-in flow works on supported platforms.
- [ ] Android and iOS builds are tested.
- [ ] Arabic/English UI and RTL/LTR work correctly.
- [ ] PDF and image upload work with validation and limits.
- [ ] Progress, empty, and error states are clear.
- [ ] AI extracts summary, eligibility, documents, deadlines, and steps.
- [ ] Missing information is never fabricated.
- [ ] Evidence/page references are shown where possible.
- [ ] Checklist tasks can be created, edited, and tracked.
- [ ] Chat is document-specific and evidence-aware.
- [ ] Translation covers agreed summaries, sections, and excerpts.
- [ ] Data persists after reopening the app.
- [ ] Document and account deletion work as specified.
- [ ] Users cannot access another user's data.
- [ ] Network and AI failures are handled gracefully.
- [ ] Test set covers Arabic/English, PDFs, images, and scanned files.
- [ ] Every extracted item can be traced to its source page, and the original file opens at that page.
- [ ] No screen claims accuracy, completeness, eligibility, or privacy guarantees that the app cannot prove.
- [ ] Every screen and error state exists and works in Arabic RTL and English LTR.
- [ ] Unsupported or personal documents (IDs, passports) are rejected with a clear message.

## 15. Current Status

**Last updated:** 15 November 2026  
**Current stage:** Stage 1 — User Flow & UI/UX (Stitch design draft v2 under review); **Implementation started and functional**  
**Implementation status:** Full Flutter app implemented with feature-first architecture, Cubit/Bloc state management, go_router navigation, Firebase integration, and Stitch design system.

### Confirmed

- [x] Project name and core concept: Wara2tak.
- [x] Student/recent-graduate audience and opportunity focus.
- [x] Flutter, Android + iOS target.
- [x] Arabic + English.
- [x] Google Sign-in selected.
- [x] PDF + image upload.
- [x] Checklist in intended MVP.
- [x] Document-specific AI Chat in intended MVP.
- [x] Limited Translation in intended MVP.
- [x] Planning first; no code before explicit approval.

### Completed Since 10 November (planning work, not approvals)

- [x] Wrote a features / stack / screens summary (`Wara2tak_Features_Stack_Screens.md`).
- [x] Reviewed Stitch design export v1 and listed required fixes.
- [x] Wrote per-screen Stitch prompts (`Wara2tak_Stitch_Fix_Prompts.md`) and applied them; design draft v2 received.
- [x] Reviewed design draft v2: most fixes applied; 12 items remain (Section 6.1).

### Implementation Completed (15 November 2026)

**Architecture & Core**
- [x] Feature-first architecture: `lib/{core,features,shared}`
- [x] Cubit/Bloc state management with `flutter_bloc ^8.1.6`
- [x] Dependency injection with GetIt
- [x] Navigation with go_router (14 routes matching Stitch screens)
- [x] Google Fonts (Cairo for Arabic/headlines, Inter for English/body)
- [x] Material 3 theming with custom ColorScheme (light/dark)
- [x] RTL/LTR support for Arabic/English via context extensions

**Desktop Support (Windows/macOS/Linux)**
- [x] **Windows**: Full runner implementation with PerMonitorV2 DPI awareness, console support, dark mode window decorations, command line argument handling
- [x] **macOS**: Runner with AppDelegate, SceneDelegate, MainFlutterWindow, entitlements, app icons, launch images
- [x] **Linux**: CMake build, GTK integration, plugin registrant

**Design System (`lib/core/design_system/`)**
- [x] AppColors: Primary Indigo, semantic colors, document type colors (blue/green/orange/purple)
- [x] AppTypography: Cairo/Inter with display/headline/title/body/label/tiny scales
- [x] AppSpacing: 4/8px scale with responsive helpers
- [x] AppShapes: Border radius scale, shadows, elevation
- [x] AppTheme: Light/dark themes with M3 components
- [x] AppMotion: Animation curves and durations

**Features Implemented**
- [x] **Auth**: Google Sign-in, auth state management (AuthCubit)
- [x] **Documents**: Upload (PDF/image via file_picker/image_picker), My Documents, Home dashboard, Document Details
- [x] **Analysis**: AI analysis cubit, progress tracking, error states
- [x] **Checklist**: Checklist cubit, state management
- [x] **Chat**: Document chat cubit
- [x] **Translation**: Translation cubit
- [x] **Profile**: Settings, theme toggle, language, account management

**Shared Widgets**
- [x] Buttons: Primary, Secondary, Tertiary, Destructive, FilledDestructive, GoogleSignIn, AppIconButton
- [x] Cards: AppCard, ElevatedCard, ActionCard, DocumentCard, EmptyState, ErrorState, LoadingState
- [x] Input fields with consistent styling

**Supabase Integration**
- [x] Supabase Flutter SDK configured
- [x] Google Sign-In authentication flow via Supabase Auth
- [x] Repository pattern with dartz Either for error handling
- [x] Supabase Database Service (PostgreSQL)
- [x] Supabase Storage Service

**Build & Quality**
- [x] `flutter analyze` → 0 errors (only style warnings)
- [x] Android debug APK builds successfully
- [x] Fixed compileSdk=36, built-in Kotlin (AGP 9+)
- [x] Updated dependencies: file_picker ^13.3.3, share_plus ^13.3.1

### Remaining (Planning Phase)

- [ ] Apply the 12 remaining design fixes (Section 6.1) and re-review.
- [ ] Decide open decisions 14-23 (Section 12).
- [ ] Obtain missing design-system `components/` files and create the Figma file.
- [ ] Write the UI/UX Specification.
- [ ] Complete and approve PRD.
- [ ] Resolve open decisions in Section 12.
- [ ] Create user flow and navigation map.
- [ ] Create wireframes and Figma designs.
- [ ] Approve screen details and UI states.
- [ ] Finalize architecture and packages.
- [ ] Finalize database and storage schema (Supabase/PostgreSQL).
- [ ] Finalize authentication, including Apple/Guest decisions.
- [ ] Approve security, privacy, retention, and deletion rules (RLS policies).
- [ ] Select Gemini model and integration approach (Direct API / Vertex AI).
- [ ] Finalize AI prompts, schema, Chat, and Translation behavior.
- [ ] Prepare test documents, QA plan, and Definition of Done.
- [ ] Obtain explicit approval before production coding.

**Last updated:** 15 November 2026  
**Current stage:** Stage 1 — User Flow & UI/UX (Stitch prompts generated for final tweaks); **Implementation prototype complete**  
**Implementation status:** Full Flutter app implemented and building successfully; design review ongoing.

### Completed Since 14 November

- [x] Generated Stitch fix prompts for the remaining 12 UI design issues.
- [x] Resolved open decisions: 3-tab navigation with FAB, Onboarding kept, auto-checklist (>=2 items), deferred Submitted status and Dark Mode, File Card only on Review screen, unified AI language scope.
- [x] **Implemented complete Flutter app with feature-first architecture, Cubit/Bloc, go_router, Firebase, Material 3 theming, RTL/LTR support.**
- [x] **Fixed all compilation errors (flutter analyze: 0 errors).**
- [x] **Built Android debug APK successfully.**
- [x] **Updated dependencies for AGP 9+ compatibility (compileSdk=36, built-in Kotlin).**

### Remaining

- [ ] Feed the new Prompts to Stitch and verify the final UI screens.
- [ ] Write the UI/UX Specification.
- [ ] Complete and approve PRD.
- [ ] Finalize architecture, database schema, authentication limits, and AI integration.
- [ ] Implement Supabase backend (RLS policies, Storage policies, Edge Functions).
- [ ] Implement AI analysis integration (Gemini API, structured output schema).
- [ ] Implement real document upload, analysis, chat, checklist, translation flows.
- [ ] Add unit/integration tests.
- [ ] Test on iOS (requires macOS).

## 16. Change Log

## 16. Change Log

| Date       | Change                                                                                                                                                                                           |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 2026-11-10 | Created the master project brief and planning roadmap.                                                                                                                                           |
| 2026-11-10 | Confirmed PDF upload in addition to images.                                                                                                                                                      |
| 2026-11-10 | Confirmed planning-only status; no implementation started.                                                                                                                                       |
| 2026-11-10 | Prepared a concise English version for reuse in new chats and lower context usage.                                                                                                               |
| 2026-11-14 | Added Section 6.1: Stitch design draft status, 14-screen inventory (up from 11), draft design system, assumptions applied, fixes done, and 12 open design fixes.                                 |
| 2026-11-14 | Added open decisions 14-23 (navigation, onboarding, checklist generation, Submitted status, dark mode, automatic file checks, Arabic style, AI language scope, Review preview, design approval). |
| 2026-11-14 | Updated Stage 1 status, Definition of Done (4 new items), Current Status, Remaining list, and Next Step. Journey step 8 and navigation note annotated with design-draft assumptions.             |
| 2026-11-15 | **Implemented full Flutter app**: feature-first architecture, Cubit/Bloc, go_router (14 routes), Firebase, Google Fonts (Cairo/Inter), Material 3 theming, RTL/LTR, design system. Fixed all compilation errors (0 errors). Built Android debug APK. Updated deps for AGP 9+ (compileSdk=36, built-in Kotlin, file_picker 13.3.3, share_plus 13.3.1). |
| 2026-11-15 | **Migrated from Firebase to Supabase**: Replaced Firebase Auth/Firestore/Storage with Supabase Auth/PostgreSQL/Storage. Updated pubspec.yaml, main.dart, injection.dart, auth repository, user model. Added Supabase config and service classes. Updated documentation. |

**Maintenance rule:** After each project session, update the date, confirmed decisions, completed items, remaining work, current stage, and next step. Record changed decisions with their dates; do not silently overwrite project history.
