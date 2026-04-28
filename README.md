# MT5 EA & Indicators

A personal collection of MetaTrader 5 Expert Advisors and indicators built and maintained by **Dhruv Sharma**.

## Projects

| Name | Type | Instrument | Strategy | Status |
|------|------|-----------|----------|--------|
| [SwingTagEA](./SwingTagEA) | EA | DAX / GER40 | 3-bar swing pivot fade — limit orders at swing highs/lows | Active |
| [DeltaFadeEA](./DeltaFadeEA) | EA | DAX / GER40 | Contrarian scalper — fades cumulative tick/volume delta extremes using dynamic Median+MAD thresholds, confirmed by volume-weighted price line slope. Trailing stop | Active |
| [CumulativeDeltaScalper](./CumulativeDeltaScalper) | EA | EURUSD M1/M3/M5 | Tick-level cumulative delta scalper — sliding window of N candle deltas, enters on threshold crossover, 15M EMA trend filter, ATR-based SL/TP, breakeven, session/spread/daily guards | Active |
| [FootprintChartPro](./FootprintChartPro) | Indicator | Any | Professional order flow visualization — canvas-based delta cells footprint with 11 analysis panels (DOM, Volume Profile, Time & Sales, Signal Meter, etc.), 16 themes, volume inference engine, 3-tier imbalance detection. Visualization only | Active |
| [ApexScalper](./ApexScalper) | EA | Liquid FX / index futures (EURUSD, NQ, ES) | Microstructure scalper — weighted composite of 8 order flow signals (Cumulative Delta, VPIN, shallow/deep OBI, footprint stacked imbalance, absorption, HVP regression, tape speed). Regime-adaptive weights (ADX + BB width + VPOC stability), conflict filter on top-weighted signals, SL/TP anchored to HVP nodes. Live dashboard, full CSV logging | Active |

## Repository Structure

Each project lives in its own folder:

```
<ProjectName>/
├── CLAUDE.md          # AI assistant instructions for this project
├── README.md          # Strategy docs, inputs reference, version history
├── .memory/           # Memory files for AI context continuity
└── src/               # Source files (.mq5, .mqh)
```

## Author

**Dhruv Sharma**
[linkedin.com/in/dhruvsharmainfo](https://www.linkedin.com/in/dhruvsharmainfo)
