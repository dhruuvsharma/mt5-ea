# Memory: Signal.mqh

## Purpose
Cumulative delta calculation from sliding window and crossover-based signal generation.

## Exports (public functions)
- CalculateCumDelta() → int — sums circular buffer
- CheckSignal() → int — returns 1 (BUY), -1 (SELL), 0 (none) using crossover logic
- PassesHTFFilter(int signal) → bool — checks price vs 15M EMA(50)

## Dependencies
- Imports from: Market.mqh
- Imported by: Risk.mqh

## Last Modified
- Date: 2026-04-11
- Change: Initial creation
