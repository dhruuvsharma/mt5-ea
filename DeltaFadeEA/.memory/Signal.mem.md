# Memory: Signal.mqh

## Purpose
Dynamic threshold calculation and contrarian signal generation.

## Exports
- dynamicTickBuyThreshold, dynamicTickSellThreshold — current tick thresholds
- dynamicVolumeBuyThreshold, dynamicVolumeSellThreshold — current volume thresholds
- signalLong, signalShort — current signal state
- ApplyThresholdBounds(raw, base, minMult, maxMult, isBuy) → double
- CalculateDynamicTickThresholds() — recalc from tick analysis window
- CalculateDynamicVolumeThresholds() — recalc from volume analysis window
- CheckTradingSignals() — evaluate contrarian signals

## Dependencies
- Imports from: Config.mqh, Market.mqh
- Imported by: Utils.mqh, DeltaFadeEA.mq5

## Key Decisions
- 2026-04-06 — Signal display moved to DeltaFadeEA.mq5 (EvaluateAndExecute) to keep Signal layer pure logic

## Last Modified
- Date: 2026-04-06
- Change: Initial creation from SlidingWindow.mq5 decoupling
