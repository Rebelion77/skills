# Scoring and Reporting

## CVSS

- Use CVSS 3.1 by default. Use CVSS 4.0 when the program asks for it.
- Score attack vector, attack complexity, privileges required, user interaction, scope, confidentiality, integrity, and availability honestly.
- Do not inflate a score to get a higher bounty. Triage will downgrade it, and it harms credibility.
- Record the vector string with the score, for example CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H

## Duplicate check

- Search disclosed reports on HackerOne and Bugcrowd for the same target and class.
- Search the target changelog and your own notes.
- One root cause is one report, unless the program asks for separate reports per endpoint.

## Triage handling

- If marked duplicate, read the original report and check whether your proof adds a new impact.
- If marked not applicable, read the reason and check whether the proof was incomplete or the asset was out of scope.
- If marked informational, do not re-submit the same finding as a higher severity without new evidence.
- Only re-submit with new evidence, and say what is new.

## Evidence log format

```
ID: BB-001
Date: YYYY-MM-DD
Target: https://example.com/profile?id=123
Class: IDOR
Severity: High — CVSS 7.5
Request: <file or pasted request, redacted>
Response: <relevant response, redacted>
Screenshot: <file name>
Status: reported / triage / accepted / duplicate
```

## Full report example

See SKILL.md for the template. Keep every report to one vulnerability, one target, and one proof of concept. A report with three vulnerabilities in one is hard to triage and hard to pay.
