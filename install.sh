#!/bin/bash
# Fern Claude Skills — one-line installer
# Usage: curl -s https://raw.githubusercontent.com/kellie-fontes/fern-claude-skills/main/install.sh | bash

set -e

SKILLS_DIR="$HOME/.claude/commands"
REPO="https://raw.githubusercontent.com/kellie-fontes/fern-claude-skills/main/.claude/commands"

echo "Installing Fern Claude Skills..."

mkdir -p "$SKILLS_DIR"

skills=(
  "00-fern-start.md"
  "01-fern-design.md"
  "02-fern-api.md"
  "03-fern-deploy.md"
  "04-fern-wire.md"
  "05-fern-agent.md"
  "06-fern-apex.md"
  "07-fern-site.md"
  "08-fern-form.md"
  "09-fern-dashboard.md"
  "10-fern-debug.md"
  "11-fern-prep.md"
)

for skill in "${skills[@]}"; do
  curl -s "$REPO/$skill" -o "$SKILLS_DIR/$skill"
  echo "  ✓ $skill"
done

# Download utility scripts to current directory
SCRIPTS_REPO="https://raw.githubusercontent.com/kellie-fontes/fern-claude-skills/main"
curl -s "$SCRIPTS_REPO/reset-demo.sh" -o ./reset-demo.sh
chmod +x ./reset-demo.sh
echo "  ✓ reset-demo.sh (saved to current directory)"

echo ""
echo "All Fern skills installed to ~/.claude/commands/"
echo ""
echo "Available commands:"
echo "  /00-fern-start     — Run this first every session"
echo "  /01-fern-design    — Step 1:  Architecture design"
echo "  /02-fern-api       — Step 2:  MuleSoft Mock API"
echo "  /03-fern-deploy    — Step 3:  Deploy to CloudHub"
echo "  /04-fern-wire      — Step 4:  Agentforce wiring"
echo "  /05-fern-agent     — Step 5:  Build the agent + wire actions"
echo "  /06-fern-apex      — Step 6:  Apex controllers + Custom Setting"
echo "  /07-fern-site      — Step 7:  Experience Cloud site + Chat UI"
echo "  /08-fern-form      — Step 8:  Custom object + form + polling"
echo "  /09-fern-dashboard — Step 9:  Internal dashboard"
echo "  /10-fern-debug     — Debugging prompts (use any time)"
echo "  /11-fern-prep      — Demo prep + token refresh (run before every demo)"
echo ""
echo "Open Claude Code and type / to see them listed."
