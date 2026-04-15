//+------------------------------------------------------------------+
//| Market.mqh — Price data, indicators, tick delta tracking         |
//+------------------------------------------------------------------+
#ifndef MARKET_MQH
#define MARKET_MQH

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Initialize indicator handles                                      |
//+------------------------------------------------------------------+
bool MarketInit()
{
   //--- ATR(14) on current chart timeframe
   g_atrHandle = iATR(_Symbol, PERIOD_CURRENT, 14);
   if(g_atrHandle == INVALID_HANDLE)
   {
      Print(EA_PREFIX, "Failed to create ATR handle. Error: ", GetLastError());
      return false;
   }

   //--- EMA(50) on 15-minute chart for HTF filter
   g_emaHandle = iMA(_Symbol, PERIOD_M15, 50, 0, MODE_EMA, PRICE_CLOSE);
   if(g_emaHandle == INVALID_HANDLE)
   {
      Print(EA_PREFIX, "Failed to create EMA handle. Error: ", GetLastError());
      return false;
   }

   //--- Initialize delta circular buffer
   ArrayResize(g_deltaBuffer, WindowSize);
   ArrayInitialize(g_deltaBuffer, 0);
   g_bufferIndex  = 0;
   g_bufferFilled = 0;

   //--- Initialize previous bid
   g_prevBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   //--- Initialize bar time
   g_lastBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);

   Print(EA_PREFIX, "Market indicators initialized successfully");
   return true;
}

//+------------------------------------------------------------------+
//| Release indicator handles                                         |
//+------------------------------------------------------------------+
void MarketDeinit()
{
   if(g_atrHandle != INVALID_HANDLE)
      IndicatorRelease(g_atrHandle);
   if(g_emaHandle != INVALID_HANDLE)
      IndicatorRelease(g_emaHandle);
}

//+------------------------------------------------------------------+
//| Detect new candle by comparing bar open time                      |
//+------------------------------------------------------------------+
bool IsNewCandle()
{
   datetime currentBarTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(currentBarTime != g_lastBarTime)
   {
      g_lastBarTime = currentBarTime;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Process tick: update uptick/downtick counters                     |
//+------------------------------------------------------------------+
void ProcessTick()
{
   double currentBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   if(currentBid > g_prevBid)
      g_uptickCount++;
   else if(currentBid < g_prevBid)
      g_downtickCount++;
   // Equal → ignore

   g_prevBid = currentBid;

   //--- Update live delta for display
   g_liveDelta = g_uptickCount - g_downtickCount;
}

//+------------------------------------------------------------------+
//| On candle close: finalize delta and push to buffer                |
//+------------------------------------------------------------------+
void FinalizeCandle()
{
   int candleDelta = g_uptickCount - g_downtickCount;

   //--- Push into circular buffer
   g_deltaBuffer[g_bufferIndex] = candleDelta;
   g_bufferIndex = (g_bufferIndex + 1) % WindowSize;
   if(g_bufferFilled < WindowSize)
      g_bufferFilled++;

   Print(EA_PREFIX, "Candle closed. Delta=", candleDelta,
         " Upticks=", g_uptickCount, " Downticks=", g_downtickCount);

   //--- Reset tick counters for new candle
   g_uptickCount   = 0;
   g_downtickCount = 0;
   g_liveDelta     = 0;
}

//+------------------------------------------------------------------+
//| Get current ATR(14) value                                         |
//+------------------------------------------------------------------+
double GetATR()
{
   double atr[];
   if(CopyBuffer(g_atrHandle, 0, 0, 1, atr) <= 0)
   {
      Print(EA_PREFIX, "Failed to read ATR. Error: ", GetLastError());
      return 0.0;
   }
   return atr[0];
}

//+------------------------------------------------------------------+
//| Get EMA(50) value from 15M chart                                  |
//+------------------------------------------------------------------+
double GetHTFEma()
{
   double ema[];
   if(CopyBuffer(g_emaHandle, 0, 0, 1, ema) <= 0)
   {
      Print(EA_PREFIX, "Failed to read EMA. Error: ", GetLastError());
      return 0.0;
   }
   return ema[0];
}

//+------------------------------------------------------------------+
//| Get current spread in points                                      |
//+------------------------------------------------------------------+
int GetSpreadPoints()
{
   return (int)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
}

//+------------------------------------------------------------------+
//| Get deltas in chronological bar order (oldest→newest)             |
//| deltas[0] = oldest bar in window, deltas[count-1] = newest       |
//| count = number of filled slots                                    |
//+------------------------------------------------------------------+
int GetOrderedDeltas(int &deltas[])
{
   int count = MathMin(g_bufferFilled, WindowSize);
   ArrayResize(deltas, count);

   //--- Oldest entry is at g_bufferIndex (if full) or 0 (if not full)
   int start = (g_bufferFilled >= WindowSize) ? g_bufferIndex : 0;

   for(int i = 0; i < count; i++)
   {
      int idx = (start + i) % WindowSize;
      deltas[i] = g_deltaBuffer[idx];
   }
   return count;
}

#endif
