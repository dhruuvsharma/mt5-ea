//+------------------------------------------------------------------+
//| Signal.mqh — Cumulative delta calculation and entry signals       |
//+------------------------------------------------------------------+
#ifndef SIGNAL_MQH
#define SIGNAL_MQH

#include "Market.mqh"

//+------------------------------------------------------------------+
//| Calculate cumulative delta from the sliding window buffer         |
//+------------------------------------------------------------------+
int CalculateCumDelta()
{
   int sum = 0;
   int count = MathMin(g_bufferFilled, WindowSize);
   for(int i = 0; i < count; i++)
      sum += g_deltaBuffer[i];
   return sum;
}

//+------------------------------------------------------------------+
//| Check for BUY signal: CumDelta crosses above +DeltaThreshold     |
//| Returns: 1=BUY, -1=SELL, 0=no signal                            |
//+------------------------------------------------------------------+
int CheckSignal()
{
   //--- Need at least a full window before generating signals
   if(g_bufferFilled < WindowSize)
      return 0;

   int cumDelta = CalculateCumDelta();
   int prevCumDelta = g_prevCumDelta;

   //--- Update previous for next comparison
   g_prevCumDelta = cumDelta;

   //--- CrossAbove: previous was <= threshold, current is > threshold
   if(prevCumDelta <= DeltaThreshold && cumDelta > DeltaThreshold)
   {
      Print(EA_PREFIX, "BUY signal: CumDelta crossed above +", DeltaThreshold,
            " (prev=", prevCumDelta, " curr=", cumDelta, ")");
      return 1;
   }

   //--- CrossBelow: previous was >= -threshold, current is < -threshold
   if(prevCumDelta >= -DeltaThreshold && cumDelta < -DeltaThreshold)
   {
      Print(EA_PREFIX, "SELL signal: CumDelta crossed below -", DeltaThreshold,
            " (prev=", prevCumDelta, " curr=", cumDelta, ")");
      return -1;
   }

   return 0;
}

//+------------------------------------------------------------------+
//| Apply HTF trend filter (15M EMA50)                                |
//| Returns true if signal passes the filter                          |
//+------------------------------------------------------------------+
bool PassesHTFFilter(int signal)
{
   if(!UseHTFFilter)
      return true;

   double ema = GetHTFEma();
   if(ema == 0.0)
      return false;

   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   if(signal > 0 && bid > ema)
      return true;
   if(signal < 0 && bid < ema)
      return true;

   Print(EA_PREFIX, "HTF filter blocked signal. Bid=", bid, " EMA50(15M)=", ema);
   return false;
}

#endif
