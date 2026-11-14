# Wara2tak (ورقتك) — Features, Tech Stack & Screens

> Derived from the Project Master Brief (last updated 10 November 2026). Planning stage only: no code written. Items marked **Proposed** are not yet approved.

## 1. Product Summary

- **Name:** Wara2tak (ورقتك)
- **Positioning:** AI-powered Document Understanding & Application Planner.
- **Audience:** University students and recent graduates.
- **Opportunity types:** Scholarships, internships, exchange programs, training, academic programs.
- **Core idea:** The user uploads an opportunity announcement (PDF or image). AI extracts and explains the key information, builds an application checklist, answers questions about the document, and translates selected content.
- **Platforms:** Android + iOS (Flutter).
- **Languages:** Arabic (RTL) + English (LTR).
- **Sign-in:** Google Sign-in.

---

## 2. Features (MVP)

### A. Upload
- Select a PDF from device files.
- Select JPG/PNG from the gallery or capture with the camera.
- Preview, confirm, cancel, or replace the file before analysis.
- Validate file type, size, and page count; show clear processing and error states.
- Exact limits are **not approved**. Earlier suggestion: 20 pages / 20 MB (to be tested for cost and service limits).

### B. AI Analysis
Extracts, when present:
- Opportunity title and type
- Plain-language summary
- Eligibility, academic, and language requirements
- Required documents
- Deadlines
- Application steps and important notes
- Missing or unclear information
- Evidence: source excerpt and page number where possible

Rules:
- Never invent missing requirements or dates.
- Mark absent or unclear information explicitly.
- Preserve official names.
- Let users verify results against the source document.

### C. Checklist
- Generate tasks from requirements and application steps.
- Mark tasks complete/incomplete; edit or delete tasks; add personal tasks.
- Optional personal due dates and progress display.
- Distinguish official requirements from personal tasks.
- Do not assume the user already has a required document; the user controls task status.

### D. Document Chat
- Available from an analyzed document's details page.
- Answers are based on that document and its extracted analysis (not a general chatbot).
- States clearly when information is not in the source.
- Shows supporting excerpt/page reference where possible.
- Conversations are separate per document and can be deleted.

### E. Translation
- Translate the summary, requirements, required-document lists, application steps, and user-selected excerpts.
- Show original text alongside the translation where useful.
- App UI language and analysis-output language are separate settings.
- Full-PDF translation with original layout, tables, and formatting is out of MVP scope.

### F. Saved Documents
- List, open, and delete saved documents and their analysis.
- Deletion also removes associated chat, tasks, and the stored source file as applicable.

### Cross-cutting
- Google Sign-in.
- Arabic RTL / English LTR support throughout, including date formatting.
- Privacy and security: users access only their own data; Firestore/Storage Security Rules from the start; App Check; upload and AI usage limits; deletion of file, analysis, chat, tasks, and account data.

### Explicitly Out of MVP
- Discovering opportunities from the internet
- Applying automatically on the user's behalf
- CV or motivation-letter generation
- Comparing many opportunities
- Full PDF translation/reconstruction
- Advanced or recurring notifications
- Acceptance-chance prediction
- General chatbot unrelated to a document
- Medical, legal, financial, or other unrelated document categories
- Passports, ID documents, or sensitive personal records

---

## 3. Tech Stack (Proposed — Not Yet Approved)

| Area | Candidate | Purpose |
|---|---|---|
| Mobile | Flutter + Dart | Shared Android/iOS codebase |
| AI | Gemini | Document understanding, extraction, summaries, chat, translation |
| Platform | Firebase | Backend services |
| Auth | Firebase Authentication | User accounts (Google Sign-in) |
| Database | Cloud Firestore | Structured data |
| Files | Firebase Storage | PDFs and images |
| AI integration | Firebase AI Logic (candidate) | App-to-Gemini integration |
| Protection | Firebase App Check | App/service abuse protection |
| Design | Figma | Flows, wireframes, UI design |

**Architecture (proposed):** MVVM + Repository Pattern.
- **Presentation:** Screens, widgets, ViewModels
- **Data:** Models, repositories, data sources
- **Services:** Firebase, Gemini integration, file picker, camera/gallery

**Feature modules:** Authentication, Documents, AI Analysis, Checklist, Document Chat, Translation, Localization, Profile/Settings.

**Candidate packages** (verify current versions and compatibility): `provider`, `go_router`, `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_ai` (or the officially recommended SDK), `file_picker`, `image_picker`.

**Environment constraint:** Development is on Linux/Arch. Android is fine; iOS build/testing needs macOS (a Mac or a macOS build service).

**Note:** Verify official documentation, versions, pricing, model availability, and SDK compatibility before finalizing. Never expose secrets or API keys in the app.

---

## 4. Screens (Proposed — 11 Screens)

**Bottom navigation (proposed):** Home / My Documents / Profile. Chat, Checklist, and Translation live inside the selected document's details experience, not in the main navigation.

| # | Screen | Description |
|---|---|---|
| 1 | **Splash / Onboarding** | App start and a short introduction. May be simplified or omitted. |
| 2 | **Authentication** | Google Sign-in. Open decisions: sign-in required before first analysis vs. Guest Mode; adding Sign in with Apple on iOS. |
| 3 | **Home** | Recent documents and an "add document" action. |
| 4 | **Upload & File Selection** | Choose a PDF from files, or an image from the gallery/camera. |
| 5 | **Preview / Confirmation** | Preview the selected file; confirm, cancel, or replace before analysis. |
| 6 | **Analysis Progress & Error States** | Shows analysis progress and handles failures (invalid file, network error, AI failure) with retry. |
| 7 | **Document Details / Results** | Main results screen: summary, eligibility, academic and language requirements, required documents, deadlines, application steps, important notes, missing/unclear information, and evidence. Entry point to Chat, Checklist, and Translation. |
| 8 | **Document Chat** | Document-specific Q&A with supporting excerpts/page references; says when information is not in the source. |
| 9 | **Checklist** | Official and personal tasks, completion tracking, optional due dates, progress display. |
| 10 | **My Documents** | List of saved documents; open or delete (deletion removes related chat, tasks, and source file). |
| 11 | **Profile / Settings** | UI language, analysis-output language, account info, account/data deletion, sign-out. |

**Translation** is not a separate screen; it is part of Document Details (toggle or section for translated content shown alongside the original).

Every screen needs Loading / Empty / Error / Success states, defined in the UI/UX stage.

---

## 5. Main User Journey

1. Open the app and sign in (timing still open).
2. Home shows recent documents and an add-document action.
3. Choose a PDF or image; preview and confirm.
4. The app validates the file and shows analysis progress.
5. AI extracts structured information and evidence.
6. Results show summary, eligibility, requirements, documents, deadlines, and steps.
7. The user reviews results and uses document-specific chat and translation.
8. The app creates a checklist; the user edits and tracks tasks.
9. The user can reopen or delete saved documents.

---

## 6. Open Decisions (Must Be Approved Before Development)

1. Require sign-in before first analysis, or allow Guest Mode (sign-in required to save)?
2. Add Sign in with Apple on iOS alongside Google?
3. Allow multiple images per upload? Maximum count?
4. Final PDF page and file-size limits?
5. One document per analysis, or combine multiple documents for one opportunity?
6. How should evidence and page references appear in the UI?
7. Can users edit AI analysis fields? Which ones?
8. Data retention and default deletion policy?
9. Are local deadline reminders required in MVP, or postponed?
10. Final visual identity, colors, and screen design?
11. Gemini model, integration method, usage limits, and cost controls?
12. iOS build/testing arrangement given the Linux/Arch environment?
13. Should users export/share an analysis or checklist?

---

## 7. Planning Roadmap (No Coding Until Stage 5 Approval)

- **Stage 0 — PRD:** problem, audience, MVP boundaries, user stories, requirements, acceptance criteria.
- **Stage 1 — User Flow & UI/UX:** navigation map, all screens and states, RTL/LTR, wireframes, Figma.
- **Stage 2 — Technical Design:** architecture, Firebase services, schema, auth, security rules, App Check, error handling.
- **Stage 3 — AI Specification:** prompts, JSON schema, anti-hallucination and evidence rules, chat and translation behavior, test documents.
- **Stage 4 — QA & Release Plan:** test plan and Definition of Done.
- **Stage 5 — Final Approval:** review everything and get explicit approval to start development.

**Current status:** Product Planning / MVP Scope Review. No code written; no project setup started.

---

# 8. Update — Design Delivery Review (13 November 2026)

> Status: **Proposed, pending your approval.** Nothing below is approved until you say so. Review was done from the exported code/text of the screens, not from rendered pixels, so visual details (spacing, alignment, colors on device) still need checking in Figma or a real preview.

## 8.1 What Was Delivered

A Stitch export (`stitch_wara2tak_mobile_design_system.zip`) containing:
- 18 screen files (`code.html`): **14 app screens + 1 system-states pattern sheet + 3 RTL variants** (Home, Results, Checklist).
- `wara2tak_master_design_system.md` (colors, typography, spacing, radii, elevation, motion, voice).
- The design system references a `components/` folder (badge, button, card, input field, tabs) that is **not included** in the zip.

## 8.2 Design System Summary (Proposed)

| Item | Value |
|---|---|
| Primary | Deep Indigo `#4F46E5` |
| Secondary | Soft Blue `#E0E7FF` |
| Background / Surface | `#F8FAFC` / `#FFFFFF` |
| Text | Navy `#0F172A`, Slate `#64748B` |
| Status | Success `#16A34A`, Warning `#F59E0B`, Error `#EF4444` |
| Fonts | Cairo (Arabic + headings), Inter (English body) |
| Layout | 390px mobile baseline, 4/8px spacing, 16px gutters, 68px nav, 44px min touch target |
| Shapes | 12–16px card radius |
| Theme | Light only (no dark designs) |

## 8.3 Updated Screen Inventory (11 → 14 screens)

| # | Screen | Folder | Change vs. earlier plan |
|---|---|---|---|
| 1 | Splash | `splash_screen` | Split from onboarding |
| 2 | Onboarding | `onboarding_value_proposition` | New standalone screen (single page, Skip + Get Started) |
| 3 | Sign-in | `sign_in_google_authentication` | Google only; no Apple, no Guest |
| 4 | Home | `home_opportunity_dashboard` (+ `home_rtl`) | Greeting, upload CTA, recent documents, "How it works" |
| 5 | Upload | `upload_document_file_selection_preview` | Browse PDFs / Gallery / Scan Paper, file card, Analyze button |
| 6 | Review / Preview | `review_document_preview_confirmation` | "Step 2 of 2", file details, Replace/Remove, Analyze |
| 7 | Analysis Progress | `ai_analysis_progress_stages` | Staged progress list |
| 8 | Analysis Error | `ai_analysis_error_state` | Split from progress: Try Again / Choose Another File / Back to Home |
| 9 | Document Details / Results | `document_details_ai_analysis_results` (+ `results_rtl`) | Overview, deadlines, eligibility, required docs, steps, notes, disclaimer |
| 10 | Document Chat | `ai_assistant_document_q_a` | "Grounded to Doc" banner, suggested questions, page references, "Not Found in Document" state |
| 11 | Checklist | `checklist_application_action_plan` (+ `checklist_rtl`) | Progress, Official vs Personal sections, add-task sheet |
| 12 | Translation | `translate_section_translation` | Now its own screen opened from Details (tabs: Eligibility, Summary, Required Documents, Deadlines & Steps; source/target toggle; original beside translation; copy) |
| 13 | My Documents | `my_documents_archive_management` | Search, type filters, card actions (Ask AI, Checklist, Delete), delete confirmation |
| 14 | Profile / Settings | `profile_settings` | Display name, Google provider, sign out, UI language, default AI language, appearance, policies, delete account |
| — | System States (pattern sheet, not a real screen) | `system_states_empty_error_loading_patterns` | Empty, error, loading patterns |

Bottom navigation matches the brief: **Home / My Documents / Profile**.

## 8.4 What Already Matches the Brief

- Bottom navigation and Chat/Checklist/Translation reached from the document, not main nav.
- UI language and AI-output language are separate settings.
- Evidence chips (page/section) and source quotes on results.
- Missing information shown explicitly ("Not specified in the document").
- Chat refuses to guess ("Not Found in Document").
- Official requirements clearly separated from personal tasks.
- Delete confirmations state that checklist, chat history, and deadlines are removed too.
- AI disclaimer on results and chat; privacy note on upload.
- PDF + JPG/PNG, camera/gallery, preview/replace/remove before analysis.

## 8.5 Review Findings

### A. Must Fix (conflicts with the brief's rules)

| # | Screen | Issue | Suggested fix |
|---|---|---|---|
| 1 | Translation | "Translation accuracy: 99% / reviewed automatically" is an invented metric | Remove; keep only "AI translation — verify against the original" |
| 2 | Results (EN + RTL) | "100% Extracted" badge implies completeness | Remove, or show "Missing information: N items" |
| 3 | Results | Deadline shows "TBA by Email"; the document only says "not specified" | Show only "Not specified in the document" |
| 4 | Onboarding | "Eligibility Verified" implies the app verifies the user's eligibility | Use "Eligibility requirements found" |
| 5 | Chat | AI answers "Yes, academically" to "Am I eligible?" (an eligibility verdict) | Answer with what the document says: "The document requires a minimum 3.0 GPA; 3.15 meets that requirement. Confirm with the provider." |
| 6 | Home | "All 5 Met" assumes the user already has the documents | Use "5 of 5 tasks done" |
| 7 | Profile | "Documents are encrypted and never shared" is a privacy claim before the privacy/retention policy is decided | Remove until the policy is approved and verified |
| 8 | Upload | "Analysis takes ~10–15 seconds" is an unverified promise (progress screen itself says scans take longer) | Remove or replace with "Usually quick; scanned files may take longer" |
| 9 | Preview | "High visual clarity for extraction" / "Format & layout verified" imply a quality-check feature that is not in scope | Remove, or approve it as a feature |
| 10 | Results | Counts do not match content: "5 Items" lists 4; "4 Consecutive Stages" lists 3 | Fix mock data/logic |
| 11 | Results RTL | Missing the English proficiency document, Application Steps, and Important Notes sections that the EN version has | Make RTL identical in content |
| 12 | Whole app | RTL exists for only 3 of 14 screens (brief requires RTL throughout) | Design RTL for the rest, at least Chat, Upload, Preview, Translation, My Documents, Profile, Sign-in, Onboarding |
| 13 | Chat | No control to delete a conversation (brief requires it) | Add "Clear conversation" in a chat menu |
| 14 | Translation | No way to translate a user-selected excerpt (brief requires it) | Add "Paste/select text to translate" |
| 15 | Results | Evidence is shown but there is no way to open the original file at that page | Add "View original (page N)" |

### B. Should Fix (flow and consistency)

1. **Upload vs. Preview duplication:** the Upload screen already shows the selected file and an Analyze button, then Preview ("Step 2 of 2") repeats both. Preview also has its own "Extracting requirements… Cancel" state while a separate Progress screen exists. Choose one flow: Upload (pick) → Preview (confirm) → Progress.
2. **Progress stages are likely simulated.** With one AI call, real stage labels ("Identifying eligibility…") may not reflect actual work. Tie stages to real steps (upload → validate → analyze → save) or use a generic progress message.
3. **"Create My Checklist" button vs. automatic checklist.** The brief says the app creates the checklist after analysis; the Details screen also has a Checklist button at the top and a bottom "Create My Checklist" CTA. Decide: auto-generated (CTA becomes "Open Checklist") or on-demand.
4. **Checklist numbers:** header says 3/5 official, list shows 4 official tasks with 2 done. Official tasks show "Due" dates although the brief allows only optional personal due dates; clarify document-derived deadline vs. personal due date.
5. **My Documents filters** cover only Scholarships / Exchanges / Internships. The brief also includes Training and Academic Programs; add them plus "Other". Add statuses for Analyzing and Failed (brief has `analysisStatus`).
6. **Home "Submitted" status** is a new concept not in the brief (user marks an application as submitted). Approve or remove.
7. **Profile "Appearance" setting** implies dark mode, but no dark designs exist. Remove or defer.
8. **Arabic numerals inconsistent:** Arabic-Indic digits in "How it works" (١ ٢ ٣) vs. Western digits everywhere else. Pick one.
9. **Menu (⋮) contents are undefined** on Details and My Documents (delete? share/export? re-analyze? edit?). Ties to open decisions #7 and #13.
10. **Typography:** the design system says body text is Inter, but the RTL screens use Cairo throughout. Align the spec with what the screens do.
11. **Contrast:** Amber `#F59E0B` is used as text color in many places (deadlines, warnings); on white it is roughly 2:1, too low for readable text. Use a darker amber for text and keep `#F59E0B` for fills/icons. Slate `#64748B` on `#F8FAFC` is borderline for small text.

### C. Missing States to Design

- Password-protected file
- Too many pages / file too large (pattern exists, but not shown in Upload)
- Blurry or low-quality image / scanned PDF warning
- Unsupported document type (passport, ID, or unrelated document; brief excludes these)
- Camera/storage permission denied
- AI timeout, quota/limit reached, partial or low-confidence result
- Sign-in failed/cancelled
- Account deletion in progress/confirmation
- Deadline already passed

### D. Not in the Design Yet (follows open decisions)

- Sign in with Apple (open decision #2; verify Apple's current requirement before approving)
- Guest Mode (open decision #1)
- Multiple images per upload (open decision #3)
- Export/share (open decision #13)
- Editing AI fields (open decision #7)
- Deadline reminders (open decision #9)

## 8.6 Updated Open Decisions (added to Section 6)

14. Is Onboarding kept as a single screen, or removed?
15. Is the checklist auto-generated after analysis, or created on demand?
16. Is the "Submitted" application status in MVP?
17. Is dark mode / Appearance in MVP, or deferred?
18. Is a pre-analysis file quality check in MVP, or removed from the UI?
19. Which RTL screens must be designed before development starts (all, or only critical ones)?
20. Which numerals are used in Arabic (Western or Arabic-Indic)?

## 8.7 Updated Status

- **Current stage:** Stage 1 — User Flow & UI/UX (design draft received, under review).
- **Done:** 14 screens + system-states sheet + 3 RTL variants + master design system draft.
- **Not done:** fixes in 8.5-A and 8.5-B, remaining RTL screens, missing states (8.5-C), `components/` files, Figma file, decisions in Sections 6 and 8.6.
- **Next step:** apply the Must-Fix list, decide the open flow questions, complete RTL and missing states, then approve the UI/UX Specification before moving to Stage 2 (Technical Design). No code until Stage 5 approval.

## 8.8 Change Log

| Date | Change |
|---|---|
| 2026-11-13 | Received Stitch design export (18 screen files + design system). Reviewed; findings and updated screen inventory added (Section 8). |
