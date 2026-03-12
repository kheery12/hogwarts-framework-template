#!/bin/bash
# Automated A/B test runner for v3 vs v4 frameworks
# Run this after setting up SWE-Bench

set -e  # Exit on error

echo "╔══════════════════════════════════════════════════╗"
echo "║   Framework A/B Test: v3 vs v4                   ║"
echo "║   Using SWE-Bench (Real-World Code Tasks)        ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Configuration
SWEBENCH_DIR=~/Desktop/claudecode_gemini_and_codex_swebench
FRAMEWORK_DIR=~/Desktop/Claude-Master/hogwarts-framework-template
RESULTS_DIR="$FRAMEWORK_DIR/tests/results"

# Check prerequisites
echo "🔍 Checking prerequisites..."

if [ ! -d "$SWEBENCH_DIR" ]; then
    echo "❌ SWE-Bench not found at $SWEBENCH_DIR"
    echo "   Run: git clone https://github.com/jimmc414/claudecode_gemini_and_codex_swebench $SWEBENCH_DIR"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Install Docker Desktop first."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Start Docker Desktop."
    exit 1
fi

echo "✅ Prerequisites met"
echo ""

# Create results directory
mkdir -p "$RESULTS_DIR"

# Test configuration
read -p "Test size? (quick=10 tasks ~2hrs, standard=50 tasks ~8hrs) [quick]: " TEST_SIZE
TEST_SIZE=${TEST_SIZE:-quick}

echo ""
echo "═══════════════════════════════════════════════════"
echo "  TEST 1: v3 Framework (Hogwarts)"
echo "═══════════════════════════════════════════════════"
echo ""

# Activate v3
cd "$FRAMEWORK_DIR"
git checkout v3.1.0-stable
export CLAUDE_PROJECT_DIR="$FRAMEWORK_DIR"

echo "🚀 Running SWE-Bench with v3 framework..."
echo "   This will take 1-2 hours..."
echo ""

cd "$SWEBENCH_DIR"
python swe_bench.py run --model opus-4.6 --$TEST_SIZE

# Save results
echo "💾 Saving v3 results..."
cp benchmark_scores.log "$RESULTS_DIR/v3-scores.json"
[ -d predictions ] && cp -r predictions "$RESULTS_DIR/v3-predictions/"

echo "✅ v3 test complete"
echo ""

echo "═══════════════════════════════════════════════════"
echo "  TEST 2: v4 Framework (Lean)"
echo "═══════════════════════════════════════════════════"
echo ""

# Activate v4
cd "$FRAMEWORK_DIR"
git checkout v4-development
export CLAUDE_PROJECT_DIR="$FRAMEWORK_DIR"

echo "🚀 Running SWE-Bench with v4 framework..."
echo "   This will take 1-2 hours..."
echo ""

cd "$SWEBENCH_DIR"
python swe_bench.py run --model opus-4.6 --$TEST_SIZE

# Save results
echo "💾 Saving v4 results..."
cp benchmark_scores.log "$RESULTS_DIR/v4-scores.json"
[ -d predictions ] && cp -r predictions "$RESULTS_DIR/v4-predictions/"

echo "✅ v4 test complete"
echo ""

echo "═══════════════════════════════════════════════════"
echo "  ANALYSIS: Generating Comparison Reports"
echo "═══════════════════════════════════════════════════"
echo ""

cd "$FRAMEWORK_DIR/tests"
python compare-frameworks.py

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║              TESTING COMPLETE! ✅                 ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "📊 View results:"
echo "   - HTML Report: open $FRAMEWORK_DIR/tests/comparison-report.html"
echo "   - Summary: cat $FRAMEWORK_DIR/tests/comparison-summary.md"
echo ""
echo "📁 Raw data saved to: $RESULTS_DIR"
echo ""
