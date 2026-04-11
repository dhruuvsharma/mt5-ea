# Memory: Config.mqh

## Purpose
All input parameters, constants, and global state variables for CumulativeDeltaScalper.

## Exports (public inputs / globals)
- Input groups: Delta Settings, Trade Settings, Filters, Risk Management, EA Identity
- Constants: EA_NAME, EA_PREFIX, DASHBOARD_*, BE_BUFFER_PIPS
- Globals: g_atrHandle, g_emaHandle, g_prevBid, g_uptickCount, g_downtickCount, g_deltaBuffer[], g_bufferIndex, g_bufferFilled, g_lastBarTime, g_prevCumDelta, g_liveDelta, g_dailyTradeCount, g_dailyPnL, g_dayStartBalance, g_lastTradeDay, g_lastLossTime, g_breakevenApplied, g_dashLabels[]

## Dependencies
- Imports from: none
- Imported by: Market.mqh

## Last Modified
- Date: 2026-04-11
- Change: Initial creation with full spec inputs and globals
