package com.amarsoft.app.als.sadre.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class DateUtil
{
  public static final String ISO_DATE_FORMAT = "dd-MMM-yyyy";
  public static final String ISO_TIME_FORMAT = "HH:mm:ss";
  public static final String ISO_TIME_WITH_MILLISECOND_FORMAT = "HH:mm:ss.SSS";
  public static final String ISO_DATETIME_FORMAT = "dd-MMM-yyyy HH:mm:ss";
  public static final String ISO_DATETIME_WITH_MILLISECOND_FORMAT = "dd-MMM-yyyy HH:mm:ss.SSS";
  public static final String ISO_SHORT_DATE_FORMAT = "dd-MMM-yy";
  public static final String AMR_FULL_DATETIME_FORMAT = "yyyy/MM/dd HH:mm:ss.SSS";
  public static final String AMR_NOMAL_DATE_FORMAT = "yyyy/MM/dd";
  public static final String AMR_SHORT_DATE_FORMAT = "yyyy/MM";
  public static final String AMR_DATE_WITHOUT_SLASH_FORMAT = "yyyyMMdd";
  public static final String AMR_ARS_DATE_FORMAT = "yyyyMMdd";

  public static String getNowTime()
  {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS");
    Calendar c = Calendar.getInstance();
    c.setTime(new Date());
    return sdf.format(c.getTime());
  }

  public static String getNowTime(String format)
  {
    SimpleDateFormat sdf = new SimpleDateFormat(format);
    Calendar c = Calendar.getInstance();
    c.setTime(new Date());
    return sdf.format(c.getTime());
  }

  public static String getToday(String sFormat) {
    Date date = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat(sFormat);
    GregorianCalendar gc = new GregorianCalendar();
    gc.setTime(date);
    String s1 = sdf.format(gc.getTime());
    return s1;
  }

  public static String getToday() {
    return getToday("yyyy/MM/dd");
  }

  public static String getYesterday() throws ParseException {
    return getRelativeDate(getToday(), 0, 0, -1);
  }

  public static String getFillInDate(String s)
  {
    String sFillDate = "";
    switch (s.length())
    {
    case 7:
      sFillDate = s.substring(0, 4) + " 年 " + s.substring(5) + " 月";
      break;
    case 10:
      sFillDate = s.substring(0, 4) + " 年 " + s.substring(5, 7) + " 月 " + s.substring(8) + " 日 ";
    }

    return sFillDate;
  }

  public static String getRelativeDate(Date date, int iYear, int iMonth, int iDate, String sFormat)
  {
    SimpleDateFormat sdf = new SimpleDateFormat(sFormat);
    GregorianCalendar gc = new GregorianCalendar();

    gc.setTime(date);

    gc.add(1, iYear);
    gc.add(2, iMonth);
    gc.add(5, iDate);

    return sdf.format(gc.getTime());
  }

  public static String getRelativeDate(String sDate, int iYear, int iMonth, int iDate, String sFormat)
    throws ParseException
  {
    if (sDate == null) return null;
    Date date = parseString2Date(sDate, "yyyy/MM/dd");
    return getRelativeDate(date, iYear, iMonth, iDate, sFormat);
  }

  public static String getRelativeDate(Date date, int iYear, int iMonth, int iDate) {
    return getRelativeDate(date, iYear, iMonth, iDate, "yyyy/MM/dd");
  }

  public static String getRelativeDate(String sDate, int iYear, int iMonth, int iDate) throws ParseException
  {
    return getRelativeDate(sDate, iYear, iMonth, iDate, "yyyy/MM/dd");
  }

  public static String getRelativeMonth(Date date, int iYear, int iMonth, String s) {
    return getRelativeDate(date, iYear, iMonth, 0, s);
  }

  public static String getRelativeMonth(String sDate, int iYear, int iMonth, String s) throws ParseException
  {
    return getRelativeDate(sDate, iYear, iMonth, 0, s);
  }

  public static String getRelativeMonth(Date date, int iYear, int iMonth) {
    return getRelativeDate(date, iYear, iMonth, 0, "yyyy/MM");
  }

  public static String getRelativeMonth(String sDate, int iYear, int iMonth) throws ParseException {
    return getRelativeDate(sDate, iYear, iMonth, 0, "yyyy/MM");
  }

  public static boolean monthEnd(String sEndDate)
    throws ParseException
  {
    String sTommorow = getRelativeDate(sEndDate, 0, 0, 1);
    if (sTommorow == null) return false;

    return (sTommorow.substring(8, 10).equals("01"));
  }

  public static String formatDate(String sDate)
  {
    if (sDate.length() == 8)
      sDate = sDate.substring(0, 4) + '/' + sDate.substring(4, 6) + '/' + sDate.substring(6);
    return sDate;
  }

  public static Date parseString2Date(String datestring) throws ParseException
  {
    return parseString2Date(datestring, "yyyy/MM/dd");
  }

  public static Date parseString2Date(String datestring, String format)
    throws ParseException
  {
    if (datestring == null) return null;

    String sDate = "";
    if (datestring.length() == 7)
      sDate = datestring + "/01";
    else
      sDate = datestring;

    Date date = new SimpleDateFormat(format).parse(sDate);
    return date;
  }

  public static boolean simplyValidate(String dateString, String splash)
  {
    if (dateString == null) return false;
    String dateSplash = "";
    if (splash != null)
      if (splash.length() > 1)
        dateSplash = "\\" + splash.substring(0, 1);
      else if (splash.length() == 1)
        dateSplash = "\\" + splash;


    String ragExp = "^\\d{4}" + dateSplash + "\\d{2}" + dateSplash + "\\d{2}$";

    return dateString.matches(ragExp);
  }

  public static String getMonthEnd(String date, String format)
    throws ParseException
  {
    if (date == null) return date;
    String sDate = date.substring(0, 7) + "/01";
    return getRelativeDate(sDate, 0, 1, -1, format);
  }

  public static String getMonthEnd(String date)
    throws ParseException
  {
    return getMonthEnd(date, "yyyy/MM/dd");
  }

  public static int getDateOfWeek(String dateString, String format)
    throws ParseException
  {
    Date date = parseString2Date(dateString);
    GregorianCalendar gc = new GregorianCalendar();
    gc.setTime(date);
    int iWeekFiled = gc.get(7);
    return iWeekFiled;
  }

  public static int getDateOfWeek(String date) throws ParseException {
    return getDateOfWeek(date, "yyyy/MM/dd");
  }

  public static int compareDate(String dateA, String dateB, String format)
  {
    if ((dateA == null) || (dateA.length() == 0) || (dateB == null) || (dateB.length() == 0))
      return -1;

    double diffDays = 0D;
    Date dateOne = null;
    Date dateTwo = null;
    try {
      dateOne = parseString2Date(dateA, format);
      dateTwo = parseString2Date(dateB, format);
      double diffMs = dateOne.getTime() - dateTwo.getTime();
      diffDays = diffMs / 86400000.0D;
    } catch (ParseException pe) {
      diffDays = -1.0D;
      System.out.println("日期对比 [" + dateA + "]-[" + dateB + "] 存在非法日期字符。");
    }

    return new Double(diffDays).intValue();
  }

  public static int compareDate(String dateA, String dateB) {
    return compareDate(dateA, dateB, "yyyy/MM/dd");
  }

  public static String getQuaterInfo(String sMonth, int iPointer) throws ParseException
  {
    String[] sDateInfo = StringUtil.toStringArray(sMonth, "/");
    if (sDateInfo.length == 1) return sDateInfo[0] + "/03";
    int iMonth = Integer.parseInt(sDateInfo[1]);
    String sMonthRange = "";
    String sQuaterValue = "";
    if ((iMonth > 0) && (iMonth <= 3))
      sMonthRange = sDateInfo[0] + "/03";
    else if ((iMonth > 3) && (iMonth <= 6))
      sMonthRange = sDateInfo[0] + "/06";
    else if ((iMonth > 6) && (iMonth <= 9))
      sMonthRange = sDateInfo[0] + "/09";
    else if ((iMonth > 9) && (iMonth <= 12))
      sMonthRange = sDateInfo[0] + "/12";

    int iStep = iPointer * 3;
    sQuaterValue = getRelativeMonth(sMonthRange + "/01", 0, iStep);

    return sQuaterValue;
  }

  public static Calendar getCalendar(String date) throws ParseException
  {
    return getCalendar(date, "yyyy/MM/dd");
  }

  public static Calendar getCalendar(String date, String format) throws ParseException
  {
    Calendar cal = Calendar.getInstance();
    cal.setTime(parseString2Date(date, format));
    return cal;
  }
}