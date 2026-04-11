# Memory: CumulativeDeltaScalper.mq5

## Purpose
Main EA file — OnInit/OnDeinit/OnTick orchestration only. No raw logic.

## Exports
- OnInit() → int — validates inputs, calls MarketInit/TradeInit/InitDashboard
- OnDeinit(int reason) → void — calls MarketDeinit/RemoveDashboard
- OnTick() → void — orchestrates: reset daily → sync stats → process tick → candle detect → manage/signal → guards → filter → trade

## Dependencies
- Imports from: Utils.mqh (which chains all layers)
- Imported by: none (entry point)

## Last Modified
- Date: 2026-04-11
- Change: Initial creation — full EA build from spec
