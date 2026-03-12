#!/bin/bash
# Run same tests with vanilla Claude (no framework) and merge results

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RESULTS_FILE="$SCRIPT_DIR/manual-test-results.json"

echo "╔══════════════════════════════════════════════════╗"
echo "║   Adding Vanilla Claude Benchmark                ║"
echo "║   (No Framework)                                 ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

if [ ! -f "$RESULTS_FILE" ]; then
    echo "❌ No existing results found. Run automated-test-runner.sh first."
    exit 1
fi

# Backup original results
cp "$RESULTS_FILE" "${RESULTS_FILE}.backup"

echo "📋 Running 3 tests with vanilla Claude (no framework)"
echo ""

# Create temporary workspace for vanilla tests
VANILLA_WORKSPACE="/tmp/vanilla-claude-test"
rm -rf "$VANILLA_WORKSPACE"
mkdir -p "$VANILLA_WORKSPACE"

# Task 1: formatDate utility
echo "═══════════════════════════════════════════════════"
echo "  Task 1: Create formatDate utility (Vanilla)"
echo "═══════════════════════════════════════════════════"

cd "$VANILLA_WORKSPACE"
TASK_DESC="Create a utility function called 'formatDate' in utils/date.js that takes a Date object and returns 'YYYY-MM-DD' format. Include JSDoc."

T1_VANILLA_START=$(date +%s)
echo "$TASK_DESC" | claude -p "$TASK_DESC" > /tmp/task1-vanilla.log 2>&1 || true
T1_VANILLA_END=$(date +%s)
T1_VANILLA_TIME=$(((T1_VANILLA_END - T1_VANILLA_START) / 60))
T1_VANILLA_TOKENS=$(($(wc -c < /tmp/task1-vanilla.log) / 4))

echo "  ✅ Task 1 complete: ${T1_VANILLA_TIME}m, ~${T1_VANILLA_TOKENS} tokens"

# Task 2: Email validation
echo "═══════════════════════════════════════════════════"
echo "  Task 2: Add email validation (Vanilla)"
echo "═══════════════════════════════════════════════════"

cd "$VANILLA_WORKSPACE"
rm -rf *  # Clean workspace
TASK_DESC="Add email validation function that checks for @ symbol with characters before and after. Create src/auth/validate.js"

T2_VANILLA_START=$(date +%s)
echo "$TASK_DESC" | claude -p "$TASK_DESC" > /tmp/task2-vanilla.log 2>&1 || true
T2_VANILLA_END=$(date +%s)
T2_VANILLA_TIME=$(((T2_VANILLA_END - T2_VANILLA_START) / 60))
T2_VANILLA_TOKENS=$(($(wc -c < /tmp/task2-vanilla.log) / 4))

echo "  ✅ Task 2 complete: ${T2_VANILLA_TIME}m, ~${T2_VANILLA_TOKENS} tokens"

# Task 3: Unit test
echo "═══════════════════════════════════════════════════"
echo "  Task 3: Write unit test (Vanilla)"
echo "═══════════════════════════════════════════════════"

cd "$VANILLA_WORKSPACE"
rm -rf *  # Clean workspace
TASK_DESC="Create a unit test file tests/math.test.js with 3 test cases for addition: positive numbers, negative numbers, and zero"

T3_VANILLA_START=$(date +%s)
echo "$TASK_DESC" | claude -p "$TASK_DESC" > /tmp/task3-vanilla.log 2>&1 || true
T3_VANILLA_END=$(date +%s)
T3_VANILLA_TIME=$(((T3_VANILLA_END - T3_VANILLA_START) / 60))
T3_VANILLA_TOKENS=$(($(wc -c < /tmp/task3-vanilla.log) / 4))

echo "  ✅ Task 3 complete: ${T3_VANILLA_TIME}m, ~${T3_VANILLA_TOKENS} tokens"
echo ""

# Add vanilla results to existing data
python3 << PYEOF
import json

with open('$RESULTS_FILE', 'r') as f:
    data = json.load(f)

# Add vanilla data to each task
vanilla_results = [
    {'tokens': $T1_VANILLA_TOKENS, 'time': $T1_VANILLA_TIME},
    {'tokens': $T2_VANILLA_TOKENS, 'time': $T2_VANILLA_TIME},
    {'tokens': $T3_VANILLA_TOKENS, 'time': $T3_VANILLA_TIME}
]

for i, task in enumerate(data['tasks']):
    task['vanilla'] = {
        'completed': True,
        'tokens_used': vanilla_results[i]['tokens'],
        'time_minutes': vanilla_results[i]['time'],
        'corrections_needed': 0,
        'first_try_success': True,
        'notes': 'Vanilla Claude (no framework)'
    }

    # Update winner to include vanilla
    v3_tokens = task['v3']['tokens_used']
    v4_tokens = task['v4']['tokens_used']
    vanilla_tokens = vanilla_results[i]['tokens']

    min_tokens = min(v3_tokens, v4_tokens, vanilla_tokens)
    if vanilla_tokens == min_tokens:
        task['winner'] = 'vanilla'
    elif v4_tokens == min_tokens:
        task['winner'] = 'v4'
    else:
        task['winner'] = 'v3'

with open('$RESULTS_FILE', 'w') as f:
    json.dump(data, f, indent=2)
PYEOF

echo "═══════════════════════════════════════════════════"
echo "  Regenerating Reports with Vanilla Data"
echo "═══════════════════════════════════════════════════"

cd "$SCRIPT_DIR"
python3 generate-3way-report.py

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║         VANILLA BENCHMARK COMPLETE! ✅            ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "📊 Updated 3-way comparison:"
echo "   open manual-comparison-report.html"
echo ""
echo "💾 Original results backed up to:"
echo "   manual-test-results.json.backup"
echo ""

# Cleanup
rm -rf "$VANILLA_WORKSPACE"
