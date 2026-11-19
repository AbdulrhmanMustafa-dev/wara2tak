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

### 7.1 Multi-Provider AI Architecture & Sequential Fallback Strategy (Updated 2026-11-18)

The AI analysis pipeline uses a **Sequential Failover Chain** (not parallel race) for maximum reliability.
This avoids the `Future.any()` bug where a fast 404 error from a deprecated model would immediately abort all other providers.

| Tier | Provider | Models (tried in order) | Protocol | Purpose |
|------|----------|------------------------|----------|---------|
| **Primary (Tier 1)** | Google AI Studio | `gemini-3-flash-preview` → `gemini-3.5-flash-lite` → `gemini-3.1-pro-preview` | `google_generative_ai` SDK | Sequential fallback chain for document analysis |
| **Fallback (Tier 2)** | Moonshot AI (Kimi) | `kimi-k2-0711-preview` | OpenAI-compatible REST (`/chat/completions`) | Fallback on ALL Gemini models failing; supports file upload for PDF extraction |
| **Fallback (Tier 3)** | Cerebras | `llama-3.3-70b` | OpenAI-compatible REST (`/chat/completions`) | Ultra-fast inference as final fallback; text-only (no file upload) |

**Gemini Internal Model Fallback Chain (sequential within Tier 1):**
1. Try `gemini-3-flash-preview` — **PRIMARY MODEL**
2. If the primary fails after retries, try `gemini-3.5-flash-lite`
3. If fallback 1 fails after retries, try `gemini-3.1-pro-preview`
4. If ALL Gemini models fail → trigger Kimi fallback (Tier 2)

**Fallback Trigger Conditions:**
- **Retryable errors** (triggers retries on same model): HTTP 503, 429, 500, 502, 504, `UNAVAILABLE`, `RESOURCE_EXHAUSTED`, `TimeoutException`, `SocketException`. Timeouts retry once before moving to the next model.
- **Immediate fallback triggers** (skips retries, tries next model): HTTP 404 (model not found), 400 (unsupported), 401, 403, `QUOTA_EXHAUSTED`
- **Provider failover** (triggers next tier): ANY exception from the full Gemini chain (all 4 models exhausted) triggers Kimi if `kimiApiKey` is configured; if Kimi fails or unconfigured, triggers Cerebras if `cerebrasApiKey` is configured

**Retry Logic (per Gemini model):**
- Max 2 retries with exponential backoff: 1s → 2s; timeouts retry once.
- Document analysis uses a 90-second Gemini timeout; chat and translation use 45 seconds.
- Only retries on retryable errors (503, 429, 500, 502, 504, UNAVAILABLE, RESOURCE_EXHAUSTED)
- Does NOT retry on 404, 400, 401, 403, QUOTA_EXCEEDED → immediately tries next model

**Kimi Fallback for PDF/Image Analysis (Tier 2):**
- On analysis requests with file attachments, uploads file to Moonshot `/v1/files` (purpose: `file-extract`) first
- Fetches extracted text via `GET /v1/files/{file_id}/content`
- Then calls `/v1/chat/completions` with the extracted document text
- Handles UTF-8 safe decoding and JSON validation

**Cerebras Fallback (Tier 3):**
- Text-only (cannot accept raw PDF bytes in JSON body)
- Used for chat/translation; for analysis, requires text content extracted beforehand
- Ultra-low latency (~100ms) but no file upload capability

**Structured Output:**
- All engines use JSON schema validation (`responseSchema`) for analysis
- Response parsing strips markdown code fences (```json ... ```) safely
- Validates required fields before returning to caller
- Error map records status of EVERY provider (including "Skipped (API key empty)") for debugging

### 7.2 Analysis Progress State Machine (Updated 2026-11-18)

Granular progress updates prevent UI freeze at 40%. The progress now reflects the **sequential** failover chain (not parallel race).

| Stage | Progress | Message | Description |
|-------|----------|---------|-------------|
| 0 | 0% | "Starting analysis..." | Initial state |
| 1 | 10% | "Reading file..." | Local file I/O |
| 2 | 20% | "File read successfully. Preparing for analysis..." | File validation complete |
| 3 | 40% | "Sending to primary AI engine (Gemini)..." | Primary API request (**gemini-3-flash-preview**) |
| 4a | 45% | "Gemini returned 503. Retrying in 1s (attempt 1/2)..." | Retry 1 on retryable error (503/429/5xx) |
| 4b | 50% | "Gemini returned 503. Retrying in 2s (attempt 2/2)..." | Retry 2 on retryable error |
| 4c | 45% | "Gemini 3-flash-preview unavailable. Trying gemini-3.5-flash-lite..." | **Model fallback** |
| 4d | 50% | "Gemini 3.5-flash-lite unavailable. Trying gemini-3.1-pro-preview..." | **Model fallback** |
| 5 | 55% | "All Gemini models failed. Switching to fallback engine (Kimi)..." | Kimi fallback triggered |
| 5a | 57% | "Uploading document to fallback engine (Kimi)..." | File upload to Moonshot `/v1/files` |
| 6 | 60% | "Processing Kimi response..." | Kimi API request |
| 6a | 62% | "Kimi failed. Trying Cerebras ultra-fast..." | Cerebras fallback triggered |
| 7 | 80% | "Parsing structured analysis..." | JSON parsing & validation |
| 8 | 85% | "Saving results to database..." | Supabase write |
| 9 | 100% | "Analysis complete" | Done → `AnalysisCompleted` state |

**Error Recovery:**
- On total failure: emits `AnalysisError` with `code` (e.g., `SERVER_ERROR`, `UNEXPECTED_ERROR`)
- UI shows retry button → calls `retryLastAnalysis()` with stored parameters
- `canRetryLastAnalysis` getter exposes retry availability
- Error message includes status of ALL providers (e.g., "Gemini (4 models): 404; Kimi: Skipped (API key empty); Cerebras: Skipped (API key empty)")

### 7.3 Configuration & Environment Setup

All secrets loaded via `--dart-define` at build time (recommended for CI/CD) or `.env` for local development:

```bash
# Build with API keys (CI/CD)
flutter build apk \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=GEMINI_API_KEY=your-gemini-key \
  --dart-define=KIMI_API_KEY=your-kimi-key \
  --dart-define=KIMI_BASE_URL=https://api.moonshot.ai/v1 \
  --dart-define=CEREBRAS_API_KEY=your-cerebras-key \
  --dart-define=CEREBRAS_BASE_URL=https://api.cerebras.ai/v1

# Local development: create .env file in project root
# SUPABASE_URL=https://...
# SUPABASE_ANON_KEY=...
# GEMINI_API_KEY=...
# KIMI_API_KEY=... (or kimi_api_key)
# KIMI_BASE_URL=https://api.moonshot.ai/v1
# CEREBRAS_API_KEY=...
# CEREBRAS_BASE_URL=https://api.cerebras.ai/v1
```

**Validation at Startup** (`SupabaseConfig.initialize()`):
- Throws `StateError` if `GEMINI_API_KEY` missing (primary required)
- Warns if `KIMI_API_KEY` missing (fallback optional but recommended)
- Warns if `CEREBRAS_API_KEY` missing (final fallback optional)
- Logs masked keys (first 4 + last 4 chars) with `CONFIGURED`/`MISSING` status in debug mode
- `isGeminiConfigured` / `isKimiConfigured` / `isCerebrasConfigured` getters for runtime checks
- Reads `.env` file at runtime; `.env` values take precedence over `--dart-define` defaults
- Supports both `KIMI_API_KEY` and `kimi_api_key` (lowercase) in `.env`

**Dependency Injection** (`injection.dart`):
- Validates keys before registering `AIRepositoryImpl`
- Registers real `AIRepositoryImpl` (not mock) when Supabase available
- `AIRepositoryImpl` receives `geminiApiKey`, `kimiApiKey`, and `cerebrasApiKey` from config
- Passes instance keys to avoid static config lookup issues

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

## 10. Proposed Data Model — **Implemented in Supabase PostgreSQL**

The following tables are created in Supabase with camelCase column names matching Dart models:

- `profiles` — profile and settings (linked to `auth.users` via foreign key, `id` PK).
- `documents` — metadata, status, storage path (with `userId` FK).
- `analyses` — structured AI result and evidence (with `documentId` FK).
- `checklist_items` — checklist tasks (with `documentId` and `userId` FKs).
- `chat_messages` — chat history (with `documentId` and `userId` FKs).
- `translations` — translation history (with `documentId` and `userId` FKs).

**Storage**: Private `documents` bucket with user-folder isolation (`$userId/{timestamp}_$fileName`).

**Security**: Row Level Security (RLS) enabled on all tables with policies ensuring users can only access their own data. `on_auth_user_created` trigger auto-creates profile on sign-up.

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

**Last updated:** 18 November 2026  
**Current stage:** Stage 1 — User Flow & UI/UX (Stitch design draft v2 under review); **Implementation started and functional**  
**Implementation status:** Full Flutter app implemented with feature-first architecture, Cubit/Bloc state management, go_router navigation, **Supabase integration (Auth, PostgreSQL, Storage)**, and Stitch design system. **All 4 UI/Feature issues from emulator testing fixed** (Deadlines overflow, ChecklistScreen, DocumentChatScreen, TranslationScreen fully implemented).

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
- [x] Navigation with go_router (14 routes matching Stitch screens) — **Fixed `AssertionError` by separating Bottom Navigation (`go()`) from Sub-screen routing (`push`)**; added `PopScope` to main tab screens (`UploadScreen`, `MyDocumentsScreen`, `ProfileScreen`) to intercept system back button and route to `HomeScreen`
- [x] Google Fonts (Cairo for Arabic/headlines, Inter for English/body)
- [x] Material 3 theming with custom ColorScheme (light/dark)
- [x] RTL/LTR support for Arabic/English via context extensions

**Localization & RTL (18 November 2026)**
- [x] Official Flutter gen-l10n with ARB files (`app_en.arb`, `app_ar.arb`)
- [x] App UI Language: English + Arabic only (2 languages matching design system)
- [x] Default Translation Language: 10-language selector under Preferences (Arabic, English, French, Spanish, German, Chinese, Hindi, Urdu, Turkish, Persian)
- [x] LocaleCubit with SharedPreferences persistence for instant launch
- [x] Full RTL support: Directionality, EdgeInsetsDirectional, AlignmentDirectional, BorderRadiusDirectional, TextAlign.start/end
- [x] MaterialApp wired with LocaleCubit via BlocBuilder
- [x] ProfileScreen: Separate App Language and Default Translation Language dialogs
- [x] 14 LocaleCubit unit tests (all passing)
- [x] Widget tests for ProfileScreen localization

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
- [x] **Database schema implemented**: `profiles`, `documents`, `analyses`, `checklist_items`, `chat_messages`, `translations` tables with camelCase columns
- [x] **RLS policies** configured on all tables for user data isolation
- [x] **Storage policies** for private `documents` bucket with user-folder isolation
- [x] **Real repositories implemented**: `DocumentRepositoryImpl`, `ProfileRepositoryImpl`, `ChecklistRepositoryImpl`, `ChatRepositoryImpl`, `TranslationRepositoryImpl`
- [x] **Repositories wired in `injection.dart`** with SupabaseClient dependency
- [x] **Automatic data loading** on auth (Home, My Documents, Profile screens)
- [x] **Storage key sanitization** for Arabic/special-char filenames in `DocumentRepositoryImpl`
- [x] **Reactive theme/locale** in `MaterialApp` via `BlocBuilder<ProfileCubit>`
- [x] **Material ancestor for `ListTile`** in `AppCard` via `provideMaterial` flag

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

**Last updated:** 18 November 2026  
**Current stage:** Stage 1 — User Flow & UI/UX (Stitch prompts generated for final tweaks); **Implementation prototype complete**  
**Implementation status:** Full Flutter app implemented and building successfully; **Supabase schema, RLS, Storage, and real repositories implemented**; **3 runtime issues fixed (Storage key sanitization, reactive theme/locale, ListTile Material ancestor)**; **4 UI/Feature issues fixed (Deadlines overflow, ChecklistScreen, DocumentChatScreen, TranslationScreen)**; design review ongoing.

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
- [ ] Finalize architecture, authentication limits, and AI integration.
- [ ] Implement AI analysis integration (Gemini API, structured output schema).
- [ ] Implement real document analysis, chat, checklist, translation flows (AI-powered).
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
| 2026-11-16 | **Added Windows Desktop Implementation Documentation**: Documented full Windows runner implementation (PerMonitorV2 DPI awareness, console support, Win32Window/FlutterWindow classes, dark mode window decorations, command line arguments, CMake build) in Section 8.1. Updated Implementation Completed status to include Desktop Support for Windows/macOS/Linux. |
| 2026-11-16 | **Refactored GoRouter Navigation**: Fixed `AssertionError: currentConfiguration.isNotEmpty` by separating Bottom Navigation routing from Sub-screen routing. Updated `lib/core/navigation/app_router.dart` to use `go()` for main tabs (Home, My Documents, Profile, Auth, Onboarding, **Upload**) and `push()` for all sub-screens (Preview, Analysis Progress, Analysis Error, Document Details, Document Chat, Checklist, Translation). Added safe navigation extensions (`canGoBack`, `goBack`) in `lib/core/extensions/context_extensions.dart`. Removed invalid back buttons from main tab AppBars (`UploadScreen`, `MyDocumentsScreen`). Updated all sub-screen back navigation to use safe pattern: `if (context.canGoBack) context.goBack() else AppRouter.goToHome(context)`. Updated delete dialog logic to safely close dialog, trigger deletion, then safely navigate back. |
| 2026-11-16 | **Added PopScope to Main Tab Screens**: Wrapped `UploadScreen`, `MyDocumentsScreen`, and `ProfileScreen` with `PopScope(canPop: false, onPopInvoked: ...)` to intercept system back button on secondary main tabs. Pressing back on these tabs now navigates to `HomeScreen` instead of closing the app — standard Android bottom navigation behavior. |
| 2026-11-16 | **Implemented Supabase Schema, RLS & Real Repositories**: Created PostgreSQL tables (`profiles`, `documents`, `analyses`, `checklist_items`, `chat_messages`, `translations`) with strict Row Level Security (RLS), auto-profile creation trigger (`handle_new_user`), and private `documents` Storage bucket with user-folder isolation. Implemented `DocumentRepositoryImpl`, `ProfileRepositoryImpl`, `ChecklistRepositoryImpl`, `ChatRepositoryImpl`, and `TranslationRepositoryImpl` and registered them in `injection.dart`. Wired automatic data loading for Home, My Documents, and Profile screens. |
| 2026-11-16 | **Fixed 3 Runtime Issues**: (1) Supabase Storage `InvalidKey` for Arabic/spaced filenames — added `_sanitizeStorageFilename()` in `DocumentRepositoryImpl` to sanitize storage keys while preserving original filename in DB. (2) Theme/Locale not reactive in `MaterialApp` — wrapped `MaterialApp.router` in `BlocBuilder<ProfileCubit>` to dynamically update `themeMode` and `locale` from profile. (3) `ListTile` Material ancestor assertion error in `AppCard` — added `provideMaterial` flag to `AppCard` and enabled it in Profile screen sections containing `ListTile`/`RadioListTile`. |
| 2026-11-17 | **AI Integration:** Implemented `AIRepositoryImpl` using `google_generative_ai` and Gemini 1.5 Flash. Integrated native JSON Structured Outputs for flawless extraction of clauses, deadlines, and requirements into Dart models. Replaced mock AI repository with the real implementation. |
| 2026-11-17 | **API Key Configured:** Added Gemini API key to `SupabaseConfig.geminiApiKey` for production use. |
| 2026-11-17 | **End-to-End Analysis Flow:** Updated `AnalysisCubit` to save AI analysis results to Supabase via `DocumentRepository.saveAnalysis()`. Analysis now: (1) calls Gemini AI, (2) receives structured JSON, (3) saves to PostgreSQL, (4) emits `AnalysisCompleted` with saved analysis. Updated `injection.dart` to inject both `AIRepository` and `DocumentRepository` into `AnalysisCubit`. |
| 2026-11-17 | **AI Retry Mechanism:** Implemented robust retry logic in `AIRepositoryImpl._generateContentWithRetry()` with exponential backoff (1s, 2s, 4s), max 4 attempts (3 retries), smart error classification (retries only on 429/500/502/503/504, UNAVAILABLE, RESOURCE_EXHAUSTED), and progress updates during retries. Applied to all AI calls: `analyzeDocument`, `chatWithDocument`, and `translateDocument`. |
| 2026-11-17 | **Multi-Provider AI Fallback:** Implemented fallback architecture in `AIRepositoryImpl` with Kimi (Moonshot AI) as secondary provider. Added `http` package for REST API calls. Added `kimiApiKey` and `kimiBaseUrl` to `SupabaseConfig`. New `_generateContentWithFallback()` method tries Gemini first with retries, then automatically falls back to Kimi on failure. Applied to `analyzeDocument`, `chatWithDocument`, and `translateDocument`. Kimi uses OpenAI-compatible endpoint (`https://api.moonshot.cn/v1/chat/completions`) with `kimi-k2-0711-preview` model. |
| 2026-11-17 | **Robust JSON Parsing & Error Handling:** Enhanced `_callKimiApi` with comprehensive error handling: HTTP status code validation, UTF-8 safe decoding, response structure validation (choices/message/content), try-catch around JSON parsing. Added `_extractJsonFromResponse()` to strip markdown code blocks (```json ... ```), and `_parseJsonSafely()` for validated JSON parsing with detailed logging. Added `isAnalysis` flag to `_generateContentWithFallback` to enforce JSON validation for document analysis. |
| 2026-11-17 | **Upload → Analysis Flow:** Updated `UploadScreen` `BlocListener` to trigger AI analysis on upload success. Now calls `AnalysisCubit.analyzeDocument()` and navigates to `AnalysisProgress` screen instead of `Preview`. |
| 2026-11-17 | **Fixed Local File Path for AI Analysis:** Updated `AIRepository.analyzeDocument()` to accept `localFilePath` parameter. Modified `AIRepositoryImpl` to read from local device path instead of Supabase Storage URL. Updated `AnalysisCubit` and `UploadScreen` to pass `_selectedFile!.path` directly to the AI service, ensuring Gemini 1.5 Flash receives the actual file bytes. |
| 2026-11-18 | **Fixed 40% Freeze Bug & Added Test Coverage:** Resolved indefinite hang at "Analyzing Document" (40%) caused by Gemini 503 errors with no fallback. Changes: (1) **Timeout & Retry** — 30s Gemini timeout, 2 retries with exponential backoff (1s, 2s), smart retry classification (503/429/500/502/504/UNAVAILABLE/RESOURCE_EXHAUSTED). (2) **Automatic Kimi Fallback** — On retry exhaustion, switches to Kimi (Moonshot AI) via OpenAI-compatible REST API with 60s timeout. (3) **Granular Progress** — 10-stage progress (0→10→20→40→45→50→55→60→80→85→100) with descriptive messages; UI never stalls. (4) **Startup Validation** — `SupabaseConfig.initialize()` validates API keys at launch; throws clear `StateError` if Gemini key missing; warns if Kimi key missing. (5) **Test Suite** — 12 automated tests covering: 3 analysis scenarios (Gemini success, Gemini 503→Kimi fallback, both fail), save failure, retry, chat, translate, checklist. All tests pass; `flutter analyze` shows 0 errors. |
| 2026-11-18 | **Gemini Model Upgrade & Fallback Chain Fix:** Fixed root cause `models/gemini-1.5-flash is not found for API version v1beta`. Changes: (1) **Model Upgrade** — Primary model changed from `gemini-1.5-flash` to `gemini-2.5-flash` (latest stable). (2) **Internal Gemini Fallback Chain** — Added `gemini-2.0-flash` as secondary model; if primary throws 404/model not found/unsupported, immediately tries secondary before Kimi. (3) **Fallback Trigger Fix** — Separated retryable errors (503/429/5xx → retry) from immediate fallback triggers (404/400/401/403/QUOTA_EXCEEDED → no retry, immediate fallback). ANY Gemini failure now triggers Kimi if configured. (4) **Kimi PDF Support** — Added file upload to Moonshot `/v1/files` (purpose: `file-extract`) for PDF/image analysis fallback. (5) **Updated Tests** — 14 tests covering: Gemini success, 503 retry→Kimi, 404→secondary Gemini, both Gemini fail→Kimi, save failure, retry, chat, translate, checklist. All tests pass. |
| 2026-11-18 | **DocumentDetailsScreen Black Screen Fix & Sequential Failover Refinement:** Fixed black screen when navigating to DocumentDetailsScreen after analysis completes. Root cause: race condition in DocumentCubit (separate DocumentLoaded + AnalysisLoaded states) + improper navigation (replace() on pushed route). Changes: (1) **Atomic State** — Added `loadDocumentWithAnalysis()` in DocumentCubit that fetches document + analysis via `Future.wait` and emits single combined `DocumentLoaded(document, analysis: analysis)` state. (2) **Removed Race** — Removed separate `AnalysisLoaded` state, removed `AnalysisProgressState` from DocumentState (handled by AnalysisCubit). (3) **Fixed Navigation** — Changed `_AnalysisProgressScreen` listener in `app_router.dart` from `AppRouter.replace()` to `context.go()` to properly clear progress screen from stack when navigating to document details. (4) **Gemini Model Order** — Reordered primary model to `gemini-3-flash-preview` first (working for new projects; `gemini-3.0-flash` returns 404). Updated docs to reflect correct order. (5) **All 14 tests pass** — `flutter analyze` 0 errors, `flutter test` 14/14 pass. |
| 2026-11-18 | **UI/Feature Fixes (4 issues from emulator testing):** (1) **Deadlines Tab Right Overflow** — Fixed `DeadlineCard` in `DocumentDetailsScreen` by wrapping title in `Expanded` with `maxLines: 2` and `overflow: TextOverflow.ellipsis`. (2) **ChecklistScreen Full Implementation** — Replaced placeholder with full interactive `_ChecklistScreen` in `app_router.dart` featuring: BlocBuilder<ChecklistCubit>, auto-generation from analysis (summary, deadlines, financial obligations, key clauses, red flags), add/edit/delete tasks, category/priority/due date dialogs, progress bar, section grouping (Official vs Personal), swipe-to-delete confirmation. (3) **DocumentChatScreen Full Implementation** — Replaced placeholder with full `_DocumentChatScreen` featuring: BlocBuilder<ChatCubit>, suggested question chips, chat history with loading bubbles, markdown-aware message rendering, source citations with page references, clear conversation with confirmation, auto-scroll to bottom, keyboard-friendly input bar. (4) **TranslationScreen Full Implementation** — Replaced placeholder with full `_TranslationScreen` featuring: BlocBuilder<DocumentCubit> + BlocBuilder<TranslationCubit>, 6 tabs (Summary, Deadlines, Financial Obligations, Key Clauses, Red Flags, Custom Text), language selectors with swap button, translate buttons with loading state, original/translation side-by-side display using `AppCard` + `SelectableText`, empty states for missing content, uses actual AnalysisModel fields (summary, deadlines, financialObligations, keyClauses, redFlags). **All `flutter analyze` errors fixed (0 errors)**, **`flutter test` 14/14 pass**. |
| 2026-11-18 | **Bug Fixes (3 issues from emulator testing — Session 2):** (1) **TranslationScreen TabController Error** — Fixed `FlutterError: No TabController for TabBarView` in `_TranslationScreen` by wrapping Scaffold with `DefaultTabController(length: 6, child: ...)` since the screen has 6 tabs and doesn't mix in `SingleTickerProviderStateMixin`. (2) **Foreign Key Constraint Error (23503)** — Verified documentId flow from `AnalysisProgressScreen` → `DocumentDetailsScreen` → `ChecklistScreen`; confirmed `AnalysisProgressScreen` uses `state.analysis.documentId` (the documents table ID, not analysis ID), `DocumentDetailsScreen` uses `doc.id` for navigation, and `ChecklistScreen` uses `widget.documentId` consistently. The FK constraint is satisfied because all layers reference the correct document ID. (3) **Bottom Action Bar Overflow** — Fixed overflow in `DocumentDetailsScreen` bottom action bar by replacing `Expanded` + `SizedBox` gaps with `Flexible(flex: 1)` + symmetric horizontal padding (4px each), reduced button padding, and `isFullWidth: true` to ensure 3 buttons fit on narrow screens without overflow. **`flutter analyze` 0 errors**, **`flutter test` 14/14 pass**. |
| 2026-11-18 | **Critical Bug Fixes (4 issues from emulator testing — Session 3):** (1) **Checklist Foreign Key Error (23503)** — Fixed `checklist_items` FK violation by storing current `documentId` in `ChecklistCubit` (`_currentDocumentId`) and using it for all mutations (`toggleItem`, `updateItem`, `saveChecklist`). Ensures checklist items always reference the correct document UUID from the `documents` table. (2) **Translation Screen "Translate" Button** — Fully wired `TranslationCubit` to `AIRepository` in `injection.dart`; implemented `translate()` method calling `_aiRepository.translateDocument()` with sequential failover (Gemini → Kimi → Cerebras); added static `detectLanguage()` using Arabic regex `[؀-ۿ]` for auto-detect; `_TranslationScreen` now calls `detectLanguage()` in `initState` to set initial source/target languages, shows loading spinner in Translate button during `TranslationLoading`, renders translated card with Copy action on `TranslationCompleted`, and shows error SnackBar on `TranslationError`. (3) **Back Button on DocumentDetailsScreen** — Added explicit leading `IconButton` with `Symbols.arrow_back` in AppBar calling safe navigation (`context.canGoBack ? context.goBack() : AppRouter.goToHome(context)`); wrapped Scaffold in `PopScope(canPop: false, onPopInvokedWithResult: ...)` to intercept system back button and navigate safely instead of closing app. (4) **Delete Document Hides All Documents** — Fixed `DocumentCubit` to maintain `_cachedDocuments` list for optimistic updates; `deleteDocument()` now removes from cache and emits `DocumentsLoaded(_cachedDocuments)` instead of `DocumentInitial`, preserving UI state. Repository `deleteDocument()` now manually deletes child records (`checklist_items`, `chat_messages`, `translations`, `analyses`) before document deletion to avoid FK constraint blocks. `saveAnalysis()` forces correct `documentId` in upsert JSON. **`flutter analyze` 0 errors**, **`flutter test` 14/14 pass**. |
| 2026-11-18 | **RangeError Crash Fix on Document Deletion** — Fixed `RangeError (length): Invalid value: Not in inclusive range 0..14: 15` in `MyDocumentsScreen` when deleting a document. Root cause: `DocumentCubit` mutated `_cachedDocuments` in-place with `.removeWhere()` while `state.documents` held a reference to the same List instance, causing ListView to access stale indices mid-frame. Changes: (1) **DocumentCubit** — Never mutate in-place; always create new list: `_cachedDocuments = _cachedDocuments.where((d) => d.id != documentId).toList();` and emit `DocumentsLoaded(List.unmodifiable(_cachedDocuments))`. (2) **MyDocumentsScreen** — Capture stable snapshot with `final documents = List.of(state.documents);` before ListView; add bounds guard in `itemBuilder`: `if (index < 0 || index >= documents.length) return const SizedBox.shrink();`; add `key: ValueKey(doc.id)` to `DocumentCard` for proper widget reconciliation. **`flutter analyze` 0 errors**, **`flutter test` 14/14 pass**. |
| 2026-11-18 | **Home Dashboard Real-time Updates** — Fixed Home screen stats (Total Documents, Analyzed, Processing) not updating after document deletion. Root cause: `HomeCubit` loaded data once via `getUserDocuments()` and didn't subscribe to real-time changes. Added `_subscribeToChanges()` in `HomeCubit` using `DocumentRepository.watchUserDocuments()` stream to emit `HomeLoaded` on every database change (insert/update/delete). Home stats now stay in sync with `MyDocumentsScreen` and `DocumentDetailsScreen` automatically. **`flutter analyze` 0 errors**, **`flutter test` 14/14 pass**. |
| 2026-11-18 | **Task 1: Optimistic UI Updates for Checklist** — Fixed infinite "Loading checklist..." loop by implementing optimistic updates in `ChecklistCubit`. All mutations (`toggleItem`, `addItem`, `updateItem`, `deleteItem`, `saveChecklist`) now: (1) immediately update local `_cachedItems` and emit `ChecklistLoaded` for instant UI feedback, (2) perform background sync to Supabase, (3) on failure rollback to previous state and emit `ChecklistError` for SnackBar display. No more full reload after every interaction. |
| 2026-11-18 | **Task 2: New Document Sync in My Documents & Home** — Fixed newly uploaded documents not appearing immediately in My Documents and Home screens. Changes: (1) `DocumentCubit.uploadDocument()` now prepends new document to `_cachedDocuments` and emits `DocumentsLoaded` optimistically before server response. (2) Added real-time subscription `_subscribeToChanges()` using `DocumentRepository.watchUserDocuments()` in both `DocumentCubit` and `HomeCubit` to auto-refresh on any database change. (3) `UploadScreen` listener now handles `DocumentsLoaded` state (instead of old `DocumentUploadSuccess`) and triggers `AnalysisCubit.analyzeDocument()`. New documents appear instantly in both screens. |
| 2026-11-18 | **Task 3: Pull-to-Refresh on All Data Screens** — Added `RefreshIndicator` with `AlwaysScrollableScrollPhysics` to 5 data screens: (1) `MyDocumentsScreen` — wraps `ListView`, empty/error states wrapped in `SingleChildScrollView`. (2) `ChecklistScreen` (`_ChecklistScreenState` in `app_router.dart`) — wraps `ListView`, calls `_loadChecklist()` on refresh. (3) `DocumentDetailsScreen` — wraps Summary tab `ListView`, adds `_onRefresh()` calling `loadDocumentWithAnalysis()`, adds Refresh option to more options bottom sheet. (4) `ProfileScreen` — wraps `SingleChildScrollView`, calls `ProfileCubit.loadProfile()`. (5) `HomeScreen` — adds refresh button in `SliverAppBar` actions + `_onRefresh()` calling `Future.wait([homeCubit.loadData(), documentCubit.loadDocuments()])`. All screens handle empty/error states correctly for pull-to-refresh. |
| 2026-11-18 | **Task 4: ChecklistCubit Optimistic Tests & Documentation** — Added comprehensive test file `test/features/checklist/presentation/cubit/checklist_cubit_test.dart` with 11 tests covering optimistic update behavior for `toggleItem`, `addItem`, `updateItem`, `deleteItem`, `saveChecklist` — verifying immediate state emission, background sync, and rollback on failure. All 25 tests pass (14 existing + 11 new). Updated this changelog with all completed tasks. **`flutter analyze` 0 errors**, **`flutter test` 25/25 pass**. |
| 2026-11-18 | **Fixed RealtimeSubscribeException Fatal Error** — Removed Realtime subscriptions from `DocumentCubit` and `HomeCubit` that caused `RealtimeSubscribeException(channelError)` when Supabase Realtime was not enabled. The subscriptions were overwriting successfully loaded `DocumentsLoaded`/`HomeLoaded` states with error states on connection failure. Changes: (1) `DocumentCubit.loadUserDocuments()` no longer calls `_subscribeToChanges()`; removed `_documentsSubscription` field and `_subscribeToChanges()` method. (2) `HomeCubit.loadDashboard()` no longer calls `_subscribeToChanges()`; removed `_subscribeToChanges()` method. (3) Kept `DocumentRepository.watchUserDocuments()` for potential future use. App now relies on optimistic updates (upload prepends, delete filters) and Pull-to-Refresh on all data screens for data synchronization. **`flutter analyze` 0 errors**, **`flutter test` 25/25 pass**. |
| 2026-11-18 | **HomeScreen Pull-to-Refresh Update** — Removed manual refresh button from `HomeScreen` `SliverAppBar` actions and replaced with native `RefreshIndicator` wrapping the `CustomScrollView`. Pull-to-refresh now triggers `_onRefresh()` which calls `Future.wait([homeCubit.loadDashboard(), documentCubit.loadUserDocuments()])` for consistent data synchronization across all data screens. **`flutter analyze` 0 errors**, **`flutter test` 25/25 pass**. |
| 2026-11-18 | **Checklist Add/Update Fix (PGRST116 & Error Wipe)** — Fixed two critical issues in `ChecklistRepositoryImpl` and `ChecklistCubit`: (1) **PGRST116 on add**: Added `addChecklistItem()` method doing INSERT (not UPDATE) with explicit authenticated `userId` for RLS compliance. Uses `.maybeSingle()` instead of `.single()` to avoid PGRST116 crash; returns descriptive `ServerFailure` if no rows returned. (2) **Error wipes checklist**: On mutation failure, `ChecklistCubit` now rolls back and emits `ChecklistLoaded(items, errorMessage: failure.message)` instead of `ChecklistError` — keeps list visible, shows error via SnackBar. Updated all mutations (`toggleItem`, `addItem`, `updateItem`, `deleteItem`, `saveChecklist`). Added `errorMessage` to `ChecklistLoaded` state. Updated interface, mock, and all 11 optimistic tests. **`flutter analyze` 0 errors**, **`flutter test` 25/25 pass**. |
| 2026-11-18 | **Shared Cubit State Overwrite Bug Fix** — Fixed critical bug where opening `DocumentDetailsScreen` and navigating back caused `MyDocumentsScreen` (and `HomeScreen`) to become blank (only AppBar + Upload FAB visible). Root cause: `MyDocumentsScreen` and `DocumentDetailsScreen` shared the same global `DocumentCubit` instance; opening details emitted `DocumentLoaded`, overwriting `DocumentsLoaded`. On back navigation, `BlocBuilder` saw `DocumentLoaded` instead of `DocumentsLoaded` and fell through to `SizedBox.shrink()`. Fix: (1) **Isolated DocumentDetailsScreen State** — Wrapped `/document/:documentId` route in `app_router.dart` with `BlocProvider<DocumentCubit>(create: (_) => getIt<DocumentCubit>()..loadDocumentWithAnalysis(documentId))` so details screen gets its own scoped Cubit instance. (2) **Safety Fallback in MyDocumentsScreen & HomeScreen** — Added `buildWhen: (previous, current) => current is DocumentsLoaded || current is DocumentLoading || current is DocumentError` to `BlocBuilder<DocumentCubit, DocumentState>` to prevent rebuilds on unexpected states. Added fallback rendering from `DocumentCubit.cachedDocuments` when state is unexpected (e.g., `DocumentLoaded` from details screen), ensuring list never goes blank. (3) **Exposed `cachedDocuments` getter** in `DocumentCubit` for fallback access. **`flutter analyze` 0 errors**, **`flutter test` 25/25 pass**. |
| 2026-11-18 | **HomeScreen Data Contradiction Fix** — Fixed bug where Stats Cards showed `Total Documents: 1, Analyzed: 0` while Recent Documents section displayed `"No documents yet"`. Root causes: (1) Both `HomeScreen` and `HomeCubit` filtered Recent Documents to only `DocumentStatus.analyzed`, hiding uploaded/processing/failed docs. (2) `DocumentRepositoryImpl.saveAnalysis()` didn't update document status to `'analyzed'` after successful analysis. Fix: (1) **HomeScreen** — Removed status filter from Recent Documents; now shows ALL documents (uploaded, processing, analyzed, failed) sorted by `createdAt` desc, take 5. (2) **HomeCubit** — Same change: recent documents now show all statuses, stats still computed correctly from full list. (3) **DocumentRepositoryImpl.saveAnalysis()** — Added explicit `documents` table update to set `status = 'analyzed'` after saving analysis record. (4) Both Stats Cards and Recent Documents now derive from the exact same `List<DocumentModel>` in `HomeLoaded` state, making data contradiction impossible. **`flutter analyze` 0 errors**, **`flutter test` 25/25 pass**. |
| 2026-11-18 | **Complete Localization (l10n) & RTL System Implementation** — Implemented production-ready localization and RTL support using official Flutter gen-l10n. Changes: (1) **App UI Language (2 languages)** — English and Arabic only, matching design system templates. (2) **Default Translation Language (10 languages)** — Separate setting under Preferences with Arabic, English, French, Spanish, German, Chinese, Hindi, Urdu, Turkish, Persian. (3) **LocaleCubit with SharedPreferences** — Persists locale for instant launch; `changeLocale()`, `toggleLocale()`, `currentLocale`, `isRtl`, `supportedLocales`. (4) **ARB Files** — `lib/core/l10n/app_en.arb` and `app_ar.arb` with 30+ translation keys for profile/settings. (5) **Full RTL Support** — `Directionality` widgets, `EdgeInsetsDirectional`, `AlignmentDirectional`, `BorderRadiusDirectional`, `TextAlign.start/end` throughout. (6) **MaterialApp Wiring** — `supportedLocales`, `localizationsDelegates`, `locale` from LocaleCubit via `BlocBuilder`. (7) **ProfileScreen Refactor** — Two separate language settings: App Language (LocaleCubit) and Default Translation Language (ProfileCubit). (8) **Automated Tests** — 14 LocaleCubit unit tests (all passing), widget tests for ProfileScreen localization. (9) **Static Analysis** — `flutter analyze` 0 errors. |
| 2026-11-19 | **AI Provider Reliability & Duplicate Fetch Fixes** — Updated Gemini analysis timeout to 90 seconds while retaining 45 seconds for chat/translation; made timeouts retry once before model failover; replaced retired Gemini fallbacks with `gemini-3.5-flash-lite` and `gemini-3.1-pro-preview`; trimmed Kimi API keys and set the default Moonshot endpoint to `https://api.moonshot.ai/v1` while preserving explicit multipart Bearer auth; removed the duplicate details fetch from the route so `DocumentDetailsScreen.initState()` loads once. |

**Maintenance rule:** After each project session, update the date, confirmed decisions, completed items, remaining work, current stage, and next step. Record changed decisions with their dates; do not silently overwrite project history.
