# Opsec & Secret Guard

Clean-room defensive playbook: keep the user's own secrets, keys, and personal
data from leaking through files, bundles, repos, screenshots, and messages —
and audit his own operational security before something goes out. Everything
here is defensive and read-only by default: this skill scans, reports, and
advises. It never moves funds, never changes credentials, and never prints a
full secret value.

## 1. Pre-share secret scan (files, bundles, repos)
Before any file set leaves this machine (GitHub backup upload, file hosting,
sharing with another agent, attaching to a message), scan the exact payload:
- Pattern sweep for: private keys / seed phrases, keystore JSON, API keys and
  tokens (generic `KEY|TOKEN|SECRET|PASSWORD|AUTH|BEARER` assignments plus
  known formats), session files and cookies, `.env` files, SSH keys, and
  credential stores.
- PII sweep for: full legal names tied to ID data, national ID / passport
  numbers, exact home addresses, phone numbers, dates of birth — whenever the
  user has marked them private or a forget order covers them.
- Scan ARCHIVES too: extract ZIPs/bundles to a scratch dir and scan the
  contents, not just the file list. A clean tree with a dirty archive inside
  is a dirty share.
- Report per hit: file path, line, TYPE of secret, and a redacted preview
  (at most first 2 + last 2 characters). Never quote the full value in chat,
  logs, or memory.
- Verdict gate: CLEAN (share may proceed) / DIRTY (stop, list hits, wait for
  the user's decision: remove, redact, or abort the share).

## 2. Leak response (if something already went out)
- Identify exactly what leaked, where, and who could access it (public vs
  private repo, commit history vs latest version — history copies count).
- Rank by blast radius: signing material and session tokens first (rotate /
  revoke / re-pair immediately), API keys next (revoke at the provider),
  PII last (cannot be un-shared; document scope, offer history-purge or
  repo-recreate options with their real costs).
- Deleting the current file is NOT a fix when history, forks, or caches may
  hold copies — say so plainly and offer the stronger option.
- Execute only the steps the user approves; verify each fix (rescan, check
  the remote state) before reporting it done.

## 3. Wallet & account opsec checklist (his own setup)
Periodic self-check, read-only, reported as pass / warn / fail:
- No keys, seeds, or keystore JSON anywhere in the workspace, memory files,
  chat logs, or screenshots; signing material lives only in the vault /
  local signer, referenced by path, never by value.
- Session hygiene: which wallet/app sessions exist, when they expire, and
  whether stale sessions should be re-paired rather than trusted.
- Approval hygiene: outstanding token approvals / operator grants on his
  wallets (read-only scan; revokes are separate transactions under the
  on-chain safety rails with his explicit go).
- Backup hygiene: every recurring backup/export path runs section 1's scan
  as a gate before upload; exclusions (vault, sessions, keys) are verified
  against the actual payload, not assumed.
- Public-footprint check: usernames/handles he uses publicly are never
  bundled with the private data they must stay separate from.

## Rules
- Redaction is absolute: no tool output, report, or memory entry from this
  skill may contain a full secret value, seed, key, or covered PII item.
- Scanning the user's own files at his request is the whole job. Never scan,
  probe, or harvest other people's credentials, accounts, or devices.
- A scan is evidence, not a guarantee: report coverage honestly (what was
  scanned, what could not be read, e.g. binary or encrypted files) and never
  call a payload "100% safe" beyond the checks actually run.
- Anything state-changing (rotating a key, revoking a session or approval,
  purging a repo) needs the user's explicit approval for that exact step,
  and on-chain steps additionally follow `on_chain_safety_rails`.
