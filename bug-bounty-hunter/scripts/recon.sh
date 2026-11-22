#!/bin/bash
# Bug Bounty Hunter — passive recon helper
# Usage: ./recon.sh example.com
# Only run against a target that is in scope in a written program.
set -e
DOMAIN="${1:-}"
if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 example.com"
  exit 1
fi
mkdir -p "recon-$DOMAIN"
subfinder -d "$DOMAIN" -o "recon-$DOMAIN/subdomains.txt" || true
httpx -l "recon-$DOMAIN/subdomains.txt" -o "recon-$DOMAIN/live.txt" -status-code -title || true
echo "Done. Check recon-$DOMAIN/live.txt"
