# Memory: Config.mqh

## Purpose
All input parameters, constants, and global state variables for CumulativeDeltaScalper.

## Exports (public inputs / globals)
- Input groups: Delta Settings, Trade Settings, Filters, Risk Management, Display, EA Identity
- Display inputs: ShowUI (bool), FootprintBlockPips (double, default 1.0 — price bucket size for footprint)
- Constants: EA_NAME, EA_PREFIX, DASHBOARD_*, BE_BUFFER_PIPS, SW_RECT_NAME, SW_DELTA_PREFIX, SW_LIVE_DELTA_NAME, SW_CUMDELTA_NAME, SW_FP_BG_PREFIX, SW_FP_TX_PREFIX, SW_FP_MAX_LEVELS, SW_TEXT_SIZE, SW_RECT_WIDTH, SW_RECT_STYLE
- Globals: g_atrHandle, g_emaHandle, g_prevBid, g_uptickCount, g_downtickCount, g_deltaBuffer[], g_bufferIndex, g_bufferFilled, g_lastBarTime, g_prevCumDelta, g_liveDelta, dailies, cooldown, breakeven, g_dashLabels[]

## Dependencies
- Imports from: none
- Imported by: Market.mqh

## Last Modified
- Date: 2026-04-14
- Change: Replaced SW_CELL_* with SW_FP_BG_PREFIX/SW_FP_TX_PREFIX/SW_FP_MAX_LEVELS. Added FootprintBlockPips input.
