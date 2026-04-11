//+------------------------------------------------------------------+
//| Utils.mqh — Dashboard, daily stats, logging helpers               |
//+------------------------------------------------------------------+
#ifndef UTILS_MQH
#define UTILS_MQH

#include "Trade.mqh"

//+------------------------------------------------------------------+
//| Get daily PnL and trade count from deal history                   |
//+------------------------------------------------------------------+
void GetDailyStats(double &todayPnL, int &todayTrades)
{
   todayPnL    = 0.0;
   todayTrades = 0;

   MqlDateTime today;
   TimeCurrent(today);
   today.hour = 0;
   today.min  = 0;
   today.sec  = 0;
   datetime dayStart = StructToTime(today);

   //--- Request history for today
   if(!HistorySelect(dayStart, TimeCurrent()))
      return;

   int totalDeals = HistoryDealsTotal();
   for(int i = 0; i < totalDeals; i++)
   {
      ulong ticket = HistoryDealGetTicket(i);
      if(ticket == 0)
         continue;

      //--- Only our magic number
      if(HistoryDealGetInteger(ticket, DEAL_MAGIC) != MagicNumber)
         continue;

      //--- Only this symbol
      if(HistoryDealGetString(ticket, DEAL_SYMBOL) != _Symbol)
         continue;

      int entry = (int)HistoryDealGetInteger(ticket, DEAL_ENTRY);

      //--- Count exits as completed trades
      if(entry == DEAL_ENTRY_OUT || entry == DEAL_ENTRY_INOUT)
      {
         todayPnL += HistoryDealGetDouble(ticket, DEAL_PROFIT)
                   + HistoryDealGetDouble(ticket, DEAL_SWAP)
                   + HistoryDealGetDouble(ticket, DEAL_COMMISSION);
         todayTrades++;
      }
   }
}

//+------------------------------------------------------------------+
//| Check if last closed trade was a loss, update cooldown timer      |
//+------------------------------------------------------------------+
void CheckLastTradeLoss()
{
   MqlDateTime today;
   TimeCurrent(today);
   today.hour = 0;
   today.min  = 0;
   today.sec  = 0;
   datetime dayStart = StructToTime(today);

   if(!HistorySelect(dayStart, TimeCurrent()))
      return;

   //--- Scan from most recent deal backwards
   for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = HistoryDealGetTicket(i);
      if(ticket == 0)
         continue;
      if(HistoryDealGetInteger(ticket, DEAL_MAGIC) != MagicNumber)
         continue;
      if(HistoryDealGetString(ticket, DEAL_SYMBOL) != _Symbol)
         continue;

      int entry = (int)HistoryDealGetInteger(ticket, DEAL_ENTRY);
      if(entry == DEAL_ENTRY_OUT || entry == DEAL_ENTRY_INOUT)
      {
         double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT)
                       + HistoryDealGetDouble(ticket, DEAL_SWAP)
                       + HistoryDealGetDouble(ticket, DEAL_COMMISSION);
         if(profit < 0.0)
         {
            datetime dealTime = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
            if(dealTime > g_lastLossTime)
               g_lastLossTime = dealTime;
         }
         break; // Only check the most recent exit
      }
   }
}

//+------------------------------------------------------------------+
//| Reset daily tracking at midnight                                  |
//+------------------------------------------------------------------+
void ResetDailyCounters()
{
   MqlDateTime now;
   TimeCurrent(now);
   datetime today;
   now.hour = 0;
   now.min  = 0;
   now.sec  = 0;
   today = StructToTime(now);

   if(g_lastTradeDay != today)
   {
      g_lastTradeDay    = today;
      g_dayStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
      g_dailyTradeCount = 0;
      g_dailyPnL        = 0.0;

      //--- Sync from history in case EA restarted mid-day
      GetDailyStats(g_dailyPnL, g_dailyTradeCount);

      Print(EA_PREFIX, "New trading day. Balance=", g_dayStartBalance,
            " Synced trades=", g_dailyTradeCount, " PnL=", g_dailyPnL);
   }
}

//+------------------------------------------------------------------+
//| Create a dashboard label object                                   |
//+------------------------------------------------------------------+
void CreateLabel(string name, int yOffset, color clr = clrWhite)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, DASHBOARD_X);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, DASHBOARD_Y + yOffset);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, DASHBOARD_FONT_SIZE);
      ObjectSetString(0, name, OBJPROP_FONT, DASHBOARD_FONT);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
}

//+------------------------------------------------------------------+
//| Initialize dashboard labels                                       |
//+------------------------------------------------------------------+
void InitDashboard()
{
   string prefix = EA_NAME + "_dash_";
   ArrayResize(g_dashLabels, 7);
   g_dashLabels[0] = prefix + "title";
   g_dashLabels[1] = prefix + "cumdelta";
   g_dashLabels[2] = prefix + "livedelta";
   g_dashLabels[3] = prefix + "trades";
   g_dashLabels[4] = prefix + "pnl";
   g_dashLabels[5] = prefix + "spread";
   g_dashLabels[6] = prefix + "status";

   for(int i = 0; i < ArraySize(g_dashLabels); i++)
      CreateLabel(g_dashLabels[i], i * DASHBOARD_LINE_HEIGHT);

   //--- Title
   ObjectSetString(0, g_dashLabels[0], OBJPROP_TEXT, "=== " + EA_NAME + " ===");
   ObjectSetInteger(0, g_dashLabels[0], OBJPROP_COLOR, clrGold);
}

//+------------------------------------------------------------------+
//| Update dashboard with current state                               |
//+------------------------------------------------------------------+
void UpdateDashboard(string status)
{
   int cumDelta = CalculateCumDelta();
   int spread   = GetSpreadPoints();

   ObjectSetString(0, g_dashLabels[1], OBJPROP_TEXT,
      "CumDelta: " + IntegerToString(cumDelta) + " (window " + IntegerToString(g_bufferFilled) + "/" + IntegerToString(WindowSize) + ")");
   ObjectSetInteger(0, g_dashLabels[1], OBJPROP_COLOR,
      cumDelta > 0 ? clrLime : (cumDelta < 0 ? clrRed : clrWhite));

   ObjectSetString(0, g_dashLabels[2], OBJPROP_TEXT,
      "LiveDelta: " + IntegerToString(g_liveDelta) +
      " (up:" + IntegerToString(g_uptickCount) + " dn:" + IntegerToString(g_downtickCount) + ")");
   ObjectSetInteger(0, g_dashLabels[2], OBJPROP_COLOR, clrSilver);

   ObjectSetString(0, g_dashLabels[3], OBJPROP_TEXT,
      "Trades: " + IntegerToString(g_dailyTradeCount) + "/" + IntegerToString(MaxDailyTrades));

   ObjectSetString(0, g_dashLabels[4], OBJPROP_TEXT,
      "PnL: " + DoubleToString(g_dailyPnL, 2));
   ObjectSetInteger(0, g_dashLabels[4], OBJPROP_COLOR,
      g_dailyPnL >= 0 ? clrLime : clrRed);

   ObjectSetString(0, g_dashLabels[5], OBJPROP_TEXT,
      "Spread: " + IntegerToString(spread) + " pts");
   ObjectSetInteger(0, g_dashLabels[5], OBJPROP_COLOR,
      spread <= MaxSpreadPoints ? clrWhite : clrOrangeRed);

   ObjectSetString(0, g_dashLabels[6], OBJPROP_TEXT,
      "Status: " + status);
   ObjectSetInteger(0, g_dashLabels[6], OBJPROP_COLOR,
      status == "ACTIVE" ? clrLime : clrOrangeRed);

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Remove all dashboard objects                                      |
//+------------------------------------------------------------------+
void RemoveDashboard()
{
   for(int i = 0; i < ArraySize(g_dashLabels); i++)
      ObjectDelete(0, g_dashLabels[i]);
}

#endif
