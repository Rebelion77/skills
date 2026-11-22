# Mobile and Cloud Testing

## Mobile

- Only test an app the user owns or is authorized to test, on a device the user owns.
- Static: decompile with jadx or apktool, search for hardcoded keys, API endpoints, and debug flags.
- Dynamic: proxy traffic with Burp or mitmproxy, check certificate pinning and cleartext traffic.
- Storage: check SharedPreferences, databases, and files for tokens and PII.
- Deep links and exported components: test whether they expose sensitive actions.
- Do not bypass protections to access other users' data, and do not distribute a modified app.

## Cloud

- Only test cloud assets listed in scope, or cloud assets the user owns.
- Storage: check public buckets, public databases, and CORS on storage.
- Secrets: check public repositories and build artefacts for keys that belong to the target.
- Do not access a cloud console, and do not change cloud configuration.
- Report the asset, the misconfiguration, and the smallest proof, without downloading bulk data.
