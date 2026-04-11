//+------------------------------------------------------------------+
//| CumulativeDeltaScalper.mq5                                        |
//| Expert Advisor: CumulativeDeltaScalper                            |
//| Version: 1.0                                                      |
//| Description: Scalps EURUSD on short timeframes using cumulative   |
//|   tick-level delta in a sliding window. Enters when delta crosses |
//|   a threshold, filtered by 15M EMA trend and session/risk guards. |
//| Author: Dhruv Sharma                                              |
//| Date: 2025-04-11                                                  |
//+------------------------------------------------------------------+
#property copyright "Dhruv Sharma"
#property link      ""
#property version   "1.00"
#property strict
#property description "Cumulative Delta Scalper — tick-level delta sliding window strategy"

//--- Include all layers
#include "Utils.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                    |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Validate inputs
   if(WindowSize < 2)
   {
      Print(EA_PREFIX, "WindowSize must be >= 2");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(DeltaThreshold <= 0)
   {
      Print(EA_PREFIX, "DeltaThreshold must be > 0");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(LotSize <= 0)
   {
      Print(EA_PREFIX, "LotSize must be > 0");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(SL_Multiplier <= 0 || TP_Multiplier <= 0)
   {
      Print(EA_PREFIX, "SL/TP multipliers must be > 0");
      return INIT_PARAMETERS_INCORRECT;
   }

   //--- Initialize market data and indicator handles
   if(!MarketInit())
      return INIT_FAILED;

   //--- Initialize trade object
   TradeInit();

   //--- Initialize daily counters
   g_lastTradeDay = 0; // Force reset on first tick
   g_lastLossTime = 0;
   g_breakevenApplied = false;

   //--- Initialize dashboard
   InitDashboard();

   Print(EA_PREFIX, "Initialized. Window=", WindowSize,
         " Threshold=", DeltaThreshold, " Magic=", MagicNumber);
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   MarketDeinit();
   RemoveDashboard();
   Print(EA_PREFIX, "Deinitialized. Reason=", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                              |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Reset daily counters at midnight
   ResetDailyCounters();

   //--- Sync daily stats from history (catches trades closed by SL/TP)
   GetDailyStats(g_dailyPnL, g_dailyTradeCount);

   //--- Check for recent loss and update cooldown
   CheckLastTradeLoss();

   //--- Process tick: update uptick/downtick counters
   ProcessTick();

   //--- Detect new candle: finalize previous candle's delta
   if(IsNewCandle())
      FinalizeCandle();

   //--- Manage existing position (breakeven)
   if(HasOpenPosition())
   {
      ManageOpenTrade();
      string guardReason = "ACTIVE (in trade)";
      UpdateDashboard(guardReason);
      return;
   }

   //--- Check for entry signal (only on completed candle data)
   int signal = CheckSignal();

   //--- Run guard checks
   string guardReason;
   bool guardsOK = CheckGuards(guardReason);

   //--- Update dashboard every tick
   UpdateDashboard(guardReason);

   //--- If no signal or guards failed, exit
   if(signal == 0 || !guardsOK)
      return;

   //--- Apply HTF trend filter
   if(!PassesHTFFilter(signal))
      return;

   //--- Open trade
   OpenTrade(signal);
}
//+------------------------------------------------------------------+
