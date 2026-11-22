# Backtest Lab

Clean-room playbook for testing rule-based trading strategies against
historical data before anyone risks a rupiah on them. Analysis only: this
skill never places orders, never connects to an exchange account, and never
presents a backtest as a promise of future profit.

## 1. Data
- Sources: public OHLCV (CoinGecko, exchange public kline endpoints,
  DexScreener pair history where available). State the source, timeframe,
  and exact period for every run — a result without its data window is
  worthless.
- Sanity-check the series first: gaps, duplicate candles, timezone of
  candle closes, survivorship (a token that died mid-period must not
  silently vanish from the test).

## 2. Strategy spec (before touching data)
- Write the rules in plain language first: entry, exit, sizing, and the
  one invalidation condition. If the rule cannot be written down, it cannot
  be backtested.
- No look-ahead: signals use only candles closed at decision time; fills
  happen at the next candle's open (or a stated worse price), never at the
  signal candle's close.

## 3. Mandatory costs (no exceptions)
- Exchange/DEX fee per side, stated explicitly.
- Slippage assumption per trade, scaled to the pair's actual liquidity —
  dust-liquidity pairs get punitive slippage or are excluded.
- Swap/gas costs for on-chain strategies, in IDR, using the user's fee-cap
  mindset: a strategy that only works at zero gas does not work.

## 4. Metrics & verdict
Report, every time: total return, max drawdown, win rate, trade count,
average win vs average loss, and the longest losing streak. Then compare
against the dumb benchmark: buy-and-hold the same asset over the same
window. A strategy that cannot beat holding, net of costs, has no edge.
- Split the window: tune on the first part, judge on the untouched second
  part (out-of-sample). If performance collapses out-of-sample, the verdict
  is OVERFIT, stated bluntly.
- Parameter sensitivity: nudge each parameter ±20%. A real edge survives
  small nudges; a curve-fit cliff does not.

## Rules
- Verdicts are one of: EDGE (beats benchmark net of costs, survives
  out-of-sample + sensitivity), NO EDGE, or OVERFIT. No fourth "promising"
  category to soften a failure.
- Past performance language is banned: report what the rules WOULD have
  done, never what they WILL do.
- Live trading is a separate decision under the user's explicit order and,
  on-chain, the on-chain safety rails — this skill ends at the report.
