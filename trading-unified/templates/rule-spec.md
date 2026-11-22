# Rule Specification + OOS Validation Record

Rule name: __________
Market / universe: __________
Author / date: __________
Status: DRAFT / TESTING / APPROVED / RETIRED (a rule is APPROVED only with a positive OOS record)

## Rule (condition DSL — one rule per line, see SKILL.md §6.5)
```
# entry conditions:
...
# exit / invalidation (what proves the rule wrong):
...
```

## Parameters
- Holding horizon: __________ (e.g. 1-day close / 3–5 day re-entry)
- Range/level method: __________ (implied move / ATR k=__ / structure)
- Odds bar: P ≥ ____%
- Risk per entry: ____% · Max concurrent: ____

## Validation record (fill BOTH halves — in-sample alone proves nothing)

| Split | Period | Trades | Win rate | Avg R | Profit factor | Return | Max DD |
|-------|--------|--------|----------|-------|---------------|--------|--------|
| In-sample |        |        |          |       |               |        |        |
| Out-of-sample |  |        |          |       |               |        |        |
| Walk-forward (if run) | |     |          |       |               |        |        |

- Random-direction benchmark (same ranges/sizing): avg R ______ vs rule avg R ______
- Markup sensitivity: OOS return at +0% / +5% / +10% markup: ______ / ______ / ______
- Parameter sensitivity: does the edge survive ±20% moves in each parameter? YES / NO (note: ______)
- Earnings/news filter applied? YES / NO (if NO, live variance will be higher than backtested)

## Verdict
- OOS verdict: PASS / FAIL — **FAIL means the rule is NEVER traded (R1), no matter the in-sample.**
- Approved sizing: 0.5% / 1% / DO NOT TRADE
- Live trades under this rule so far: ____ / 20 (re-evaluate at 20 — R4)
- Notes / redesign ideas: __________
