# Memory: Market.mqh

## Purpose
Indicator handle management, tick-level delta processing, candle detection, and market data queries.

## Exports (public functions)
- MarketInit() → bool — creates ATR/EMA handles, inits buffer
- MarketDeinit() → void — releases handles
- IsNewCandle() → bool — compares bar time
- ProcessTick() → void — updates uptick/downtick counters
- FinalizeCandle() → void — pushes delta to circular buffer, resets counters
- GetATR() → double — reads ATR(14) from handle
- GetHTFEma() → double — reads EMA(50) 15M from handle
- GetSpreadPoints() → int — current spread

## Dependencies
- Imports from: Config.mqh
- Imported by: Signal.mqh

## Last Modified
- Date: 2026-04-11
- Change: Initial creation
