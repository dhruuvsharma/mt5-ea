# Memory: Risk.mqh

## Purpose
Guard checks (session, spread, daily limits, cooldown, ATR volatility) and SL/TP distance calculation.

## Exports (public functions)
- CalcSLDistance() → double — ATR × SL_Multiplier
- CalcTPDistance() → double — ATR × TP_Multiplier
- CheckGuards(string &reason) → bool — all 6 guards, outputs status reason
- IsInSession() → bool — London 08-12 / NY 13-17 GMT

## Dependencies
- Imports from: Signal.mqh (→ Market.mqh → Config.mqh)
- Imported by: Trade.mqh

## Last Modified
- Date: 2026-04-11
- Change: Initial creation
