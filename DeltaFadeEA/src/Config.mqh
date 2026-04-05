//+------------------------------------------------------------------+
//|                                                      Config.mqh |
//|                                        DeltaFadeEA — Dhruv Sharma |
//+------------------------------------------------------------------+
#ifndef CONFIG_MQH
#define CONFIG_MQH

//--- EA Identity
#define EA_NAME        "DeltaFadeEA"
#define EA_VERSION     "2.00"
#define EA_MAGIC       12345

//--- Sliding Window
input int    WindowSize = 20;    // Number of candles for trading window
input int    TextSize   = 8;     // Text size for display

//--- Trading Master Switch
input bool   EnableTrading = true; // Enable automated trading

//--- Signal Filter Mode
input bool   RequireBothDeltas       = false; // Require BOTH tick+vol deltas (false = either)
input bool   RequireSlopeConfirmation = false; // Require VWP slope confirmation

//--- Dynamic Threshold — Tick Delta
input bool   EnableTickDynamicThresholds    = true;  // Enable dynamic tick thresholds
input int    TickAnalysisWindowSize         = 50;    // Sliding window for tick threshold analysis
input double TickThresholdMultiplier        = 1.5;   // MAD multiplier for tick thresholds
input double TickMinThresholdMultiplier     = 0.3;   // Minimum tick threshold multiplier
input double TickMaxThresholdMultiplier     = 3.0;   // Maximum tick threshold multiplier
input double TickMinAbsoluteThreshold       = 100;   // Minimum absolute tick threshold value

//--- Dynamic Threshold — Volume Delta
input bool   EnableVolumeDynamicThresholds  = true;  // Enable dynamic volume thresholds
input int    VolumeAnalysisWindowSize       = 50;    // Sliding window for volume threshold analysis
input double VolumeThresholdMultiplier      = 1.5;   // MAD multiplier for volume thresholds
input double VolumeMinThresholdMultiplier   = 0.3;   // Minimum volume threshold multiplier
input double VolumeMaxThresholdMultiplier   = 3.0;   // Maximum volume threshold multiplier
input double VolumeMinAbsoluteThreshold     = 80;    // Minimum absolute volume threshold value

//--- Threshold Window Display
input bool   ShowThresholdWindows    = true;     // Show tick and volume analysis windows
input color  TickWindowColor         = clrBlue;  // Color for tick analysis window
input color  VolumeWindowColor       = clrSkyBlue; // Color for volume analysis window
input int    ThresholdWindowWidth    = 1;        // Width of threshold window borders

//--- Trading Time Filters
input bool   EnableTimeFilter   = true;  // Enable trading time filters
input bool   SundayTrading      = false; // Allow trading on Sunday
input bool   MondayTrading      = true;  // Allow trading on Monday
input bool   TuesdayTrading     = true;  // Allow trading on Tuesday
input bool   WednesdayTrading   = true;  // Allow trading on Wednesday
input bool   ThursdayTrading    = true;  // Allow trading on Thursday
input bool   FridayTrading      = true;  // Allow trading on Friday
input bool   SaturdayTrading    = false; // Allow trading on Saturday

//--- Trading Hours (0-23, true = allow trading during this hour)
input bool Hour00 = false; // 00:00 - 01:00
input bool Hour01 = false; // 01:00 - 02:00
input bool Hour02 = false; // 02:00 - 03:00
input bool Hour03 = false; // 03:00 - 04:00
input bool Hour04 = false; // 04:00 - 05:00
input bool Hour05 = false; // 05:00 - 06:00
input bool Hour06 = false; // 06:00 - 07:00
input bool Hour07 = true;  // 07:00 - 08:00
input bool Hour08 = true;  // 08:00 - 09:00
input bool Hour09 = true;  // 09:00 - 10:00
input bool Hour10 = true;  // 10:00 - 11:00
input bool Hour11 = true;  // 11:00 - 12:00
input bool Hour12 = true;  // 12:00 - 13:00
input bool Hour13 = true;  // 13:00 - 14:00
input bool Hour14 = true;  // 14:00 - 15:00
input bool Hour15 = true;  // 15:00 - 16:00
input bool Hour16 = true;  // 16:00 - 17:00
input bool Hour17 = true;  // 17:00 - 18:00
input bool Hour18 = false; // 18:00 - 19:00
input bool Hour19 = false; // 19:00 - 20:00
input bool Hour20 = false; // 20:00 - 21:00
input bool Hour21 = false; // 21:00 - 22:00
input bool Hour22 = false; // 22:00 - 23:00
input bool Hour23 = false; // 23:00 - 00:00

//--- Risk Management
input double RiskPercent       = 2.0;   // Risk per trade %
input double LotSize           = 0.01;  // Fixed lot size (0 = use risk-based)
input int    StopLossPoints    = 300;   // Fixed SL in points
input int    TakeProfitPoints  = 0;     // Fixed TP in points (0 = use RR ratio)
input double RiskRewardRatio   = 2.0;   // Risk:Reward ratio (used when TP = 0)
input int    MaxSpread         = 3;     // Maximum allowed spread in points
input int    Slippage          = 3;     // Maximum slippage in points
input int    TrailingStart     = 200;   // Trailing start in points
input int    TrailingStep      = 100;   // Trailing step in points

//--- Volume Footprint Line
input bool   ShowVolumeFootprintLine = true;    // Show volume footprint line
input color  UpTrendColor            = clrLime; // Color for uptrend line
input color  DownTrendColor          = clrRed;  // Color for downtrend line
input int    LineWidth               = 2;       // Width of the volume footprint line

//--- Volume Weighted Price Weights
#define VWP_CLOSE_WEIGHT    0.4
#define VWP_TYPICAL_WEIGHT  0.4
#define VWP_OPEN_WEIGHT     0.2

//--- Minimum MAD floor (prevents extreme thresholds)
#define MIN_MAD_VALUE       10.0

//--- MAD scaling factor for normal distribution
#define MAD_SCALE_FACTOR    1.4826

//--- Minimum trade delay in seconds
#define MIN_TRADE_DELAY     5

#endif
