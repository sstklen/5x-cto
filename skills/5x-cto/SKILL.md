---
name: 5x-cto
description: |
  Public version of the 5x-cto methodology skill for Claude Code.

  A structured requirements-to-delivery pipeline where Claude (Opus) leads Codex CLI
  through high-standard requirement → spec → implementation → acceptance workflows.

  Use this when:
  1. You have a task, feature, or fix list that needs to go through a complete pipeline
  2. You want structured card-based work delegation to Codex CLI
  3. You need clear separation of concerns: planning, implementation, and review
  4. You have multiple cards to process sequentially
  5. A new project or feature needs to go from requirements all the way to delivery

  Core: Product Owner defines requirements, Opus writes specs + cuts cards + reviews, Codex implements + reports. Role boundaries are strictly separated.
version: 1.0.0
date: 2026-03-15
author: sstklen
---

# 5x-CTO — Requirements to Delivery Pipeline

> Product Owner = define requirements + confirm specs | Opus = specs + cut cards + review | Codex = implementation

---

## Entry Point: Which Phase to Start From?

```
What does the Product Owner provide?
│
├─ Vague idea / problem description → Phase R (Requirements)
├─ Requirements exist, need system design → Phase S (Specification)
├─ Spec exists, ready to build → Phase 0 (Init + Cut Cards)
├─ CARDS.md already exists → Phase 2 (Dispatch directly)
└─ Small fix / bug → Skip R+S, go directly to Phase 0
```

---

## Phase R: Requirements

The Product Owner describes what they want, Opus helps structure it.

### Guiding Questions (Product Owner only needs to answer these)

1. **What problem are we solving?** — Without this, what's the pain right now?
2. **Who will use it?** — What role, what level of user?
3. **How do we know it's done?** — After completion, how do you judge "correct"?
4. **What's out of scope?** — Explicitly exclude what?

### Opus Output Format

```markdown
# Requirements: {Project Name}

## REQ-01: {Title}
- Background: {Why is this needed}
- Users: {Who}
- Scenario: {When used, how triggered}
- Success Criteria: {Observable pass/fail}
- Non-Goals: {What we won't do}
- Constraints: {Technical/business/time limits}
- Acceptance Criteria: {How to test, how to judge}

## REQ-02: ...
```

### Phase R Completion Checklist

- [ ] Every requirement has pass/fail acceptance criteria (not vague descriptions)
- [ ] Non-goals are explicitly listed
- [ ] Product Owner confirms: "This is the problem I want solved"

Pass → Phase S

---

## Phase S: Specification

Opus translates requirements into system behavior.

### Opus Output Format

```markdown
# Specification: {Project Name}

## SPEC-01 (→ REQ-01): {Title}
- Input: {Trigger conditions}
- Behavior: {What the system does}
- Output: {What it returns, what it displays}
- Exceptions: {How each error is handled}
- Edge Cases: {Extreme scenarios}
- Examples:
  - Normal: request → response
  - Error: request → error response
  - Edge: edge case → expected behavior

## SPEC-02 (→ REQ-01): ...

## Assumptions
| ID | Assumption | Verification Method | Status |
|----|-----------|-------------------|--------|
| A-01 | ... | ... | Verified/Pending/Rejected |

## Open Questions
| ID | Question | Impact Scope | Status |
|----|----------|-------------|--------|
| Q-01 | ... | SPEC-XX | Open/Decided/N-A |

## Decision Log
| ID | Decision | Reason | Rejected Alternatives | Date |
|----|----------|--------|----------------------|------|
| D-01 | ... | ... | ... | YYYY-MM-DD |

## Traceability
| REQ | SPEC | Status |
|-----|------|--------|
| REQ-01 | SPEC-01, SPEC-02 | Done |
| REQ-02 | — | Not yet designed |
```

### Phase S Completion Checklist

- [ ] Every spec has examples (not just abstract text)
- [ ] Every spec traces back to a requirement
- [ ] Assumptions registry fully resolved (no "Pending" — either verified or prototyped first)
- [ ] Open Questions fully cleared (no "Open" — either decided or marked N/A)
- [ ] All decided questions recorded in Decision Log
- [ ] Product Owner confirms: "This is the system behavior I want"

Pass → Phase 0

---

## Phase 0: Init

After spec confirmation, prepare for implementation.

1. **Confirm working directory** — `pwd` + `git status`, working tree clean
2. **Confirm Codex available** — `which codex`
3. **Build traceability table** — REQ → SPEC → CARD mapping

Init announcement format:
```
Init complete.
Project: {project path}
Working tree: {clean / has uncommitted changes → handle first}
Codex: {available / unavailable}
Requirements: {N items}  Specs: {N items}  Ready to cut cards
```

---

## Phase 1: Cut Cards

Analyze the task, break it into independent cards, write to CARDS.md.

### Card-Cutting Principles

- One card = one independently verifiable goal
- One card should be completable in a single Codex session
- Mark dependency order where needed; independent cards can run in parallel
- Not too large (back-and-forth gets heavy), not too granular (overhead too high)

### Card Format (required for each card)

```markdown
## CARD-XX: {Single Verifiable Goal}

**Status:** todo
**Traces:** SPEC-XX → REQ-XX
**Why:** {What problem this solves, one sentence}
**Dependencies:** None / CARD-YY

### Scope
- Only modify: {file/module list}
- Only do: {behavior description}

### Non-scope
- Don't touch: {explicitly excluded files/modules/behaviors}

### Environment
- Runtime: bun/npm/yarn (or python, etc.)
- Working directory: {path}
- Requires: {tools needed for this card}
- Codex limitations: {if any unavailable items, note here}

### WORKORDER
1. {Concrete step 1}
2. {Concrete step 2}
3. ...

### Implementation Constraints
- {Technical limitations}

### ACCEPTANCE
- [ ] {Observable, testable, pass/fail condition 1}
- [ ] {Condition 2}
- [ ] ...

### Acceptance Evidence
- {What output to check: specific command + expected result}

### Required Checks
- {test command / typecheck / curl ... / etc.}

### Done Definition
All ACCEPTANCE checked + Required Checks all pass = PASS
```

### Report to Product Owner After Cutting

```
Cards ready, total N cards:
| Card | Goal | Dependencies | Priority |
|------|------|-------------|----------|
| CARD-01 | ... | None | P1 |
| CARD-02 | ... | CARD-01 | P1 |
| CARD-03 | ... | None | P2 |

Ready to start? (Say "go" and it will auto-run from CARD-01 to the last card)
```

---

## Auto-Run Mode (Default)

After card confirmation, **automatically runs from CARD-01 to the last card without stopping.**

### Product Owner Only Appears Three Times

| # | Action | When |
|---|--------|------|
| 1 | State requirements | Phase R |
| 2 | Confirm specs + cards | Phase S → Phase 1 |
| 3 | Receive final acceptance report | After everything completes |

### Auto-Advance Rules

- **PASS** → commit → auto-advance to next card (no human input)
- **FAIL** → auto-rework (up to 3 rounds, no human input)
- **3 rounds failed** → `blocked` → skip, continue with other non-dependent cards
- **All complete** → Phase 5.5 Total Acceptance → report to Product Owner

### Only Stop Conditions

1. All cards complete (or cannot continue) → enter Total Acceptance
2. Blocked card blocks all subsequent cards → stop and report
3. Context pressure (every 5 cards) → suggest checkpoint, but not forced

### In-Progress Tracking (Not a Stop, Just Recording)

After each card completes, record a line in PROGRESS.md without interrupting the flow.
Product Owner can check the file anytime without waiting for the AI to ask.

---

## Phase 2: Dispatch

In Auto-Run mode, automatically dispatch cards to Codex one by one.

### Pre-Dispatch Checks (Required for Each Card)

1. Working tree clean? (`git status` has no uncommitted changes from other cards)
2. Prerequisite dependency cards already `accepted`?
3. Tools required by this card's Environment are available to Codex?

### Codex Dispatch Command

```bash
codex exec "
Your task is {Card ID}: {Title}

## WORKORDER
{Complete WORKORDER content}

## Scope Limits
- Can only modify: {Files in scope}
- Cannot touch: {Non-scope}
- Cannot expand scope, cannot fix other things on the side

## Implementation Constraints
{constraints}

## After Completion (Required)
1. Execute these checks:
{Required Checks — listed one by one}

2. Report using this fixed format (no free-form reporting):

### REPORT
- Card: {Card ID}
- Status: DONE / BLOCKED
- Files changed: {filename + one-sentence change summary}
- Checks executed:
  - {check}: {command} → {PASS/FAIL + summary}
- Acceptance self-check:
  - {condition1}: PASS/FAIL
  - {condition2}: PASS/FAIL
- Blockers: None / {specific blocker}

3. Only git add files related to this card, do not git add . and do not git commit
" --full-auto --skip-git-repo-check
```

### After Dispatch

- Record `CARD-XX: dispatched → Codex`
- Wait for Codex report

---

## Phase 3: Review

After Codex reports, Opus performs acceptance review.

### Three Review Tasks (Only These Three, No More No Less)

1. **Matches ACCEPTANCE?** — Compare Codex's self-check against actual output line by line
2. **Regression risk?** — `git diff` for unexpected changes, grep upstream/downstream for impact
3. **Test gaps?** — Did Required Checks actually run? Are results traceable?

### Independent Verification (Don't Just Trust Codex's Self-Report)

```bash
# 1. Check actual changes
git diff --stat
git diff

# 2. Run Required Checks yourself
{Execute Required Checks one by one}

# 3. Confirm scope wasn't exceeded
# Are all changed files within Scope?
```

### Review Output Format (Fixed)

```markdown
### Verdict: PASS / FAIL

### Findings
- {Specific items not matching ACCEPTANCE, or "None"}

### Risks
- {Regression risks or test gaps, or "None"}

### Required Fixes (Only when FAIL)
- {fix 1 — must trace back to an ACCEPTANCE item}
- {fix 2}
(Don't write complete code, just describe "what's wrong, what to achieve")

### Evidence
- {command}: {output summary}
- {command}: {output summary}

### Scope Control
- {Out-of-scope changes: None / list them}
```

---

## Phase 4: Rework (On FAIL)

### Rework Dispatch Command

```bash
codex exec "
{Card ID} failed review, needs fixes:

## Required Fixes
{List Required Fixes from Phase 3 one by one}

## Constraints
- Only fix the issues listed above
- Do not expand scope
- Re-run Required Checks after fixing
- Report using the fixed REPORT format

## Previous Changes
Keep the correct parts already done, only fix what failed
" --full-auto --skip-git-repo-check
```

### Circuit Breaker

- Round 1 FAIL → normal rework
- Round 2 FAIL → normal rework, but start paying attention
- Round 3 FAIL → **circuit break**, mark `blocked`, report to Product Owner:
  ```
  CARD-XX failed 3 rounds, blocked.
  Root cause assessment: {card too large / unclear definition / Codex capability limit / technical obstacle}
  Suggestion: {split into sub-cards / rewrite acceptance criteria / Opus takes over}
  ```

---

## Phase 5: Pass → Commit → Next Card

### Post-PASS Flow

```bash
# 1. Confirm staged content is only this card's files
git diff --cached --stat

# 2. Commit
git commit -m "$(cat <<'EOF'
{type}: {description} ({Card ID})

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
EOF
)"

# 3. Update CARDS.md — change this card's status to accepted
# 4. Write PROGRESS.md — "CARD-XX — {one sentence}"
```

### Auto-Advance Checks

Before moving to next card, must confirm:
- [ ] Current card is `accepted` and committed
- [ ] Working tree is clean (`git status` no residuals)
- [ ] No `blocked` dependency cards blocking subsequent work
- [ ] Next card's prerequisites are all `accepted`

All pass → **auto-advance to next card**:
```
CARD-XX done → auto-dispatch CARD-YY
(No stopping, no asking, until all complete or blocked)
```

---

## Phase 5.5: Total Acceptance (After All Cards Complete)

> **Per-card review checks "is this card correct", Total Acceptance checks "can the whole system work".**

After all cards are `accepted` (or all doable cards complete, remainder is `blocked`), trigger Total Acceptance.

### A. End-to-End Flow

- [ ] Walk through the complete flow from user perspective
- [ ] Every entry point reaches the expected exit
- [ ] Error paths have reasonable handling

### B. Cross-Module Integration

- [ ] Import chains between modules are complete (zero broken links)
- [ ] Data flow between APIs is correct
- [ ] Shared types / constants are consistent

### C. Architecture Consistency

- [ ] Naming conventions are uniform (variables, functions, files)
- [ ] Error handling patterns are uniform
- [ ] Response formats are uniform

### D. Security Full Check

- [ ] Zero hardcoded secrets (all via env)
- [ ] Environment variables centrally managed (config.ts or similar)
- [ ] Input validation coverage

### E. Deployment Readiness

- [ ] Traceability table complete (every REQ has corresponding PASS card)
- [ ] Migration / seed scripts are executable
- [ ] Config aligned with production
- [ ] Rollback plan prepared
- [ ] Health check covers new features
- [ ] No unresolved open questions

### F. Scoring (If score.sh Exists)

- [ ] Run scoring script
- [ ] Generate scorecard
- [ ] Save scorecard to case-studies/

### Total Acceptance Output Format

```markdown
# Total Acceptance Report

## Project: {name}
## Date: {date}
## Cards: {accepted}/{total} (blocked: {N})

### Scorecard
| Category | Max Score | Score |
|----------|----------|-------|
| Process Compliance | 35 | XX |
| Code Quality | 40 | XX |
| Delivery Completeness | 25 | XX |
| **Total** | **100** | **XX** |

### End-to-End: PASS / FAIL
### Cross-Module Integration: PASS / FAIL
### Architecture Consistency: PASS / FAIL
### Security: PASS / FAIL
### Deployment Readiness: PASS / FAIL

### Blocked Cards (If Any)
- CARD-XX: {reason}

### Recommendations
- {Next steps}
```

Total Acceptance complete → report to Product Owner: "All done, here's the scorecard. Ready to deploy?"

### Post-Deploy 24h Verification

- [ ] Health check normal
- [ ] Core API response times not degraded
- [ ] 5xx error rate not spiking
- [ ] Real user operation flows not broken
- Issues found → backfill traceability table + record lessons learned

---

## Phase 6: Anti-Forget Mechanism

> Core principle: Don't trust model memory, only trust rebuildable external state.

### Checkpoint (Required After Each Card Accepted)

Three files updated simultaneously, all required:

```bash
# 1. Update PIPELINE_STATE.json
# current_card → next_card, last_accepted_card → just completed card, accepted_count +1

# 2. Update CARDS.md
# Change this card's status to accepted

# 3. Update PROGRESS.md
# Add a line: "CARD-XX — {one sentence}"
```

### Pipeline Initialization (Created at Phase 0)

```bash
# Create in project root directory
cat > PIPELINE_STATE.json << 'EOF'
{
  "project": "{project name}",
  "current_phase": "Phase 1",
  "current_card": null,
  "last_accepted_card": null,
  "blocked_cards": [],
  "next_card": "CARD-01",
  "last_commit": null,
  "total_cards": 0,
  "accepted_count": 0,
  "open_questions": 0,
  "updated_at": "{ISO timestamp}"
}
EOF
```

### Resume (Flow When Continuing)

Trigger: "continue pipeline", "resume pipeline", "pipeline status"

```
1. Read PIPELINE_STATE.json     → know where we left off
2. Read CARDS.md                → confirm card statuses
3. Read PROGRESS.md             → understand completed summary
4. Report:
   "Last time we reached {current_card}, completed {accepted_count}/{total_cards}.
    Next: {next_card} — {title}
    Blocked: {blocked_cards}
    Continue?"
5. Product Owner confirms → then continue
```

**Forbidden:** Resume and dispatch immediately without reporting status first.

### Forget-Safe Rule

Cannot determine with 100% certainty where we left off → **stop**.

```
PIPELINE_STATE.json doesn't exist → stop, ask Product Owner
PIPELINE_STATE.json and CARDS.md statuses don't match → stop, fix first
Unsure if last round was PASS or FAIL → stop, check git log to confirm
```

**Forbidden:** Guessing, assuming, "it should be at CARD-XX".

### Every 5 Cards

- Check context pressure
- Suggest to Product Owner: "Completed N cards, suggest saving and starting a new session"
- Before handoff, confirm all three files are up to date

---

## Quick Reference

### Status Flow

```
todo → in_progress → review → accepted
                       ↓
                     FAIL (≤2x) → in_progress
                       ↓
                     FAIL (3rd) → blocked
```

### Problem Found During Implementation → Stop Protocol

```
Found an issue at requirements/spec/implementation layer
  → Stop immediately
  → Determine which layer has the problem (requirements wrong? spec mistranslated? implementation wrong?)
  → Fix that layer's document
  → Re-align traceability table from the fix point downward
  → Product Owner confirms → then continue
```

### Opus Red Lines

- Don't modify src/ files directly (except blocked takeover, must be marked)
- Don't write complete code in Required Fixes
- Don't smuggle new standards not in ACCEPTANCE through fixes
- Don't rewrite requirements during review
- Don't assume "it probably means this" and continue (if in doubt, stop and ask)

### Codex Red Lines

- Don't expand scope
- Don't invent workaround solutions
- Don't skip Required Checks
- Don't use free-form reporting
- Don't `git add .` or stage files not belonging to this card

### Common Commands

```bash
# Dispatch
codex exec "..." --full-auto --skip-git-repo-check

# Review checks
git diff --stat
git diff
bun test          # or: npm test / yarn test
bun run typecheck # or: npx tsc --noEmit

# Commit
git commit -m "feat: ... (CARD-XX)"

# Check progress
cat PIPELINE_STATE.json
cat CARDS.md
cat PROGRESS.md
```

---

*v1.0.0 — 2026-03-16 — by sstklen*
*Full pipeline: Phase R(Requirements) → Phase S(Specification) → Phase 0-6(Implementation + Review + Total Acceptance)*
*Features: Auto-Run mode (one-click end-to-end) + Total Acceptance (full system scoring)*
