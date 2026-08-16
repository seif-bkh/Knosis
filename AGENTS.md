# AGENTS.md — Knosis Engineering Contract

Read fully before touching the repo. These rules apply unless the product owner overrides them.

---

## 1. Product

**Knosis** — Android-only, offline-first reading + language-learning app.
Tagline: *"From words to worlds."*

A reading-**learning system**, not just an EPUB/PDF reader. Core loop:

    words → context → flow reading → reflection → memory → independent reading

Combines: Flow Reading, Study Reading, purposeful rereading, contextual vocabulary, notes/questions, retrieval practice, spaced repetition, long-term book journeys.

---

## 2. Source of Truth (check in this order)

1. `AGENTS.md`
2. Product Report / PRD
3. Architecture docs
4. Existing code & tests
5. Task docs
6. Available skills

Docs vs. code disagree → investigate, don't guess.
- Minor inconsistency → pick the safest interpretation, document it.
- Affects behavior/architecture/data/privacy/UX → **ask the owner.**

---

## 3. Before Coding (non-trivial tasks)

1. Understand desired outcome
2. Inspect repo structure, related code, tests
3. Identify dependencies & risks
4. Identify files/modules that will change
5. Define how to validate the result
6. Write a plan → *then* implement

Scale the plan to the task. Mandatory for: features, migrations, architecture, reader, import, persistence changes.

Keep the big picture: consider Library, Book Journey, Reader, Sessions, Notes, Questions, Vocabulary, Review, Progress, Placement, future adaptive learning. Don't box in future features — but don't build speculative systems either.

---

## 4. Local Task Files

Agent may keep private planning files (`.local/tasks.md`, `.local/current-plan.md`, etc.) for TODOs, hypotheses, notes, checkpoints.
- Gitignored, never committed unless explicitly requested.

---

## 5. Skills

Use available skills/tools/workflows (Flutter, Android, testing, CI, Drift/SQLite, EPUB, accessibility, performance, UI) instead of reinventing them. Repo instructions override generic habits.

---

## 6. When Blocked

Ask the owner if genuinely stuck — especially on: product behavior, destructive data changes, migrations, privacy, security, large architecture calls, heavy dependencies, removing functionality, changing UX semantics, contradictory requirements.

Investigate first. Question format: **what's unclear → what you checked → options → consequences → your recommendation.**
Don't ask what the repo already answers.

---

## 7. Platform

Android only. Flutter is the framework, not a multi-platform signal. No iOS/Web/Windows/macOS/Linux effort unless explicitly requested.

---

## 8. Android UX

Respect: system + predictive back, edge-to-edge, safe insets, file picker, share/open-with, keyboard behavior, dark mode, text scaling, accessibility, lifecycle, process restoration. Never fight Android navigation conventions.

**Gestures:** horizontal nav, center-tap for controls, long-press selection, native selection handles, swipe-dismiss, system back — all fine, but:
- never conflict with back gesture
- never make a core feature gesture-only (always a visible alternative)
- preserve selection & accessibility
- prioritize natural scrolling over gesture novelty

---

## 9. UI/UX

Feel: calm, modern, intelligent, focused, warm, premium, lightweight.
Avoid: childish, gamified, noisy, enterprise-heavy, academically dull, overloaded.

**The reader screen is the most important screen — protect it.**

Flow Mode = uninterrupted reading. No auto popups, mid-paragraph quizzes, intrusive vocab prompts, unnecessary modals, frequent animation, aggressive streaks. Learning interventions happen on request, at natural boundaries, session end, or in Study/Review mode.

Design system: centralized colors, type, spacing, radii, animation durations, components. No magic values.

---

## 10. Performance

Optimize: startup, scroll smoothness, memory, idle CPU, battery, app size, DB speed, reader nav.

Before adding a dependency, check: necessity, size cost, maintenance status, Android compatibility, overlap with existing deps. Simple > clever. Don't sacrifice correctness for micro-optimization without evidence.

**Large books are core, not an edge case** (assume 2,000+ pages):
- never fully load/render a whole book in memory
- incremental parsing, chunked persistence, lazy load/render, stable positions, efficient indexing, background/isolate work for heavy parsing
- never block UI thread on book processing
- test with small **and** large documents

---

## 11. Offline-First (non-negotiable)

Must work with no internet: app launch, library, books, reading, position, highlights, notes, questions, vocabulary, sessions, progress, review. No hidden network dependency in a core path. Online features must degrade cleanly.

---

## 12. Privacy & Data Ownership

Books, notes, questions, reading history = **local by default**, never sent externally without an explicit feature + explicit consent. Future AI features must disclose exactly what leaves the device.

User owns their data → support local persistence, export, backup, future restore/import. No opaque data lock-in. Migrations must preserve existing user data whenever reasonably possible.

---

## 13. Stack

Flutter · Dart · Android only · Riverpod (state) · Drift/SQLite (persistence) · local filesystem (books/assets) · SQLite FTS (search).

Don't replace major stack pieces without approval. Follow the repo's established architecture if more specific.

---

## 14. Architecture

    lib/
      app/
      core/
      features/
        onboarding/ placement/ library/ import/
        reader/ notes/ vocabulary/ review/
        progress/ settings/
      shared/

Avoid: god services/utils, arbitrary cross-feature coupling, business logic in widgets, scattered DB access, hard-coded global state.

Separate UI / state / domain / persistence / filesystem / parsing / integrations. No abstraction layers for theoretical purity only.

---

## 15. Data Model

Core entities: `UserProfile`, `LanguageProfile`, `Book`, `Chapter`, `Chunk`, `ReadingSession`, `Annotation`, `Note`, `Question`, `VocabularyItem`, `ReviewEvent`, `Tag`.

Annotations & reading positions must survive restarts, sessions, reopening, updates, migrations. Never casually change position semantics once annotation data exists.

**Migrations:** never reset DB to fix schema issues (destructive reset only pre-persistent-data, in dev). Otherwise: write migrations, preserve data, test migration paths, document schema changes. Risky/ambiguous migration → stop and investigate.

---

## 16. Book Import

Resilient by format: validate file, handle malformed input gracefully, preserve/derive metadata, no UI freezes, actionable errors.

EPUB = primary rich format. TXT/Markdown = simple & robust. PDF is a later-phase concern — don't let it distort current EPUB architecture.

**Reader position:** stable & recoverable, not just a transient UI index. Distinguish book/chapter identity, chunk identity, text offset, viewport state where practical.

---

## 17. Accessibility

Screen reader semantics, scalable text, sufficient contrast, large tap targets, reduced motion, dark/sepia themes, focus semantics, readable selection states. Never color-only for essential info. Text scaling must not break navigation.

---

## 18. Animation

Subtle, short, purposeful, interruptible. No continuous decorative animation, heavy blur, excessive shadow, elaborate transitions, or anything that delays reading/navigation. Respect reduced-motion where practical.

---

## 19. Errors & Logging

User-facing errors: explain what failed, plain language, preserve recoverable state, offer a next action. No stack traces to users.

Bad: `Something went wrong.`
Better: `Knosis couldn't read this EPUB file. The file may be damaged or use an unsupported structure.`

Logging: metadata/technical context only. Never log full book passages, full notes, sensitive file contents, or user answers. Strip excess debug logging before release.

---

## 20. Testing

Priority: domain logic, parsers, DB ops, migrations, review scheduling, chunking, state transitions, critical widgets, known regressions. No coverage-% chasing while core behavior stays untested. Reading data > decorative UI in test priority.

**Definition of "task done":** implement → format → lint/analyze → unit tests → widget tests → integration/build validation (where available) → fix failures → repeat. No knowingly-failing tests left behind.

---

## 21. Sandbox Limits

Local sandbox may not fully compile/build Android. Never claim local compilation succeeded if it didn't. Always distinguish:
- checks actually run
- checks unavailable locally
- checks delegated to CI

GitHub Actions is authoritative for full Android build validation.

---

## 22. CI Setup (mandatory first infra task)

After understanding the repo, before major implementation: prepare `.github/workflows/ci.yml` (checkout, Flutter setup, deps, format check, static analysis, tests, Android build; caching where reliable; pinned toolchain versions; no unnecessary complexity).

**Agent cannot push/install this workflow.** Process:
1. Generate complete `ci.yml`
2. Present to owner with expected path
3. Wait for owner to add it manually
4. Only then rely on GitHub Actions

---

## 23. CI-Driven Iteration

    Plan → Implement → Local checks → Push → Wait for CI →
    Inspect result → Fix → Push → Repeat until green

Red CI is never an acceptable final state. Unrelated failure → investigate, explain evidence, judge if it blocks safe completion. Never edit unrelated code just to force green.

For substantial changes, get CI green before stacking more major work (small planning work can continue in parallel).

**Never claim** "build passes / tests pass / CI is green" unless actually verified. Use precise language: *"unit tests passed locally,"* *"Android build not executable in this sandbox,"* *"CI currently failing in X."*

---

## 24. Git Discipline

Before changes: check `git status`, understand uncommitted work, don't overwrite unrelated changes.
Never: force push, rewrite history, delete branches, run destructive git commands — unless explicitly instructed.
Keep changes scoped; don't mix broad refactors into feature work.

Unfamiliar edits in the repo (owner-made) → preserve, understand, work around. Conflicts → ask before deleting/rewriting.

---

## 25. Dependencies

Before adding one, check: necessary? already covered by Flutter/Dart/Android or an existing dep? actively maintained? size impact? offline/privacy/network implications? Major deps need strong justification.

**No premature AI dependency.** AI Coach is a later phase — core app must work without it. No LLM SDKs, remote inference, embeddings, vector DBs, AI accounts until that phase is explicitly requested.

---

## 26. Security

Treat all imported files as untrusted. Don't assume EPUB/PDF/TXT is safe/well-formed. Avoid: arbitrary code execution, unsafe path extraction, path traversal in archive extraction, trusting filenames as paths, uncontrolled memory allocation from file metadata. Sanitize archive paths, validate extracted content.

---

## 27. Scope & Refactoring

No unrequested scope expansion — log out-of-scope ideas in local notes, mention if useful, stay on task.

Refactor only when it improves correctness, current-feature maintainability, testability, or removes clearly harmful duplication. No speculative refactors; never bundle a big architectural rewrite into a small UI request unless the current architecture truly blocks the work.

---

## 28. Comments & Docs

Code should self-explain via clear names, small functions, coherent modules. Comments explain *why*, invariants, non-obvious constraints, unusual algorithms, compatibility decisions — not obvious syntax. Update docs when architecture/behavior changes.

---

## 29. Completion Report

Report concisely: what was implemented, key files changed, tests/checks run, CI result, anything unvalidated, known limitations, decisions needing owner attention. Never bury failures or limitations.

---

## 30. Work Cycle

    1. Read task           8. Identify risks        15. Wait for CI
    2. Read docs            9. Implement smallest    16. Inspect CI
    3. Inspect repo             coherent increment    17. Fix & iterate
    4. Inspect skills      10. Format                18. Stop only when
    5. Check git status    11. Analyze                   green or blocked
    6. Investigate code    12. Test                  19. Report outcome
    7. Create local plan   13. Review diff
                            14. Push when appropriate

---

## 31. First Time in the Repo

Don't build random screens first. Instead:
1. Inspect top-level structure
2. Read all product/engineering docs
3. Inspect available skills
4. Inspect source/config & git state
5. Determine implementation stage + toolchain versions
6. Determine what's validatable locally
7. Write a private local plan
8. Prepare `.github/workflows/ci.yml` and hand it to the owner (see §22)
9. Once CI exists: validate baseline, make it green, then start the next milestone

---

## 32. Priority Order (when tradeoffs are needed)

1. User data integrity
2. Correct reading behavior
3. Privacy & offline capability
4. Reliability
5. Android UX
6. Performance
7. Accessibility
8. Maintainability
9. Visual polish
10. Feature quantity

Polish never costs annotations, broken books, or unreliable positions.

---

## 33. Final Rule

When uncertain, return to the core idea: **"From words to worlds."**

Protect the reading experience. Protect the user's data. Keep it fast. Keep it offline-first. Build for Android. Plan before coding. Validate through CI. Ask when genuinely blocked. Don't guess on important decisions.
