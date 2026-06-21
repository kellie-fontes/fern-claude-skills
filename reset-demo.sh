#!/bin/bash
# reset-demo.sh — Wipe demo log records so the demo starts clean
# Reads org_alias, log_object, persona_id, and persona_id_field from fern-context.md
# Usage: bash reset-demo.sh

set -e

# Find fern-context.md — check project root, one level up, or home
for CONTEXT in "$(dirname "$0")/fern-context.md" "$(dirname "$0")/../fern-context.md" "$HOME/fern-context.md"; do
  [ -f "$CONTEXT" ] && break
done
if [ ! -f "$CONTEXT" ]; then
  echo "ERROR: fern-context.md not found. Run /01-fern-design first."
  exit 1
fi

ALIAS=$(grep '^org_alias:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)
LOG_OBJECT=$(grep '^log_object:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)
PERSONA_ID=$(grep '^persona_id:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)
PERSONA_ID_FIELD=$(grep '^persona_id_field:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)

echo "Org:        $ALIAS"
echo "Object:     $LOG_OBJECT"
echo "Scoped to:  ${PERSONA_ID_FIELD} = ${PERSONA_ID}"
echo ""

read -r -p "Delete all ${LOG_OBJECT} records for ${PERSONA_ID}? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Cancelled."; exit 0; }

cat > /tmp/reset-demo.apex << APEX
List<${LOG_OBJECT}> records = [SELECT Id FROM ${LOG_OBJECT} WHERE ${PERSONA_ID_FIELD} = '${PERSONA_ID}'];
Integer count = records.size();
delete records;
System.debug('Deleted ' + count + ' ${LOG_OBJECT} records.');
APEX

sf apex run --target-org "$ALIAS" --file /tmp/reset-demo.apex
rm -f /tmp/reset-demo.apex

echo ""
echo "Done — ${LOG_OBJECT} cleared for $ALIAS."
echo "Open the chatbot in an incognito window and run the demo flow to verify."
