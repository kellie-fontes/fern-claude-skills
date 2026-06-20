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

echo ""
echo "All Fern skills installed to ~/.claude/commands/"
echo ""
echo "Available commands:"
echo "  /fern-start     — Run this first every session"
echo "  /fern-design    — Step 1:  Architecture design"
echo "  /fern-api       — Step 2:  MuleSoft Mock API"
echo "  /fern-deploy    — Step 3:  Deploy to CloudHub"
echo "  /fern-wire      — Step 4:  Agentforce wiring"
echo "  /fern-agent     — Step 4B: Build the agent + wire actions"
echo "  /fern-apex      — Step 5:  Apex controllers + Custom Setting"
echo "  /fern-site      — Step 6:  Experience Cloud site + Chat UI"
echo "  /fern-form      — Step 7:  Custom object + form + polling"
echo "  /fern-dashboard — Step 8:  Internal dashboard"
echo "  /fern-debug     — Debugging prompts (use any time)"
echo "  /fern-prep      — Demo prep + token refresh (run before every demo)"
echo ""
echo "Open Claude Code and type / to see them listed."
