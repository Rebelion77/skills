# Enterprise Defensive Ops

Clean-room DEFENSIVE security operations playbook for enterprise/cloud
environments: log analytics and hunting queries, host intrusion
detection triage, and firewall/detection review. Defensive only — no
exploitation, no offensive tooling, no evasion techniques.

## 1. Log analytics & hunting (KQL-first)
- Environment mapping first: which tables exist (SigninLogs,
  AuditLogs, SecurityEvent, DeviceProcessEvents, etc.), retention, and
  timezones — a query against the wrong table proves nothing.
- Query patterns, in the user's own environment only:
  - Identity: impossible travel, MFA fatigue patterns, dormant account
    sign-ins, privilege grants outside change windows.
  - Endpoint: rare parent-child process pairs, unsigned binaries in
    user-writable paths, mass file-rename bursts (ransomware precursor).
  - Network: first-seen external destinations per host, beaconing
    intervals, DNS tunneling shapes (length/entropy outliers).
- Every hunt ends with: hypothesis, result (hits or a true negative),
  and the follow-up tuning — never just raw output.

## 2. HIDS triage (Wazuh/OSSEC-class)
- Alert classification by rule level + context: is the host supposed
  to do this, at this hour, by this user?
- Integrity monitoring: which files changed, do they match a known
  deployment, is the change window legitimate.
- False-positive tuning is documented per rule (why suppressed, what
  would re-trigger review) — silent suppression is forbidden.

## 3. Detection & firewall review
- Rule review: stale rules, overly broad allows, shadowed rules, and
  logging gaps (allowed traffic with no log is a blind spot, named as
  such).
- Change proposals are written defensively: scope, justification,
  rollback — and executed only by the user's own change process.

## Rules
- Read-only by default in any live environment; changes go through
  the owner's approval and change management, never around them.
- Only the user's/employer's own tenants, hosts, and logs. Never a
  third party's environment.
- Findings are reported with evidence and confidence; an inconclusive
  hunt is reported as inconclusive, not as "clean".
