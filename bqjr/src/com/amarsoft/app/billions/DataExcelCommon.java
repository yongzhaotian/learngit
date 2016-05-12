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
	 * 初始化数据
	 * @param xlsPath
	 * @throws Exception
	 */
	public DataExcelCommon(String xlsPath) throws Exception {
		
		
		if (xlsPath!=null && !xlsPath.endsWith("xls")) {
			throw new RuntimeException("数据导入文件请选择2003的格式！");
		}
		// fixme  目前仅从第一个工作薄sheet中数据
		String platform = (String)System.getProperties().get("os.name");
		if (!"Linux".equalsIgnoreCase(platform)) xlsPath = xlsPath.replaceAll("/", "\\\\");
		HSSFWorkbook wbook = new HSSFWorkbook(new FileInputStream(xlsPath));
		sheet = wbook.getSheetAt(0);
		// 根据表头获取数据的列数目
		HSSFRow headerRow = sheet.getRow(0);
		firstRowNum = sheet.getFirstRowNum();
		lastRowNum = sheet.getLastRowNum();
		firstCellNum = headerRow.getFirstCellNum();
		lastCellNum = headerRow.getLastCellNum();
		
	}
	
		
	/**
	 * 检查合法性
	 * @return
	 */
	public boolean validCheck() {
		return true;
	}
	
	/**
	 * 将xls2003中数据读取到字符数组中
	 * @return
	 */
	public String[][] getAllData() {
		// 根据xls中行数和列初始化数组
		String[][] rowColsData = new String[lastRowNum][lastCellNum];
		
		for (int rowNum=firstRowNum+1; rowNum<lastRowNum+1; rowNum++) {
			HSSFRow aRow = sheet.getRow(rowNum);
			for (short colNum=firstCellNum; colNum<lastCellNum; colNum++) {
				HSSFCell aCell = aRow.getCell(colNum);
				String aRowColVal = "";
				if(aCell!=null){
				// fixme 目前仅处理数字和字符串格式的数据，其他格式默认初始化成""空串
				if (HSSFCell.CELL_TYPE_NUMERIC==aCell.getCellType()) {
					if (HSSFDateUtil.isCellDateFormatted(aCell)) {	
						// 处理日期单元格格式数据，将日期转换成字符串
						Date date = HSSFDateUtil.getJavaDate(aCell.getNumericCellValue());
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
						aRowColVal = sdf.format(date);
					} else {
						aRowColVal = String.valueOf(aCell.getNumericCellValue());
					}
				} else if (HSSFCell.CELL_TYPE_STRING==aCell.getCellType()) {
					aRowColVal = aCell.getStringCellValue();
				} else  {	// fixme area, 处理其他情况格式数据
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
		// 根据xls中行数和列初始化数组
		String[][] rowColsData = new String[lastRowNum][lastCellNum];
		DecimalFormat df = new DecimalFormat();
		for (int rowNum=firstRowNum+1; rowNum<lastRowNum+1; rowNum++) {
			HSSFRow aRow = sheet.getRow(rowNum);
			for (short colNum=firstCellNum; colNum<lastCellNum; colNum++) {
				HSSFCell aCell = aRow.getCell(colNum);
				String aRowColVal = "";
				if(aCell!=null){
				// fixme 目前仅处理数字和字符串格式的数据，其他格式默认初始化成""空串
				if (HSSFCell.CELL_TYPE_NUMERIC==aCell.getCellType()) {
					if (HSSFDateUtil.isCellDateFormatted(aCell)) {	
						// 处理日期单元格格式数据，将日期转换成字符串
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
				} else  {	// fixme area, 处理其他情况格式数据
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
		// 根据xls中行数和列初始化数组
		String[][] rowColsData = new String[lastRowNum][lastCellNum];
		DecimalFormat df = new DecimalFormat();
		for (int rowNum=firstRowNum+2; rowNum<lastRowNum+1; rowNum++) {
			HSSFRow aRow = sheet.getRow(rowNum);
			for (short colNum=firstCellNum; colNum<lastCellNum; colNum++) {
				HSSFCell aCell = aRow.getCell(colNum);
				String aRowColVal = "";
				if(aCell!=null){
				// fixme 目前仅处理数字和字符串格式的数据，其他格式默认初始化成""空串
				if (HSSFCell.CELL_TYPE_NUMERIC==aCell.getCellType()) {
					if (HSSFDateUtil.isCellDateFormatted(aCell)) {	
						// 处理日期单元格格式数据，将日期转换成字符串
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
				} else  {	// fixme area, 处理其他情况格式数据
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
		// 根据xls中行数和列初始化数组
		String[][] rowColsData = new String[lastRowNum][lastCellNum];
		DecimalFormat df = new DecimalFormat();
		for (int rowNum=firstRowNum; rowNum<lastRowNum; rowNum++) {
			HSSFRow aRow = sheet.getRow(rowNum+1);
			for (short colNum=firstCellNum; colNum<lastCellNum; colNum++) {
				HSSFCell aCell = aRow.getCell(colNum);
				String aRowColVal = "";
				if(aCell!=null){
				// fixme 目前仅处理数字和字符串格式的数据，其他格式默认初始化成""空串
				if (HSSFCell.CELL_TYPE_NUMERIC==aCell.getCellType()) {
					if (HSSFDateUtil.isCellDateFormatted(aCell)) {	
						// 处理日期单元格格式数据，将日期转换成字符串
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
				} else  {	// fixme area, 处理其他情况格式数据
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
