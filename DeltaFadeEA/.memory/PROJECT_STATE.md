# Project State — DeltaFadeEA

## Status: Active

## Last Updated: 2026-04-06

## Recent Changes
- 2026-04-06 — v2.00: Strategy + backtest speed overhaul
  - Lowered default MAD multipliers 2.5 → 1.5 (more frequent signals)
  - Shrunk analysis windows 100 → 50 (more responsive)
  - Added RequireBothDeltas input (default: false = either delta triggers)
  - Added RequireSlopeConfirmation input (default: false = slope is bypassed)
  - Added RiskRewardRatio input (default: 2.0, used when TakeProfitPoints = 0)
  - TakeProfitPoints default changed to 0 (auto-calculated from SL * RR)
  - Tester mode detection: skips ALL visuals in non-visual backtest
  - Intra-bar processing skipped entirely in non-visual backtest
  - Version bumped to 2.00
- 2026-04-06 — v1.00: Initial decoupling from SlidingWindow.mq5 (2160 lines)
  - Replaced raw OrderSend with CTrade/CPositionInfo
  - Centralised magic number, weight constants, MAD params into Config.mqh
  - Removed unused DisplayThresholdValues() function
  - Added [DeltaFadeEA] prefix to all Print statements

## Known Issues / TODOs
- [ ] TrailingStep input defined but not used (only TrailingStart is used as fixed distance)
- [ ] Analysis window O(n*m) lookup in DrawThresholdWindows could be optimised with index mapping
- [ ] Consider adding max-positions-per-symbol limit
