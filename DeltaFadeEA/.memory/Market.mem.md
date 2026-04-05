# Memory: Market.mqh

## Purpose
Price data collection, delta calculations, volume footprint, ticks-per-second, analysis windows, and statistical functions (median, MAD).

## Exports (public functions / arrays)
- MarketInit() — allocate and zero all arrays
- InitializeAnalysisWindows() — seed from historical bars
- CandleDelta(MqlRates&) → double — signed tick_volume
- CalculateDeltas() — full window recalculation
- UpdateCurrentCandleDelta() — real-time current candle
- CalculateVolumeFootprint() / UpdateCurrentVolumeFootprint()
- CalculateTicksPerSecond() / UpdateCurrentTicksPerSecond()
- UpdateTickAnalysisWindow(double) / UpdateVolumeAnalysisWindow(double)
- GetVolumeLineSlope() → int (+1/-1/0)
- CalculateMedian(double&[], int) → double
- CalculateMAD(double&[], double, int) → double
- GetCurrentSpread() → double
- Arrays: volumeDelta[], tickDelta[], ticksPerSecond[], volumeWeightedPrices[], typicalPrices[]
- Globals: cumulativeVolumeDelta, cumulativeTickDelta, averageTicksPerSecond
- Analysis: tickAnalysisData/Times/Count, volumeAnalysisData/Times/Count

## Dependencies
- Imports from: Config.mqh
- Imported by: Signal.mqh, Utils.mqh, DeltaFadeEA.mq5

## Last Modified
- Date: 2026-04-06
- Change: Initial creation from SlidingWindow.mq5 decoupling
