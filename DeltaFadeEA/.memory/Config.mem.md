# Memory: Config.mqh

## Purpose
All input parameters, constants, and #defines for DeltaFadeEA.

## Exports (public inputs / defines)
- EA_NAME, EA_VERSION, EA_MAGIC — identity constants
- WindowSize, TextSize — sliding window config
- EnableTrading — master trading switch
- Tick/Volume dynamic threshold inputs (enable, window size, multipliers, bounds)
- ShowThresholdWindows, TickWindowColor, VolumeWindowColor, ThresholdWindowWidth
- Time filter: EnableTimeFilter, day bools, Hour00–Hour23
- Risk: RiskPercent, LotSize, StopLossPoints, TakeProfitPoints, MaxSpread, Slippage, TrailingStart, TrailingStep
- Volume footprint: ShowVolumeFootprintLine, UpTrendColor, DownTrendColor, LineWidth
- VWP_CLOSE_WEIGHT, VWP_TYPICAL_WEIGHT, VWP_OPEN_WEIGHT
- MIN_MAD_VALUE, MAD_SCALE_FACTOR, MIN_TRADE_DELAY

## Dependencies
- Imports from: (none)
- Imported by: Market.mqh, Signal.mqh, Risk.mqh, Trade.mqh, Utils.mqh, DeltaFadeEA.mq5

## Last Modified
- Date: 2026-04-06
- Change: Initial creation from SlidingWindow.mq5 decoupling
