# Case Study: AI Academy Platform

**Date:** 2026-03-16
**Builder:** Non-technical founder (zero programming background)
**Method:** 5x-cto skill (Opus specs + Codex implementation)
**Final Score:** 92/100

## What Was Built

A complete AI learning academy platform with:

- **Course management** — 4 API endpoints, trilingual course materials + quizzes
- **Certificate translation** — Apply, verify, and download translated certificates
- **Stripe payments** — Checkout flow, webhooks, license verification
- **Recommendation letters** — Eligibility check (requires 2 certificates), payment, unique RC-xxx codes
- **PDF certificate generation** — Puppeteer + QR code + download endpoint
- **Homepage** — Hero section, feature cards, navigation, trust indicators
- **Trilingual i18n** — Japanese, English, Chinese throughout

## Tech Stack

- Runtime: Bun + Hono
- Database: SQLite (3 tables)
- Payments: Stripe (Checkout + Webhooks)
- PDF: Puppeteer + QR Code
- Frontend: DaisyUI + vanilla JS
- Deployment: Docker

## Pipeline Results

| Metric | Value |
|--------|-------|
| Total cards | 9 |
| Accepted | 9/9 (100%) |
| Blocked | 0 |
| Rework rounds | minimal |
| Timeline | Single evening session |

### Cards Completed

1. Backend skeleton: Hono + SQLite 3 tables + health check
2. Course API: 4 endpoints, trilingual materials + quizzes
3. Course frontend: DaisyUI + language switching + drawer nav
4. Chrome Extension: manifest v3 + Skilljar integration
5. Certificate translation API: POST apply + GET verify
6. Certificate translation frontend: form + auto-lookup
7. Stripe payment + license: Checkout + webhook
8. Recommendation letter: eligibility check + Stripe + webhook
9. Homepage rebuild: Hero + features + navigation + trust

## Score Timeline

This project went through two scoring rounds. Showing both for transparency.

### Round 1: Initial pipeline completion (before fixes)

| Category | Score | Details |
|----------|-------|---------|
| Process Compliance | 32/35 | Pipeline complete, 9/9 cards accepted. 70% commit convention. |
| Code Quality | 27/40 | 4-layer architecture, zero secrets, 10/10 import chain. **No tests. Partial error handling.** |
| Delivery | 25/25 | All 9 cards shipped, 5 feature categories. |
| **Total** | **84/100** | |

**Gaps identified:**
- No automated tests (0 test files)
- Error handling only in 5/10 source files (webhook had it, courses didn't)
- 5/7 commits missing Card ID

### Round 2: After adding tests + error handling

| Category | Score | Details |
|----------|-------|---------|
| Process Compliance | 32/35 | Same as Round 1 (historical commits can't be changed). |
| Code Quality | 35/40 | Added 10 tests (all passing). Added try/catch to all routes. |
| Delivery | 25/25 | Same as Round 1. |
| **Total** | **92/100** | |

**What was fixed:**
- Added `courses.test.ts` with 10 tests covering health check, course API, payment validation, recommendation flow
- Added try/catch to all 4 course routes, payment Stripe call, recommendation Stripe call
- Tests run in isolated temp DB to avoid filesystem issues

## Remaining Gaps (honest)

- **Commit convention** (3/10): Historical commits can't be retrofitted with Card IDs. This is a process discipline issue that the skill now enforces for future projects.
- **Architecture** (8/10): 4 layers (routes/services/db/lib) is clean but not deep. A larger project would benefit from more separation.
- **Test coverage**: 10 tests cover the happy paths and basic error cases. No load testing, no edge case fuzzing, no integration tests with real Stripe.

## Key Insight

> A person with zero coding experience built a working e-commerce platform
> with payment processing, PDF generation, and multi-language support — in a single
> evening session — using the 5x-cto methodology.
>
> The first pass scored 84/100. After the methodology identified the gaps
> (no tests, uneven error handling), fixes brought it to 92/100.
> The methodology caught what a human reviewer would catch.

---

*Scored by 5x-cto/scripts/score.sh — Round 1: 84, Round 2: 93*

## Appendix: Raw Score Output

See [ai-academy-score-output.txt](2026-03-16-ai-academy-score-output.txt) for the complete, unedited `score.sh` output.

**How to reproduce:** Clone the washin-academy repo and run:
```bash
bash scripts/score.sh /path/to/washin-academy
```

Note: The source repo is private. This raw output is provided as the closest available audit evidence.
