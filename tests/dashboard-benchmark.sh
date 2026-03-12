#!/bin/bash
# Dashboard creation benchmark: v3 vs v4 vs vanilla
# Real-world task: Turn restaurant sales data into interactive dashboard

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DATA_FILE="$HOME/Downloads/04 Restaurant Sales.xlsx"
RESULTS_FILE="$SCRIPT_DIR/dashboard-benchmark-results.json"

echo "╔══════════════════════════════════════════════════╗"
echo "║   Dashboard Creation Benchmark                   ║"
echo "║   v3 vs v4 vs Vanilla                            ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Check data file exists
if [ ! -f "$DATA_FILE" ]; then
    echo "❌ Data file not found: $DATA_FILE"
    exit 1
fi

echo "📊 Data file: $(basename "$DATA_FILE")"
echo "📏 File size: $(ls -lh "$DATA_FILE" | awk '{print $5}')"
echo ""

# The prompt
PROMPT="I have restaurant sales data in this file. Create a working interactive dashboard that shows the most important metrics and insights. Choose whatever technology makes sense (HTML/JS, Python, etc). Make it functional and visually clear. Include:
- Key metrics that matter for restaurant performance
- Visualizations that reveal insights
- Make it immediately runnable/viewable

Use your judgment on what's important to show."

echo "📝 Prompt:"
echo "$PROMPT"
echo ""
echo "═══════════════════════════════════════════════════"
echo ""

START_TIME=$(date +%s)

# Initialize results
cat > "$RESULTS_FILE" << 'EOF'
{
  "test_date": "2026-03-12",
  "task": "dashboard-creation",
  "data_file": "04 Restaurant Sales.xlsx",
  "results": {}
}
EOF

# Test v3
echo "Testing v3 (Hogwarts)..."
cd "$PROJECT_ROOT"
git stash > /dev/null 2>&1 || true
git checkout v3.1.0-stable > /dev/null 2>&1

V3_WORKSPACE="/tmp/dashboard-test-v3"
rm -rf "$V3_WORKSPACE"
mkdir -p "$V3_WORKSPACE"
cp "$DATA_FILE" "$V3_WORKSPACE/"
cd "$V3_WORKSPACE"

V3_START=$(date +%s)
echo "$PROMPT" | claude -p --dangerously-skip-permissions > "/tmp/dashboard-v3.log" 2>&1 || true
V3_END=$(date +%s)
V3_TIME=$(( (V3_END - V3_START) / 60 ))
V3_TOKENS=$(( $(wc -c < "/tmp/dashboard-v3.log") / 4 ))

echo "  ✅ v3 complete: ${V3_TIME}m, ~${V3_TOKENS} tokens"
echo "  📁 Output saved to: $V3_WORKSPACE"
echo ""

# Test v4
echo "Testing v4 (Lean)..."
cd "$PROJECT_ROOT"
git stash > /dev/null 2>&1 || true
git checkout v4-development > /dev/null 2>&1

V4_WORKSPACE="/tmp/dashboard-test-v4"
rm -rf "$V4_WORKSPACE"
mkdir -p "$V4_WORKSPACE"
cp "$DATA_FILE" "$V4_WORKSPACE/"
cd "$V4_WORKSPACE"

V4_START=$(date +%s)
echo "$PROMPT" | claude -p --dangerously-skip-permissions > "/tmp/dashboard-v4.log" 2>&1 || true
V4_END=$(date +%s)
V4_TIME=$(( (V4_END - V4_START) / 60 ))
V4_TOKENS=$(( $(wc -c < "/tmp/dashboard-v4.log") / 4 ))

echo "  ✅ v4 complete: ${V4_TIME}m, ~${V4_TOKENS} tokens"
echo "  📁 Output saved to: $V4_WORKSPACE"
echo ""

# Test vanilla
echo "Testing vanilla (No Framework)..."
VANILLA_WORKSPACE="/tmp/dashboard-test-vanilla"
rm -rf "$VANILLA_WORKSPACE"
mkdir -p "$VANILLA_WORKSPACE"
cp "$DATA_FILE" "$VANILLA_WORKSPACE/"
cd "$VANILLA_WORKSPACE"

VANILLA_START=$(date +%s)
echo "$PROMPT" | claude -p --dangerously-skip-permissions > "/tmp/dashboard-vanilla.log" 2>&1 || true
VANILLA_END=$(date +%s)
VANILLA_TIME=$(( (VANILLA_END - VANILLA_START) / 60 ))
VANILLA_TOKENS=$(( $(wc -c < "/tmp/dashboard-vanilla.log") / 4 ))

echo "  ✅ vanilla complete: ${VANILLA_TIME}m, ~${VANILLA_TOKENS} tokens"
echo "  📁 Output saved to: $VANILLA_WORKSPACE"
echo ""

# Save results
python3 << PYEOF
import json

results = {
    "test_date": "2026-03-12",
    "task": "dashboard-creation",
    "data_file": "04 Restaurant Sales.xlsx",
    "results": {
        "v3": {
            "tokens": $V3_TOKENS,
            "time_minutes": $V3_TIME,
            "workspace": "$V3_WORKSPACE",
            "log": "/tmp/dashboard-v3.log"
        },
        "v4": {
            "tokens": $V4_TOKENS,
            "time_minutes": $V4_TIME,
            "workspace": "$V4_WORKSPACE",
            "log": "/tmp/dashboard-v4.log"
        },
        "vanilla": {
            "tokens": $VANILLA_TOKENS,
            "time_minutes": $VANILLA_TIME,
            "workspace": "$VANILLA_WORKSPACE",
            "log": "/tmp/dashboard-vanilla.log"
        }
    }
}

# Determine winner (lowest tokens)
min_tokens = min($V3_TOKENS, $V4_TOKENS, $VANILLA_TOKENS)
if $V3_TOKENS == min_tokens:
    results["winner"] = "v3"
elif $V4_TOKENS == min_tokens:
    results["winner"] = "v4"
else:
    results["winner"] = "vanilla"

with open('$RESULTS_FILE', 'w') as f:
    json.dump(results, f, indent=2)
PYEOF

END_TIME=$(date +%s)
TOTAL_TIME=$(( (END_TIME - START_TIME) / 60 ))

echo "═══════════════════════════════════════════════════"
echo "  Results Summary"
echo "═══════════════════════════════════════════════════"
echo ""
echo "v3 (Hogwarts):  ${V3_TOKENS} tokens in ${V3_TIME}m"
echo "v4 (Lean):      ${V4_TOKENS} tokens in ${V4_TIME}m"
echo "Vanilla:        ${VANILLA_TOKENS} tokens in ${VANILLA_TIME}m"
echo ""

# Calculate percentages
python3 << PYEOF
v3 = $V3_TOKENS
v4 = $V4_TOKENS
vanilla = $VANILLA_TOKENS
min_tokens = min(v3, v4, vanilla)

print(f"vs Best:")
print(f"  v3:      {'+' if v3 > min_tokens else ''}{((v3 - min_tokens) / min_tokens * 100):.1f}%")
print(f"  v4:      {'+' if v4 > min_tokens else ''}{((v4 - min_tokens) / min_tokens * 100):.1f}%")
print(f"  vanilla: {'+' if vanilla > min_tokens else ''}{((vanilla - min_tokens) / min_tokens * 100):.1f}%")
PYEOF

echo ""
echo "═══════════════════════════════════════════════════"
echo "  Review Outputs"
echo "═══════════════════════════════════════════════════"
echo ""
echo "v3:      open $V3_WORKSPACE"
echo "v4:      open $V4_WORKSPACE"
echo "vanilla: open $VANILLA_WORKSPACE"
echo ""
echo "Results: cat $RESULTS_FILE"
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║         DASHBOARD BENCHMARK COMPLETE! ✅         ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
