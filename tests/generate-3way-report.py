#!/usr/bin/env python3
"""
Generate 3-way comparison report: v3 vs v4 vs vanilla Claude.
"""

import json
import sys
from pathlib import Path
from datetime import datetime

def load_results():
    """Load test results."""
    results_file = Path("manual-test-results.json")

    if not results_file.exists():
        print("❌ No results file found")
        sys.exit(1)

    with open(results_file) as f:
        data = json.load(f)

    return data

def calculate_metrics(tasks, framework):
    """Calculate metrics for a framework."""
    stats = {
        'total_tasks': len(tasks),
        'completed': 0,
        'total_tokens': 0,
        'total_time': 0,
        'total_corrections': 0,
        'first_try_success': 0
    }

    for task in tasks:
        if task[framework]['completed']:
            stats['completed'] += 1
        stats['total_tokens'] += task[framework]['tokens_used']
        stats['total_time'] += task[framework]['time_minutes']
        stats['total_corrections'] += task[framework]['corrections_needed']
        if task[framework]['first_try_success']:
            stats['first_try_success'] += 1

    stats['completion_rate'] = (stats['completed'] / stats['total_tasks'] * 100)
    stats['avg_tokens'] = stats['total_tokens'] / stats['total_tasks']
    stats['avg_time'] = stats['total_time'] / stats['total_tasks']
    stats['avg_corrections'] = stats['total_corrections'] / stats['total_tasks']
    stats['first_try_rate'] = (stats['first_try_success'] / stats['total_tasks'] * 100)

    return stats

def determine_winner(v3_stats, v4_stats, vanilla_stats):
    """Determine winner across 3 frameworks."""
    scores = {'v3': 0, 'v4': 0, 'vanilla': 0}

    # Completion rate (most important)
    max_completion = max(v3_stats['completion_rate'], v4_stats['completion_rate'], vanilla_stats['completion_rate'])
    if v3_stats['completion_rate'] == max_completion:
        scores['v3'] += 3
    if v4_stats['completion_rate'] == max_completion:
        scores['v4'] += 3
    if vanilla_stats['completion_rate'] == max_completion:
        scores['vanilla'] += 3

    # Token efficiency (lower is better)
    min_tokens = min(v3_stats['avg_tokens'], v4_stats['avg_tokens'], vanilla_stats['avg_tokens'])
    if v3_stats['avg_tokens'] == min_tokens:
        scores['v3'] += 2
    if v4_stats['avg_tokens'] == min_tokens:
        scores['v4'] += 2
    if vanilla_stats['avg_tokens'] == min_tokens:
        scores['vanilla'] += 2

    # Corrections (lower is better)
    min_corrections = min(v3_stats['avg_corrections'], v4_stats['avg_corrections'], vanilla_stats['avg_corrections'])
    if v3_stats['avg_corrections'] == min_corrections:
        scores['v3'] += 1
    if v4_stats['avg_corrections'] == min_corrections:
        scores['v4'] += 1
    if vanilla_stats['avg_corrections'] == min_corrections:
        scores['vanilla'] += 1

    winner = max(scores, key=scores.get)
    return winner, scores[winner]

def generate_html_report(data, v3_stats, v4_stats, vanilla_stats):
    """Generate 3-way HTML comparison."""
    winner, _ = determine_winner(v3_stats, v4_stats, vanilla_stats)

    def winner_class(fw):
        return 'winner' if winner == fw else 'loser'

    html = f"""<!DOCTYPE html>
<html>
<head>
    <title>Framework Comparison: v3 vs v4 vs Vanilla</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            max-width: 1400px;
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
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 40px;
        }}
        .card {{
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }}
        .winner {{
            background: #d4edda;
            border-left: 4px solid #28a745;
        }}
        .loser {{
            background: #fff3cd;
            border-left: 4px solid #ffc107;
        }}
        .metric {{
            margin: 15px 0;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 4px;
        }}
        .metric-label {{
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }}
        .metric-value {{
            font-size: 24px;
            font-weight: bold;
            color: #000;
            margin-top: 5px;
        }}
        h2 {{
            margin-top: 0;
            font-size: 18px;
        }}
        .bar-chart {{
            margin: 25px 0;
        }}
        .bar {{
            display: flex;
            align-items: center;
            margin: 12px 0;
        }}
        .bar-label {{
            width: 120px;
            font-weight: 500;
            font-size: 14px;
        }}
        .bar-container {{
            flex: 1;
            height: 35px;
            background: #e9ecef;
            border-radius: 4px;
            position: relative;
            overflow: hidden;
        }}
        .bar-fill {{
            height: 100%;
            display: flex;
            align-items: center;
            padding: 0 10px;
            color: white;
            font-weight: bold;
            font-size: 13px;
            transition: width 0.5s ease;
        }}
        .bar-fill.v3 {{ background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); }}
        .bar-fill.v4 {{ background: linear-gradient(90deg, #f093fb 0%, #f5576c 100%); }}
        .bar-fill.vanilla {{ background: linear-gradient(90deg, #4facfe 0%, #00f2fe 100%); }}
    </style>
</head>
<body>
    <div class="header">
        <h1>3-Way Framework Comparison</h1>
        <p>v3 (Hogwarts) vs v4 (Lean) vs Vanilla Claude</p>
        <p>Tasks: {v3_stats['total_tasks']} | Date: {data.get('test_date', 'Unknown')}</p>
    </div>

    <div class="metrics">
        <div class="card {winner_class('v3')}">
            <h2>v3 (Hogwarts) {'✅' if winner == 'v3' else ''}</h2>
            <div class="metric">
                <div class="metric-label">Completion</div>
                <div class="metric-value">{v3_stats['completion_rate']:.0f}%</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Tokens</div>
                <div class="metric-value">{v3_stats['avg_tokens']:,.0f}</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Time</div>
                <div class="metric-value">{v3_stats['avg_time']:.1f}m</div>
            </div>
        </div>

        <div class="card {winner_class('v4')}">
            <h2>v4 (Lean) {'✅' if winner == 'v4' else ''}</h2>
            <div class="metric">
                <div class="metric-label">Completion</div>
                <div class="metric-value">{v4_stats['completion_rate']:.0f}%</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Tokens</div>
                <div class="metric-value">{v4_stats['avg_tokens']:,.0f}</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Time</div>
                <div class="metric-value">{v4_stats['avg_time']:.1f}m</div>
            </div>
        </div>

        <div class="card {winner_class('vanilla')}">
            <h2>Vanilla (No Framework) {'✅' if winner == 'vanilla' else ''}</h2>
            <div class="metric">
                <div class="metric-label">Completion</div>
                <div class="metric-value">{vanilla_stats['completion_rate']:.0f}%</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Tokens</div>
                <div class="metric-value">{vanilla_stats['avg_tokens']:,.0f}</div>
            </div>
            <div class="metric">
                <div class="metric-label">Avg Time</div>
                <div class="metric-value">{vanilla_stats['avg_time']:.1f}m</div>
            </div>
        </div>
    </div>

    <div class="card">
        <h2>Token Efficiency Comparison (Lower is Better)</h2>
        <div class="bar-chart">
            <div class="bar">
                <div class="bar-label">v3 (Hogwarts)</div>
                <div class="bar-container">
                    <div class="bar-fill v3" style="width: {min(100, v3_stats['avg_tokens']/200)}%">
                        {v3_stats['avg_tokens']:,.0f}
                    </div>
                </div>
            </div>
            <div class="bar">
                <div class="bar-label">v4 (Lean)</div>
                <div class="bar-container">
                    <div class="bar-fill v4" style="width: {min(100, v4_stats['avg_tokens']/200)}%">
                        {v4_stats['avg_tokens']:,.0f}
                    </div>
                </div>
            </div>
            <div class="bar">
                <div class="bar-label">Vanilla</div>
                <div class="bar-container">
                    <div class="bar-fill vanilla" style="width: {min(100, vanilla_stats['avg_tokens']/200)}%">
                        {vanilla_stats['avg_tokens']:,.0f}
                    </div>
                </div>
            </div>
        </div>

        <h2>Framework Value Analysis</h2>
        <p><strong>Key Question:</strong> Do frameworks help or hurt?</p>
        <ul>
            <li><strong>v3 vs Vanilla:</strong> {abs(v3_stats['avg_tokens'] - vanilla_stats['avg_tokens']):,.0f} token difference ({'+' if v3_stats['avg_tokens'] > vanilla_stats['avg_tokens'] else '-'}{abs(v3_stats['avg_tokens'] - vanilla_stats['avg_tokens'])/vanilla_stats['avg_tokens']*100:.1f}%)</li>
            <li><strong>v4 vs Vanilla:</strong> {abs(v4_stats['avg_tokens'] - vanilla_stats['avg_tokens']):,.0f} token difference ({'+' if v4_stats['avg_tokens'] > vanilla_stats['avg_tokens'] else '-'}{abs(v4_stats['avg_tokens'] - vanilla_stats['avg_tokens'])/vanilla_stats['avg_tokens']*100:.1f}%)</li>
            <li><strong>v3 vs v4:</strong> {abs(v3_stats['avg_tokens'] - v4_stats['avg_tokens']):,.0f} token difference ({'+' if v3_stats['avg_tokens'] > v4_stats['avg_tokens'] else '-'}{abs(v3_stats['avg_tokens'] - v4_stats['avg_tokens'])/max(v3_stats['avg_tokens'], v4_stats['avg_tokens'])*100:.1f}%)</li>
        </ul>
    </div>

    <div style="text-align: center; margin-top: 40px; color: #666; font-size: 14px;">
        Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
    </div>
</body>
</html>"""

    with open('manual-comparison-report.html', 'w') as f:
        f.write(html)

    print("✅ Generated manual-comparison-report.html")

def main():
    """Main workflow."""
    data = load_results()

    # Check if vanilla data exists
    if 'vanilla' not in data['tasks'][0]:
        print("❌ No vanilla benchmark data found")
        print("   Run: ./add-vanilla-benchmark.sh")
        sys.exit(1)

    print("📊 Generating 3-way comparison...\n")

    v3_stats = calculate_metrics(data['tasks'], 'v3')
    v4_stats = calculate_metrics(data['tasks'], 'v4')
    vanilla_stats = calculate_metrics(data['tasks'], 'vanilla')

    generate_html_report(data, v3_stats, v4_stats, vanilla_stats)

    print("\n✅ 3-way comparison complete!")
    print("\nView: open manual-comparison-report.html")

if __name__ == '__main__':
    main()
