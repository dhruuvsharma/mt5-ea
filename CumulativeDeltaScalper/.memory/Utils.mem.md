# Memory: Utils.mqh

## Purpose
Daily statistics, dashboard (OBJ_LABEL), sliding window rect, per-candle delta labels below bars, footprint cells above bars (stacked colored rectangles with delta text per price level), daily counter management.

## Exports (public functions)
- GetDailyStats / CheckLastTradeLoss / ResetDailyCounters — daily tracking
- CreateLabel / InitDashboard / UpdateDashboard — dashboard panel (guarded by ShowUI)
- RemoveWindowObjects / RemoveDashboard — cleanup
- DrawSlidingWindow() — OBJ_RECTANGLE around N candles
- DisplayCandleDeltas() — OBJ_TEXT per candle with delta below bars
- GetCellBgColor(delta, isPOC) → color — dark gold (positive), dark red (negative), purple (POC)
- GetCellTxColor(delta) → color — white (positive), red (negative), gray (zero)
- BuildBarFootprint(barIndex, barTime, barHigh, periodSec, cellHeight, basePrice) — CopyTicksRange, buckets ticks by price level, draws stacked OBJ_RECTANGLE bg + OBJ_TEXT per level above candle
- DisplayFootprint() — iterates window bars calling BuildBarFootprint

## Dependencies
- Imports from: Trade.mqh, Signal.mqh (CalculateCumDelta), Market.mqh (GetOrderedDeltas, GetATR, GetSpreadPoints)
- Imported by: CumulativeDeltaScalper.mq5

## Last Modified
- Date: 2026-04-14
- Change: Replaced simple delta cells with proper footprint: stacked colored rectangle cells above each candle, each showing per-price-level delta from CopyTicksRange tick bucketing. POC level highlighted in purple.
