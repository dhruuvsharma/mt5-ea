# Memory: DeltaFadeEA.mq5

## Purpose
Core EA orchestration — OnInit, OnDeinit, OnTick, OnChartEvent. No raw logic, only function calls.

## Exports
- OnInit() → int
- OnDeinit(reason)
- OnTick()
- OnNewBar() — full recalc + signal check
- OnSameBar() — real-time update + optional signal check
- RedrawVisuals() — refresh all chart objects
- EvaluateAndExecute() — check signals, display, execute trades
- OnChartEvent(id, lparam, dparam, sparam)

## Dependencies
- Imports from: Config.mqh, Market.mqh, Signal.mqh, Risk.mqh, Trade.mqh, Utils.mqh
- Imported by: (none — this is the entry point)

## Last Modified
- Date: 2026-04-06
- Change: Initial creation from SlidingWindow.mq5 decoupling
