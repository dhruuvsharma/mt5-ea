# Memory: Utils.mqh

## Purpose
Daily statistics from deal history, dashboard rendering (OBJ_LABEL), and daily counter management.

## Exports (public functions)
- GetDailyStats(double &todayPnL, int &todayTrades) → void — scans deal history
- CheckLastTradeLoss() → void — updates g_lastLossTime cooldown
- ResetDailyCounters() → void — midnight reset with history sync
- InitDashboard() → void — creates 7 OBJ_LABEL objects
- UpdateDashboard(string status) → void — refreshes all labels each tick
- RemoveDashboard() → void — deletes label objects

## Dependencies
- Imports from: Trade.mqh (full chain)
- Imported by: CumulativeDeltaScalper.mq5

## Last Modified
- Date: 2026-04-11
- Change: Initial creation
