#!/bin/bash
# Hogwarts Framework - Wizard-Themed Status Line
# This script creates a magical status bar at the bottom of Claude Code

# Get data from environment (Claude Code provides these)
MODEL="${CLAUDE_MODEL:-opus}"
CWD="${CLAUDE_CWD:-$(pwd)}"
CONTEXT_PERCENT="${CLAUDE_CONTEXT_PERCENT:-0}"
COST="${CLAUDE_COST:-0.00}"
GIT_BRANCH="${CLAUDE_GIT_BRANCH:-}"

# House colors based on git branch (customize these patterns)
get_house() {
    case "$GIT_BRANCH" in
        *frontend*|*ui*|*ux*|*component*) echo "GRYFFINDOR" ;;
        *api*|*backend*|*database*|*server*) echo "RAVENCLAW" ;;
        *test*|*security*|*audit*|*qa*) echo "SLYTHERIN" ;;
        *docs*|*devops*|*ci*|*deploy*) echo "HUFFLEPUFF" ;;
        main|master) echo "GREAT HALL" ;;
        *) echo "SORTING HAT" ;;
    esac
}

# Threat level based on context usage
get_threat_level() {
    if [ "$CONTEXT_PERCENT" -lt 50 ]; then
        echo "🟢"
    elif [ "$CONTEXT_PERCENT" -lt 75 ]; then
        echo "🟡"
    elif [ "$CONTEXT_PERCENT" -lt 90 ]; then
        echo "🟠"
    else
        echo "🔴"
    fi
}

# Magic meter visualization
get_magic_meter() {
    local percent=$CONTEXT_PERCENT
    local filled=$((percent / 10))
    local empty=$((10 - filled))
    local meter=""

    for ((i=0; i<filled; i++)); do
        meter+="▓"
    done
    for ((i=0; i<empty; i++)); do
        meter+="░"
    done

    echo "$meter"
}

# Model as wizard title
get_wizard_title() {
    case "$MODEL" in
        *opus*) echo "🧙 Dumbledore" ;;
        *sonnet*) echo "🪄 McGonagall" ;;
        *haiku*) echo "✨ Flitwick" ;;
        *) echo "🔮 Wizard" ;;
    esac
}

# Build the status line
HOUSE=$(get_house)
THREAT=$(get_threat_level)
METER=$(get_magic_meter)
WIZARD=$(get_wizard_title)

# Format: [Wizard] House | Magic: [meter] 45% | Galleons: $0.02 | Threat: 🟢
echo "[$WIZARD] $HOUSE | Magic: $METER ${CONTEXT_PERCENT}% | Galleons: \$${COST} | $THREAT"
