---
name: bug-bounty-hunter
description: Authorized bug bounty methodology, fast edition v3.0.0, for in-scope web, API, mobile, GraphQL, WebSocket, and cloud targets — program intake and scope verification, deep passive and active reconnaissance, subdomain takeover, authenticated testing for OWASP Top 10, API Top 10, JWT, OAuth, SSO, MFA, business logic, race conditions, and cloud misconfiguration, minimal-impact proof of concept, CVSS 3.1 and 4.0 scoring, duplicate and triage handling, and a complete HackerOne / Bugcrowd style report with reproduction steps, remediation, and evidence log. Speed doctrine: race the board (enumerate live reports first, hunt newest surface first), Medium floor (never hunt or report below Medium), early dup-kill, parallel specialist lanes, time-boxed phases, no re-sweeps without a new angle. Use for "cari bug di program ini", "audit keamanan web ini", "bounty hunting", "cek kerentanan", "buat laporan bug bounty", "recon target bounty", "upgrade skill bounty". Trigger whenever the user supplies a bug bounty program, target domain, or URL and wants a security assessment, vulnerability hunt, or bounty report.
metadata:
  author: "Kacung"
  whenToUse: The user supplies a bug bounty program, target domain, or URL and wants a security assessment, vulnerability hunt, or bounty report — with or without a specific vulnerability class in mind.
  version: "3.0.0"
  license: MIT
  entrypoint: references/checklists.md
  testedAgainst: [Web, API, GraphQL, WebSocket, Mobile Web, Cloud]
---

# Bug Bounty Hunter — Fast Edition v3.0.0

Find real, in-scope vulnerabilities, prove them with minimal impact, chain them only where the program allows it, and report them so the vendor can fix them and pay the bounty.

This is the fast edition (v3.0.0, upgraded from the v2.0.0 full max edition). Same completeness, plus a speed doctrine: the hunt is a race against other hunters, so every stage is built to find the bug first without cutting the proof. It does not guarantee a bug on any given target. It guarantees a complete method, run fast: every stage that a professional hunter runs, in order, with a checklist, a stop rule, and a report at the end.

## v3.0 doctrine — FAST + THOROUGH (gercep)

Speed and thoroughness are not a trade-off here. Speed comes from killing dead leads early and never redoing finished work; thoroughness comes from proving what survives. The rules below override any slower habit from v2.0.0. Amendment 2026-11-11 (gacor): bank + composition, fix watch, triage play, triager-comment mining, award calibration, per-lead stop-loss — see below.

### Race the board first

- Before hunting, enumerate the program's live board: all open reports, all closed/duplicate reports, and the newest filings. A lead that is already claimed is not a lead — learn that in minutes, not after a PoC.
- Hunt the newest surface first: fresh commits, fresh features, and areas with no recent filings beat re-sweeping harvested ground. A fresh-code tripwire (commit watch) outranks a scheduled re-sweep.
- File fast after verification. A verified finding that sits undrafted is a finding someone else files first. Draft, proofread, and submit in the same session whenever possible.

### Medium floor — hard rule, no exceptions

- **Hunt Medium and above only.** The minimum tier is Medium (CVSS 3.1 4.0+ or the program's Medium). Do not spend hunt time on leads that cap at Low or Minor: no PoC, no draft, no proofread, no report for them. A sub-Medium lead gets one line in the notes (title + why it caps below Medium) and the hunt moves on.
- **Never report below Medium.** A Low/Minor finding is not submitted, not drafted, and not banked as a candidate. It may be banked only as a one-line watch if a program change (a fix landing, a bar dropping) could raise it — otherwise it is retired.
- Judge the cap early, at triage: if the realistic impact cannot reach Medium (no money movement, no liveness loss, no auth bypass, no data access, self-harm only, or a fix already covers it), kill the lead there. Do not "prove it anyway" — a proven Low costs the same hours as a proven Medium and pays nothing.

### Kill fast at every gate (the funnel)

Work flows through gates; a lead dies at the first gate it fails, immediately:

1. **Triage (minutes):** is the impact plausibly Medium+? If not, one line, move on.
2. **Dup-check (minutes, BEFORE any deep PoC):** grep ALL corpora — open reports AND closed/duplicate reports AND the live board — and read the full body of every neighbour. A closed duplicate still kills a finding. Title-only grep is not enough.
3. **PoC (hours, not days):** drive the real production path end-to-end. A PoC that stubs or mocks the mechanism under test proves nothing — reject it. If the mechanism cannot be driven for real, the lead is not proven.
4. **Independent verification:** the verifier re-runs the PoC themselves and reads every code site the claim rests on. A claim nobody re-ran is not verified.
5. **Draft + proofread + submit:** two independent proofreaders, one fix-verification pass, then file. The submitter verifies identity, privacy, and body completeness on the ticket page.

### Parallel specialist lanes — deploy the full roster, each team in its own field

- On a full hunt, deploy ALL specialist teams at once, each in its own field — no field left uncovered, no team spread across fields it does not own. A full roster, by field:
  - **Board & verdict watch** — live board enumeration, new filings, verdict changes, fix/PR status, triager comments.
  - **Recon & fresh surface** — new commits, new features, new endpoints, areas with no recent filings.
  - **Web & API** — OWASP Top 10, API Top 10, GraphQL, WebSocket, auth/session, JWT/OAuth.
  - **Core logic & state machine** — the target's core state transitions, invariants, and edge cases (for a chain: consensus, finalization, ledger; for an app: the core domain logic).
  - **Economic & business logic** — pricing, fees, incentives, rewards, race conditions, multi-step flows, composition of banked findings.
  - **Network & sync** — P2P, sync, gossip, peer handling, rate limits, availability.
  - **Client, SDK & integrations** — SDKs, clients, dashboards, admin tools, third-party integrations.
  - **Critical track** — new angles only, cross-cutting, hunting the highest tier.
- Adapt the roster to the target's architecture (a chain target gets consensus/ledger/P2P teams; a web target gets web/API/auth/mobile/cloud teams), but never shrink it by leaving a field unstaffed on a full hunt. On a focused hunt, deploy only the teams whose field the focus touches.
- Each team works ONLY its own field — no overlap, no re-sweeping another team's ground. A team staffed with genuine specialists in its field beats generalists spread thin.
- All lanes run at the same time, not in sequence. The coordinator verifies every lane's claims itself — a team's report is a claim, not a verdict.
- Each lane has one owner and writes its own report before finishing, including the fact that killed each lead. A lane that finds nothing reports that plainly. An empty round is a result, not a failure — but a round that re-sweeps harvested ground without a new angle is wasted motion.

### Never redo finished work

- Do not re-sweep an area without a concrete new angle (fresh commit, new ticket, new primitive, new composition). Harvested surface stays harvested.
- Do not re-run an identical PoC on an identical codebase: if the HEAD is unchanged and the code sites are byte-identical, verify the sites and move on — re-running only reproduces identical numbers.
- Every piece of evidence goes to persistent storage immediately, with resume-skip so a restart never redoes a finished step. A finding without a running PoC is not a finding.

### Bank proven findings and compose them

- A finding that is proven but blocked (duplicate, below the bar, fix pending) is not thrown away — it goes in the bank with four fields: mechanism, proof (PoC file), kill reason, and re-test trigger (which fix, verdict, or program change would free it). A bank entry without a trigger is a dead entry: retire it.
- At the end of every round, run a composition matrix over the bank: test pairs of banked findings that share state, share a primitive, or where one enables the other. Composition is systematic, not ad-hoc — list the pairs, test each, record dead or alive. A composition is filed only when the combined impact reaches a tier on its own and every step is proven end-to-end.
- Never file a composition whose combined impact is just two Lows added together on paper. The chain must produce a real new impact (money movement, liveness loss, auth bypass, data access) that neither step produces alone.

### Watch the fix, not just the verdict

- Verdict watch is not enough: track the fix/PR status of every parent report a banked finding depends on. A verdict ("accepted") without a fix changes nothing; a fix landing changes everything.
- When a parent fix lands, re-run the banked residual's PoC against the fixed code before deciding anything. A fix can kill the residual — or set it free. Read the fix diff yourself: check what it actually changes (re-weighting votes is not the same as recomputing a denominator).
- Do not file a residual while its parent is accepted-but-unfixed. File only after the fix has landed and the PoC has been re-run against the fixed code.

### Kill a lead on a clock, not on a feeling

- Every lead gets a time budget at triage: minutes for triage, hours (not days) for a PoC. The budget is set before the work starts, not after it has already eaten a round.
- If the code or the docs show the mechanism is by design, kill the lead in minutes — do not "prove it anyway" to be sure. A by-design mechanism is a dead lead, not a finding waiting for a longer PoC.
- If the PoC has produced no decisive signal by the end of its budget, park the lead (one line in the notes, with the reason and the budget spent) and move on. Never let one lead eat a whole round. A parked lead can be picked up again only with a new angle.

### Mine the triager's comments

- When you read a closed or duplicate ticket, read the triager's replies too — not just the report body. The replies reveal the program's real duplicate boundaries: what counts as the same root cause, what counts as a distinct trigger, and what the triager considers already-known.
- A triager reply that says "same finding as an earlier report that is not public" tells you the family is claimed even when you cannot see the original. Do not file into a family the triager has already closed — unless your trigger, call-site, or victim is genuinely different, and you can prove the difference in the report.
- Record every triager reply that teaches a boundary, next to the ticket it belongs to. These replies are the program's real rules, written in verdicts.

### Thoroughness that speed never cuts

- Anti-stub rule, full-corpus dup-check, independent PoC re-run, and honest caveats (including merge risk and score sensitivities) are non-negotiable. Speed never means skipping them — they are what keep a fast filing from being a duplicate or a false claim.
- Report exactly what was found, as it is, with no fabrication and no embellishment. A fast wrong report costs more than a slow round: credibility with the triager.

## Scope and authorization — non-negotiable

- Only test targets that are explicitly in scope in a written bug bounty program, a signed authorization, or a target the user owns.
- Read the program page first and record: in-scope domains and assets, out-of-scope assets, allowed and forbidden test types, rate limits, data handling rules, safe harbour, and the disclosure policy.
- Record the program version and the date you read it. Programs change scope. A finding on an asset that left scope is not a finding.
- If there is no program, no scope, or no authorization, stop and say so. Do not test, scan aggressively, or attempt to bypass authentication on a target you do not own and have no permission to test.
- Never test: production data belonging to other users, other customers' accounts, payment systems with real money, or any system outside the stated scope.
- Never do: denial of service, brute force at scale, spam, social engineering of employees or users, phishing, physical access, credential stuffing with leaked lists, or downloading, deleting, or altering other people's data.
- Use only test accounts you created yourself, or accounts the program explicitly provides. Never use another person's credentials, session, or token.
- Stop immediately if a test starts affecting availability, other users, or real data. Record what happened, revert what you changed, and disclose it in the report.
- Chaining is allowed only when each step is in scope and minimal impact. Do not chain a low finding into access to real user data to prove impact. Describe the chain, stop at your own test account.

### Read every applicable rule — in detail, without error

A report is only as good as its compliance with the program's rules. A technically real bug filed against the wrong rule is an invalid report. Read all of it, not just the scope:

- Read the program's rules page in full before hunting: scope, reward table, allowed and forbidden test types, rate limits, safe harbour, disclosure policy, duplicate policy, and what the program counts as valid, out-of-scope, or informational. Record the rules and the date you read them, next to the scope.
- Read the submission form itself: every required field, the severity taxonomy the program uses, the exact meanings of its tiers, and any template or format it demands. A report in the wrong format or with the wrong severity label is a defective report even if the bug is real.
- Read the program's triage and validity guidance (FAQ, known-issues list, changelog, disclosed reports): what gets marked duplicate, what gets marked not-applicable, and what evidence the triager expects. A finding that repeats a known issue is not a new bounty, however well proven.
- Re-read the rules at filing time. Programs change scope and rules; a report that was valid when the hunt started may be invalid when filed. If anything changed, re-check the finding against the new rules before submitting.
- Never guess a rule. If a rule is ambiguous — a tier boundary, a scope edge, a duplicate question — do not assume the favourable reading. Check the program's docs, disclosed reports, or changelog for the answer; if there is no answer, state the ambiguity in the report instead of hiding it.
- Pre-submit rules audit (do this for every report, no exceptions): check each field against the form's requirements; check the severity against the program's tier definitions and your own CVSS math; check every factual claim against the rules (in scope? allowed test type? duplicate-free against open AND closed reports?); check that nothing in the report violates the disclosure policy. Any item that fails is fixed before filing — a report goes out clean or not at all.
- The goal is a zero-defect report: every field filled as the program requires, every severity matching the program's definitions, every claim traceable to evidence, nothing that gives the triager a reason to mark it invalid on a technicality.

## Inputs

Required: target program URL or program name, and at least one in-scope domain or URL.

Helpful: program scope text, test account credentials the user created for testing, API documentation, OpenAPI or Swagger file, GraphQL schema, mobile app package, cloud asset list, and the vulnerability class the user suspects.

Missing target or scope: ask. Do not guess scope from a domain name alone. A wildcard `*.example.com` does not include `example.com` itself unless the program says so, and it does not include third-party services on a subdomain unless the program says so.

Missing authorization: ask the user to paste the program scope or link. A link to a public program page is enough; a screenshot of scope text is acceptable.

## Modes

- **Quick triage** — user gives one URL and asks "is this vulnerable". Run intake, passive recon, active recon, and the top 10 checks for that page and its API. Give a verdict, a severity, and a next step. Do not run a full program hunt.
- **Full hunt** — user gives a program. Run every stage below, keep a target map, test every in-scope asset, and produce a ranked findings list.
- **Focused hunt** — user names one class, for example IDOR, XSS, or SSRF. Run intake and recon, then run only that class deeply across every endpoint, plus the checks that chain into it.
- **Report only** — user gives a finding and asks for a report. Verify it by hand if you can, score it, check duplicates, and write the report. Do not invent reproduction steps you did not run.

Default to full hunt when the user gives a program, quick triage for a single URL, and focused hunt when the user names a class.

## Tools and setup

Use only tools the user has installed or that are freely available, and keep requests close to ordinary use. Stop on rate limits, 429, 403, account locks, or WAF blocks. See `references/tools-setup.md` for install commands.

- Recon: `subfinder`, `amass`, `httpx`, `nuclei`, `katana`, `gau`, `waybackurls`, `dnsx`, `naabu`, `ffuf`, `arjun`, `paramspider`
- Proxy and manual testing: Burp Suite, OWASP ZAP, browser DevTools, `mitmproxy`
- API testing: Postman, `curl`, `jq`, Burp Repeater, `graphql-voyager`, `inql`
- Auth and tokens: `jwt.io`, `jwt_tool`, Burp JWT Editor, `oath-toolkit`
- Mobile: `apktool`, `jadx`, `adb`, `MobSF`, Frida only on a device and app the user owns or is authorized to test
- Cloud: `cloudsploit`, `Prowler`, `ScoutSuite`, only on cloud assets the user owns or the program lists in scope
- Wordlists: SecLists, only for in-scope fuzzing at a low rate
- Collaboration: `interactsh`, Burp Collaborator, only with a server you control

Do not run automated scanners at full speed against production. Use a low rate, a short timeout, and stop when the target slows down. One scanner hit is a lead, never a finding.

## Workflow

### 0. Intake and scope

- Record the program, its scope, its rules, its reward table, and the date you read them.
- List every in-scope asset and mark every out-of-scope asset as do-not-touch. Include subdomains, APIs, mobile apps, and cloud assets separately.
- Create two fresh test accounts, A and B, with unique emails and strong passwords. Record only that they are test accounts, never share their passwords in a report. Use A as victim and B as attacker for access control tests.
- Set up Burp or ZAP as a proxy, or use browser DevTools, so every request and response is logged.
- Take a baseline: load the main pages, log in, log out, and note normal behaviour, normal status codes, and normal error messages.
- Save the scope text, the target map, and the baseline in a working file. Every later step refers back to this file.

### 1. Passive reconnaissance

See `references/recon.md` for the full checklist and commands.

- Search public sources only: search engines, GitHub, GitLab, Certificate Transparency logs, DNS records, Shodan, Censys, and the Wayback Machine.
- Enumerate subdomains with `subfinder` and `amass`, then check which ones are live with `httpx`. Deduplicate, then add every live host to the target map.
- Check subdomain takeover: CNAME pointing to a dead service, expired cloud bucket, or unclaimed SaaS. Verify with a harmless DNS or HTTP check only. Do not claim a service you do not own.
- Collect URLs, JavaScript files, API endpoints, and parameters from `gau`, `waybackurls`, `katana`, and `paramspider`.
- Read JavaScript files for API endpoints, hardcoded keys, internal URLs, GraphQL queries, and commented-out code. A key in JavaScript is a lead, not a finding by itself. Test whether the key actually works, and only against an in-scope service.
- Check for exposed files: `robots.txt`, `sitemap.xml`, `.git/`, `.env`, backup files, `/.well-known/`, and open storage buckets, only when they are in scope. Do not download large datasets.
- Check tech stack, third-party services, analytics, and error pages. Record versions only when they are visible in normal responses.
- Record every asset, endpoint, and parameter in a target map before testing. Do not test an endpoint you have not mapped.

### 2. Active reconnaissance

- Fingerprint the stack: headers, cookies, server banner, framework, and WAF presence.
- Map authentication: login, signup, password reset, OAuth, SSO, SAML, MFA, session handling, remember-me, and logout. Note every token, its lifetime, and where it is stored.
- Map authorization: roles, user IDs, object IDs, and every place one user can access another user's data. Note admin, moderator, and support roles separately.
- Map input: every form, search box, upload, API parameter, header, cookie, and WebSocket message.
- Map state-changing actions: every POST, PUT, PATCH, and DELETE, and what token or check protects it.
- Check security headers, CORS, CSP, HSTS, and cookie flags (`HttpOnly`, `Secure`, `SameSite`).
- Check rate limiting on login, password reset, signup, OTP, and API calls. Send a small number of requests, note the limit, and stop.
- Run `nuclei` with a low rate and only the templates that match the target stack. Record every hit, then verify each hit by hand. A scanner hit without manual verification is not a finding.
- Run `ffuf` for hidden directories and files only on in-scope hosts, at a low rate, with a small wordlist first.

### 3. Vulnerability testing — web

See `references/web-testing.md` for the full checklist, payloads, and proof steps.

Test each class below only where it applies, with a minimal, non-destructive proof of concept.

- Cross-Site Scripting (XSS): reflected, stored, and DOM, including blind XSS with a collaborator you control. Use a harmless alert or console marker in a test account, never in another user's data. Stored XSS in a shared area: report it, do not trigger it against other users.
- SQL Injection: boolean, time-based, error-based, and UNION-based checks first, never `DROP`, `DELETE`, or `UPDATE`. A successful extraction of one row from your own test account is enough proof.
- Cross-Site Request Forgery (CSRF): test state-changing requests without a token, with a token from another session, and with a token in a GET request.
- Broken Access Control / IDOR: change object IDs, user IDs, and role parameters while logged in as a low-privilege test user. Accessing your own second test account is valid proof. Accessing a real user's data is not.
- Authentication flaws: weak password policy, no rate limiting, credential stuffing protections, session fixation, session not invalidated on logout or password change, password reset token predictability or leakage, OTP brute force, and MFA bypass, including response manipulation and missing MFA on sensitive actions.
- OAuth and SSO flaws: open redirect in `redirect_uri`, missing `state`, token leakage in URLs, and account takeover via email change or unverified email.
- Security misconfiguration: default credentials only on test systems, directory listing, verbose errors, debug mode, exposed admin panels, and misconfigured CORS that allows credentialed cross-origin reads.
- Sensitive data exposure: PII, tokens, or secrets in responses, logs, URLs, or error messages. Report the field and the endpoint, do not copy bulk data.
- File upload: upload a harmless text file first, then test extension, content-type, and path traversal checks. Never upload a shell to a production server.
- Server-Side Request Forgery (SSRF): use a collaborator URL you control, or an internal metadata endpoint only in a way the program allows. Do not exfiltrate internal data. Test URL parsers, redirects, and PDF or image fetchers.
- Server-Side Template Injection (SSTI): test template syntax in inputs that render server-side, with a harmless mathematical expression first.
- XML External Entity (XXE): use a harmless out-of-band check first, never read local files beyond proof of parsing.
- Business logic: price manipulation, quantity manipulation, coupon reuse, race conditions on a test purchase with no real payment, workflow skipping, and negative values. Test each step of a multi-step flow out of order.
- Race conditions: send a small number of parallel requests for a test action, for example redeeming a test coupon twice. Stop if the target slows down.
- Web cache poisoning, HTTP request smuggling, and host header injection: test only when the program allows it, with a harmless cache key first, and never poison a cache that other users read.
- Subdomain takeover, open redirect, and CRLF injection: verify with a harmless redirect to your own domain, never to a phishing page.

### 4. Vulnerability testing — API

See `references/api-testing.md` for the full checklist.

- Enumerate API versions, endpoints, methods, and parameters from documentation, OpenAPI, JavaScript, and proxy traffic.
- Test Broken Object Level Authorization (BOLA): change object IDs in API calls as a low-privilege test user, for reads, writes, and deletes.
- Test Broken Function Level Authorization (BFLA): call admin endpoints as a normal test user, and call endpoints the UI never shows.
- Test Broken Object Property Level Authorization (BOPLA): add extra fields such as `is_admin`, `role`, `price`, or `user_id` to requests.
- Test excessive data exposure: check whether list endpoints return fields the UI never shows, including internal IDs, emails, and tokens.
- Test rate limiting and resource consumption: send a small number of requests, note the limit, and stop. Do not flood the API.
- Test authentication: missing, weak, or predictable tokens, JWT algorithm confusion, `none` algorithm, weak secret, expired tokens still accepted, and tokens in URLs.
- Test JWT: decode the header and payload, check `alg`, `kid`, `jku`, and expiry, and test whether changing the payload without a valid signature is accepted. Do not brute force a production secret at scale.
- Test GraphQL: introspection, field suggestions, batching, depth and complexity limits, and authorization on every field and mutation. See `references/api-testing.md`.
- Test WebSocket: authentication on connect, authorization on subscribe, and injection in messages.
- Test mass assignment, injection, and input validation the same way as web testing, with minimal impact.
- Test API versioning: old versions that lack new checks, and undocumented parameters.

### 5. Vulnerability testing — mobile web and app

See `references/mobile-cloud.md`.

- Only test an app the user owns or is authorized to test, on a device the user owns.
- Check certificate pinning, cleartext traffic, insecure storage, hardcoded secrets, deep links, exported components, and intent handling.
- Check biometric bypass, root detection bypass, and debug flags only on a test build or a device the user owns, and only when the program allows it.
- Test API endpoints the app calls, using the same API checklist above.
- Do not bypass app protections to access other users' data, and do not distribute a modified app.

### 6. Vulnerability testing — cloud and third-party

See `references/mobile-cloud.md`.

- Only test cloud assets listed in scope, or cloud assets the user owns.
- Check public storage buckets, public databases, exposed keys, and misconfigured CORS on storage.
- Check CI and build artefacts that are public, and secrets in public repositories that belong to the target.
- Do not access a cloud console, and do not change cloud configuration.

### 7. Proof of concept — minimal impact

- Prove the vulnerability with the smallest possible action.
- Use your own test accounts and your own test data only.
- Take screenshots, save the request and response, and record the exact steps, the time, and the test account used.
- If a proof would affect other users, stop and describe the theoretical impact instead. Do not execute it.
- Never exfiltrate bulk data, never persist a backdoor, and never leave a test payload that other users can trigger.
- Clean up: delete test data you created, log out, and revoke test tokens when you finish.
- Keep an evidence log: every finding gets an ID, a target, a request, a response, a screenshot, and a timestamp. See `references/scoring-reporting.md`.

### 8. Chaining and impact

- Chain only when each step is in scope, minimal impact, and reproducible.
- Common chains: open redirect plus OAuth flaw, IDOR plus missing authorization, XSS plus CSRF, SSRF plus internal metadata, and JWT flaw plus admin access.
- State the chain clearly: step 1, step 2, and the final impact, with a proof for each step.
- Do not exaggerate impact. A reflected XSS is not account takeover unless you prove the chain to a session token, and only on your own test account.

## Scoring

See `references/scoring-reporting.md` for CVSS 3.1 and 4.0 guidance and the triage flow.

Score every confirmed finding with CVSS 3.1, and record CVSS 4.0 when the program uses it. Record the program's own severity if it differs.

| Severity | CVSS 3.1 | Example |
|---|---|---|
| Critical | 9.0 to 10.0 | Remote code execution, authentication bypass to admin, full account takeover |
| High | 7.0 to 8.9 | Stored XSS in a shared area, SQL injection with data access, IDOR to another user's private data |
| Medium | 4.0 to 6.9 | Reflected XSS, CSRF on a sensitive action, missing rate limiting with impact |
| Low | 0.1 to 3.9 | Missing security header with limited impact, verbose error, information disclosure with no sensitive data |
| Informational | 0.0 | Best practice suggestion, no direct impact |

A finding is not a finding until it is reproduced by hand, in scope, with a minimal proof of concept. Scanner output alone is not a finding.

**Medium floor (v3.0, user rule):** only findings that reach Medium or above are hunted, drafted, proofread, or reported. Judge the cap at triage: a lead whose realistic impact cannot reach Medium gets one line in the notes and the hunt moves on. Never spend PoC hours proving a Low. A disclosed family/merge risk is not a proven duplicate, but it must be stated honestly in the report with its basis and percentage.

### Calibrate severity to what the program actually pays

- Before hunting, study what the program has actually awarded: which areas, which severities, and how far the awards run below the published ceilings. A program that publishes Critical 50,000 but awards a few hundred per ticket is a different game from its reward table. Patched does not mean awarded, and awarded does not mean paid — nothing is paid before the program's payout event.
- Aim where awards actually land, not where the reward table looks biggest. An area with many filings and few awards is harvested; an area with awards and few filings is where the next award is.
- Calibrate severity claims to triage reality, not just CVSS math. A CVSS 7.5 that the triager will call Medium is a Medium report — state the CVSS honestly, then state the program-realistic tier and why. Never inflate a tier to match the ceiling.

Duplicate check: search the program's disclosed reports, the target's changelog, and your own notes before reporting. A known issue is not a new bounty. Check for the same root cause in a different endpoint: one root cause is one report, unless the program asks for separate reports. **Check closed/duplicate reports too, not only open ones — a closed duplicate still kills a finding.** Check the live board again right before filing: a corpus snapshot goes stale the moment another hunter files.

### After filing: play the triage

- Filing is not the end of the report — the triage conversation is part of the hunt. Answer triager questions fast, in the same session when possible, with evidence attached (PoC output, code sites, measurements). A slow or vague answer is how a valid report stalls.
- Add a follow-up comment when new information arrives: a fresh measurement, a live reproduction, or a correction to your own report. Correct your own mistakes openly — a triager trusts a reporter who corrects themselves.
- Dispute a duplicate ruling only through the program's own mediation or request-help path, never by DM or in a public channel. State the concrete difference (different trigger, different call-site, different victim) and point at the code. If the difference does not survive scrutiny, accept the ruling and retire the family — do not re-file the same finding unchanged.
- Track every verdict (accepted, duplicate, not-applicable, informational) and what it teaches about the triager's boundaries. A duplicate ruling on one report can still leave a residual — a different trigger or call-site in the same family — but check the ruling's reasoning before assuming the residual stands.
- A report that is valid but unanswered is normal: programs triage slowly. Do not pester the triager, do not re-file to get attention, and do not disclose the bug publicly to force a verdict.

## Report format

Use the program's template when it has one. Otherwise use this format. See `references/scoring-reporting.md` for a full example. Before filing, run the pre-submit rules audit (see "Read every applicable rule") — the report goes out clean or not at all.

```markdown
# [Severity] Title — Target

Program: <program name and URL>
Target: <domain / URL>
Date: <YYYY-MM-DD>
Tester: <test account only, no real name unless the user asks>

## Summary
One paragraph: what the vulnerability is, where it is, and what an attacker can do with it.

## Severity
CVSS 3.1: <score> (<vector>)
CVSS 4.0: <score> (<vector>, if the program uses it)
Program severity: <Critical / High / Medium / Low / Informational>

## Steps to Reproduce
1. Log in as test user A.
2. Go to <URL>.
3. Send <request / action>.
4. Observe <result>.

## Proof of Concept
Request:
```
<HTTP request, with secrets redacted>
```

Response:
```
<relevant response, with other users' data redacted>
```

Screenshot: <file name>

## Impact
What an attacker can do, with the smallest realistic impact. Do not exaggerate.

## Remediation
Concrete fix: what code, configuration, or check to change, and where.

## References
- <OWASP link>
- <CWE link>
```

Rules: redact secrets, tokens, passwords, and other users' data. Keep the report factual and reproducible. Do not include bulk data, and do not include a payload that harms other users.

## Before closing

- [ ] Scope read and recorded, out-of-scope assets marked do-not-touch.
- [ ] Live board enumerated fresh before hunting (open + closed + newest filings); dup-check done early, before deep PoC.
- [ ] Target map complete, every in-scope asset checked or marked as checked.
- [ ] No hunt time spent on sub-Medium leads (one line in the notes each, then move on).
- [ ] Test accounts are yours, and no real user's data was accessed.
- [ ] Every finding reproduced by hand, with a minimal proof of concept.
- [ ] PoC drives the real production path (no stubs/mocks on the mechanism under test); verifier re-ran it independently.
- [ ] CVSS scored, duplicate checked (all corpora + live board re-checked right before filing), and impact stated honestly, with merge risk and score sensitivities disclosed.
- [ ] Pre-submit rules audit done: every field, severity, and claim checked against the program's CURRENT rules (scope, tiers, duplicate policy, disclosure policy, form requirements) — re-read at filing time, not from memory.
- [ ] Report redacted, reproducible, and submitted through the program's channel.
- [ ] Test data cleaned up, test tokens revoked, and no payload left behind.
- [ ] No unauthorized access, no data exfiltration, and no availability impact.
- [ ] Evidence log saved, with IDs, requests, responses, and screenshots.
- [ ] No finished work redone: no re-sweep without a new angle, no identical PoC re-run on an identical codebase.
- [ ] Banked findings recorded with kill reason + re-test trigger; composition matrix checked for the round.
- [ ] Fix watch running on parent reports (PR/fix status tracked, not just verdicts); residuals re-tested only against fixed code.
- [ ] Verdicts tracked; triager questions answered with evidence; duplicate disputes only via the program's mediation path.
- [ ] Severity calibrated to the program's actual award history, not just CVSS math.
- [ ] Per-lead time budgets respected; parked leads recorded with reason + budget spent.

## References

- OWASP Top 10 — https://owasp.org/www-project-top-ten/
- OWASP API Security Top 10 — https://owasp.org/www-project-api-security/
- OWASP Testing Guide — https://owasp.org/www-project-web-security-testing-guide/
- OWASP Mobile Top 10 — https://owasp.org/www-project-mobile-top-10/
- CWE — https://cwe.mitre.org/
- CVSS 3.1 — https://www.first.org/cvss/v3.1/specification-document
- CVSS 4.0 — https://www.first.org/cvss/v4.0/specification-document
- HackerOne — https://www.hackerone.com/
- Bugcrowd — https://www.bugcrowd.com/
- PortSwigger Web Security Academy — https://portswigger.net/web-security
- SecLists — https://github.com/danielmiessler/SecLists
