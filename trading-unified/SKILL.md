# trading-unified — One Disciplined Trading Co-pilot

Version: 1.0.0 · Date: 22 Nov 2026 · Status: deployed to Hermes VPS
(`~/.hermes/skills/trading-unified/`, gateway restarted 22 Nov 18:02 WIB) +
backed up to github.com/Rebelion77/skills (public, commit 8d6079c1).
Approved Clocked rule A-TREND5 recorded in `templates/rule-spec-a-trend5.md`.
Owners: Kacung (local Muse) + Hermes (VPS agent). License of this file: original synthesis;
underlying ideas are attributed per-repo below (all source repos MIT/Apache-2.0).

## 1. What this skill is

One trading skill that merges the best ideas from five repos into a single
discipline, usable in **paper/testnet mode (default)** and **mainnet mode
(real money, heavily gated)**. It covers the whole loop — regime, scan,
analysis, range/odds, plan, risk gate, human execution, journal, review —
for US stocks and options ranges (Clocked), general US equities, crypto spot,
IDX stocks, and forex/commodities.

**What it is NOT:** it is not a bot. It never places an order by itself, never
touches an exchange API, and never automates any platform. Every order is
prepared by the agent and executed by the human, one explicit confirmation
at a time.

**How it was built:** concepts only, synthesized from prior read-only studies
(`trading-skills-study-2026-11-22.md`, `trading-skills-compare-2026-11-22.md`,
`clocked-backtest-2026-11-22.md`). **No code was copied, imported, run, or
installed from any source repo into this skill** — this folder contains only
original playbook text (Markdown). Where an underlying implementation exists,
it is referenced by path/URL so it can be installed later under a separate
approval; nothing here depends on it.

## 2. Lineage — what came from each repo (ideas only)

| Repo | What was taken | What was NOT taken |
|---|---|---|
| reddygopalkrishna/trading-skills (21 skills, MIT, stdlib-only) | The backbone: chart bias score, FNO implied move, Monte Carlo odds, market regime, plan/size/backtest/journal, paper-by-default posture, stdlib `tradekit` indicator set | Live broker orders, bar-by-bar entry timer, auto-alert triggers |
| freqtrade/freqtrade (Apache-2.0) | Strategy-framework thinking (`populate_indicators` → entry/exit conditions), entry = indicator condition + guards, exit ladders (ROI/stoploss/trailing), backtest hygiene (no look-ahead, costs on, bias checks), risk stack (stoploss, max open trades, drawdown guards, cooldowns) | The entire exchange execution engine, ccxt connectivity, Telegram control, FreqAI/ML, Hyperopt (ideas referenced, not shipped) |
| hh-git/tradingagents-skill (MIT; upstream Apache-2.0) | Multi-agent reasoning pattern: bull researcher vs bear researcher debate, then a risk panel (conservative / neutral / aggressive) before any decision | The vendored graph, langchain/langgraph stack, OKX-only launcher, backend + API-key requirement, dozens of LLM calls per analysis |
| jagres0039/hermes-market-skills (MIT) | Gated `recommend` verdict (BUY/SELL/HOLD/WAIT with entry zone, stop, 3-tier TP, RR), Smart Money Concepts overlay (BOS/CHoCH, order blocks, FVG, liquidity sweeps, premium/discount), deterministic walk-forward backtest with R-multiples, multi-market breadth | Telegram ingestion setup, paid/optional API keys, pandas-heavy engine (concepts kept, code not vendored) |
| 0xrikt/crypto-skills (MIT) | Multi-factor strategy-completion templates (never a single indicator), condition DSL for writing rules, advisor output principles (conclusion first, concrete numbers, invalidation levels, bias self-check), risk profiles | Crypto-only backtest engine (spot long-only), Node installer |

## 3. Modes and safety architecture (non-negotiable)

### 3.1 Paper/testnet is the DEFAULT
- Every new session starts in paper mode. No real money moves, no live orders.
- Paper uses virtual bankrolls only (e.g. Clocked Coins, a paper ledger in the journal).
- Switching modes never happens silently: the mode is stated at the top of every plan.

### 3.2 Mainnet mode — four gates, ALL required
1. **Explicit per-session opt-in**: the user says in plain words, in that session,
   that mainnet is on for a named market/venue and a named maximum amount.
   A past opt-in never carries over to a new session.
2. **Human approval for EVERY order**: each order is previewed (symbol, side,
   size, price, max loss, invalidation) and the user confirms that exact order
   before it is placed. No batch approvals, no standing "yes".
3. **Daily loss cap**: mainnet stops for the day at −2% of bankroll (paper: −3%).
   Hitting the cap = no new entries today, no exceptions, no "one more to win it back".
4. **Kill switch**: if a file named `KILL` exists in this skill's directory
   (local: `~/workspace/custom-skills/trading-unified/KILL`,
   VPS: `~/.hermes/skills/trading-unified/KILL`), no new entries are prepared
   or proposed at all. Anyone (user or agent) can create it; only the user
   removes it.

### 3.3 Absolute bans (no override exists)
- **No automation against Clocked (getclocked.com), ever, in any mode.**
  Clocked's Terms ban bots/scripts/scrapers/automation; the account is played
  manually by the human, one account only. This skill's Clocked work is
  analysis + a written pick list only. No script, bot, or browser automation
  touches Clocked — not for entries, not for checks, not for claims.
- **No keys, seeds, or credentials inside this skill.** No private key, API
  key, seed phrase, session token, or password is ever written into this
  folder, its templates, or its journal. Credentials live only in the agent's
  approved secret store and are passed transiently when a tool needs them.
- **Money movement always needs the user's explicit confirmation each time.**
  Funding a wallet, approving a token spend, or placing a live order each
  needs its own fresh confirmation. A general "go ahead" never covers a
  specific movement.
- **No paid API keys required.** All data sources in this skill are free tier
  (Yahoo OHLCV, Google News, SEC filings, Cboe delayed option chains,
  CoinGecko/Binance public endpoints). If a paid key is ever proposed, it
  needs the user's separate approval first.

## 4. The pipeline — seven stages, each with an exit criterion

Every pick, paper or mainnet, walks the same seven stages. A stage that fails
stops the pick — it is skipped, not forced.

| # | Stage | Do | Exit criterion (else SKIP) |
|---|---|---|---|
| 1 | **Regime** | Market regime on the benchmark (SPY for US stocks; BTC dominance/Fear&Greed for crypto) → exposure 100/75/50/25/0% | Risk-off (0%) = no new entries today |
| 2 | **Scan** | Find setups: trend/momentum/squeeze/pattern presets, multi-factor only | At least one setup with a written rule (see §6.5 condition DSL) |
| 3 | **Analyze** | Bias score + SMC overlay + bull/bear debate + risk panel (see §6) | Direction needs ≥3 independent confirmations; bias alone is never enough |
| 4 | **Range / odds** | Implied move (options) or ATR proxy → candidate range/band; Monte Carlo P(target before stop) | P ≥ 55–60% AND positive expected R; else SKIP |
| 5 | **Plan** | Entry, stop/invalidation, targets (R-multiples or next level), size, R:R | Written plan with invalidation price/condition; no plan = no trade |
| 6 | **Risk gate** | 12 checks: mode, kill switch, daily loss cap, max concurrent, per-trade risk, fair-value markup, earnings/news, duplicate exposure, bankroll, approval state | ALL checks pass; any fail = no entry |
| 7 | **Execute + journal** | Human places the order (manual click / broker confirm); log the fill immediately | Every fill logged the same day with R-multiple; unlogged = undisciplined |

## 5. HARD RULES — baked in from the Clocked backtest (22 Nov 2026)

These are rules, not footnotes. They come from a real backtest
(`clocked-backtest-2026-11-22.md`, Yahoo daily bars 2023–2026, universe
AAPL/NVDA/TSLA/MSFT/AMZN/META/GOOGL + SPY, IS Oct 2023–Dec 2024,
OOS Jan 2025–Nov 2026, 2,168 trades at k=2.0). Violating one is a skill
violation, not a style choice.

- **R1 — OOS validation gate.** A rule that fails out-of-sample is NEVER
  traded, no matter how good in-sample looks. In-sample +64.1% at 1% risk
  became OOS −5.4% (profit factor 0.99). In-sample beauty is not evidence.
  Every rule ships with its IS/OOS record (`templates/rule-spec.md`).
- **R2 — No single-factor entries; 1-day bias is a coin flip.** The 1-day
  bias signal predicted next-day direction at **49.9% over 4,503 signals** —
  statistically identical to a random-direction benchmark. Trend/momentum
  indicators are built for multi-day moves; a 1-day horizon is noise.
  Therefore: every daily-close bet needs **≥3 independent confirmations**
  (e.g. bias + SMC structure + debate verdict + regime agreement) and/or a
  longer-horizon signal (3–5 day holding view, re-entered daily). A lone
  bias score ≥ +25 / ≤ −25 is a **watchlist note, not an entry**.
- **R3 — Fair-value price check before ANY entry.** Compare the price you
  would pay against fair value (Black-Scholes/model value). **Reject the
  entry if markup > +2%.** Backtest: a +5% premium markup turned OOS −5.4%
  into **−45%**; +10% → **−66.4%**. Markup kills expectancy faster than any
  bad signal. If fair value cannot be computed, the entry is skipped — an
  unpriced entry is a refused entry.
- **R4 — Sizing defaults.** **0.5% risk per entry** until a rule proves
  itself out-of-sample. **1% is the absolute max**, never the default.
  Max **3–5 concurrent entries** per day. **20-trade re-evaluation stop**:
  after 20 live/paper trades under a rule, stop and re-evaluate against the
  journal before continuing. Daily loss cap: paper −3%, mainnet −2%.
- **R5 — Earnings/news filter.** Skip the symbol on earnings day and on
  major MOVING news. IV collapses after earnings; earnings days are the
  biggest variance events. (The backtest could not implement this filter —
  Yahoo earnings dates were blocked — so live variance is higher than
  backtested. The filter is mandatory live.)
- **R6 — Narrow ranges need the odds bar.** With a 55–60% odds bar, only
  wide ranges (±1 ATR, k=2.0) qualified in backtest; k=1.0/1.5 produced
  ZERO trades. Do not lower the odds bar to force narrow-range trades —
  narrow ranges pay more per Coin precisely because they usually miss.
- **R7 — Never raise risk to "make it back".** No martingale, no doubling
  after losses, no raising the per-trade % after a drawdown. A drawdown is
  answered by smaller size or no trading, never bigger size.
- **R8 — Never tune thresholds until OOS looks good.** That just moves the
  overfit into OOS. Threshold changes need a fresh IS/OOS split.
- **R9 — Journal everything, review weekly.** An unlogged trade did not
  happen for learning purposes. Weekly review grades setups and hunts leaks
  (cutting winners, holding losers, ignored stops).
- **R10 — When in doubt, size 0.5% or skip.** A skipped trade costs
  nothing; a forced trade costs bankroll and discipline.

## 6. Analysis kit

All analysis is stdlib-only thinking: plain arithmetic on OHLCV bars, no
heavy dependencies. If an implementation is wanted later, the referenced
pieces live in the source repos (see §2); this skill does not vendor them.

### 6.1 Indicators (the menu)
SMA/EMA/WMA, RSI(14), MACD, ADX + DI, Supertrend, Bollinger Bands (+ width
percentile; ≤10th = squeeze), ATR + ATR%, ROC, OBV, VWAP, Keltner, Stoch,
CCI, MFI, true range, highest/lowest, slope, realized vol. Trend stage
(Weinstein 1–4). Daily vs weekly agreement required for direction.

### 6.2 Bias score (−100…+100)
Trend (SMA20/50/200, EMA21), ADX/DI, Supertrend, RSI, MACD, ROC, ATR,
Bollinger squeeze, relative volume, OBV, support/resistance, daily vs weekly
agreement. Thresholds: ≥ +60 strong bullish, +25 bullish, −25…+25 neutral,
≤ −25 bearish, ≤ −60 strong bearish. **Always quote the 3–5 reasons behind
the number, never the number alone.** And per R2: the bias score alone never
triggers an entry.

### 6.3 Smart Money Concepts overlay (second opinion on bias)
BOS (break of structure) / CHoCH (change of character), order blocks,
fair value gaps (FVG), liquidity sweeps, premium/discount zones. Use as a
vote alongside the bias score: SMC agreeing with bias = +1 confirmation;
SMC contradicting bias = the pick is demoted to watchlist. SMC never
overrides the OOS gate (R1) or the odds bar (R6).

### 6.4 Bull/bear debate + risk panel (reasoning pattern)
Before any pick, run a short written debate:
1. **Bull researcher**: the strongest case FOR the direction (3 points, with numbers).
2. **Bear researcher**: the strongest case AGAINST it (3 points, with numbers).
3. **Risk panel**: three voices — conservative (what kills this trade?),
   neutral (what is the base case?), aggressive (what is the upside if right?).
4. **Manager verdict**: direction, or SKIP, with the single decisive reason.
A debate where the bear case has no answer = SKIP. The debate is written
into the daily plan so it can be graded later.

### 6.5 Condition DSL — writing rules so they can be tested
Rules are written in a compact condition language (one rule per line):
```
rsi<35, price<bb_lower, volume>1.5*vol_sma20        # mean-reversion long
cross_above(ema21, ema50), adx>25, rsi>50          # trend long
bias>=25, smc=bullish, regime>=50, odds>=55        # Clocked daily pick
```
Operators: `< > <= >= ==`, `cross_above(a,b)`, `cross_below(a,b)`,
`rising(x,n)`, `falling(x,n)`, `consecutive(x,n)`, `turning_up(x)`,
`turning_down(x)`. Every rule also states its invalidation (what proves it
wrong) and its OOS record. A rule without an invalidation is not a rule.

### 6.6 Range selection — implied move (options) or ATR proxy
- **Preferred**: ATM straddle price from the option chain (Cboe delayed
  quotes, ~15 min delayed, no key) ≈ the market's expected daily move.
  Pick the range covering spot ± ~0.5–1.0× implied move in the bias
  direction; compare breakevens of candidate ranges against the implied move.
- **Fallback**: ATR(14) as the expected-move proxy (state openly that it is
  a proxy — historical ATM-straddle IV is not freely available in bulk).
- **Shifted ranges**: test ranges shifted in the bias direction and
  asymmetric widths; centered is the default, not the law.
- The implied move is the market's expectation — the edge is in direction +
  range selection, not in "beating" IV (IV is usually efficient).

### 6.7 Monte Carlo odds
10,000 block-bootstrapped paths from the symbol's own bars → P(setup hits
target before stop) and P(close lands inside the chosen range); equity-path
resampling → return/drawdown percentiles, losing streaks, risk of ruin.
Take only if P ≥ 55–60% AND expected R > 0.

### 6.8 Regime → exposure
Risk-on 100%, selective 75%, choppy 50%, correction 25%, risk-off 0%.
Exposure scales the per-trade risk (e.g. 0.5% × 50% = 0.25% in choppy
markets). Risk-off = no new entries, full stop.

### 6.9 Sizing (fixed-fractional)
`qty = floor(equity × risk% / (|entry − stop| × multiplier + fee))`,
capped by max-position% and cash. On Clocked, max loss = amount paid, so
sizing is direct: pay ≤ risk% × bankroll per entry (0.5% = 125 Coins on
25,000; 1% = 250 Coins). Kelly: quarter-Kelly at most, only after ~100
logged trades — start fixed-fractional. Ruin math: at 0.5% risk/trade a 20%
drawdown needs ~40 consecutive losses; at 1% it needs ~20; at 2% only ~10.
See `references/sizing-table.md`.

### 6.10 Backtest hygiene (mandatory for any rule change)
Next-bar-open execution, **no look-ahead**, commissions + slippage on,
ATR/%/rule stops, R or % targets, trailing stops, time exits, risk-based
sizing, max concurrent positions with ranking, benchmark comparison,
**in-sample vs out-of-sample split**, parameter-sensitivity check (if results
collapse when a parameter moves slightly, the edge is not robust),
walk-forward validation (roll the IS/OOS window forward). Lookahead and
recursive-analysis bias checks before any verdict. See R1, R8.

### 6.11 Patterns (with pivot + stop)
VCP, breakout on volume, bull flag, cup & handle, double bottom, inside
bar, NR7, pocket pivot. A pattern without a pivot and a stop is a story,
not a setup.

### 6.12 News / earnings / insiders (filters, not signals)
News: only what is new since last check, tagged/timed, MOVING flags.
Earnings: quarterly revenue/margins/EPS vs a year ago, TTM, one-off flags;
skip earnings day (R5). Insiders: Congress trades, SEC Form 4, block deals
— context only, never an entry trigger by themselves.

## 7. Daily routines

### 7.1 Clocked routine (evening WIB, before the US open) — PAPER, manual execution
Universe: AAPL, NVDA, TSLA, MSFT, AMZN, META, GOOGL + SPY regime.
1. **Regime** — SPY trend/volatility/breadth → exposure % (§6.8). Risk-off = stop.
2. **Bias per stock** — bias score daily + weekly (§6.2). Bull ≥ +25, Bear ≤ −25, else skip.
3. **SMC overlay** — structure vote per stock (§6.3). Contradiction = watchlist.
4. **Debate + risk panel** — written bull/bear + conservative/neutral/aggressive (§6.4).
5. **Range** — implied move from the Cboe chain (or ATR proxy, stated openly) → candidate range in the bias direction (§6.6).
6. **Odds** — Monte Carlo P(close in range) ≥ 55–60% AND expected R > 0 (§6.7). Else skip.
7. **Filters** — skip earnings day / major MOVING news (§6.12, R5).
8. **Fair-value check** — token price vs fair value; markup > +2% = reject (R3).
9. **Size** — 0.5% risk/entry default (R4); max 3–5 entries/day; log the plan
   (`templates/daily-plan-clocked.md`).
10. **Human clicks** — the user places each trade on getclocked.com by hand,
    following the written plan. The agent never touches Clocked.
11. **Journal** — log fills + outcomes the same day; 20-trade re-evaluation stop (R4).

### 7.2 General routine (US stocks / crypto spot / IDX / forex+commodities)
Same seven stages (§4). Differences: the range step becomes entry/stop/target
levels (ATR/structure/swing stops, R-multiple targets); the odds step is
P(target before stop); execution is via the broker preview + single-use human
confirm code (paper default; mainnet only under §3.2). Crypto is spot only
unless the user explicitly configures otherwise — no leverage, no futures by
default. Forex/commodities use the same bias + SMC + regime frame with their
own benchmarks.

### 7.3 Weekly review
Stats by setup/side/symbol/month; grade every closed trade (A/B/C/F with a
reason); hunt leaks — cutting winners early, holding losers past invalidation,
ignored stops, entries without 3 confirmations, trades taken in risk-off.
One concrete fix per week, written into the next week's plan. A rule that
loses for 20 trades gets redesigned or retired (R4/R1).

## 8. Journal and review
- Every plan, fill, and outcome is logged the same day
  (`templates/trade-journal-entry.md`): symbol, direction, range/levels,
  bias + reasons, SMC vote, debate verdict, implied move/ATR, odds, size,
  fair-value markup, outcome, R-multiple, grade, notes.
- The journal is the only source of truth for what works. No journal, no
  sizing increase, no new rules.
- Review weekly (§7.3). Rules graduate from 0.5% to 1% only after a positive
  OOS record AND 20+ logged trades under the rule.

## 9. Templates and references (in this folder)
- `templates/daily-plan-clocked.md` — the Clocked daily pick sheet.
- `templates/rule-spec.md` — rule specification + IS/OOS validation record.
- `templates/trade-journal-entry.md` — one journal entry per trade.
- `templates/mainnet-activation.md` — per-session mainnet activation checklist.
- `references/sizing-table.md` — fixed-fractional sizing, ruin math, loss caps.
- `references/debate-and-smc.md` — debate + risk-panel protocol, SMC checklist.

## 10. Data sources (free tier only)
Yahoo Finance OHLCV (no key), Google News, SEC filings / Form 4,
Cboe delayed US option chains (~15 min delayed, no key), CoinGecko,
Binance public REST, DeFiLlama, CryptoPanic, TwelveData free tier
(800 calls/day), ForexFactory calendar, Fear & Greed Index, BTC dominance,
DXY. If a source needs a key, it is optional and free-tier; the skill works
without it (reduced coverage, stated openly).

## 11. Dependencies
**None required.** This skill is pure playbook text; it runs on the agent's
judgment plus the data sources in §10. If an implementation is installed
later (under separate approval), the preferred core is the stdlib-only
`tradekit` style (no pandas/numpy needed for the indicator set); pandas /
numpy / yfinance are optional conveniences, never requirements. No torch,
no langchain, no Docker, no Node, no paid models.

## 12. Deliberately excluded (and why)
- **Automated execution against Clocked** — banned by Clocked's Terms; would
  get the account disqualified and the prize eligibility forfeited.
- **Exchange execution engines** (freqtrade/ccxt, broker live-order code) —
  wrong layer for this skill; execution is human-gated by design.
- **Telegram ingestion** (Telethon user sessions) — marginal sentiment value
  for real secret-handling cost; skipped.
- **Paid API keys / paid data** — the skill must work free; paid keys need
  separate user approval.
- **Heavy ML (FreqAI, torch, RL)** — unproven on this horizon, heavy on a
  2 GB VPS, and the backtest showed the edge is not in fancier signals but
  in validation, pricing, and sizing.
- **Bar-by-bar intraday entry timers** — Clocked settles on the daily close;
  intraday timing adds noise, not edge.
- **Auto-alert triggers** — alerts are reminders for the human, never triggers
  for an order.

## 13. How to use (quick start)
1. **Paper first**: run the §7.1 Clocked routine (or §7.2 general routine) for
   at least 20 trades at 0.5% risk, journaling everything.
2. **Validate**: every rule gets a `rule-spec.md` with its IS/OOS record. No
   OOS pass = no trade (R1).
3. **Size up only on evidence**: 0.5% → 1% only after a positive OOS record
   and 20+ logged trades.
4. **Mainnet**: only under §3.2 (per-session opt-in, per-order approval,
   −2% daily cap, kill switch armed). Paper rules R1–R10 apply unchanged.
5. **Deploy**: deployed 22 Nov 2026 to the Hermes VPS
   (`~/.hermes/skills/trading-unified/`, gateway restarted) and backed up to
   github.com/Rebelion77/skills (public). Underlying implementations installed
   separately: trading-skills core (`~/workspace/custom-skills/trading-skills/`)
   and hermes-market-skills engine (VPS `~/.hermes/skills/research/market/`).
