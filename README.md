# 5x-cto

**Spec-ops for non-coders.** $400/mo outperforms $1,000/mo.

> You don't need to code. You need to spec.

---

## What is this?

A battle-tested development methodology that lets **non-technical founders** build production-grade systems using AI.

- **Claude Opus** = Your CTO (writes specs, cuts tasks, reviews code)
- **Codex CLI** = Your engineer (writes code, runs tests, reports back)
- **You** = The product owner (says what you want in plain language)

No coding required. Seriously.

## The 5x Claim

Claude MAX plan charges Opus tokens at **~10x the rate** of lighter models. When you use Opus for everything — including writing for-loops and fixing CSS — you're paying PhD rates for manual labor.

**5x-cto splits the work:**

| Role | Who | Token Budget |
|------|-----|-------------|
| Thinking (specs, review, acceptance) | Opus (~15-20%) | Your Claude MAX |
| Building (code, debug, tests) | Codex (~80-85%) | Separate Codex budget |

**Result:** Your Claude MAX subscription stretches **5x further** because 80% of the work runs on a separate budget.

### Cost Comparison

| Setup | Monthly Cost | Capacity | Quality |
|-------|-------------|----------|---------|
| 5× Claude MAX (all Opus) | $1,000 | Not enough | ★★★★★ |
| 5× Claude MAX (all Sonnet) | $1,000 | 10× more | ★★★★ |
| **1× MAX + 1× Codex (5x-cto)** | **$400** | **≥ all-Opus** | **★★★★★** |

Same quality. 60% cheaper. More capacity.

## The Real Selling Point

> **This skill IS your technical ability.**

It asks the right questions, breaks work into the right steps, and enforces quality at every gate. You only need to know **what problem you're solving** — the process guarantees the quality.

### Proven: A non-technical founder built these production systems using this methodology:

- Production API serving 30+ external service integrations
- AI-powered analytics platform
- Multi-language AI chatbot system
- Full certification & examination platform
- E-commerce with Stripe payments, PDF certificates, QR verification

All running in production. Not demos — real revenue-generating systems.

## How It Works

### You show up 3 times. AI handles the rest.

```
 You                          AI
  │                            │
  ├─ "I want X" ──────────►  Phase R: Structures your requirements
  │                            │
  ├─ "Yes, that's right" ──►  Phase S: Writes technical spec
  │                           Phase 1: Cuts work into cards
  │                           Phase 2-5: Auto-runs ALL cards
  │                             ├─ Card 1 → Build → Review → ✅
  │                             ├─ Card 2 → Build → Review → ✅
  │                             ├─ Card 3 → Build → Review → ✅
  │                             └─ ...
  │                           Phase 5.5: Total System Review
  │                            │
  └─ Reviews final report ◄──┘
```

### Quality Gates (Built-in, Not Optional)

Every card goes through:

1. **Scope control** — Only touches files in scope. No side effects.
2. **Acceptance criteria** — Pass/fail, not "looks good"
3. **Independent verification** — Opus re-runs checks, doesn't trust self-reports
4. **Rework loop** — Fail? Fix and resubmit. 3 failures = blocked, escalate.

After ALL cards complete, **Total Acceptance**:

- End-to-end flow verification
- Cross-module integration check
- Architecture consistency review
- Security audit
- Deploy readiness assessment
- Automated scoring (see `scripts/score.sh`)

## Quick Start

### Prerequisites

- Claude Code with MAX plan ($200/mo) — set to Opus model
- OpenAI Codex CLI with Pro plan ($200/mo)

### Install

```bash
# Copy the skill to your Claude Code skills directory
cp -r skills/5x-cto ~/.claude/skills/

# Verify
ls ~/.claude/skills/5x-cto/SKILL.md
```

### Usage

Open Claude Code and say:

```
"I want to build a bookmark API with auth, CRUD, and search"
```

The skill activates automatically. You'll be guided through requirements, then it runs.

### Run the Scorer

After your pipeline completes:

```bash
bash scripts/score.sh /path/to/your/project
```

## Case Studies

Real projects, real scores, built by a non-technical founder:

| Date | Project | Cards | Score | Highlights |
|------|---------|-------|-------|------------|
| 2026-03-16 | [AI Academy](case-studies/2026-03-16-ai-academy.md) | 9/9 ✅ | 87/100 | Stripe + PDF certs + i18n |
| 2026-03-16 | [Boss Dashboard](case-studies/2026-03-16-boss-dashboard.md) | 4/4 ✅ | 85/100 | Real-time status + 3-lang UI |

## FAQ

**Q: Do I really not need to code?**
A: Correct. You need to know what problem you're solving and who it's for. The methodology handles the rest.

**Q: What if a card fails 3 times?**
A: It's marked "blocked." The system skips it, continues with other cards, and reports the blocker. You decide: re-scope, simplify, or have Opus take over.

**Q: Is 5x really accurate?**
A: Conservative estimate. Opus handles ~20% of work (specs + review). The rest goes to Codex on a separate budget. Measured range: 5-7x depending on task type.

**Q: Can I use this with other AI tools?**
A: The methodology is model-agnostic. The skill is written for Claude + Codex, but the principles (requirement → spec → card → build → review) work with any AI coding tool.

## License

MIT — Use it, modify it, ship with it.

---

*Built by a non-technical founder in rural Japan. If I can build production systems with this, so can you.*
