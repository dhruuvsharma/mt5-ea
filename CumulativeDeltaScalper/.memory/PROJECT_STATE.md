# Project State — CumulativeDeltaScalper

## Current Status
- **Phase**: UI enhancement v5 — proper footprint cells
- **Date**: 2026-04-14
- **Version**: 1.5

## What Changed
- 2026-04-11 — Full EA built from spec. All 7 files created following decoupled architecture.
- 2026-04-13 — Added sliding window rect, per-candle delta labels below bars, ShowUI toggle.
- 2026-04-14 — Implemented proper footprint: stacked colored rectangle cells above each candle, each cell = one price level showing delta (uptick−downtick) from CopyTicksRange bucketing. Color: dark gold (positive), dark red (negative), purple (POC = highest volume level). Text: +N white / -N red. Live candle (bar 0) updates every tick. Configurable via FootprintBlockPips input.

## Open Items
- [ ] Compile test on MT5 build 4000+
- [ ] Backtest on EURUSD M1/M5 (footprint needs "Every tick based on real ticks" mode)
- [ ] Tune DeltaThreshold and WindowSize for live tick data
