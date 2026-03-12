#!/bin/bash
# Complete automated benchmark: v3 + v4 + vanilla
# Runs v3 vs v4, then automatically adds vanilla comparison

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "╔══════════════════════════════════════════════════╗"
echo "║   Complete Framework Benchmark                   ║"
echo "║   v3 vs v4 vs Vanilla (No Framework)             ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "Phase 1: v3 vs v4 comparison (~30 min)"
echo "Phase 2: Vanilla benchmark (~15 min)"
echo "Total time: ~45 minutes"
echo ""

START_TIME=$(date +%s)

# Check if v3 vs v4 tests are already running
if pgrep -f "automated-test-runner.sh" > /dev/null; then
    echo "✅ Tests already running, will add vanilla when they finish"
    echo ""
else
    echo "🚀 Starting v3 vs v4 tests..."
    cd "$SCRIPT_DIR"
    ./automated-test-runner.sh > automated-test-output.log 2>&1
    echo "✅ Phase 1 complete"
    echo ""
fi

# Wait for tests to finish if running
while pgrep -f "automated-test-runner.sh" > /dev/null; do
    echo "⏳ Waiting for v3 vs v4 tests to complete..."
    sleep 30
done

echo ""
echo "═══════════════════════════════════════════════════"
echo "  Phase 1 Complete - Starting Vanilla Benchmark"
echo "═══════════════════════════════════════════════════"
echo ""

# Run vanilla benchmark
cd "$SCRIPT_DIR"
./add-vanilla-benchmark.sh

END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))
MINUTES=$((TOTAL_TIME / 60))
SECONDS=$((TOTAL_TIME % 60))

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║         ALL BENCHMARKS COMPLETE! ✅               ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "⏱️  Total Time: ${MINUTES}m ${SECONDS}s"
echo ""
echo "📊 View 3-way comparison:"
echo "   open manual-comparison-report.html"
echo ""
