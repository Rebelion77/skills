# Checklists — Fast Edition v3.0.0

## Fast doctrine checklist (v3.0 — run this before anything else)

- Live board enumerated fresh (open + closed/duplicate + newest filings)
- Full specialist roster deployed, each team in its own field; coordinator verifies every claim
- Fresh commits / newest surface hunted first; harvested ground not re-swept without a new angle
- Every lead triaged for Medium+ cap in minutes; sub-Medium leads get one line, then move on
- Dup-check early, before deep PoC, across ALL corpora + live board; neighbour bodies read in full
- PoC drives the real production path (no stubs/mocks on the mechanism); verifier re-runs it independently
- Draft + 2 proofreaders + fix-verification, then file in the same session; live board re-checked right before filing
- Banked findings recorded with kill reason + re-test trigger; composition matrix run at round end
- Fix/PR status tracked for parent reports; residuals re-tested only against fixed code
- Triager comments mined for duplicate boundaries; verdicts tracked
- Severity calibrated to the program's actual award history, not just CVSS math
- Per-lead time budget set at triage and respected; parked leads recorded with reason + budget spent
- Evidence to persistent storage immediately, resume-skip so a restart never redoes finished work

## Intake checklist

- Program name, URL, scope, rules, reward table, and date recorded
- In-scope assets listed, out-of-scope assets marked do-not-touch
- Allowed and forbidden test types recorded
- Test accounts A and B created, unique emails, strong passwords
- Baseline behaviour recorded
- Target map file created

## Recon checklist

- Subdomains enumerated and live hosts checked
- Subdomain takeover checked, harmless verification only
- URLs, JavaScript, API endpoints, and parameters collected
- Authentication, authorization, and input mapped
- Security headers, CORS, CSP, and cookie flags checked
- Nuclei run at low rate, every hit verified by hand
- ffuf run at low rate, small wordlist first

## Testing checklist

- XSS reflected, stored, DOM, blind
- SQL injection, minimal proof only
- CSRF on state-changing requests
- IDOR / BOLA / BFLA / BOPLA
- Authentication, session, password reset, OTP, MFA
- OAuth, SSO, JWT, GraphQL, WebSocket
- SSRF, XXE, SSTI, file upload, business logic, race conditions
- API rate limiting, excessive data exposure
- Mobile static and dynamic, cloud misconfiguration
- Chaining, only in scope and minimal impact

## Reporting checklist

- Reproduced by hand, minimal proof of concept
- CVSS 3.1 scored, CVSS 4.0 when the program uses it
- Duplicate checked, impact stated honestly
- Secrets and other users' data redacted
- Evidence log saved, with IDs, requests, responses, and screenshots
- Test data cleaned up, tokens revoked
- Submitted through the program's channel
- Triager questions answered with evidence; duplicate disputes only via the program's mediation path
