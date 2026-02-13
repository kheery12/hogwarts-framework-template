#!/bin/bash

# Hogwarts Agent Framework - Project Setup Script
# For macOS users

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║     🏰 HOGWARTS AGENT FRAMEWORK 🏰                        ║"
echo "║                                                           ║"
echo "║     Setting up your new project...                        ║"
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

echo -e "${GREEN}Creating project: $PROJECT_NAME${NC}"

# Get project description
echo -e "${YELLOW}Enter a one-line description of your project:${NC}"
read PROJECT_DESCRIPTION

# Get tech stack
echo -e "${YELLOW}Frontend framework (e.g., React, Vue, Next.js):${NC}"
read TECH_FRONTEND

echo -e "${YELLOW}Backend framework (e.g., Node.js, Python, Go):${NC}"
read TECH_BACKEND

echo -e "${YELLOW}Database (e.g., PostgreSQL, MongoDB, SQLite):${NC}"
read TECH_DATABASE

echo -e "${YELLOW}Package manager (npm, yarn, pnpm, bun):${NC}"
read PACKAGE_MANAGER

# Update CLAUDE.md
echo -e "${BLUE}Configuring CLAUDE.md...${NC}"

sed -i '' "s/\[PROJECT_NAME\]/$PROJECT_NAME/g" CLAUDE.md
sed -i '' "s/\[One-line description of what this software does and who it protects\]/$PROJECT_DESCRIPTION/g" CLAUDE.md
sed -i '' "s/\[e.g., React, TypeScript\]/$TECH_FRONTEND/g" CLAUDE.md
sed -i '' "s/\[e.g., Node.js, Python\]/$TECH_BACKEND/g" CLAUDE.md
sed -i '' "s/\[e.g., PostgreSQL, MongoDB\]/$TECH_DATABASE/g" CLAUDE.md
sed -i '' "s/\[e.g., AWS, Vercel\]/TBD/g" CLAUDE.md
sed -i '' "s/\[package-manager\]/$PACKAGE_MANAGER/g" CLAUDE.md

# Update House Cup standings
echo -e "${BLUE}Initializing House Cup...${NC}"
sed -i '' "s/\[Project Name\]/$PROJECT_NAME/g" logs/house-cup/standings.md
sed -i '' "s/\[Date\]/$(date '+%Y-%m-%d')/g" logs/house-cup/standings.md
sed -i '' "s/\[Timestamp\]/$(date '+%Y-%m-%d %H:%M:%S')/g" logs/house-cup/standings.md

# Update Marauder's Map
sed -i '' "s/\[Timestamp\]/$(date '+%Y-%m-%d %H:%M:%S')/g" logs/marauders-map.md

# Update other log files
sed -i '' "s/\[Timestamp\]/$(date '+%Y-%m-%d %H:%M:%S')/g" logs/house-cup/specialization-matrix.md
sed -i '' "s/\[Timestamp\]/$(date '+%Y-%m-%d %H:%M:%S')/g" logs/house-cup/sorting-hat-cache.md
sed -i '' "s/\[Timestamp\]/$(date '+%Y-%m-%d %H:%M:%S')/g" logs/horcrux-registry/active.md

# Create CLAUDE.local.md from example
echo -e "${BLUE}Creating CLAUDE.local.md...${NC}"
cp CLAUDE.local.md.example CLAUDE.local.md

# Make status line script executable
echo -e "${BLUE}Enabling wizard status line...${NC}"
chmod +x .claude/statusline.sh

# Initialize git if not already
if [ ! -d ".git" ]; then
    echo -e "${BLUE}Initializing git repository...${NC}"
    git init
fi

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo -e "${BLUE}Creating .gitignore...${NC}"
    cat > .gitignore << 'EOF'
# Local configuration
CLAUDE.local.md

# Environment files
.env
.env.local
.env.*.local

# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/
.next/
out/

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Test coverage
coverage/

# Temporary files
tmp/
temp/
EOF
fi

# Summary
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║     ✅ SETUP COMPLETE!                                    ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Project: ${NC}$PROJECT_NAME"
echo -e "${BLUE}Description: ${NC}$PROJECT_DESCRIPTION"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Review and customize CLAUDE.md"
echo "2. Update CLAUDE.local.md with your preferences"
echo "3. Start your first mission!"
echo ""
echo -e "${BLUE}Quick Commands:${NC}"
echo "  cat CLAUDE.md              # View project context"
echo "  cat logs/marauders-map.md  # View current status"
echo ""
echo -e "${BLUE}Wizard Status Line:${NC}"
echo "  A magical status bar is enabled showing House, magic meter, and threat level."
echo "  Customize: .claude/statusline.sh"
echo ""
echo -e "${GREEN}May your code be bug-free and your deployments smooth! 🧙‍♂️${NC}"
