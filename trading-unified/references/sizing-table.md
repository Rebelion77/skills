# Sizing Table — fixed-fractional, ruin math, loss caps

## Formula
`qty = floor(equity × risk% / (|entry − stop| × multiplier + fee))`,
capped by max-position% and cash. On Clocked, max loss = amount paid, so
sizing is direct: **pay ≤ risk% × bankroll per entry**.

## Default risk per entry
| Rule state | Risk / entry | On 25,000 Coins | On 100,000 (example mainnet) |
|---|---|---|---|
| Unproven / testing (default) | **0.5%** | 125 | 500 |
| Proven out-of-sample + 20 logged trades | **1.0% (max)** | 250 | 1,000 |
| Never | 2%+ | — | — (ruin math below is why) |

## Ruin math (consecutive losses to a −20% drawdown)
| Risk / trade | Losses to −20% |
|---|---|
| 0.5% | ~40 |
| 1.0% | ~20 |
| 2.0% | ~10 |

At ~100 planned trades (e.g. Clocked: ~50 sessions × ~2/day), 0.5–1% keeps
the bankroll alive through a bad streak; 2% risks a season-ending drawdown.

## Concurrency and daily caps
- Max **3–5 concurrent entries** per day.
- Daily risk ≤ 3–5% of bankroll (entries × risk%).
- **Daily loss cap: paper −3%, mainnet −2%.** Hit it = no new entries today.
- Regime scaling: risk × exposure% (risk-on 100% → full size; choppy 50% →
  half size; risk-off 0% → no trades).

## Kelly
Quarter-Kelly at most, and only after ~100 logged trades. Start
fixed-fractional. Never full Kelly.

## Breakeven check
If average payout ≈ 1.5× amount paid → required win rate ≈ 40%.
If average payout ≈ 1.2× → required win rate ≈ 45%.
Track the realized average payout in the journal and adjust the required
win rate — do not assume it.
