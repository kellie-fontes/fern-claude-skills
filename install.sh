#!/bin/bash
# Fern Claude Skills — one-line installer
# Usage: curl -s https://raw.githubusercontent.com/kellie-fontes/fern-claude-skills/main/install.sh | bash

set -e

SKILLS_DIR="$HOME/.claude/commands"
REPO="https://raw.githubusercontent.com/kellie-fontes/fern-claude-skills/main/.claude/commands"

echo "Installing Fern Claude Skills..."

mkdir -p "$SKILLS_DIR"

skills=(
  "fern-start.md"
  "fern-design.md"
  "fern-context.md"
  "fern-api.md"
  "fern-deploy.md"
  "fern-wire.md"
  "fern-agent.md"
  "fern-apex.md"
  "fern-site.md"
  "fern-form.md"
  "fern-dashboard.md"
  "fern-debug.md"
  "fern-prep.md"
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
echo "  /fern-design    — Architecture design"
echo "  /fern-api       — MuleSoft Mock API"
echo "  /fern-deploy    — Deploy to CloudHub"
echo "  /fern-wire      — Agentforce wiring"
echo "  /fern-agent     — Build the agent + wire actions"
echo "  /fern-apex      — Apex controllers + Custom Setting"
echo "  /fern-site      — Experience Cloud site + Chat UI"
echo "  /fern-form      — Custom object + form + polling"
echo "  /fern-dashboard — Internal dashboard"
echo "  /fern-debug     — Debugging prompts"
echo "  /fern-prep      — Demo prep + token refresh"
echo ""
echo "Open Claude Code and type / to see them listed."
