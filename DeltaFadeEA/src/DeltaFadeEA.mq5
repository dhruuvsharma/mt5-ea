//+------------------------------------------------------------------+
//|                                                  DeltaFadeEA.mq5 |
//|                                                     Dhruv Sharma |
//|                              www.linkedin.com/in/dhruvsharmainfo |
//+------------------------------------------------------------------+
#property copyright "Dhruv Sharma"
#property version   "2.00"
#property description "Contrarian scalper that fades cumulative tick/volume delta extremes using dynamic Median+MAD thresholds and volume-weighted price slope confirmation."

#include "Config.mqh"
#include "Market.mqh"
#include "Signal.mqh"
#include "Risk.mqh"
#include "Trade.mqh"
#include "Utils.mqh"

//--- Bar tracking
datetime lastBarTime = 0;

//--- Tester mode flag (set once in OnInit, avoids repeated calls)
bool isTester      = false;
bool isTesterVisual = false;

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
{
    isTester       = (bool)MQLInfoInteger(MQL_TESTER);
    isTesterVisual = (bool)MQLInfoInteger(MQL_VISUAL_MODE);

    MarketInit();
    TradeInit();

    lastBarTime = iTime(_Symbol, _Period, 0);

    CalculateDeltas();
    CalculateVolumeFootprint();
    CalculateTicksPerSecond();
    InitializeAnalysisWindows();

    CalculateDynamicTickThresholds();
    CalculateDynamicVolumeThresholds();

    // Only draw visuals when NOT in backtest (or in visual mode)
    if(!isTester || isTesterVisual)
    {
        DrawRectangle();
        DrawVolumeFootprintLine();
        if(ShowThresholdWindows) DrawThresholdWindows();
    }

    Print("[", EA_NAME, "] v", EA_VERSION, " initialised",
          isTester ? " [TESTER MODE]" : "");
    Print("[", EA_NAME, "] Trading=", EnableTrading,
          "  BothDeltas=", RequireBothDeltas,
          "  SlopeConfirm=", RequireSlopeConfirmation,
          "  TimeFilter=", EnableTimeFilter);

    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    if(!isTester || isTesterVisual)
        CleanupObjects();
    Print("[", EA_NAME, "] deinitialised");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    datetime curBarTime = iTime(_Symbol, _Period, 0);
    bool isNewBar = (curBarTime != lastBarTime);

    if(isNewBar)
    {
        lastBarTime = curBarTime;
        OnNewBar();
    }
    else
    {
        // In tester (non-visual): skip intra-bar updates entirely
        if(isTester && !isTesterVisual)
            return;
        OnSameBar();
    }

    if(!isTester || isTesterVisual)
        DisplayTimeFilterStatus();

    if(EnableTrading)
        ManagePositions();
}

//+------------------------------------------------------------------+
//| New-bar logic                                                    |
//+------------------------------------------------------------------+
void OnNewBar()
{
    CalculateDeltas();
    CalculateVolumeFootprint();
    CalculateTicksPerSecond();

    if(WindowSize > 1)
    {
        UpdateTickAnalysisWindow(tickDelta[1]);
        UpdateVolumeAnalysisWindow(volumeDelta[1]);
        CalculateDynamicTickThresholds();
        CalculateDynamicVolumeThresholds();
    }

    if(!isTester || isTesterVisual)
        RedrawVisuals();

    if(EnableTrading && IsTradingAllowed())
        EvaluateAndExecute();
}

//+------------------------------------------------------------------+
//| Same-bar (intra-bar) logic — live / visual-tester only           |
//+------------------------------------------------------------------+
void OnSameBar()
{
    UpdateCurrentCandleDelta();
    UpdateCurrentVolumeFootprint();
    UpdateCurrentTicksPerSecond();

    if(!isTester || isTesterVisual)
        RedrawVisuals();

    if(EnableTrading && IsTradeTime() && IsTradingAllowed())
        EvaluateAndExecute();
}

//+------------------------------------------------------------------+
//| Refresh all chart drawings                                       |
//+------------------------------------------------------------------+
void RedrawVisuals()
{
    DrawRectangle();
    DrawVolumeFootprintLine();
    DisplayDeltas();
    if(ShowThresholdWindows) UpdateThresholdWindows();
}

//+------------------------------------------------------------------+
//| Check signals then execute if valid                              |
//+------------------------------------------------------------------+
void EvaluateAndExecute()
{
    CheckTradingSignals();

    if(signalLong && !HasLongPosition())
    {
        if(!isTester || isTesterVisual)
            DisplaySignal("LONG - Dynamic Thresholds", clrLime);
        EnterLong();
    }
    if(signalShort && !HasShortPosition())
    {
        if(!isTester || isTesterVisual)
            DisplaySignal("SHORT - Dynamic Thresholds", clrRed);
        EnterShort();
    }
    if(!signalLong && !signalShort)
    {
        if(!isTester || isTesterVisual)
            ObjectDelete(0, "Current_Signal");
    }
}

//+------------------------------------------------------------------+
//| Chart-event handler (never fires in tester)                      |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam,
                  const double &dparam, const string &sparam)
{
    if(id == CHARTEVENT_CHART_CHANGE)
    {
        DrawRectangle();
        DisplayDeltas();
        DrawVolumeFootprintLine();
        DisplayTimeFilterStatus();
        DisplayDynamicThresholds();
    }
}
//+------------------------------------------------------------------+
