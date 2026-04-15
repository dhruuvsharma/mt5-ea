//+------------------------------------------------------------------+
//| Config.mqh — All inputs and constants for CumulativeDeltaScalper |
//+------------------------------------------------------------------+
#ifndef CONFIG_MQH
#define CONFIG_MQH

//--- Delta Settings
input group "Delta Settings"
input int    WindowSize       = 10;     // Number of candles in sliding window
input int    DeltaThreshold   = 300;    // Cumulative delta trigger level

//--- Trade Settings
input group "Trade Settings"
input double LotSize          = 0.01;   // Fixed lot size
input double TP_Multiplier    = 0.6;    // Take Profit = ATR × this
input double SL_Multiplier    = 1.2;    // Stop Loss = ATR × this
input double BreakevenPips    = 3.0;    // Pips in profit to move SL to breakeven
input int    MaxSpreadPoints  = 15;     // Max allowed spread in points (1.5 pips)
input int    Slippage         = 3;      // Slippage tolerance in points

//--- Filters
input group "Filters"
input bool   UseHTFFilter     = true;   // Use 15M EMA trend filter
input bool   UseSessionFilter = true;   // Use London/NY session filter
input double MinATR           = 0.00030;// Minimum ATR (skip if too flat)
input double MaxATR           = 0.00200;// Maximum ATR (skip if too volatile)

//--- Risk Management
input group "Risk Management"
input int    MaxDailyTrades     = 8;    // Max trades per day
input double MaxDailyLossPercent= 2.0;  // Max daily loss % of balance
input int    CooldownMinutes    = 15;   // Minutes to pause after a loss

//--- Display
input group "Display"
input bool   ShowUI           = true;     // Show chart UI (window, deltas, footprint)
input double FootprintBlockPips = 1.0;   // Price level height in pips for footprint cells

//--- EA Identity
input group "EA Identity"
input int    MagicNumber      = 20250411; // EA magic number
input string EAComment        = "CDScalper"; // Trade comment

//--- Constants
#define EA_NAME       "CumulativeDeltaScalper"
#define EA_PREFIX     "[CDScalper] "
#define DASHBOARD_X   20
#define DASHBOARD_Y   30
#define DASHBOARD_FONT_SIZE  10
#define DASHBOARD_FONT       "Consolas"
#define DASHBOARD_LINE_HEIGHT 18
#define BE_BUFFER_PIPS 0.5   // Breakeven buffer above entry

//--- Sliding Window UI Constants
#define SW_RECT_NAME          "CDScalper_SlidingWindow_Rect"
#define SW_DELTA_PREFIX       "CDScalper_Delta_"
#define SW_LIVE_DELTA_NAME    "CDScalper_LiveDelta"
#define SW_CUMDELTA_NAME      "CDScalper_CumDelta_Label"
#define SW_TEXT_SIZE           8
#define SW_RECT_WIDTH         2
#define SW_RECT_STYLE         STYLE_DOT
#define SW_FP_BG_PREFIX       "CDScalper_FpBg_"
#define SW_FP_TX_PREFIX       "CDScalper_FpTx_"
#define SW_FP_MAX_LEVELS      40

//--- Global State Variables
int    g_atrHandle       = INVALID_HANDLE;
int    g_emaHandle       = INVALID_HANDLE;
double g_prevBid         = 0.0;
int    g_uptickCount     = 0;
int    g_downtickCount   = 0;
int    g_deltaBuffer[];          // Circular buffer for candle deltas
int    g_bufferIndex     = 0;    // Current write position in circular buffer
int    g_bufferFilled    = 0;    // How many slots have been written
datetime g_lastBarTime   = 0;    // Last known bar open time
int    g_prevCumDelta    = 0;    // Previous cumDelta for crossover detection
int    g_liveDelta       = 0;    // Current candle running delta (display only)

//--- Daily Tracking
int    g_dailyTradeCount = 0;
double g_dailyPnL        = 0.0;
double g_dayStartBalance  = 0.0;
datetime g_lastTradeDay  = 0;

//--- Cooldown
datetime g_lastLossTime  = 0;

//--- Breakeven
bool   g_breakevenApplied = false;

//--- Dashboard object names
string g_dashLabels[];

#endif
