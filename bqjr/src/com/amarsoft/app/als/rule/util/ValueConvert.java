package com.amarsoft.app.als.rule.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.util.DateRange;
import com.amarsoft.are.util.StringFunction;

/**
 * 规则取数相关处理转化类
 * @author zszhang
 */
public class ValueConvert {
	
    /**
     * 返回日期区间包含的整年数
     *
     * @param   startYMD  起始年月日，格式为YYYY/MM/DD
     * @return	区间包括的年数
     * @throws  ParseException
     *          if the beginning of the specified string cannot be parsed.
     */
	public static String getYear(String startYMD) throws ParseException {
		if(startYMD == null) return "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/mm/dd");
		
		//转换日期为DATE类型
		Date startDate = sdf.parse(startYMD);
		Date endDate = sdf.parse(StringFunction.getToday());
		
		DateRange dateRange = new DateRange();
		dateRange.setStartDate(startDate);
		dateRange.setEndDate(endDate);
		
		return String.valueOf(dateRange.intervalYears(true));
	}
	
    /**
     * 返回日期区间包含的天数
     *
     * @param   startYMD  起始年月日，格式为YYYY/MM/DD
     * @return	区间包括的天数
     * @throws  ParseException
     *          if the beginning of the specified string cannot be parsed.
     */
	public static String getDate(String startYMD) throws ParseException {
		if(startYMD == null) return "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/mm/dd");
		
		//转换日期为DATE类型
		Date startDate = sdf.parse(startYMD);
		Date endDate = sdf.parse(StringFunction.getToday());
		
		DateRange dateRange = new DateRange();
		dateRange.setStartDate(startDate);
		dateRange.setEndDate(endDate);
		
		return String.valueOf(dateRange.intervalDays());
	}
}
