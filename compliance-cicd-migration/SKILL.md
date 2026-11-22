# Compliance, CI/CD & Migration

Clean-room engineering playbook for three chores that sink projects
when done casually: compliance readiness, pipeline quality, and code
migration. Advisory and planning only — compliance output is an
engineering checklist, never legal advice or an audit opinion.

## 1. Compliance readiness (engineering view)
- Translate a framework (GDPR, SOC 2, ISO 27001 basics) into concrete
  engineering controls: data inventory (what personal data, where,
  why), access control and audit logging, retention/deletion paths,
  encryption in transit/at rest, incident response runbook.
- Gap list format: control, current state (evidence-based, from the
  actual repo/infra), gap, smallest fix. "We believe we're compliant"
  without evidence is recorded as a gap, not a pass.
- Anything ambiguous goes to a qualified auditor/lawyer — say so.

## 2. CI/CD pipeline review
- Stages audit: build reproducibility, test gates that actually block,
  lint/typecheck, dependency vulnerability scanning, secrets handling
  (no secrets in code, logs, or artifacts; scoped CI tokens), artifact
  integrity (signing/checksums), deploy strategy (rollback tested, not
  theoretical).
- Environment parity and promotion rules: what differs between
  staging and production is listed; unlisted differences are findings.
- Output: pipeline diagram in words, weak points ranked by blast
  radius, fixes ordered by effort-to-risk-reduction.

## 3. Code migration planning
- Inventory first: languages, frameworks, dead code, data stores,
  external integrations, and the tests that exist (or honestly don't).
- Strategy choice with reasons: strangler/incremental (default) vs
  big-bang (only when the system is small enough to re-verify fully).
- Every phase has: scope, verification method, rollback trigger, and
  a stop condition. Data migration gets its own rehearsal on a copy
  before any real run.

## Rules
- Never certify compliance; prepare evidence and checklists only.
- A migration plan without a tested rollback is not a plan — say so
  and do not proceed past planning.
- Pipeline changes to the user's repos follow his normal approval:
  show the diff/effect before applying.
