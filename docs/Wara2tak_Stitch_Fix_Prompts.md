# Wara2tak — Stitch Fix Prompts

How to use: paste **Prompt 0** first (global rules), then paste each screen prompt one at a time. Keep the existing design system (Deep Indigo, Cairo + Inter, 390px mobile, 12–16px radii, light theme only).

Assumptions used in these prompts (change them before pasting if you decide differently):
- Checklist is created automatically after analysis.
- Onboarding stays as one screen.
- "Submitted" status and the Appearance/dark-mode setting are removed.
- Western digits (0–9) are used in Arabic screens.

---

## Prompt 0 — Global rules (paste first)

```
Update the entire Wara2tak app design with these global rules. Keep the current visual style, colors, fonts and layout language.

CONTENT HONESTY (remove anything that claims more than the AI can guarantee):
- Remove every accuracy or completeness claim: "Translation accuracy 99%", "Reviewed automatically", "100% Extracted", "High visual clarity for extraction", "Format & layout verified", "Eligibility Verified", "All 5 Met".
- Remove any promised processing time such as "~10-15 seconds".
- Remove "encrypted and never shared" claims.
- Missing dates or facts must read exactly "Not specified in the document". Never write "TBA by Email" or any inferred value.
- The app never tells the user they are eligible or accepted. It only states what the document says.

EVIDENCE:
- Every extracted item (deadline, eligibility rule, required document, step) shows a small source chip like "Page 3" or "Section 2.1" and, where possible, a short quote.

ARABIC / RTL:
- Every screen must exist in both English (LTR) and Arabic (RTL). Mirror layouts, icons with direction (back arrows, chevrons, send), progress bars and swipe directions.
- Use Cairo for all Arabic text, including body text. Use Inter for English.
- Use Western digits (0-9) everywhere, including Arabic screens.
- Keep official program names and useful English terms (GPA, IELTS, SoP) in English inside Arabic text.

ACCESSIBILITY:
- Do not use amber #F59E0B as text color on white. Use a darker amber (#B45309) for warning text; keep #F59E0B only for icons and fills.
- Use #475569 instead of #64748B for small secondary text on #F8FAFC.
- Minimum touch target 44px.

CONSISTENCY:
- Counts in headers must match the lists below them (e.g. "5 Items" must show 5 items; "4 stages" must show 4).
- Document types used in labels and filters: Scholarship, Internship, Exchange, Training, Academic Program, Other.
- Bottom navigation stays: Home / My Documents / Profile.
```

---

## Prompt 1 — Splash + Onboarding

```
Keep the Splash screen. Keep Onboarding as one screen.
On Onboarding, change the floating card "Eligibility Verified - GPA > 3.0 / B2 Level" to "Eligibility requirements found - GPA 3.0+ / B2 level". Keep "Deadline Extracted" and "Action Checklist". Keep Skip and Get Started.
Create both screens in English LTR and Arabic RTL.
```

## Prompt 2 — Sign-in

```
Keep "Continue with Google" as the only button. Change the privacy line to "Your documents stay in your own workspace." Keep links to Terms of Service and Privacy Policy.
Add a sign-in error state: "Sign-in didn't complete. Please try again." with a Try Again button.
Create English LTR and Arabic RTL versions of the screen and of the error state.
```

## Prompt 3 — Home

```
Update Home:
- Document cards show status as "X of Y tasks done" (never "All 5 Met").
- Remove the "Submitted" status. Card states are: Analyzing, Analyzed, Failed, plus task progress.
- Deadline chip shows "N days left" only when a deadline exists; otherwise show "No deadline found".
- Use the document types: Scholarship, Internship, Exchange, Training, Academic Program, Other.
- Keep the "How Wara2tak Works" row with Western digits 1, 2, 3.
Create English LTR and Arabic RTL versions.
```

## Prompt 4 — Upload (pick a file)

```
Redesign "Upload a Document" as the first step only: choose a file.
- Show three options: Browse PDFs, From Gallery, Scan Paper (camera).
- Show supported formats (PDF, JPG, JPEG, PNG) and a note: "Clear, high-contrast documents give the most accurate results. A file size and page limit applies."
- Remove the selected-file card, the page preview, the "Analyze Opportunity with AI" button and the "~10-15 seconds" text from this screen. Selection leads to the Review screen.
- Add a notice: "Don't upload passports, ID cards or other personal records. Upload opportunity announcements only."
Create English LTR and Arabic RTL versions.
```

## Prompt 5 — Review / Preview

```
Update "Review Document" (Step 2 of 2):
- Show the file preview, file name, format, size and page count.
- Keep Replace File and Remove File.
- Keep the "Analyze Document" button. Pressing it goes to the separate Analysis Progress screen. Remove the inline "Extracting requirements..." loading state and its Cancel button from this screen.
- Remove "High visual clarity for extraction" and any "verified" quality badges.
- Add warning banners (as variants): "This image looks blurry. Results may be less accurate." and "This file has many pages. Analysis may take longer."
Create English LTR and Arabic RTL versions.
```

## Prompt 6 — Analysis Progress

```
Update Analysis Progress with 4 honest stages: Uploading file, Checking file, Analyzing document, Saving results. Show the current stage, completed stages with a check, and pending stages greyed out.
Add a Cancel button. Keep the note: "Scanned or complex files may take longer. Please keep Wara2tak open."
Create English LTR and Arabic RTL versions.
```

## Prompt 7 — Analysis Error + new error states

```
Keep the existing analysis error screen (Try Again, Choose Another File, Back to Home). Create these additional full-screen error states, each with an icon, a clear title, one short explanation and one main action:
1. Password-protected file: "This file is protected by a password."
2. File too large / too many pages.
3. Unsupported file type (e.g. .docx): choose PDF, JPG or PNG.
4. Unsupported document: "This looks like a personal or ID document. Wara2tak only analyzes opportunity announcements."
5. Blurry or unreadable scan: suggest retaking the photo.
6. Camera or storage permission denied: button "Open Settings".
7. No internet connection: Retry.
8. AI took too long or daily limit reached: Try again later.
9. Partial results: "We couldn't read some sections. Missing information is marked."
Create all in English LTR and Arabic RTL.
```

## Prompt 8 — Document Details / Results

```
Update Document Details:
- Remove the "100% Extracted" badge. Replace it with "N items not found in the document" (tap to see them).
- Deadlines: if a date is missing show "Not specified in the document" (no "TBA by Email").
- Make counts match content: Required Documents shows all 5 items; Application Steps shows all 4 steps.
- Add a source chip on every eligibility item, required document and step.
- Add a "View original (page N)" button next to every source chip; it opens the original file at that page.
- Add a "Missing or unclear information" section listing absent items.
- The checklist is created automatically after analysis. Remove the bottom "Create My Checklist" button; replace it with "Open Checklist (4 of 8 done)". Keep the top actions Checklist, Ask AI, Translate.
- Define the ⋮ menu: Re-analyze, Change analysis language, Delete document.
- Keep the AI disclaimer, without "100%" wording.
Create the Arabic RTL version with identical content and all the same sections (Required Documents including the English proficiency report, Application Steps, Important Notes).
```

## Prompt 9 — Document Chat

```
Update Document Chat:
- Replace the answer "Yes, academically." with a neutral answer: "The document requires a minimum cumulative GPA of 3.0 out of 4.0. A GPA of 3.15 meets this requirement. Other conditions also apply: ... Please confirm with the official provider." Keep the page reference chip.
- Keep the "Not Found in Document" answer style.
- Add a ⋮ menu in the header with "Clear conversation" and a confirmation sheet: "Delete this conversation? This can't be undone."
- Add the empty state "Start a conversation" with 3 suggested questions.
- Add a chat error state: "Couldn't get an answer. Try again."
Create English LTR and Arabic RTL versions.
```

## Prompt 10 — Checklist

```
Update Checklist:
- Make the numbers consistent: if the header says 3 of 5 official tasks, the list must show 5 official tasks with 3 completed. Total progress counts both official and personal tasks.
- Official tasks show the document's deadline as "Document deadline: date" (not editable). Personal tasks have an optional "My due date" the user can set.
- Keep Official Requirements and Personal Tasks sections with source chips "Page N".
- Users can edit and delete any task; official tasks show a "From document" tag.
- Keep the Add Personal Task sheet (Title, Description optional, Due date optional).
- Add a "Deadline passed" state in red text for overdue items.
Create English LTR and Arabic RTL versions.
```

## Prompt 11 — Translation

```
Update Translation:
- Remove "Translation accuracy: 99%" and "Reviewed automatically". Use: "AI translation. Verify against the original."
- Keep tabs: Summary, Eligibility, Required Documents, Deadlines & Steps. Keep Source/Target language switch, original text beside the translation, and Copy.
- Add a fifth option "Custom text": a text box where the user pastes or selects an excerpt from the document and translates it.
- Add a translation error state with Retry.
Create English LTR and Arabic RTL versions.
```

## Prompt 12 — My Documents

```
Update My Documents:
- Filters: All, Scholarship, Internship, Exchange, Training, Academic Program, Other (horizontally scrollable).
- Statuses on cards: Analyzing (with spinner), Analyzed, Failed (with Retry).
- Keep search, card actions (Ask AI, Checklist, Delete) and the delete confirmation. Update the confirmation text: "This permanently deletes the file, analysis, checklist and chat history."
- Add the empty state "No documents yet" with an Upload Document button, and a "No results" state for search.
Create English LTR and Arabic RTL versions.
```

## Prompt 13 — Profile / Settings

```
Update Profile:
- Remove the Appearance setting (no dark mode in this version).
- Remove the sentence "Your opportunity documents are encrypted and never shared." Replace with "You can delete any document anytime from My Documents."
- Keep Edit Display Name, Sign-In Provider (Google), Sign Out, App Interface Language (English / العربية), Default AI Language, Privacy Policy, Terms of Service, Delete Account, About.
- Delete Account: keep the confirmation sheet and add a final "Deleting your account..." progress state.
Create English LTR and Arabic RTL versions.
```

## Prompt 14 — System States sheet

```
Update the System States sheet to include: empty states (no documents, no tasks, no chat), loading skeletons for Home, Results and Checklist, upload progress, and all error states from Prompt 7. Show each in English LTR and Arabic RTL.
```

---

## Not designed yet (do after decisions)

- Sign in with Apple (verify Apple's current requirement first)
- Guest Mode
- Multiple images per upload
- Export / share
- Editing AI fields
- Deadline reminders
