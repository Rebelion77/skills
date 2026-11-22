# Tools Setup

## Install — Linux

```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/ffuf/ffuf/v2@latest
```

## Install — wordlists and helpers

```bash
git clone https://github.com/danielmiessler/SecLists.git ~/SecLists
nuclei -update-templates
```

## Safe defaults

- Rate limit: 10 requests per second or lower on production.
- Timeout: 10 seconds.
- Stop on 429, 403, account lock, or WAF block.
- Log every command, its output file, and its date in the evidence log.
