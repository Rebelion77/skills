# BSC audit skills

Two complementary agent skills for due diligence on **BNB Smart Chain** (chain id 56). They share one
discipline — evidence over claims, on-chain state over the homepage, a block-pinned finding log — and one
machine-readable **`DECISION: GO | CAUTION | BLOCK`** output that can gate an agent wallet before it acts.

| Skill | Audits | Tracks / scope |
|-------|--------|----------------|
| [`bsc-contract-audit`](skills/bsc-contract-audit) | the **asset & escrow** (buyer-side) | TOKEN (BEP-20) · NFT MINT (BEP-721/1155) · LOCK (deposit-refund allocation escrow) |
| [`launch-curve-audit`](skills/launch-curve-audit) | the **sale mechanism** (pre-launch) | bonding curve / tranche IEO · admission & escrow · graduation & LP custody · coupled emissions |

Rough division of labour: `launch-curve-audit` reviews *how the token is sold*; `bsc-contract-audit`
reviews *what you end up holding* and *whether a lock returns your money*. A full review of a trending
launch usually runs both — the curve audit hands off to the contract audit at graduation.

> ⚠️ **Reference only, not investment advice.** On-chain state changes; a clean report is not a guarantee.
> Independent community skills — **not affiliated with or endorsed by Binance or Anthropic.**

## Install

Replace `setyamickala/bsc-contract-audit-skill` with your repo if you fork or rename it.

```bash
# the asset & escrow auditor (token / NFT mint / lock-refund)
npx skills add setyamickala/bsc-contract-audit-skill/skills/bsc-contract-audit

# the sale / bonding-curve auditor (pre-launch)
npx skills add setyamickala/bsc-contract-audit-skill/skills/launch-curve-audit
```

Or drop a `skills/<name>/` folder into your agent's skills directory (e.g. `.claude/skills/`). On
claude.ai, use the packaged `.skill` files and click **Save skill**.

## Runtime

The scripts are dependency-free Python + `curl`/`jq`, read-only, and run wherever the agent has a shell
(Claude Code, Cowork). Set a BSC RPC: `export RPC_URL=https://bsc-rpc.publicnode.com`. Optional
`ETHERSCAN_KEY` for the Etherscan v2 source lookup.

**No paid APIs required — GoPlus is optional.** The low-cost stack is a premium RPC + a free
BscScan/Etherscan key + Sourcify + honeypot.is + the public Binance Web3 audit API. Holder concentration
comes from `rpc.py holders` (reconstructed from Transfer logs), and escrow pool integrity from `rpc.py nbal`.

## The decision contract

Both skills end a pre-trade audit with one line a wallet (e.g. `binance-agentic-wallet`) can gate on:

```
DECISION: GO | CAUTION | BLOCK — <one-line reason>
```

- **BLOCK** — refuse the buy/swap/mint/lock.
- **CAUTION** — proceed only after the user acknowledges the ranked risks.
- **GO** — may proceed (still not financial advice).

`bsc-contract-audit` maps it from its 0–100 score (<55 BLOCK · 55–84 CAUTION · ≥85 GO, tightest hard cap
wins). `launch-curve-audit` maps it from its verdict (BLOCK → BLOCK · HOLD → CAUTION · SHIP → GO). If a fast
check (`query-token-audit`) and a deep audit disagree, the stricter result wins. Each skill's SKILL.md
carries its own fail-fast flow diagram (token / NFT mint / lock escrow / launch curve).

## Repo layout

```
skills/
├── bsc-contract-audit/     SKILL.md · references/ (code-red-flags, data-sources, selectors, probes) · scripts/ (rpc.py, binance_audit.sh)
└── launch-curve-audit/     SKILL.md · references/ (economics, invariants, attack-surface) · scripts/ (rpc.py, curve_math.py, snapshot.sh)
```

## License

MIT — see [LICENSE](LICENSE).
