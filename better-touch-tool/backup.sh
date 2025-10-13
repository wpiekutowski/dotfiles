#!/usr/bin/env bash
set -euo pipefail

BTT_DIR="$HOME/Library/Application Support/BetterTouchTool"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}"
BACKUP_FILE="${BACKUP_DIR}/backup.sql"

# Check if BTT directory exists
if [[ ! -d "$BTT_DIR" ]]; then
    echo "Error: BetterTouchTool directory not found: ${BTT_DIR}"
    exit 1
fi

# Find the most recent BetterTouchTool database
DB=$(ls -t "${BTT_DIR}"/btt_data_store*build_?????????? 2>/dev/null | head -n 1)

if [[ -z "$DB" ]]; then
    echo "Error: BetterTouchTool database not found in ${BTT_DIR}"
    exit 1
fi

if [[ ! -f "$DB" ]]; then
    echo "Error: Database file does not exist: ${DB}"
    exit 1
fi

# Check if database file has content
if [[ ! -s "$DB" ]]; then
    echo "Error: Database file is empty: ${DB}"
    exit 1
fi

echo "Backing up BetterTouchTool database..."
echo "Source: ${DB}"
echo "Destination: ${BACKUP_FILE}"

# Dump database and filter out display configurations (ENT=4)
echo "Dumping database and filtering out display configurations..."
TEMP_FILE="${BACKUP_FILE}.tmp"

# Use -bail flag to fail on errors and verify database can be opened
if ! sqlite3 -bail "$DB" ".dump" > "$TEMP_FILE"; then
    echo "Error: Failed to dump database"
    rm -f "$TEMP_FILE"
    exit 1
fi

# Filter out BSTCDisplay entries (ENT=4) which contain monitor serial numbers
# Keep the schema but remove INSERT statements for display configurations
awk '
BEGIN { skip = 0 }
/^INSERT INTO ZBTTBASEENTITY VALUES\([0-9]+,4,/ {
    # Skip display configuration entries (ENT=4 = BSTCDisplay)
    skip = 1
    next
}
{ print }
' "$TEMP_FILE" > "$BACKUP_FILE"

rm -f "$TEMP_FILE"

# Verify backup file has substantial content (more than just empty schema)
if [[ $(wc -c < "$BACKUP_FILE") -lt 100 ]]; then
    echo "Error: Backup file appears to be empty or invalid"
    exit 1
fi

echo "Backup completed successfully ($(wc -c < "$BACKUP_FILE") bytes)"
echo "Adding to git..."

cd "$SCRIPT_DIR"
git add backup.sql
git commit --edit -m "BetterTouchTool backup"
