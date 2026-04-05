# Project State — DeltaFadeEA

## Status: Active

## Last Updated: 2026-04-06

## Recent Changes
- 2026-04-06 — v2.10: Input cleanup for XAUUSD 1M/3M/5M
  - Removed 50+ useless inputs: 24 hour bools, 7 day bools, all visual colour/size inputs, separate tick/volume window sizes and multipliers, TrailingStep, ShowThresholdWindows, ShowVolumeFootprintLine
  - Merged TickAnalysisWindowSize + VolumeAnalysisWindowSize → single AnalysisWindowSize (default 50)
  - Merged TickThresholdMultiplier + VolumeThresholdMultiplier → single ThresholdMultiplier (default 1.5)
  - Replaced 24 hour bools with StartHour/EndHour range (default 7–17)
  - Replaced 7 day bools with hardcoded Mon–Fri (weekends always blocked)
  - EA_MAGIC replaced with MagicNumber input
  - MaxSpread default 3 → 30 (for XAUUSD)
  - Slippage default 3 → 10 (for XAUUSD)
  - TakeProfitPoints default → 0 (uses RiskRewardRatio = 2.0)
  - All visual constants hardcoded as #defines
  - Signal.mqh: consolidated duplicate threshold logic into CalculateThresholdsFromData()
  - Config now has only 16 inputs (was 60+)

## Known Issues / TODOs
- [ ] Analysis window O(n*m) lookup in DrawThresholdWindows could be optimised with index mapping
- [ ] Consider adding max-positions-per-symbol limit
