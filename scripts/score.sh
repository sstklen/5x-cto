#!/bin/bash
# 5x-cto Project Scorer
# Automatically evaluates project quality after pipeline completion
# Usage: bash score.sh /path/to/project

set -e

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

echo "============================================"
echo "  5x-cto Project Scorer"
echo "  Project: $(basename "$PWD")"
echo "  Date: $(date '+%Y-%m-%d %H:%M')"
echo "============================================"
echo ""

TOTAL=0
MAX_TOTAL=100

# ─────────────────────────────────────────────
# SECTION 1: Process Compliance (35 points)
# ─────────────────────────────────────────────
echo "## Process Compliance (max 35)"
echo ""
S1=0

# 1.1 Pipeline state file (10 pts)
if [ -f "PIPELINE_STATE.json" ]; then
  phase=$(cat PIPELINE_STATE.json | grep -o '"current_phase"[^,]*' | cut -d'"' -f4)
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
# Primary source: PIPELINE_STATE.json; fallback: CARDS.md status
if [ -f "PIPELINE_STATE.json" ] && [ -f "CARDS.md" ]; then
  total_cards=$(cat PIPELINE_STATE.json | grep -o '"total_cards"[^,]*' | grep -o '[0-9]*')
  accepted=$(cat PIPELINE_STATE.json | grep -o '"accepted_count"[^,]*' | grep -o '[0-9]*')
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
    echo "  [ 0/10] Cards: No cards found"
  fi
elif [ -f "CARDS.md" ]; then
  total_cards=$(grep -c "^## CARD-" CARDS.md 2>/dev/null; true)
  echo "  [ 5/10] Cards: CARDS.md found ($total_cards cards), no pipeline state"
  S1=$((S1 + 5))
else
  echo "  [ 0/10] Cards: CARDS.md MISSING"
fi

# 1.3 Progress documented (5 pts)
if [ -f "PROGRESS.md" ]; then
  lines=$(grep -c "✅" PROGRESS.md 2>/dev/null || echo 0)
  if [ "$lines" -gt 0 ]; then
    echo "  [ 5/ 5] Progress: $lines entries documented"
    S1=$((S1 + 5))
  else
    echo "  [ 2/ 5] Progress: File exists but no entries"
    S1=$((S1 + 2))
  fi
else
  echo "  [ 0/ 5] Progress: PROGRESS.md MISSING"
fi

# 1.4 Commits with Card ID (10 pts)
total_commits=$(git log --oneline --no-merges 2>/dev/null | head -20 | wc -l | tr -d ' ')
card_commits=$(git log --oneline --no-merges 2>/dev/null | head -20 | grep -cE "CARD-[0-9]+" || echo 0)
if [ "$total_commits" -gt 0 ]; then
  pct=$((card_commits * 100 / total_commits))
  pts=$((pct / 10))
  [ "$pts" -gt 10 ] && pts=10
  echo "  [ $pts/10] Commit convention: $card_commits/$total_commits with Card ID ($pct%)"
  S1=$((S1 + pts))
else
  echo "  [ 0/10] Commit convention: No commits found"
fi

echo ""
echo "  Section 1 Total: $S1/35"
echo ""

# ─────────────────────────────────────────────
# SECTION 2: Code Quality (40 points)
# ─────────────────────────────────────────────
echo "## Code Quality (max 40)"
echo ""
S2=0

# 2.1 No hardcoded secrets (10 pts)
SRC_DIR=""
for d in src lib app; do
  [ -d "$d" ] && SRC_DIR="$d" && break
done

if [ -n "$SRC_DIR" ]; then
  secrets=$(grep -rn "sk_live\|sk_test_[a-zA-Z0-9]\{20,\}" "$SRC_DIR" --include="*.ts" --include="*.js" --include="*.py" 2>/dev/null | grep -cv "env\|process\|config\|import\|//\|#\|test\|example\|placeholder\|changeme"; true)
  secrets=$((secrets + 0))
  if [ "$secrets" -eq 0 ]; then
    echo "  [10/10] Secrets: Clean (no hardcoded secrets)"
    S2=$((S2 + 10))
  else
    echo "  [ 3/10] Secrets: $secrets potential hardcoded secrets found"
    S2=$((S2 + 3))
  fi
else
  echo "  [ 5/10] Secrets: No src directory found (skipped)"
  S2=$((S2 + 5))
fi

# 2.2 Architecture separation (10 pts)
if [ -n "$SRC_DIR" ]; then
  layers=0
  for layer in routes api services db lib models utils middleware hub controllers; do
    [ -d "$SRC_DIR/$layer" ] && layers=$((layers + 1))
  done
  if [ "$layers" -ge 3 ]; then
    echo "  [10/10] Architecture: $layers layers separated"
    S2=$((S2 + 10))
  elif [ "$layers" -ge 2 ]; then
    echo "  [ 7/10] Architecture: $layers layers (good)"
    S2=$((S2 + 7))
  elif [ "$layers" -ge 1 ]; then
    echo "  [ 4/10] Architecture: $layers layer"
    S2=$((S2 + 4))
  else
    echo "  [ 2/10] Architecture: Flat structure"
    S2=$((S2 + 2))
  fi
else
  echo "  [ 0/10] Architecture: No src directory"
fi

# 2.3 Import chain integrity (5 pts)
if command -v bun &>/dev/null && [ -n "$SRC_DIR" ]; then
  import_total=0
  import_pass=0
  for f in $(find "$SRC_DIR" -name "*.ts" -not -path "*/node_modules/*" 2>/dev/null | head -20); do
    import_total=$((import_total + 1))
    if bun build --target=bun "$f" --outdir=/tmp/5xcto-check 2>&1 | grep -qi error; then
      : # fail
    else
      import_pass=$((import_pass + 1))
    fi
  done
  if [ "$import_total" -gt 0 ]; then
    if [ "$import_pass" -eq "$import_total" ]; then
      echo "  [ 5/ 5] Import chain: $import_pass/$import_total clean"
      S2=$((S2 + 5))
    else
      pts=$((import_pass * 5 / import_total))
      echo "  [ $pts/ 5] Import chain: $import_pass/$import_total clean"
      S2=$((S2 + pts))
    fi
  else
    echo "  [ 0/ 5] Import chain: No .ts files found"
  fi
else
  echo "  [ 3/ 5] Import chain: Skipped (bun not available)"
  S2=$((S2 + 3))
fi

# 2.4 Error handling (10 pts)
if [ -n "$SRC_DIR" ]; then
  total_files=$(find "$SRC_DIR" -name "*.ts" -o -name "*.js" 2>/dev/null | grep -v node_modules | wc -l | tr -d ' ')
  files_with_errors=$(grep -rlE "try|catch|throw|HTTPException|createError" "$SRC_DIR" --include="*.ts" --include="*.js" 2>/dev/null | grep -v node_modules | wc -l | tr -d ' ')
  if [ "$total_files" -gt 0 ]; then
    pct=$((files_with_errors * 100 / total_files))
    pts=$((pct / 10))
    [ "$pts" -gt 10 ] && pts=10
    echo "  [ $pts/10] Error handling: $files_with_errors/$total_files files ($pct%)"
    S2=$((S2 + pts))
  else
    echo "  [ 0/10] Error handling: No source files"
  fi
else
  echo "  [ 0/10] Error handling: No src directory"
fi

# 2.5 Tests exist and pass (5 pts)
test_files=$(find . -name "*.test.*" -o -name "*.spec.*" 2>/dev/null | grep -v node_modules | wc -l | tr -d ' ')
if [ "$test_files" -gt 0 ]; then
  if command -v bun &>/dev/null && bun test 2>&1 | grep -q "pass"; then
    echo "  [ 5/ 5] Tests: $test_files test files, passing"
    S2=$((S2 + 5))
  else
    echo "  [ 3/ 5] Tests: $test_files test files exist"
    S2=$((S2 + 3))
  fi
else
  echo "  [ 0/ 5] Tests: No test files found"
fi

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
  accepted_count=$(cat PIPELINE_STATE.json | grep -o '"accepted_count"[^,]*' | grep -o '[0-9]*')
  total_count=$(cat PIPELINE_STATE.json | grep -o '"total_cards"[^,]*' | grep -o '[0-9]*')
  if [ -n "$accepted_count" ] && [ -n "$total_count" ] && [ "$total_count" -gt 0 ]; then
    if [ "$accepted_count" -eq "$total_count" ]; then
      echo "  [10/10] Delivery: $accepted_count/$total_count cards shipped"
      S3=$((S3 + 10))
    else
      pts=$((accepted_count * 10 / total_count))
      echo "  [ $pts/10] Delivery: $accepted_count/$total_count cards shipped"
      S3=$((S3 + pts))
    fi
  else
    echo "  [ 0/10] Delivery: Cannot parse pipeline state"
  fi
else
  echo "  [ 5/10] Delivery: No pipeline state (manual check needed)"
  S3=$((S3 + 5))
fi

# 3.2 Feature completeness (10 pts - based on code indicators)
if [ -n "$SRC_DIR" ]; then
  features=0
  grep -rql "route\|router\|app\.\(get\|post\)" "$SRC_DIR" --include="*.ts" --include="*.js" 2>/dev/null && features=$((features + 1))
  [ -d "$SRC_DIR/db" ] || [ -d "$SRC_DIR/models" ] && features=$((features + 1))
  grep -rql "stripe\|payment\|checkout" "$SRC_DIR" --include="*.ts" --include="*.js" 2>/dev/null && features=$((features + 1))
  grep -rql "i18n\|locale\|lang\|ja\|en\|zh" "$SRC_DIR" --include="*.ts" --include="*.js" 2>/dev/null && features=$((features + 1))
  grep -rql "auth\|token\|session\|password" "$SRC_DIR" --include="*.ts" --include="*.js" 2>/dev/null && features=$((features + 1))
  pts=$((features * 2))
  [ "$pts" -gt 10 ] && pts=10
  echo "  [ $pts/10] Features: $features categories detected"
  S3=$((S3 + pts))
else
  echo "  [ 0/10] Features: No src directory"
fi

# 3.3 Reasonable timeline (5 pts)
if [ -f "PIPELINE_STATE.json" ]; then
  echo "  [ 5/ 5] Timeline: Pipeline completed"
  S3=$((S3 + 5))
else
  echo "  [ 3/ 5] Timeline: No pipeline tracking"
  S3=$((S3 + 3))
fi

echo ""
echo "  Section 3 Total: $S3/25"
echo ""

# ─────────────────────────────────────────────
# FINAL SCORE
# ─────────────────────────────────────────────
TOTAL=$((S1 + S2 + S3))

# Star rating
if [ "$TOTAL" -ge 90 ]; then STARS="★★★★★"
elif [ "$TOTAL" -ge 80 ]; then STARS="★★★★"
elif [ "$TOTAL" -ge 70 ]; then STARS="★★★"
elif [ "$TOTAL" -ge 60 ]; then STARS="★★"
else STARS="★"
fi

echo "============================================"
echo ""
echo "  FINAL SCORE: $TOTAL / $MAX_TOTAL  $STARS"
echo ""
echo "  | Category          | Score  |"
echo "  |-------------------|--------|"
echo "  | Process Compliance | $S1/35  |"
echo "  | Code Quality       | $S2/40  |"
echo "  | Delivery           | $S3/25  |"
echo "  | TOTAL              | $TOTAL/100 |"
echo ""
echo "  Built by non-coder with 5x-cto"
echo ""
echo "============================================"
