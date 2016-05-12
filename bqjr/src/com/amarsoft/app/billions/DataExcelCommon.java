package com.amarsoft.app.billions;

import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.poi.hssf.record.formula.functions.Replace;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

/*
 * Author: tbzeng
 * Version: 1.0
 * Date: 2014/4/12
 */

public class DataExcelCommon {

	private int firstRowNum;
	private int lastRowNum;
	private short firstCellNum;
	private short lastCellNum;
	private HSSFSheet sheet;
	
	/**
	 * ��ʼ������
	 * @param xlsPath
	 * @throws Exception
	 */
	public DataExcelCommon(String xlsPath) throws Exception {
		
		
		if (xlsPath!=null && !xlsPath.endsWith("xls")) {
			throw new RuntimeException("���ݵ����ļ���ѡ��2003�ĸ�ʽ��");
		}
		// fixme  Ŀǰ���ӵ�һ��������sheet������
		String platform = (String)System.getProperties().get("os.name");
		if (!"Linux".equalsIgnoreCase(platform)) xlsPath = xlsPath.replaceAll("/", "\\\\");
		HSSFWorkbook wbook = new HSSFWorkbook(new FileInputStream(xlsPath));
		sheet = wbook.getSheetAt(0);
		// ���ݱ�ͷ��ȡ���ݵ�����Ŀ
		HSSFRow headerRow = sheet.getRow(0);
		firstRowNum = sheet.getFirstRowNum();
		lastRowNum = sheet.getLastRowNum();
		firstCellNum = headerRow.getFirstCellNum();
		lastCellNum = headerRow.getLastCellNum();
		
	}
	
		
	/**
	 * ���Ϸ���
	 * @return
	 */
	public boolean validCheck() {
		return true;
	}
	
	/**
	 * ��xls2003�����ݶ�ȡ���ַ�������
	 * @return
	 */
	public String[][] getAllData() {
		// ����xls���������г�ʼ������
		String[][] rowColsData = new String[lastRowNum][lastCellNum];
		
		for (int rowNum=firstRowNum+1; rowNum<lastRowNum+1; rowNum++) {
			HSSFRow aRow = sheet.getRow(rowNum);
			for (short colNum=firstCellNum; colNum<lastCellNum; colNum++) {
				HSSFCell aCell = aRow.getCell(colNum);
				String aRowColVal = "";
				if(aCell!=null){
				// fixme Ŀǰ���������ֺ��ַ�����ʽ�����ݣ�������ʽĬ�ϳ�ʼ����""�մ�
				if (HSSFCell.CELL_TYPE_NUMERIC==aCell.getCellType()) {
					if (HSSFDateUtil.isCellDateFormatted(aCell)) {	
						// �������ڵ�Ԫ���ʽ���ݣ�������ת�����ַ���
						Date date = HSSFDateUtil.getJavaDate(aCell.getNumericCellValue());
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
						aRowColVal = sdf.format(date);
					} else {
						aRowColVal = String.valueOf(aCell.getNumericCellValue());
					}
				} else if (HSSFCell.CELL_TYPE_STRING==aCell.getCellType()) {
					aRowColVal = aCell.getStringCellValue();
				} else  {	// fixme area, �������������ʽ����
					aRowColVal = "";
				}
				}else{
					aRowColVal = "";
				}
				rowColsData[rowNum-1][colNum] = aRowColVal.trim();
				
				
			}
		}
		
		return rowColsData;
	}
	
	
	public String[][] getAllData11() {
		// ����xls���������г�ʼ������
		String[][] rowColsData = new String[lastRowNum][lastCellNum];
		DecimalFormat df = new DecimalFormat();
		for (int rowNum=firstRowNum+1; rowNum<lastRowNum+1; rowNum++) {
			HSSFRow aRow = sheet.getRow(rowNum);
			for (short colNum=firstCellNum; colNum<lastCellNum; colNum++) {
				HSSFCell aCell = aRow.getCell(colNum);
				String aRowColVal = "";
				if(aCell!=null){
				// fixme Ŀǰ���������ֺ��ַ�����ʽ�����ݣ�������ʽĬ�ϳ�ʼ����""�մ�
				if (HSSFCell.CELL_TYPE_NUMERIC==aCell.getCellType()) {
					if (HSSFDateUtil.isCellDateFormatted(aCell)) {	
						// �������ڵ�Ԫ���ʽ���ݣ�������ת�����ַ���
						Date date = HSSFDateUtil.getJavaDate(aCell.getNumericCellValue());
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
						aRowColVal = sdf.format(date);
						System.out.println("aRowColVal="+aRowColVal);
					} else {
						aRowColVal = String.valueOf(df.format(aCell.getNumericCellValue()).replace(",", ""));
						System.out.println(aRowColVal);
					}
				} else if (HSSFCell.CELL_TYPE_STRING==aCell.getCellType()) {
					aRowColVal = aCell.getStringCellValue().replace(String.valueOf((char)160),"");
				} else  {	// fixme area, �������������ʽ����
					aRowColVal = "";
				}
				}else{
					aRowColVal = "";
				}
				rowColsData[rowNum-1][colNum] = aRowColVal.trim();
			}
		}
		
		return rowColsData;
	}

	

	public String[][] getAllData2() {
		// ����xls���������г�ʼ������
		String[][] rowColsData = new String[lastRowNum][lastCellNum];
		DecimalFormat df = new DecimalFormat();
		for (int rowNum=firstRowNum+2; rowNum<lastRowNum+1; rowNum++) {
			HSSFRow aRow = sheet.getRow(rowNum);
			for (short colNum=firstCellNum; colNum<lastCellNum; colNum++) {
				HSSFCell aCell = aRow.getCell(colNum);
				String aRowColVal = "";
				if(aCell!=null){
				// fixme Ŀǰ���������ֺ��ַ�����ʽ�����ݣ�������ʽĬ�ϳ�ʼ����""�մ�
				if (HSSFCell.CELL_TYPE_NUMERIC==aCell.getCellType()) {
					if (HSSFDateUtil.isCellDateFormatted(aCell)) {	
						// �������ڵ�Ԫ���ʽ���ݣ�������ת�����ַ���
						Date date = HSSFDateUtil.getJavaDate(aCell.getNumericCellValue());
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
						aRowColVal = sdf.format(date);
						System.out.println("aRowColVal="+aRowColVal);
					} else {
						aRowColVal = String.valueOf(df.format(aCell.getNumericCellValue()).replace(",", ""));
						System.out.println(aRowColVal);
					}
				} else if (HSSFCell.CELL_TYPE_STRING==aCell.getCellType()) {
					aRowColVal = aCell.getStringCellValue().replace(String.valueOf((char)160),"");
				} else  {	// fixme area, �������������ʽ����
					aRowColVal = "";
				}
				}else{
					aRowColVal = "";
				}
				rowColsData[rowNum-1][colNum] = aRowColVal.trim();
			}
		}
		
		return rowColsData;
	}
	public String[][] getAllData12() {
		// ����xls���������г�ʼ������
		String[][] rowColsData = new String[lastRowNum][lastCellNum];
		DecimalFormat df = new DecimalFormat();
		for (int rowNum=firstRowNum; rowNum<lastRowNum; rowNum++) {
			HSSFRow aRow = sheet.getRow(rowNum+1);
			for (short colNum=firstCellNum; colNum<lastCellNum; colNum++) {
				HSSFCell aCell = aRow.getCell(colNum);
				String aRowColVal = "";
				if(aCell!=null){
				// fixme Ŀǰ���������ֺ��ַ�����ʽ�����ݣ�������ʽĬ�ϳ�ʼ����""�մ�
				if (HSSFCell.CELL_TYPE_NUMERIC==aCell.getCellType()) {
					if (HSSFDateUtil.isCellDateFormatted(aCell)) {	
						// �������ڵ�Ԫ���ʽ���ݣ�������ת�����ַ���
						Date date = HSSFDateUtil.getJavaDate(aCell.getNumericCellValue());
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
						aRowColVal = sdf.format(date);
						System.out.println("aRowColVal="+aRowColVal);
					} else {
						aRowColVal = String.valueOf(df.format(aCell.getNumericCellValue()).replace(",", ""));
						System.out.println(aRowColVal);
					}
				} else if (HSSFCell.CELL_TYPE_STRING==aCell.getCellType()) {
					aRowColVal = aCell.getStringCellValue().replace(String.valueOf((char)160),"");
				} else  {	// fixme area, �������������ʽ����
					aRowColVal = "";
				}
				}else{
					aRowColVal = "";
				}
				System.out.print("rowNum="+rowNum);
				System.out.print("rowNum111="+rowColsData[rowNum][colNum]);
				rowColsData[rowNum][colNum] = aRowColVal.trim();
			}
		}
		
		return rowColsData;
	}

	
}
