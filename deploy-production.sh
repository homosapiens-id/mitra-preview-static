#!/bin/sh
set -eu

ROOT="/home/u398929082/domains/mitra.homosapiens.id/public_html"
BACKUP="/home/u398929082/mitra-production-backup-$(date -u +%Y%m%dT%H%M%SZ).tgz"
SOURCE="https://raw.githubusercontent.com/homosapiens-id/mitra-preview-static/main/index.html"

mkdir -p "$ROOT"
tar -czf "$BACKUP" -C "$ROOT" . 2>/dev/null || true

TMP="$ROOT/.mitra-production-index.$$.html"
curl -fsSL "$SOURCE" -o "$TMP"

find "$ROOT" -mindepth 1 -maxdepth 1 ! -name "$(basename "$TMP")" -exec rm -rf {} +
mv "$TMP" "$ROOT/index.html"
chmod 644 "$ROOT/index.html"

grep -q "Mitra" "$ROOT/index.html"
echo "MITRA_PRODUCTION_DEPLOY_OK backup=$BACKUP"
