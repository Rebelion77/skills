# Recon — Full Checklist

## Passive

- Certificate Transparency: search crt.sh for the domain, record every subdomain and certificate date.
- DNS: A, AAAA, CNAME, MX, TXT, NS, and SOA. Record CNAME targets for takeover checks.
- Subdomains: run subfinder and amass, merge, deduplicate, then httpx to find live hosts.
- Wayback and URL collection: gau, waybackurls, katana, and paramspider. Save all URLs, parameters, and JavaScript files.
- GitHub and public code: search the organization name, domain, and API keys in public repositories. A secret in a public repo is a lead, verify it only against an in-scope service.
- Shodan and Censys: record open ports and services only for in-scope hosts.
- JavaScript: download JS files, search for api, endpoint, graphql, token, key, admin, and internal hostnames. Record every endpoint found.

## Active

- httpx with status, title, tech detection, and content length for every live host.
- nuclei with a low rate, templates for the detected stack only.
- ffuf for directories and files, small wordlist first, low rate.
- arjun for hidden API parameters.
- Check robots.txt, sitemap.xml, .well-known, and security.txt.

## Takeover check

- CNAME to a dead service, expired bucket, or unclaimed SaaS is a lead.
- Verify with a harmless DNS lookup or HTTP request only.
- Do not claim the service, do not create an account on it to prove takeover, and do not point it at a phishing page.

## Commands

```bash
subfinder -d example.com -o subdomains.txt
amass enum -d example.com -o amass.txt
cat subdomains.txt amass.txt | sort -u > all.txt
httpx -l all.txt -o live.txt -status-code -title -tech-detect
katana -u https://example.com -o urls.txt
gau example.com >> urls.txt
nuclei -l live.txt -rl 10 -o nuclei.txt
```
