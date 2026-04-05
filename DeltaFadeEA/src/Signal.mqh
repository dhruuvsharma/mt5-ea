//+------------------------------------------------------------------+
//|                                                      Signal.mqh |
//|                                        DeltaFadeEA — Dhruv Sharma |
//+------------------------------------------------------------------+
#ifndef SIGNAL_MQH
#define SIGNAL_MQH

#include "Config.mqh"
#include "Market.mqh"

//--- Dynamic thresholds (recalculated each bar)
double dynamicTickBuyThreshold      =  1000;
double dynamicTickSellThreshold     = -1000;
double dynamicVolumeBuyThreshold    =  800;
double dynamicVolumeSellThreshold   = -800;

//--- Base thresholds for multiplier bounds
double baseTickBuyThreshold         =  1000;
double baseTickSellThreshold        = -1000;
double baseVolumeBuyThreshold       =  800;
double baseVolumeSellThreshold      = -800;

//--- Last signal state
bool signalLong  = false;
bool signalShort = false;

//+------------------------------------------------------------------+
//| Clamp a threshold within [min..max] of its base, sign-aware     |
//+------------------------------------------------------------------+
double ApplyThresholdBounds(double raw, double base,
                            double minMult, double maxMult, bool isBuy)
{
    if(isBuy)
    {
        if(raw < 0) raw = MathAbs(raw);
        double lo = base * minMult;
        double hi = base * maxMult;
        return MathMin(MathMax(raw, lo), hi);
    }
    else
    {
        if(raw > 0) raw = -raw;
        double lo = base * minMult;   // negative
        double hi = base * maxMult;   // negative
        return MathMax(MathMin(raw, lo), hi);
    }
}

//+------------------------------------------------------------------+
//| Recalculate dynamic tick thresholds from analysis window         |
//+------------------------------------------------------------------+
void CalculateDynamicTickThresholds()
{
    if(!EnableTickDynamicThresholds)
    {
        dynamicTickBuyThreshold  = baseTickBuyThreshold;
        dynamicTickSellThreshold = baseTickSellThreshold;
        return;
    }

    if(tickAnalysisCount < 10)
    {
        Print("[", EA_NAME, "] Tick analysis data insufficient (", tickAnalysisCount, "). Using base thresholds.");
        dynamicTickBuyThreshold  = baseTickBuyThreshold;
        dynamicTickSellThreshold = baseTickSellThreshold;
        return;
    }

    double temp[];
    ArrayResize(temp, tickAnalysisCount);
    for(int i = 0; i < tickAnalysisCount; i++)
        temp[i] = tickAnalysisData[i];

    double med = CalculateMedian(temp, tickAnalysisCount);
    double mad = MathMax(CalculateMAD(temp, med, tickAnalysisCount), MIN_MAD_VALUE);

    double rawBuy  = med + TickThresholdMultiplier * mad;
    double rawSell = med - TickThresholdMultiplier * mad;

    if(MathAbs(rawBuy)  < TickMinAbsoluteThreshold)
        rawBuy  = (rawBuy  >= 0) ?  TickMinAbsoluteThreshold : -TickMinAbsoluteThreshold;
    if(MathAbs(rawSell) < TickMinAbsoluteThreshold)
        rawSell = (rawSell >= 0) ?  TickMinAbsoluteThreshold : -TickMinAbsoluteThreshold;

    dynamicTickBuyThreshold  = ApplyThresholdBounds(rawBuy,  baseTickBuyThreshold,
                                TickMinThresholdMultiplier, TickMaxThresholdMultiplier, true);
    dynamicTickSellThreshold = ApplyThresholdBounds(rawSell, baseTickSellThreshold,
                                TickMinThresholdMultiplier, TickMaxThresholdMultiplier, false);
}

//+------------------------------------------------------------------+
//| Recalculate dynamic volume thresholds from analysis window       |
//+------------------------------------------------------------------+
void CalculateDynamicVolumeThresholds()
{
    if(!EnableVolumeDynamicThresholds)
    {
        dynamicVolumeBuyThreshold  = baseVolumeBuyThreshold;
        dynamicVolumeSellThreshold = baseVolumeSellThreshold;
        return;
    }

    if(volumeAnalysisCount < 10)
    {
        Print("[", EA_NAME, "] Volume analysis data insufficient (", volumeAnalysisCount, "). Using base thresholds.");
        dynamicVolumeBuyThreshold  = baseVolumeBuyThreshold;
        dynamicVolumeSellThreshold = baseVolumeSellThreshold;
        return;
    }

    double temp[];
    ArrayResize(temp, volumeAnalysisCount);
    for(int i = 0; i < volumeAnalysisCount; i++)
        temp[i] = volumeAnalysisData[i];

    double med = CalculateMedian(temp, volumeAnalysisCount);
    double mad = MathMax(CalculateMAD(temp, med, volumeAnalysisCount), MIN_MAD_VALUE);

    double rawBuy  = med + VolumeThresholdMultiplier * mad;
    double rawSell = med - VolumeThresholdMultiplier * mad;

    if(MathAbs(rawBuy)  < VolumeMinAbsoluteThreshold)
        rawBuy  = (rawBuy  >= 0) ?  VolumeMinAbsoluteThreshold : -VolumeMinAbsoluteThreshold;
    if(MathAbs(rawSell) < VolumeMinAbsoluteThreshold)
        rawSell = (rawSell >= 0) ?  VolumeMinAbsoluteThreshold : -VolumeMinAbsoluteThreshold;

    dynamicVolumeBuyThreshold  = ApplyThresholdBounds(rawBuy,  baseVolumeBuyThreshold,
                                  VolumeMinThresholdMultiplier, VolumeMaxThresholdMultiplier, true);
    dynamicVolumeSellThreshold = ApplyThresholdBounds(rawSell, baseVolumeSellThreshold,
                                  VolumeMinThresholdMultiplier, VolumeMaxThresholdMultiplier, false);
}

//+------------------------------------------------------------------+
//| Evaluate entry signals — contrarian delta + slope confirmation   |
//+------------------------------------------------------------------+
void CheckTradingSignals()
{
    signalLong  = false;
    signalShort = false;

    if(GetCurrentSpread() > MaxSpread * _Point)
        return;

    int slope = GetVolumeLineSlope();

    bool tickSell   = (cumulativeTickDelta   > dynamicTickBuyThreshold);
    bool tickBuy    = (cumulativeTickDelta   < dynamicTickSellThreshold);
    bool volSell    = (cumulativeVolumeDelta > dynamicVolumeBuyThreshold);
    bool volBuy     = (cumulativeVolumeDelta < dynamicVolumeSellThreshold);

    // Delta filter: require both or accept either
    bool sellDelta, buyDelta;
    if(RequireBothDeltas)
    {
        sellDelta = tickSell && volSell;
        buyDelta  = tickBuy  && volBuy;
    }
    else
    {
        sellDelta = tickSell || volSell;
        buyDelta  = tickBuy  || volBuy;
    }

    // Slope filter: hard gate or bypassed
    bool slopeOkShort = !RequireSlopeConfirmation || (slope == 1);
    bool slopeOkLong  = !RequireSlopeConfirmation || (slope == -1);

    static bool prevLong  = false;
    static bool prevShort = false;

    if(sellDelta && slopeOkShort)
    {
        signalShort = true;
        if(!prevShort)
            Print("[", EA_NAME, "] SHORT signal — delta sell + slope=", slope);
    }
    else if(buyDelta && slopeOkLong)
    {
        signalLong = true;
        if(!prevLong)
            Print("[", EA_NAME, "] LONG signal — delta buy + slope=", slope);
    }

    prevLong  = signalLong;
    prevShort = signalShort;
}

#endif
