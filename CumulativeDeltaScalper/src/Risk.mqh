//+------------------------------------------------------------------+
//| Risk.mqh — Guard checks, SL/TP calculation                       |
//+------------------------------------------------------------------+
#ifndef RISK_MQH
#define RISK_MQH

#include "Signal.mqh"

//+------------------------------------------------------------------+
//| Calculate Stop Loss distance in price (ATR × SL_Multiplier)       |
//+------------------------------------------------------------------+
double CalcSLDistance()
{
   double atr = GetATR();
   return NormalizeDouble(atr * SL_Multiplier, _Digits);
}

//+------------------------------------------------------------------+
//| Calculate Take Profit distance in price (ATR × TP_Multiplier)     |
//+------------------------------------------------------------------+
double CalcTPDistance()
{
   double atr = GetATR();
   return NormalizeDouble(atr * TP_Multiplier, _Digits);
}

//+------------------------------------------------------------------+
//| Check all guards — returns true if trading is allowed             |
//+------------------------------------------------------------------+
bool CheckGuards(string &reason)
{
   //--- 1. Session Filter
   if(UseSessionFilter && !IsInSession())
   {
      reason = "SESSION CLOSED";
      return false;
   }

   //--- 2. Spread Guard
   int spread = GetSpreadPoints();
   if(spread > MaxSpreadPoints)
   {
      reason = "SPREAD HIGH (" + IntegerToString(spread) + ">" + IntegerToString(MaxSpreadPoints) + ")";
      return false;
   }

   //--- 3. Daily Trade Limit
   if(g_dailyTradeCount >= MaxDailyTrades)
   {
      reason = "DAILY LIMIT (" + IntegerToString(g_dailyTradeCount) + "/" + IntegerToString(MaxDailyTrades) + ")";
      return false;
   }

   //--- 4. Daily Loss Limit
   if(g_dayStartBalance > 0)
   {
      double maxLoss = g_dayStartBalance * MaxDailyLossPercent / 100.0;
      if(g_dailyPnL < -maxLoss)
      {
         reason = "DAILY LOSS LIMIT";
         return false;
      }
   }

   //--- 5. Cooldown After Loss
   if(g_lastLossTime > 0)
   {
      datetime cooldownEnd = g_lastLossTime + CooldownMinutes * 60;
      if(TimeCurrent() < cooldownEnd)
      {
         int remaining = (int)(cooldownEnd - TimeCurrent()) / 60;
         reason = "COOLDOWN (" + IntegerToString(remaining) + "m left)";
         return false;
      }
   }

   //--- 6. ATR Volatility Check
   double atr = GetATR();
   if(atr < MinATR)
   {
      reason = "ATR TOO LOW (" + DoubleToString(atr, 5) + ")";
      return false;
   }
   if(atr > MaxATR)
   {
      reason = "ATR TOO HIGH (" + DoubleToString(atr, 5) + ")";
      return false;
   }

   reason = "ACTIVE";
   return true;
}

//+------------------------------------------------------------------+
//| Session filter: London 08:00-12:00 GMT, New York 13:00-17:00 GMT  |
//+------------------------------------------------------------------+
bool IsInSession()
{
   MqlDateTime gmtTime;
   TimeToStruct(TimeGMT(), gmtTime);
   int hour = gmtTime.hour;

   //--- London session: 08:00 - 12:00 GMT
   if(hour >= 8 && hour < 12)
      return true;

   //--- New York session: 13:00 - 17:00 GMT
   if(hour >= 13 && hour < 17)
      return true;

   return false;
}

#endif
