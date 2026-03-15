#!/bin/bash
# 5x-cto Project Scorer v2
# Heuristic quality checker for projects built with 5x-cto methodology
# Usage: bash score.sh /path/to/project
#
# LIMITATIONS (read before trusting scores):
# - This is a heuristic checker, not a security audit or code review
# - Keyword-based checks can miss real issues and flag false positives
# - "No src directory" = 0 points, not free points
# - Scores are relative indicators, not absolute quality guarantees
# - Always pair with human review for production deployments

set -uo pipefail
# Note: not using -e (errexit) because grep returning no matches (exit 1)
# and head causing SIGPIPE (exit 141) are expected behaviors in a scorer.

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

echo "============================================"
echo "  5x-cto Project Scorer v2"
echo "  Project: $(basename "$PWD")"
echo "  Date: $(date '+%Y-%m-%d %H:%M')"
echo "  Type: Heuristic (not audit)"
echo "============================================"
echo ""

TOTAL=0
MAX_TOTAL=100
WARNINGS=""

# Safe grep -c: returns count without the || echo 0 bug
safe_grep_c() {
  local count
  count=$(grep -c "$@" 2>/dev/null) || true
  echo "$((count + 0))"
}

# ─────────────────────────────────────────────
# SECTION 1: Process Compliance (35 points)
# ─────────────────────────────────────────────
echo "## Process Compliance (max 35)"
echo ""
S1=0

# 1.1 Pipeline state file (10 pts)
if [ -f "PIPELINE_STATE.json" ]; then
  phase=$(grep -o '"current_phase"[^,]*' PIPELINE_STATE.json | cut -d'"' -f4 || echo "unknown")
  if [ "$phase" = "Complete" ]; then
    echo "  [10/10] Pipeline state: Complete"
    S1=$((S1 + 10))
  else
    echo "  [ 5/10] Pipeline state: $phase (not complete)"
    S1=$((S1 + 5))
  fi
else
  echo "  [ 0/10] Pipeline state: MISSING"
fi

# 1.2 Cards all accepted (10 pts)
if [ -f "PIPELINE_STATE.json" ] && [ -f "CARDS.md" ]; then
  total_cards=$(grep -o '"total_cards"[^,]*' PIPELINE_STATE.json | grep -o '[0-9]*' || echo "0")
  accepted=$(grep -o '"accepted_count"[^,]*' PIPELINE_STATE.json | grep -o '[0-9]*' || echo "0")
  total_cards=$((total_cards + 0))
  accepted=$((accepted + 0))
  if [ "$total_cards" -gt 0 ] && [ "$accepted" -ge "$total_cards" ]; then
    echo "  [10/10] Cards: $accepted/$total_cards accepted"
    S1=$((S1 + 10))
  elif [ "$total_cards" -gt 0 ]; then
    pts=$((accepted * 10 / total_cards))
    echo "  [ $pts/10] Cards: $accepted/$total_cards accepted"
    S1=$((S1 + pts))
  else
    echo "  [ 0/10] Cards: No cards found in pipeline state"
  fi
elif [ -f "CARDS.md" ]; then
  total_cards=$(safe_grep_c "^## CARD-" CARDS.md)
  echo "  [ 5/10] Cards: CARDS.md found ($total_cards cards), no pipeline state"
  S1=$((S1 + 5))
else
  echo "  [ 0/10] Cards: CARDS.md MISSING"
fi

# 1.3 Progress documented (5 pts)
if [ -f "PROGRESS.md" ]; then
  lines=$(safe_grep_c "CARD-" PROGRESS.md)
  if [ "$lines" -gt 0 ]; then
    echo "  [ 5/ 5] Progress: $lines entries documented"
    S1=$((S1 + 5))
  else
    echo "  [ 2/ 5] Progress: File exists but no card entries"
    S1=$((S1 + 2))
  fi
else
  echo "  [ 0/ 5] Progress: PROGRESS.md MISSING"
fi

# 1.4 Commits with Card ID (10 pts)
if git rev-parse --git-dir >/dev/null 2>&1; then
  commit_lines=$(git log --oneline --no-merges -20 2>/dev/null || true)
  total_commits=$(echo "$commit_lines" | grep -c . || true)
  total_commits=$((total_commits + 0))
  card_commits=$(echo "$commit_lines" | grep -cE "CARD-[0-9]+" || true)
  card_commits=$((card_commits + 0))
  if [ "$total_commits" -gt 0 ]; then
    pct=$((card_commits * 100 / total_commits))
    pts=$((pct / 10))
    [ "$pts" -gt 10 ] && pts=10
    echo "  [ $pts/10] Commit convention: $card_commits/$total_commits with Card ID ($pct%)"
    S1=$((S1 + pts))
  else
    echo "  [ 0/10] Commit convention: No commits found"
  fi
else
  echo "  [ 0/10] Commit convention: Not a git repository"
fi

echo ""
echo "  Section 1 Total: $S1/35"
echo ""

# ─────────────────────────────────────────────
# SECTION 2: Code Quality (40 points)
# No src directory = 0 for entire section
# ─────────────────────────────────────────────
echo "## Code Quality (max 40)"
echo ""
S2=0

# Find source directory
SRC_DIR=""
for d in src lib app; do
  [ -d "$d" ] && SRC_DIR="$d" && break
done

if [ -z "$SRC_DIR" ]; then
  echo "  [ 0/40] No source directory found (src/, lib/, or app/)"
  echo "          Cannot evaluate code quality without source files."
  WARNINGS="${WARNINGS}\n  - Code quality scored 0: no source directory"
else

  # 2.1 No hardcoded secrets (10 pts)
  # Checks for: live API keys, hardcoded passwords with values
  # Limitation: keyword-based, may miss obfuscated secrets or flag false positives
  secrets=$(grep -rnE "sk_live_|sk_test_[a-zA-Z0-9]{20,}|AKIA[0-9A-Z]{16}|password\s*=\s*['\"][^'\"]{8,}['\"]" "$SRC_DIR" --include="*.ts" --include="*.js" --include="*.py" 2>/dev/null | grep -cvE "env|process|config|import|//|#|test|example|placeholder|changeme|TODO" || true)
  secrets=$((secrets + 0))
  if [ "$secrets" -eq 0 ]; then
    echo "  [10/10] Secrets: No hardcoded secrets detected (heuristic)"
    S2=$((S2 + 10))
  else
    echo "  [ 3/10] Secrets: $secrets potential hardcoded secrets (review manually)"
    S2=$((S2 + 3))
    WARNINGS="${WARNINGS}\n  - $secrets potential hardcoded secrets found — manual review needed"
  fi

  # 2.2 Architecture separation (10 pts)
  layers=0
  layer_names=""
  for layer in routes api services db lib models utils middleware hub controllers; do
    if [ -d "$SRC_DIR/$layer" ]; then
      layers=$((layers + 1))
      layer_names="${layer_names} ${layer}"
    fi
  done
  if [ "$layers" -ge 3 ]; then
    echo "  [10/10] Architecture: $layers layers ($layer_names )"
    S2=$((S2 + 10))
  elif [ "$layers" -ge 2 ]; then
    echo "  [ 7/10] Architecture: $layers layers ($layer_names )"
    S2=$((S2 + 7))
  elif [ "$layers" -ge 1 ]; then
    echo "  [ 4/10] Architecture: $layers layer ($layer_names )"
    S2=$((S2 + 4))
  else
    echo "  [ 2/10] Architecture: Flat structure (no subdirectories)"
    S2=$((S2 + 2))
  fi

  # 2.3 Import chain integrity (5 pts)
  # Requires bun. No bun = 0 points (can't verify = can't score)
  if command -v bun &>/dev/null; then
    import_total=0
    import_pass=0
    import_fail_list=""
    for f in $(find "$SRC_DIR" -name "*.ts" -not -path "*/node_modules/*" -not -name "*.test.*" -not -name "*.spec.*" 2>/dev/null | head -20); do
      import_total=$((import_total + 1))
      if bun build --target=bun "$f" --outdir=/tmp/5xcto-check 2>&1 | grep -qi error; then
        import_fail_list="${import_fail_list} $(basename "$f")"
      else
        import_pass=$((import_pass + 1))
      fi
    done
    if [ "$import_total" -gt 0 ]; then
      if [ "$import_pass" -eq "$import_total" ]; then
        echo "  [ 5/ 5] Import chain: $import_pass/$import_total verified clean"
        S2=$((S2 + 5))
      else
        pts=$((import_pass * 5 / import_total))
        echo "  [ $pts/ 5] Import chain: $import_pass/$import_total (failed:$import_fail_list )"
        S2=$((S2 + pts))
      fi
    else
      echo "  [ 0/ 5] Import chain: No .ts files found"
    fi
  else
    echo "  [ 0/ 5] Import chain: SKIPPED (bun not installed, cannot verify)"
    WARNINGS="${WARNINGS}\n  - Import chain not verified: bun not available"
  fi

  # 2.4 Error handling (10 pts)
  # Limitation: checks for try/catch/throw keywords, not quality of error handling
  total_files=$(find "$SRC_DIR" \( -name "*.ts" -o -name "*.js" \) -not -path "*/node_modules/*" -not -name "*.test.*" -not -name "*.spec.*" -not -name "*.d.ts" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$total_files" -gt 0 ]; then
    files_with_errors=$(grep -rlE "try\s*\{|catch\s*\(|throw\s" "$SRC_DIR" --include="*.ts" --include="*.js" 2>/dev/null | grep -v node_modules | grep -v "\.test\." | grep -v "\.spec\." | wc -l | tr -d ' ')
    pct=$((files_with_errors * 100 / total_files))
    pts=$((pct / 10))
    [ "$pts" -gt 10 ] && pts=10
    echo "  [ $pts/10] Error handling: $files_with_errors/$total_files files ($pct%) (keyword check)"
    S2=$((S2 + pts))
    if [ "$pct" -lt 50 ]; then
      WARNINGS="${WARNINGS}\n  - Error handling below 50% — review routes without try/catch"
    fi
  else
    echo "  [ 0/10] Error handling: No source files found"
  fi

  # 2.5 Tests exist and pass (5 pts)
  test_files=$(find . \( -name "*.test.*" -o -name "*.spec.*" \) -not -path "*/node_modules/*" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$test_files" -gt 0 ]; then
    if command -v bun &>/dev/null; then
      test_output=$(bun test 2>&1)
      if echo "$test_output" | grep -q "pass"; then
        pass_count=$(echo "$test_output" | grep -oE "[0-9]+ pass" | grep -oE "[0-9]+" || echo "?")
        fail_count=$(echo "$test_output" | grep -oE "[0-9]+ fail" | grep -oE "[0-9]+" || echo "0")
        fail_count=$((fail_count + 0))
        if [ "$fail_count" -eq 0 ]; then
          echo "  [ 5/ 5] Tests: $test_files file(s), $pass_count passed, 0 failed"
          S2=$((S2 + 5))
        else
          echo "  [ 2/ 5] Tests: $test_files file(s), $pass_count passed, $fail_count FAILED"
          S2=$((S2 + 2))
          WARNINGS="${WARNINGS}\n  - $fail_count test(s) failing"
        fi
      else
        echo "  [ 1/ 5] Tests: $test_files file(s) exist but tests did not pass"
        S2=$((S2 + 1))
      fi
    else
      echo "  [ 0/ 5] Tests: $test_files file(s) exist but cannot run (bun not installed)"
      WARNINGS="${WARNINGS}\n  - Tests not executed: bun not available"
    fi
  else
    echo "  [ 0/ 5] Tests: No test files found"
  fi

fi  # end SRC_DIR check

echo ""
echo "  Section 2 Total: $S2/40"
echo ""

# ─────────────────────────────────────────────
# SECTION 3: Delivery Completeness (25 points)
# ─────────────────────────────────────────────
echo "## Delivery Completeness (max 25)"
echo ""
S3=0

# 3.1 All cards shipped (10 pts)
if [ -f "PIPELINE_STATE.json" ]; then
  accepted_count=$(grep -o '"accepted_count"[^,]*' PIPELINE_STATE.json | grep -o '[0-9]*' || echo "0")
  total_count=$(grep -o '"total_cards"[^,]*' PIPELINE_STATE.json | grep -o '[0-9]*' || echo "0")
  accepted_count=$((accepted_count + 0))
  total_count=$((total_count + 0))
  if [ "$total_count" -gt 0 ]; then
    if [ "$accepted_count" -eq "$total_count" ]; then
      echo "  [10/10] Delivery: $accepted_count/$total_count cards shipped"
      S3=$((S3 + 10))
    else
      pts=$((accepted_count * 10 / total_count))
      blocked=$((total_count - accepted_count))
      echo "  [ $pts/10] Delivery: $accepted_count/$total_count shipped ($blocked blocked/incomplete)"
      S3=$((S3 + pts))
    fi
  else
    echo "  [ 0/10] Delivery: Cannot parse pipeline state"
  fi
else
  echo "  [ 0/10] Delivery: No PIPELINE_STATE.json"
fi

# 3.2 Traceability (10 pts) — replaces keyword-based "feature completeness"
# Checks if REQ → SPEC → CARD traceability exists
trace_score=0
if [ -f "CARDS.md" ]; then
  has_traces=$(safe_grep_c "Traces.*SPEC\|Traces.*REQ\|SPEC-[0-9]" CARDS.md)
  if [ "$has_traces" -gt 0 ]; then
    trace_score=$((trace_score + 5))
    echo "  [ 5/10] Traceability: $has_traces trace references in CARDS.md"
  else
    echo "  [ 0/10] Traceability: No REQ/SPEC traces in CARDS.md"
  fi
else
  echo "  [ 0/10] Traceability: No CARDS.md"
fi
# Check for requirements or spec docs
req_files=$(find . -maxdepth 2 \( -name "*REQ*" -o -name "*SPEC*" -o -name "*requirement*" -o -name "*spec*" \) -not -path "*/node_modules/*" 2>/dev/null | wc -l | tr -d ' ')
if [ "$req_files" -gt 0 ]; then
  trace_score=$((trace_score + 5))
  echo "          + $req_files requirement/spec doc(s) found"
fi
S3=$((S3 + trace_score))

# 3.3 Pipeline tracking completeness (5 pts)
pipeline_files=0
[ -f "PIPELINE_STATE.json" ] && pipeline_files=$((pipeline_files + 1))
[ -f "CARDS.md" ] && pipeline_files=$((pipeline_files + 1))
[ -f "PROGRESS.md" ] && pipeline_files=$((pipeline_files + 1))
if [ "$pipeline_files" -eq 3 ]; then
  echo "  [ 5/ 5] Pipeline files: All 3 present (STATE + CARDS + PROGRESS)"
  S3=$((S3 + 5))
elif [ "$pipeline_files" -ge 1 ]; then
  echo "  [ 2/ 5] Pipeline files: $pipeline_files/3 present"
  S3=$((S3 + 2))
else
  echo "  [ 0/ 5] Pipeline files: None found"
fi

echo ""
echo "  Section 3 Total: $S3/25"
echo ""

# ─────────────────────────────────────────────
# FINAL SCORE
# ─────────────────────────────────────────────
TOTAL=$((S1 + S2 + S3))

echo "============================================"
echo ""
echo "  FINAL SCORE: $TOTAL / $MAX_TOTAL"
echo ""
echo "  | Category           | Score   |"
echo "  |--------------------|---------|"
echo "  | Process Compliance  | $S1/35   |"
echo "  | Code Quality        | $S2/40   |"
echo "  | Delivery            | $S3/25   |"
echo "  | TOTAL               | $TOTAL/100 |"
echo ""

# Print warnings if any
if [ -n "$WARNINGS" ]; then
  echo "  WARNINGS:"
  echo -e "$WARNINGS"
  echo ""
fi

echo "  Note: This is a heuristic check, not a security audit."
echo "  Keyword-based checks may miss real issues or flag false positives."
echo "  Always pair with human review before production deployment."
echo ""
echo "============================================"
