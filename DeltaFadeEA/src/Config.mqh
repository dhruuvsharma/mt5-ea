//+------------------------------------------------------------------+
//|                                                      Config.mqh |
//|                                        DeltaFadeEA — Dhruv Sharma |
//+------------------------------------------------------------------+
#ifndef CONFIG_MQH
#define CONFIG_MQH

//--- EA Identity
#define EA_NAME        "DeltaFadeEA"
#define EA_VERSION     "2.10"

//+------------------------------------------------------------------+
//| INPUTS — only what matters                                       |
//+------------------------------------------------------------------+

//--- Core
input int    MagicNumber  = 12345;  // Magic number
input bool   EnableTrading = true;  // Enable automated trading

//--- Sliding Window
input int    WindowSize          = 20;   // Candles in trading window
input int    AnalysisWindowSize  = 50;   // Candles in threshold analysis window

//--- Signal Tuning
input double ThresholdMultiplier       = 1.5;   // MAD multiplier for dynamic thresholds
input bool   RequireBothDeltas         = false;  // Require BOTH tick+vol (false = either)
input bool   RequireSlopeConfirmation  = false;  // Require VWP slope confirmation

//--- Risk Management
input double LotSize           = 0.01;  // Fixed lot size (0 = risk-based)
input double RiskPercent       = 2.0;   // Risk % per trade (when LotSize = 0)
input int    StopLossPoints    = 300;   // SL in points
input int    TakeProfitPoints  = 0;     // TP in points (0 = use RR ratio)
input double RiskRewardRatio   = 2.0;   // R:R ratio (used when TP = 0)
input int    MaxSpread         = 30;    // Max spread in points
input int    Slippage          = 10;    // Max slippage in points
input int    TrailingStart     = 200;   // Trailing stop distance in points

//--- Session Filter
input bool   EnableTimeFilter = true;  // Enable session time filter
input int    StartHour        = 7;     // Session start hour (0-23)
input int    EndHour          = 17;    // Session end hour (0-23)

//+------------------------------------------------------------------+
//| HARDCODED CONSTANTS — not worth exposing as inputs               |
//+------------------------------------------------------------------+

//--- Visual defaults (only used in live / visual-tester)
#define TEXT_SIZE               8
#define TICK_WINDOW_COLOR       clrBlue
#define VOLUME_WINDOW_COLOR     clrSkyBlue
#define THRESHOLD_WINDOW_WIDTH  1
#define UP_TREND_COLOR          clrLime
#define DOWN_TREND_COLOR        clrRed
#define FOOTPRINT_LINE_WIDTH    2

//--- Volume Weighted Price weights
#define VWP_CLOSE_WEIGHT    0.4
#define VWP_TYPICAL_WEIGHT  0.4
#define VWP_OPEN_WEIGHT     0.2

//--- Threshold bounds (fraction of base threshold)
#define THRESHOLD_MIN_MULT  0.3
#define THRESHOLD_MAX_MULT  3.0
#define MIN_ABSOLUTE_THRESHOLD 80.0

//--- Statistical
#define MIN_MAD_VALUE       10.0
#define MAD_SCALE_FACTOR    1.4826

//--- Trade throttle
#define MIN_TRADE_DELAY     5

#endif
