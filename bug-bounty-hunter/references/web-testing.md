# Web Testing — Full Checklist

## XSS

- Reflected: test every parameter, header, and search box with a harmless marker.
- Stored: test profile, comment, and name fields with your own test account only.
- DOM: check JavaScript sinks such as innerHTML, document.write, and eval.
- Blind: use a collaborator URL you control, never a third-party payload that exfiltrates data.

## SQL injection

- Test with a single quote, boolean true and false, and a time delay.
- Never use DROP, DELETE, UPDATE, or bulk extraction.
- One row from your own test account is enough proof.

## Access control

- Create test user A and test user B.
- Try every object ID from A as B, for read, write, and delete.
- Try admin endpoints as a normal user.
- Try role parameters such as role, is_admin, and user_type.

## Authentication

- Password reset: check token expiry, token leakage in the URL, and whether the token works for another user.
- OTP: check rate limiting, expiry, and whether an old code still works.
- Session: check logout, password change, and whether a session survives both.
- MFA: check whether sensitive actions skip MFA, and whether the MFA code can be reused.

## SSRF and XXE

- SSRF: test URL parameters, image fetchers, PDF generators, and webhooks with a collaborator URL you control.
- XXE: test XML uploads and API inputs with a harmless out-of-band check first.
- Do not exfiltrate internal data, and do not read local files beyond proof of parsing.

## Business logic and race conditions

- Price, quantity, coupon, and discount: test negative, zero, and very large values on a test purchase with no real payment.
- Workflow: skip steps, repeat steps, and change the order of a multi-step flow.
- Race: send a small number of parallel requests for a test action, stop if the target slows down.

## File upload

- Upload a harmless .txt file first.
- Test extension, content-type, and filename checks.
- Never upload a shell to a production server.
