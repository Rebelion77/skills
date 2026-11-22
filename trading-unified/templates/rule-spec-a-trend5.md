# Rule Specification + OOS Validation Record — A-TREND5 (APPROVED, conditional)

Rule name: **A-TREND5 — 5-day momentum trend continuation**
Market / universe: US stocks AAPL, NVDA, TSLA, MSFT, AMZN, META, GOOGL + SPY regime (Clocked daily spreads)
Author / date: Kacung (backtest v2), 22 Nov 2026
Status: **APPROVED (conditional — weak edge, see verdict notes)**

## Rule (condition DSL — one rule per line, see SKILL.md §6.5)
```
# entry conditions (signal at close of day t, outcome at close of day t+1):
ret5 > 0, close > sma50, rsi14 > 50        # Bull
ret5 < 0, close < sma50, rsi14 < 50        # Bear
# range: centered on close, width = 2.0 * ATR(14); odds P(close in range) >= 55%
# regime: SPY close > SMA50 and SMA200 -> exposure 100%; above one -> 50%; below both -> 0% (no trades)
# selection: max 3 trades/day, ranked by |ret5|
# exit / invalidation (what proves the rule wrong):
#   - signal reverses the next day (no re-entry on the same name that day)
#   - live avg R < 0 after 20 trades (R4 re-evaluation stop) -> rule is RETIRED, not re-tuned
```

## Parameters
- Holding horizon: 1-day close (signal is a 5-day trend view, re-entered daily)
- Range/level method: ATR k=2.0, centered
- Odds bar: P ≥ 55%
- Risk per entry: **0.5% ONLY** (1% rejected: OOS max DD 24.1% exceeds the 20% cap) · Max concurrent: 3/day

## Validation record (fill BOTH halves — in-sample alone proves nothing)

| Split | Period | Trades | Win rate | Avg R | Profit factor | Return @0.5% | Max DD @0.5% |
|-------|--------|--------|----------|-------|---------------|--------------|--------------|
| In-sample | Oct 2023–Dec 2024 | 864 | 50.0% | +0.0141 | 1.06 | +8.2% | 5.3% |
| Out-of-sample | Jan 2025–Nov 2026 | 1234 | 51.1% | +0.0137 | 1.06 | +6.1% | 12.8% |
| Walk-forward (if run) | — | — | — | — | — | — | — |

- Random-direction benchmark (same ranges/sizing): avg R **−0.0213 / −0.0002 / −0.0200** (3 seeds) vs rule avg R **+0.0137**. The direction adds something; random is negative on all seeds.
- Markup sensitivity: OOS return at +0% / +5% / +10% markup: **+6.1% / −18.8% / (not run — +5% already kills it)**. R3 is load-bearing: every live entry must be price-checked against fair value; markup > +2% = REJECT the entry.
- Parameter sensitivity: does the edge survive ±20% moves in each parameter? **NOT RUN** (single pre-committed parameter set; no OOS tuning was done, per R8). Open item: run a ±20% sensitivity check before sizing up.
- Earnings/news filter applied? **NO** (Yahoo earnings dates blocked, HTTP 401/403 — could not be backtested). Live variance will be higher than backtested; the live routine MUST skip earnings days manually (R5).
- Monte Carlo on OOS R-multiples (10,000 paths × 100 trades, 0.5% risk): median final equity 25,155 (vs 25,000 start), p5 23,988, P(DD>20%) = 0.0%, P(ruin) = 0.0%.
- Per-ticker OOS avg R: GOOGL +0.0612, META +0.0342, MSFT +0.0295, AAPL +0.0135, NVDA −0.0079, AMZN −0.0064, TSLA −0.0217. Edge is broad-based (4 of 7 positive), not one name.

## Verdict
- OOS verdict: **PASS (conditional)** — avg R +0.0137 > 0, PF 1.06 > 1, max DD 12.8% ≤ 20%, n=1234 ≥ 100. All pre-committed R1 criteria met at 0.5% risk, fair pricing.
- Approved sizing: **0.5%** / 1% REJECTED (max DD 24.1%) / DO NOT TRADE if markup > +2%
- Live trades under this rule so far: **0 / 20** (re-evaluate at 20 — R4)
- Notes / redesign ideas:
  - **WEAK EDGE — read this first.** Avg R +0.0137 over 1,234 trades is ~0.8 standard errors from zero (not significant at 95%). The supporting evidence is the IS→OOS consistency (+0.0141 → +0.0137, no cliff) and the random benchmark being negative on all seeds. Treat this as a small, real-but-fragile edge, not a money machine. The 20-trade live re-evaluation stop is mandatory, not optional.
  - **R2 correction (finding from v2):** the multi-factor confirmation candidate (B-MULTI: bias + breakout/FVG/ROC5) HURT direction (48.4% accuracy, OOS avg R −0.005) — stacking confirmations does not help on this horizon. The edge came from a SIMPLER longer-horizon signal, not from more confirmations. SKILL.md §5 R2 should be amended: confirmations must each be validated, never assumed.
  - Directional accuracy is only 50.3% — the edge is in the R-distribution (wins pay more than losses cost), not in calling direction. Do not expect to "be right" most days.
  - If Clocked's token pricing embeds a take above ~+2%, this rule loses money (OOS −18.8% at +5% markup). The daily routine must compute fair value for every entry and skip anything priced above it.

## Other candidates tested in the same run (backtest_v2.py, results_v2.json) — all FAILED, never trade

| Candidate | Idea | OOS avg R | OOS PF | OOS ret @0.5% | Verdict |
|-----------|------|-----------|--------|---------------|---------|
| V1-BASE | original composite bias | −0.0032 | 0.99 | −2.3% | FAIL — coin flip confirmed |
| B-MULTI | bias + breakout/FVG/ROC5 confirmations | −0.0050 | 0.98 | −2.0% | FAIL — confirmations hurt |
| C-SHIFT | range shifted in bias direction | — (0 trades) | — | — | FAIL — 55% odds bar mathematically unreachable for shifted ranges |
| D-VOLF | skip high own-vol days (ATR% > 80th pct) | −0.0087 | 0.96 | −3.9% | FAIL — best dir. accuracy (50.7%) but wins shrink more than losses |
| E-VIXF | skip when VIX > 25 | −0.0041 | 0.98 | −2.7% | FAIL |
| F-COMB | B + D + E combined | −0.0001 | 1.00 | −0.6% | FAIL — breakeven, safest loser (max DD 5.1%) |
| G-PERS | bias sign persistent ≥3 days | −0.0020 | 0.99 | −1.4% | FAIL |
| H-SUBSET | v1 bias on IS-top-3 (NVDA/META/MSFT) | +0.0027 | 1.01 | **−1.2%** | FAIL — avg R marginally positive but realized OOS return is NEGATIVE; statistical artifact, not an edge |

Code: `~/workspace/vps-telegram-bot/clocked-backtest/backtest_v2.py`, `results_v2.json`, `backtest_v2.log`.
Data: Yahoo daily OHLCV 2023-01-03 → 2026-11-20 (+ ^VIX). Payoff model: 1-day vertical spread at fair-value Black-Scholes (T=1/252, r=0, σ=ATR/close). No look-ahead; nothing tuned on OOS.
