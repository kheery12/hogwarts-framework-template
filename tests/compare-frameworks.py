#!/usr/bin/env python3
"""
Compare v3 and v4 framework performance from SWE-Bench results.
Generates visual charts and HTML report.
"""

import json
import sys
from pathlib import Path
from datetime import datetime

def load_results(version):
    """Load SWE-Bench results for a framework version."""
    scores_file = Path(f"results/{version}-scores.json")

    if not scores_file.exists():
        print(f"❌ Missing {scores_file}")
        print(f"   Run SWE-Bench with {version} framework first")
        return None

    with open(scores_file) as f:
        data = json.load(f)

    return data

def calculate_metrics(data):
    """Extract key metrics from SWE-Bench results."""
    if not data or 'results' not in data:
        return None

    results = data['results']

    # Calculate metrics
    total_tasks = len(results)
    resolved = sum(1 for r in results if r.get('resolved', False))
    resolve_rate = (resolved / total_tasks * 100) if total_tasks > 0 else 0

    # Token usage (if available)
    total_tokens = sum(r.get('tokens_used', 0) for r in results)
    avg_tokens = total_tokens / total_tasks if total_tasks > 0 else 0

    # Time metrics (if available)
    times = [r.get('time_seconds', 0) for r in results if r.get('time_seconds')]
    avg_time = sum(times) / len(times) if times else 0

    return {
        'total_tasks': total_tasks,
        'resolved': resolved,
        'resolve_rate': resolve_rate,
        'total_tokens': total_tokens,
        'avg_tokens': avg_tokens,
        'avg_time': avg_time
    }

def generate_html_report(v3_metrics, v4_metrics):
    """Generate interactive HTML comparison report."""

    html = f"""<!DOCTYPE html>
<html>
<head>
    <title>Framework Comparison: v3 vs v4</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
            background: #f5f5f5;
        }}
        .header {{
            text-align: center;
            margin-bottom: 40px;
        }}
        .metrics {{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 40px;
        }}
        .card {{
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }}
        .card h2 {{
            margin-top: 0;
            color: #333;
        }}
        .metric {{
            margin: 20px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
        }}
        .metric-label {{
            font-size: 14px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }}
        .metric-value {{
            font-size: 32px;
            font-weight: bold;
            color: #000;
            margin-top: 5px;
        }}
        .winner {{
            background: #d4edda;
            border-left: 4px solid #28a745;
        }}
        .loser {{
            background: #f8d7da;
            border-left: 4px solid #dc3545;
        }}
        .comparison {{
            background: white;
            padding: 30px;
            border-radius: 8px;
            margin-top: 20px;
        }}
        .bar-chart {{
            margin: 30px 0;
        }}
        .bar {{
            display: flex;
            align-items: center;
            margin: 15px 0;
        }}
        .bar-label {{
            width: 150px;
            font-weight: 500;
        }}
        .bar-container {{
            flex: 1;
            height: 40px;
            background: #e9ecef;
            border-radius: 4px;
            position: relative;
            overflow: hidden;
        }}
        .bar-fill {{
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            padding: 0 10px;
            color: white;
            font-weight: bold;
            transition: width 0.5s ease;
        }}
        .timestamp {{
            text-align: center;
            color: #666;
            font-size: 14px;
            margin-top: 40px;
        }}
    </style>
</head>
<body>
    <div class="header">
        <h1>Framework Performance Comparison</h1>
        <p>SWE-Bench Results: v3.1.0 vs v4.0.0</p>
    </div>

    <div class="metrics">
        <div class="card {'winner' if v3_metrics['resolve_rate'] > v4_metrics['resolve_rate'] else 'loser'}">
            <h2>v3.1.0 (Hogwarts)</h2>
            <div class="metric">
                <div class="metric-label">Resolve Rate</div>
                <div class="metric-value">{v3_metrics['resolve_rate']:.1f}%</div>
            </div>
            <div class="metric">
                <div class="metric-label">Tasks Resolved</div>
                <div class="metric-value">{v3_metrics['resolved']}/{v3_metrics['total_tasks']}</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Tokens/Task</div>
                <div class="metric-value">{v3_metrics['avg_tokens']:,.0f}</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Time/Task</div>
                <div class="metric-value">{v3_metrics['avg_time']:.0f}s</div>
            </div>
        </div>

        <div class="card {'winner' if v4_metrics['resolve_rate'] > v3_metrics['resolve_rate'] else 'loser'}">
            <h2>v4.0.0 (Lean)</h2>
            <div class="metric">
                <div class="metric-label">Resolve Rate</div>
                <div class="metric-value">{v4_metrics['resolve_rate']:.1f}%</div>
            </div>
            <div class="metric">
                <div class="metric-label">Tasks Resolved</div>
                <div class="metric-value">{v4_metrics['resolved']}/{v4_metrics['total_tasks']}</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Tokens/Task</div>
                <div class="metric-value">{v4_metrics['avg_tokens']:,.0f}</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Time/Task</div>
                <div class="metric-value">{v4_metrics['avg_time']:.0f}s</div>
            </div>
        </div>
    </div>

    <div class="comparison">
        <h2>Visual Comparison</h2>

        <div class="bar-chart">
            <h3>Resolve Rate</h3>
            <div class="bar">
                <div class="bar-label">v3 (Hogwarts)</div>
                <div class="bar-container">
                    <div class="bar-fill" style="width: {v3_metrics['resolve_rate']}%">
                        {v3_metrics['resolve_rate']:.1f}%
                    </div>
                </div>
            </div>
            <div class="bar">
                <div class="bar-label">v4 (Lean)</div>
                <div class="bar-container">
                    <div class="bar-fill" style="width: {v4_metrics['resolve_rate']}%">
                        {v4_metrics['resolve_rate']:.1f}%
                    </div>
                </div>
            </div>
        </div>

        <div class="bar-chart">
            <h3>Token Efficiency (Lower is Better)</h3>
            <div class="bar">
                <div class="bar-label">v3 (Hogwarts)</div>
                <div class="bar-container">
                    <div class="bar-fill" style="width: {min(100, v3_metrics['avg_tokens']/1000)}%; background: linear-gradient(90deg, #f093fb 0%, #f5576c 100%)">
                        {v3_metrics['avg_tokens']:,.0f}
                    </div>
                </div>
            </div>
            <div class="bar">
                <div class="bar-label">v4 (Lean)</div>
                <div class="bar-container">
                    <div class="bar-fill" style="width: {min(100, v4_metrics['avg_tokens']/1000)}%; background: linear-gradient(90deg, #f093fb 0%, #f5576c 100%)">
                        {v4_metrics['avg_tokens']:,.0f}
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="timestamp">
        Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
    </div>
</body>
</html>"""

    with open('comparison-report.html', 'w') as f:
        f.write(html)

    print("✅ Generated comparison-report.html")

def generate_markdown_summary(v3_metrics, v4_metrics):
    """Generate markdown summary."""

    # Determine winner
    v3_better = v3_metrics['resolve_rate'] > v4_metrics['resolve_rate']
    winner = "v3 (Hogwarts)" if v3_better else "v4 (Lean)"

    md = f"""# Framework Comparison Summary

**Test Date:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## Results

| Metric | v3 (Hogwarts) | v4 (Lean) | Winner |
|--------|---------------|-----------|--------|
| Resolve Rate | {v3_metrics['resolve_rate']:.1f}% | {v4_metrics['resolve_rate']:.1f}% | {'v3' if v3_better else 'v4'} ✅ |
| Tasks Resolved | {v3_metrics['resolved']}/{v3_metrics['total_tasks']} | {v4_metrics['resolved']}/{v4_metrics['total_tasks']} | - |
| Avg Tokens/Task | {v3_metrics['avg_tokens']:,.0f} | {v4_metrics['avg_tokens']:,.0f} | {'v3' if v3_metrics['avg_tokens'] < v4_metrics['avg_tokens'] else 'v4'} ✅ |
| Total Tokens | {v3_metrics['total_tokens']:,} | {v4_metrics['total_tokens']:,} | - |
| Avg Time/Task | {v3_metrics['avg_time']:.0f}s | {v4_metrics['avg_time']:.0f}s | {'v3' if v3_metrics['avg_time'] < v4_metrics['avg_time'] else 'v4'} ✅ |

## Overall Winner: {winner}

### Analysis

**Resolve Rate:**
- v3: {v3_metrics['resolve_rate']:.1f}% ({v3_metrics['resolved']} tasks)
- v4: {v4_metrics['resolve_rate']:.1f}% ({v4_metrics['resolved']} tasks)
- Difference: {abs(v3_metrics['resolve_rate'] - v4_metrics['resolve_rate']):.1f} percentage points

**Token Efficiency:**
- v3: {v3_metrics['avg_tokens']:,.0f} avg tokens/task
- v4: {v4_metrics['avg_tokens']:,.0f} avg tokens/task
- Savings: {abs(v3_metrics['avg_tokens'] - v4_metrics['avg_tokens']):,.0f} tokens/task ({abs(v3_metrics['avg_tokens'] - v4_metrics['avg_tokens'])/v3_metrics['avg_tokens']*100:.1f}%)

## Recommendation

{'v4 is more efficient with comparable results.' if not v3_better and v4_metrics['avg_tokens'] < v3_metrics['avg_tokens'] else 'v3 has better resolve rate.' if v3_better else 'Results are mixed - consider use case.'}
"""

    with open('comparison-summary.md', 'w') as f:
        f.write(md)

    print("✅ Generated comparison-summary.md")

def main():
    """Main comparison workflow."""
    print("🔍 Loading SWE-Bench results...\n")

    # Load results
    v3_data = load_results('v3')
    v4_data = load_results('v4')

    if not v3_data or not v4_data:
        print("\n❌ Missing results. Run SWE-Bench tests first:")
        print("   See tests/swe-bench-setup.md for instructions")
        sys.exit(1)

    # Calculate metrics
    v3_metrics = calculate_metrics(v3_data)
    v4_metrics = calculate_metrics(v4_data)

    if not v3_metrics or not v4_metrics:
        print("❌ Failed to calculate metrics")
        sys.exit(1)

    print("📊 Generating comparison reports...\n")

    # Generate outputs
    generate_html_report(v3_metrics, v4_metrics)
    generate_markdown_summary(v3_metrics, v4_metrics)

    print("\n✅ Comparison complete!")
    print("\nView results:")
    print("  - HTML Report: open comparison-report.html")
    print("  - Summary: cat comparison-summary.md")

if __name__ == '__main__':
    main()
