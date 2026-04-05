# Memory: Trade.mqh

## Purpose
Order execution via CTrade, trailing stop management, position queries.

## Exports
- TradeInit() — set magic, slippage, fill type on CTrade
- IsTradeTime() → bool — minimum delay between trades
- EnterLong() / EnterShort() — market order with SL/TP
- ManagePositions() — loop all EA positions for trailing
- ApplyTrailingStop(ticket) — move SL toward profit, preserves TP
- HasLongPosition() / HasShortPosition() → bool

## Dependencies
- Imports from: Config.mqh, Risk.mqh, <Trade\Trade.mqh>, <Trade\PositionInfo.mqh>
- Imported by: DeltaFadeEA.mq5

## Key Decisions
- 2026-04-06 — Replaced raw MqlTradeRequest/OrderSend with CTrade class per repo standards
- 2026-04-06 — PositionModify now passes curTP to preserve take-profit (original code lost TP on SL modification)

## Last Modified
- Date: 2026-04-06
- Change: Initial creation from SlidingWindow.mq5 decoupling
