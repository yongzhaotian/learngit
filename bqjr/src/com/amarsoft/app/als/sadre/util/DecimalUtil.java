package com.amarsoft.app.als.sadre.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;

public class DecimalUtil
{
  private static final int DEF_DIV_SCALE = 10;
  private static final int DEFAULT_SCALE = 2;

  public static String getFormatDecimal(String sParam, int iDot, int iType)
  {
    double dTemp = 0D; double dParam = 0D;
    String sReturnValue = sParam;
    if ((sParam == null) || (sParam.trim().length() == 0)) return "";
    dParam = Double.parseDouble(sParam);
    switch (iType)
    {
    case 3:
      dTemp = 100000000.0D;
      break;
    case 2:
      dTemp = 10000.0D;
      break;
    case 1:
      dTemp = 1000.0D;
      break;
    default:
      dTemp = 1D;
    }

    sReturnValue = String.valueOf(divide(dParam, dTemp, iDot));
    return sReturnValue;
  }

  public static String getFormatDecimal(double sParam, int iDot, int iType) {
    return getFormatDecimal(String.valueOf(sParam), iDot, iType);
  }

  public static String getFormatDecimal(String sParam, String iDot, String iType) {
    int iTemp1 = 0; int iTemp2 = 0;
    iTemp1 = Integer.parseInt(iDot);
    iTemp2 = Integer.parseInt(iType);
    return getFormatDecimal(sParam, iTemp1, iTemp2);
  }

  public static double add(double dValue1, double dValue2)
  {
    BigDecimal bg1 = new BigDecimal(Double.toString(dValue1));
    BigDecimal bg2 = new BigDecimal(Double.toString(dValue2));
    return bg1.add(bg2).doubleValue();
  }

  public static double add(String dValue1, String dValue2) {
    double dTemp1 = 0D;
    double dTemp2 = 0D;
    if ((dValue1 != null) && (dValue1.length() != 0))
      dTemp1 = Double.parseDouble(dValue1);

    if ((dValue2 != null) && (dValue2.length() != 0))
      dTemp2 = Double.parseDouble(dValue2);

    return add(dTemp1, dTemp2);
  }

  public static double subtract(double dValue1, double dValue2)
  {
    return subtract(dValue1, dValue2, 2);
  }

  public static double subtract(double dValue1, double dValue2, int scale) {
    BigDecimal bg1 = new BigDecimal(dValue1);
    BigDecimal bg2 = new BigDecimal(dValue2);
    return subtract(bg1, bg2, scale);
  }

  public static double subtract(String sValue1, String sValue2)
  {
    if ((sValue1 == null) || (sValue1.length() == 0) || (sValue2 == null) || (sValue2.length() == 0))
    {
      throw new IllegalArgumentException("数学表达式操作数非法!");
    }
    BigDecimal bg1 = new BigDecimal(sValue1);
    BigDecimal bg2 = new BigDecimal(sValue2);
    return subtract(bg1, bg2);
  }

  public static double subtract(BigDecimal bgValue1, BigDecimal bgValue2) {
    return subtract(bgValue1, bgValue2, 2);
  }

  public static double subtract(BigDecimal bgValue1, BigDecimal bgValue2, int scale) {
    BigDecimal bg = bgValue1.subtract(bgValue2);

    return bg.setScale(scale, 4).doubleValue();
  }

  public static double multiply(BigDecimal bgValue1, BigDecimal bgValue2)
  {
    return multiply(bgValue1, bgValue2, 2);
  }

  public static double multiply(BigDecimal bgValue1, BigDecimal bgValue2, int scale) {
    BigDecimal bg = bgValue1.multiply(bgValue2);

    return bg.setScale(scale, 4).doubleValue();
  }

  public static double multiply(double dValue1, double dValue2, int scale) {
    BigDecimal bg1 = new BigDecimal(dValue1);
    BigDecimal bg2 = new BigDecimal(dValue2);
    return multiply(bg1, bg2, scale);
  }

  public static double multiply(double dValue1, double dValue2)
  {
    return multiply(dValue1, dValue2, 2);
  }

  public static double multiply(String sValue1, String sValue2, int scale) {
    if ((sValue1 == null) || (sValue1.length() == 0) || (sValue2 == null) || (sValue2.length() == 0))
    {
      throw new IllegalArgumentException("数学表达式操作数非法!");
    }
    BigDecimal bg1 = new BigDecimal(sValue1);
    BigDecimal bg2 = new BigDecimal(sValue2);
    return multiply(bg1, bg2, scale);
  }

  public static double multiply(String sValue1, String sValue2) {
    return multiply(sValue1, sValue2, 2);
  }

  public static double multiply(double dValue1, int iValue2) {
    return multiply(String.valueOf(dValue1), String.valueOf(iValue2));
  }

  public static double multiply(int iValue1, double dValue2) {
    return multiply(String.valueOf(iValue1), String.valueOf(dValue2));
  }

  public static int devide(int iValue1, int iValue2)
  {
    return divide(iValue1, iValue2, 2);
  }

  public static int divide(int iValue1, int iValue2, int scale)
  {
    BigDecimal bg1 = new BigDecimal(Integer.toString(iValue1));
    BigDecimal bg2 = new BigDecimal(Integer.toString(iValue2));

    return divide(bg1, bg2, scale).intValue();
  }

  public static double divide(String sValue1, String sValue2, int scale)
  {
    BigDecimal bg1 = new BigDecimal(sValue1);
    BigDecimal bg2 = new BigDecimal(sValue2);
    return divide(bg1, bg2, scale).doubleValue();
  }

  public static double divide(String sValue1, String sValue2)
  {
    return divide(sValue1, sValue2, 2);
  }

  public static double divide(double dValue1, double dValue2)
  {
    return divide(dValue1, dValue2, 2);
  }

  public static double divide(double dValue1, double dValue2, int scale)
  {
    BigDecimal bg1 = new BigDecimal(dValue1);
    BigDecimal bg2 = new BigDecimal(dValue2);
    return divide(bg1, bg2, scale).doubleValue();
  }

  public static double divide(BigDecimal bg1, BigDecimal bg2) {
    return divide(bg1, bg2, 2).doubleValue();
  }

  public static BigDecimal divide(BigDecimal bg1, BigDecimal bg2, int scale) {
    int keepScale = (scale < 0) ? 0 : scale;
    BigDecimal bg = bg1.divide(bg2, keepScale, 4);
    return bg;
  }

  public static double percentage(double numerator, double denominator)
  {
    if (denominator == 0D) return 0D;
    return (divide(numerator, denominator, 6) * 100.0D);
  }

  public static double getDouble(String value)
  {
    if (value == null) return 0D;
    return Double.valueOf(value).doubleValue();
  }

  public static int getInt(String value)
  {
    if (value == null) return 0;
    return Integer.valueOf(value).intValue();
  }

  public static double cbrn(double x, int n)
  {
    double y = StrictMath.pow(x, 1D / n);
    return y;
  }

  public static String formatNumber(double value, String format) {
    DecimalFormat df = new DecimalFormat(format);
    String formatedValue = df.format(value);
    return formatedValue;
  }

  public static String formatNumber(double value) {
    return formatNumber(value, "#0.00");
  }
}