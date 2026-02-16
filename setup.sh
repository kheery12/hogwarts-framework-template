#!/bin/bash

# Hogwarts Agent Framework v2 - Project Setup Script
# For macOS users
#
# NEW IN V2: Minimal setup! Just provide project name.
# Claude handles all configuration on first conversation.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║     🏰 HOGWARTS AGENT FRAMEWORK v2 🏰                     ║"
echo "║                                                           ║"
echo "║     Now with Professors, Students, and House Cup!         ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Get project name
if [ -z "$1" ]; then
    echo -e "${YELLOW}Enter your project name (kebab-case):${NC}"
    read PROJECT_NAME
else
    PROJECT_NAME=$1
fi

# Validate project name (kebab-case)
if [[ ! $PROJECT_NAME =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo -e "${RED}Error: Project name must be kebab-case (lowercase letters, numbers, hyphens)${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Creating project: $PROJECT_NAME${NC}"
echo ""

# Update project name in files
echo -e "${BLUE}[1/5] Setting project name...${NC}"
sed -i '' "s/\[Project Name\]/$PROJECT_NAME/g" CLAUDE.md 2>/dev/null || true
sed -i '' "s/\[Project Name\]/$PROJECT_NAME/g" Context.md 2>/dev/null || true
sed -i '' "s/\[Project Name\]/$PROJECT_NAME/g" logs/house-cup/standings.md 2>/dev/null || true

# Set timestamps
echo -e "${BLUE}[2/5] Initializing timestamps...${NC}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DATE=$(date '+%Y-%m-%d')

sed -i '' "s/\[pending\] <!-- timestamp -->/$TIMESTAMP/g" logs/marauders-map.md 2>/dev/null || true
sed -i '' "s/\[Date\]/$DATE/g" logs/house-cup/standings.md 2>/dev/null || true
sed -i '' "s/\[Timestamp\]/$TIMESTAMP/g" logs/house-cup/standings.md 2>/dev/null || true
sed -i '' "s/\[Timestamp\]/$TIMESTAMP/g" logs/session-handoff.md 2>/dev/null || true

# Create CLAUDE.local.md from example if exists
echo -e "${BLUE}[3/5] Creating local preferences file...${NC}"
if [ -f "CLAUDE.local.md.example" ]; then
    cp CLAUDE.local.md.example CLAUDE.local.md
    echo "  Created CLAUDE.local.md (personal preferences, gitignored)"
fi

# Make scripts executable
echo -e "${BLUE}[4/5] Setting permissions...${NC}"
if [ -f ".claude/statusline.sh" ]; then
    chmod +x .claude/statusline.sh
    echo "  Made statusline.sh executable"
fi

# Initialize git if not already
echo -e "${BLUE}[5/5] Initializing git repository...${NC}"
if [ ! -d ".git" ]; then
    git init
    echo "  Git repository initialized"
else
    echo "  Git repository already exists"
fi

# Summary
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║     ✅ CASTLE CONSTRUCTED!                                ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${PURPLE}Project: ${NC}$PROJECT_NAME"
echo ""
echo -e "${YELLOW}━━━ NEXT STEP (Important!) ━━━${NC}"
echo ""
echo "1. Open ${BLUE}Context.md${NC} and add your one-line mission description"
echo ""
echo "2. Start Claude Code:"
echo "   ${BLUE}cd $PROJECT_NAME && claude${NC}"
echo ""
echo "3. Say hello! Claude will:"
echo "   • Ask 5 setup questions (tech stack, etc.)"
echo "   • Configure everything automatically"
echo "   • Begin the House Cup game"
echo ""
echo -e "${YELLOW}━━━ FRAMEWORK FILES ━━━${NC}"
echo ""
echo "  Context.md           Your mission and project details"
echo "  CLAUDE.md            Framework rules (auto-loaded)"
echo "  .claude/rules/       Hogwarts rules and protocols"
echo "  skills/houses/       The four Houses (Professors)"
echo "  skills/students/     Student agents (created as needed)"
echo "  logs/                Status tracking and House Cup"
echo ""
echo -e "${YELLOW}━━━ KEY COMMANDS ━━━${NC}"
echo ""
echo "  /close               End session gracefully"
echo "  Check Marauder's Map Show current status"
echo "  House Cup standings  See current scores"
echo ""
echo -e "${GREEN}The castle awaits your command, Headmaster. 🧙‍♂️${NC}"
echo ""
