package com.amarsoft.app.als.rule.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.util.DateRange;
import com.amarsoft.are.util.StringFunction;

/**
 * ����ȡ����ش���ת����
 * @author zszhang
 */
public class ValueConvert {
	
    /**
     * �����������������������
     *
     * @param   startYMD  ��ʼ�����գ���ʽΪYYYY/MM/DD
     * @return	�������������
     * @throws  ParseException
     *          if the beginning of the specified string cannot be parsed.
     */
	public static String getYear(String startYMD) throws ParseException {
		if(startYMD == null) return "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/mm/dd");
		
		//ת������ΪDATE����
		Date startDate = sdf.parse(startYMD);
		Date endDate = sdf.parse(StringFunction.getToday());
		
		DateRange dateRange = new DateRange();
		dateRange.setStartDate(startDate);
		dateRange.setEndDate(endDate);
		
		return String.valueOf(dateRange.intervalYears(true));
	}
	
    /**
     * ���������������������
     *
     * @param   startYMD  ��ʼ�����գ���ʽΪYYYY/MM/DD
     * @return	�������������
     * @throws  ParseException
     *          if the beginning of the specified string cannot be parsed.
     */
	public static String getDate(String startYMD) throws ParseException {
		if(startYMD == null) return "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/mm/dd");
		
		//ת������ΪDATE����
		Date startDate = sdf.parse(startYMD);
		Date endDate = sdf.parse(StringFunction.getToday());
		
		DateRange dateRange = new DateRange();
		dateRange.setStartDate(startDate);
		dateRange.setEndDate(endDate);
		
		return String.valueOf(dateRange.intervalDays());
	}
}
