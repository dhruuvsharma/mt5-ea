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
double ApplyThresholdBounds(double raw, double base, bool isBuy)
{
    if(isBuy)
    {
        if(raw < 0) raw = MathAbs(raw);
        double lo = base * THRESHOLD_MIN_MULT;
        double hi = base * THRESHOLD_MAX_MULT;
        return MathMin(MathMax(raw, lo), hi);
    }
    else
    {
        if(raw > 0) raw = -raw;
        double lo = base * THRESHOLD_MIN_MULT;   // negative
        double hi = base * THRESHOLD_MAX_MULT;   // negative
        return MathMax(MathMin(raw, lo), hi);
    }
}

//+------------------------------------------------------------------+
//| Calculate dynamic thresholds from analysis window data           |
//+------------------------------------------------------------------+
void CalculateThresholdsFromData(double &data[], int count,
                                  double baseBuy, double baseSell,
                                  double &outBuy, double &outSell)
{
    if(count < 10)
    {
        outBuy  = baseBuy;
        outSell = baseSell;
        return;
    }

    double temp[];
    ArrayResize(temp, count);
    for(int i = 0; i < count; i++)
        temp[i] = data[i];

    double med = CalculateMedian(temp, count);
    double mad = MathMax(CalculateMAD(temp, med, count), MIN_MAD_VALUE);

    double rawBuy  = med + ThresholdMultiplier * mad;
    double rawSell = med - ThresholdMultiplier * mad;

    if(MathAbs(rawBuy)  < MIN_ABSOLUTE_THRESHOLD)
        rawBuy  = (rawBuy  >= 0) ?  MIN_ABSOLUTE_THRESHOLD : -MIN_ABSOLUTE_THRESHOLD;
    if(MathAbs(rawSell) < MIN_ABSOLUTE_THRESHOLD)
        rawSell = (rawSell >= 0) ?  MIN_ABSOLUTE_THRESHOLD : -MIN_ABSOLUTE_THRESHOLD;

    outBuy  = ApplyThresholdBounds(rawBuy,  baseBuy,  true);
    outSell = ApplyThresholdBounds(rawSell, baseSell, false);
}

//+------------------------------------------------------------------+
//| Recalculate dynamic tick thresholds                              |
//+------------------------------------------------------------------+
void CalculateDynamicTickThresholds()
{
    CalculateThresholdsFromData(tickAnalysisData, tickAnalysisCount,
        baseTickBuyThreshold, baseTickSellThreshold,
        dynamicTickBuyThreshold, dynamicTickSellThreshold);
}

//+------------------------------------------------------------------+
//| Recalculate dynamic volume thresholds                            |
//+------------------------------------------------------------------+
void CalculateDynamicVolumeThresholds()
{
    CalculateThresholdsFromData(volumeAnalysisData, volumeAnalysisCount,
        baseVolumeBuyThreshold, baseVolumeSellThreshold,
        dynamicVolumeBuyThreshold, dynamicVolumeSellThreshold);
}

//+------------------------------------------------------------------+
//| Evaluate entry signals — contrarian delta + optional slope       |
//+------------------------------------------------------------------+
void CheckTradingSignals()
{
    signalLong  = false;
    signalShort = false;

    if(GetCurrentSpread() > MaxSpread * _Point)
        return;

    int slope = GetVolumeLineSlope();

    bool tickSell = (cumulativeTickDelta   > dynamicTickBuyThreshold);
    bool tickBuy  = (cumulativeTickDelta   < dynamicTickSellThreshold);
    bool volSell  = (cumulativeVolumeDelta > dynamicVolumeBuyThreshold);
    bool volBuy   = (cumulativeVolumeDelta < dynamicVolumeSellThreshold);

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
