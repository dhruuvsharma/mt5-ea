# Memory: Trade.mqh

## Purpose
Order placement via CTrade, position detection, and breakeven management.

## Exports (public functions / objects)
- g_trade (CTrade), g_posInfo (CPositionInfo) — global trade objects
- TradeInit() → void — sets magic, slippage, fill type
- HasOpenPosition() → bool — checks for matching symbol+magic
- OpenTrade(int direction) → bool — opens BUY/SELL with ATR SL/TP
- ManageOpenTrade() → void — breakeven logic at BreakevenPips threshold

## Dependencies
- Imports from: Risk.mqh, <Trade/Trade.mqh>, <Trade/PositionInfo.mqh>
- Imported by: Utils.mqh

## Last Modified
- Date: 2026-04-11
- Change: Initial creation
