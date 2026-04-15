# Repo Map

## Last Updated
2026-04-14

## EAs Index
| Folder | Strategy Summary | Status | Files |
|--------|-----------------|--------|-------|
| SwingTagEA | 3-bar swing pivot fade — SELL LIMIT at mid-bar high when both extremes peak above oldest bar; BUY LIMIT at mid-bar low when both extremes trough below. DAX-focused, 13:00–16:00 session, fixed lots, symmetric SL/TP. | Active | Config.mqh, Market.mqh, Signal.mqh, Risk.mqh, Trade.mqh, Utils.mqh, SwingTagEA.mq5 |
| DeltaFadeEA | Contrarian scalper — fades cumulative tick/volume delta extremes using dynamic Median+MAD thresholds over rolling analysis windows, confirmed by volume-weighted price line slope. Day/hour time filter, trailing stop. | Active | Config.mqh, Market.mqh, Signal.mqh, Risk.mqh, Trade.mqh, Utils.mqh, DeltaFadeEA.mq5 |

| CumulativeDeltaScalper | Tick-level cumulative delta scalper — sliding window of N candle deltas (uptick−downtick), enters on threshold crossover, 15M EMA trend filter, ATR-based SL/TP, breakeven, session/spread/daily guards. EURUSD M1/M3/M5. | Active | Config.mqh, Market.mqh, Signal.mqh, Risk.mqh, Trade.mqh, Utils.mqh, CumulativeDeltaScalper.mq5 |
| FootprintChartPro | Professional order flow visualization — canvas-based delta cells footprint with 11 analysis panels (DOM, Volume Profile, Time & Sales, Signal Meter, Chart Analyst, RSI, MACD, S&D Zones, Calendar, Mini Session Chart). 16 themes, volume inference engine, 3-tier imbalance detection. Visualization only, no trading. | Active | Config.mqh, Market.mqh, Signal.mqh, Render.mqh, Panels.mqh, FootprintChartPro.mq5 |

## Notes
- Each EA lives in its own folder with a src/ and .memory/ subfolder
- Every source file has a corresponding .mem.md in .memory/
- Original file: "DaxAlgo - StratTagger.mq5" → renamed and moved to SwingTagEA/src/SwingTagEA.mq5
- Original file: "SlidingWindow.mq5" (UTF-16, 2160 lines) → decoupled and renamed to DeltaFadeEA/src/DeltaFadeEA.mq5
