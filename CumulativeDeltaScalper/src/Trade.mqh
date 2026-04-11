//+------------------------------------------------------------------+
//| Trade.mqh — Order placement, modification, position management    |
//+------------------------------------------------------------------+
#ifndef TRADE_MQH
#define TRADE_MQH

#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include "Risk.mqh"

CTrade         g_trade;
CPositionInfo  g_posInfo;

//+------------------------------------------------------------------+
//| Initialize trade object                                           |
//+------------------------------------------------------------------+
void TradeInit()
{
   g_trade.SetExpertMagicNumber(MagicNumber);
   g_trade.SetDeviationInPoints(Slippage);
   g_trade.SetTypeFilling(ORDER_FILLING_FOK);
}

//+------------------------------------------------------------------+
//| Check if we already have a position on this symbol with our magic |
//+------------------------------------------------------------------+
bool HasOpenPosition()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(g_posInfo.SelectByIndex(i))
      {
         if(g_posInfo.Symbol() == _Symbol && g_posInfo.Magic() == MagicNumber)
            return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| Open a trade in the given direction                                |
//+------------------------------------------------------------------+
bool OpenTrade(int direction)
{
   double slDist = CalcSLDistance();
   double tpDist = CalcTPDistance();

   if(slDist == 0.0 || tpDist == 0.0)
   {
      Print(EA_PREFIX, "Invalid SL/TP distance. SL=", slDist, " TP=", tpDist);
      return false;
   }

   bool result = false;

   if(direction > 0) // BUY
   {
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double sl  = NormalizeDouble(ask - slDist, _Digits);
      double tp  = NormalizeDouble(ask + tpDist, _Digits);

      result = g_trade.Buy(LotSize, _Symbol, ask, sl, tp, EAComment);
      if(result)
         Print(EA_PREFIX, "BUY opened at ", ask, " SL=", sl, " TP=", tp);
      else
         Print(EA_PREFIX, "BUY failed. Error: ", GetLastError());
   }
   else if(direction < 0) // SELL
   {
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double sl  = NormalizeDouble(bid + slDist, _Digits);
      double tp  = NormalizeDouble(bid - tpDist, _Digits);

      result = g_trade.Sell(LotSize, _Symbol, bid, sl, tp, EAComment);
      if(result)
         Print(EA_PREFIX, "SELL opened at ", bid, " SL=", sl, " TP=", tp);
      else
         Print(EA_PREFIX, "SELL failed. Error: ", GetLastError());
   }

   if(result)
   {
      g_dailyTradeCount++;
      g_breakevenApplied = false;
   }

   return result;
}

//+------------------------------------------------------------------+
//| Manage open trade: breakeven logic                                 |
//+------------------------------------------------------------------+
void ManageOpenTrade()
{
   if(g_breakevenApplied)
      return;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(!g_posInfo.SelectByIndex(i))
         continue;
      if(g_posInfo.Symbol() != _Symbol || g_posInfo.Magic() != MagicNumber)
         continue;

      double openPrice = g_posInfo.PriceOpen();
      double currentSL = g_posInfo.StopLoss();
      double point     = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      double beBuffer  = BE_BUFFER_PIPS * 10.0 * point; // Convert pips to price

      if(g_posInfo.PositionType() == POSITION_TYPE_BUY)
      {
         double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double profitPips = (bid - openPrice) / (10.0 * point);

         if(profitPips >= BreakevenPips)
         {
            double newSL = NormalizeDouble(openPrice + beBuffer, _Digits);
            if(newSL > currentSL)
            {
               if(g_trade.PositionModify(g_posInfo.Ticket(), newSL, g_posInfo.TakeProfit()))
               {
                  Print(EA_PREFIX, "Breakeven applied. New SL=", newSL);
                  g_breakevenApplied = true;
               }
               else
                  Print(EA_PREFIX, "Breakeven modify failed. Error: ", GetLastError());
            }
         }
      }
      else if(g_posInfo.PositionType() == POSITION_TYPE_SELL)
      {
         double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         double profitPips = (openPrice - ask) / (10.0 * point);

         if(profitPips >= BreakevenPips)
         {
            double newSL = NormalizeDouble(openPrice - beBuffer, _Digits);
            if(currentSL == 0.0 || newSL < currentSL)
            {
               if(g_trade.PositionModify(g_posInfo.Ticket(), newSL, g_posInfo.TakeProfit()))
               {
                  Print(EA_PREFIX, "Breakeven applied. New SL=", newSL);
                  g_breakevenApplied = true;
               }
               else
                  Print(EA_PREFIX, "Breakeven modify failed. Error: ", GetLastError());
            }
         }
      }

      break; // Only one position expected
   }
}

#endif
