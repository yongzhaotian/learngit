/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.rules.aco;

import java.io.IOException;
import java.io.Serializable;
import java.io.Writer;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.naming.OperationNotSupportedException;

import com.amarsoft.app.als.sadre.util.DecimalUtil;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.Dimensions;
import com.amarsoft.sadre.rules.es.ESParser;
import com.amarsoft.sadre.rules.op.Operator;
import com.amarsoft.sadre.rules.op.OperatorFactory;
import com.amarsoft.sadre.rules.rpn.Expression;

 /**
 * <p>Title: Assumption.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-15 下午03:48:44
 *
 * logs: 1. 
 */
public class Assumption implements Serializable {

	private static final long serialVersionUID = 1L;
	
	/** left term of the assumption */
	private Dimension dimension;

	/** operator of the assumption; possible values: =,<,>,<=,>=,<> */
	private String operator;

	/** right term of the assumption */
	private String target;
	
	/**
	 * @param leftTerm
	 *            left term of the assumption
	 * @param operator
	 *            operator of the assumption; possible values: =,<,>,<=,>=,<>
	 * @param rightTerm
	 *            right term of the assumption
	 */
	public Assumption(Dimension dimension, String operator, String target) {
		this.dimension = dimension;
		this.operator = operator;
		this.target = target;
	}
	
	public Dimension belongDimension() {
		return dimension;
	}

	public String getOperator() {
		return operator;
	}

	public String getTarget() {
		return target;
	}
	
	public void setOperator(String operator) {
		this.operator = operator;
	}

	public void setTarget(String target) {
		this.target = target;
	}
	
//	public boolean doValidate(Hashtable<String,Object> workingMemory) throws SADREException{
//		
//	}
	
	/**
	 * 将维度条件原值与条件过结果比较
	 * @param sourceValue
	 * @return
	 * @throws SADREException
	 */
	public boolean doValidate(String sourceValue) throws SADREException{
		return doValidate(sourceValue, getTarget());
	}
	
	public boolean doValidate(Hashtable<String,Object> workingMemory) throws SADREException{
		return doValidate(workingMemory,null);
	}
	
	public boolean doValidate(Hashtable<String,Object> workingMemory, Writer out) throws SADREException{
		String sourceValue = this.dimension.calculateValue(workingMemory);		//经过了变量替换之后的比较源表达式
		String targetValue = ESParser.parseESValue(getTarget(), workingMemory);	//经过了变量替换之后的比较目标表达式 ${apply.getBusinessSum}*0.9 -> 100*0.9
		boolean validateIt = doValidate(sourceValue, targetValue);
		
		String displaySourceValue = sourceValue;
		//add xkqong 源维度中文对照 2012-09-11
		String sourcename = this.dimension.calculateSourceValue(workingMemory);
		if(sourcename == null) sourcename = displaySourceValue;
		//end
		if(this.dimension.getType()==Dimension.维度值类型_精度数){
			try{
				displaySourceValue = DecimalUtil.formatNumber(Double.valueOf(sourceValue));
			}catch(Exception e){
				ARE.getLog().trace(sourceValue+" not legal number.",e);
			}
		}
		ARE.getLog().trace(" >> "+this.dimension.getName()+" sourceValue="+displaySourceValue+" |op="+this.getOperator()+" |targetValue="+targetValue+" |result="+validateIt);
		//----------------------add at 2011-07-12 for 增加对jsp输出的支持
		try {
			if(out!=null){
				String ico="<img src=../../Resources/1/arrow.gif></img>";
				String message="";
			  if (validateIt && sourcename!=null){
				  message="<img src=../../Resources/1/alarm/icon7.gif></img>";
				  out.write("&nbsp;&nbsp;"+ico+" 维度规则:【"+this.dimension.getName()+"】为【"+sourcename+"】 "+message+"<br>");
			  }else {   
				  message="<img src=../../Resources/1/alarm/icon10.gif></img>";
				  out.write("&nbsp;&nbsp;"+ico+" 维度规则:【"+this.dimension.getName()+"】为【"+sourcename+"】 "+message+"<br>");
			  }
			}
		} catch (IOException e) {
			ARE.getLog().warn("日志信息输出有误!",e);
		}
		//----------------------add end
		
		return validateIt;
	}

	/**
	 * 维度条件表达式真伪判断
	 * @param sourceValue	比较源维度值
	 * @param workingMemory 
	 * @return
	 * @throws SADREException
	 */
	public boolean doValidate(String sourceValue, String targetValue) throws SADREException{
		
		Operator op = OperatorFactory.getOperator(getOperator());
		boolean validateIt = false;
		switch(this.dimension.getType()){
			case Dimension.维度值类型_整数型:
				try{
					//-------------------对于数学表达式进行转换计算
					if(targetValue.indexOf("+")!=-1
							||targetValue.indexOf("-")!=-1
							||targetValue.indexOf("*")!=-1
							||targetValue.indexOf("/")!=-1){
						targetValue = (String)Expression.getInstance(targetValue).getCalculateValue();
					}
					int srcInt = Integer.valueOf(sourceValue,10);
					int descInt = Integer.valueOf(targetValue,10);
					validateIt = op.validateInteger(srcInt, descInt);
					
				}catch(Exception e){
					ARE.getLog().error(e);
					throw new SADREException(e);
				}
				break;
			case Dimension.维度值类型_精度数:
				try{
					//-------------------对于数学表达式进行转换计算
					if(targetValue.indexOf("+")!=-1
							||targetValue.indexOf("-")!=-1
							||targetValue.indexOf("*")!=-1
							||targetValue.indexOf("/")!=-1){
						targetValue = (String)Expression.getInstance(targetValue).getCalculateValue();
					}
					
					double srcDouble = Double.valueOf(sourceValue);
					double descDouble = Double.valueOf(targetValue);
					validateIt = op.validateNumber(srcDouble, descDouble);
					
				}catch(Exception e){
					ARE.getLog().error(e);
					throw new SADREException(e);
				}
				
				break;
//			case Dimension.维度值类型_布尔值:
//				try {
//					validateIt = op.validateString(sourceValue, targetValue);
//				} catch (OperationNotSupportedException e) {
//					ARE.getLog().error(e);
//					throw new SADREException(e);
//				}
//				break;
			case Dimension.维度值类型_字符型:
				try {
					validateIt = op.validateString(sourceValue, targetValue);
				} catch (OperationNotSupportedException e) {
					ARE.getLog().error(e);
					throw new SADREException(e);
				}
				break;
		}
		
		
		return validateIt;
	}
	
	public String toString(){
		return "Assumption: ("+(dimension==null?"dimension_not_exists!":dimension.getId())+" "+getOperator()+" "+getTarget()+") ";
	}
	
	public boolean isAvailable(){
		return (dimension != null);
	}
	
	/**
	 * 根据授权维度类型返回其规则表达式中的目标描述<p>
	 * 举例：xxx in 14,01,13 -->  xxx 在...之中 美元,人民币
	 * @return
	 */
	public String getTargetDescription(Transaction Sqlca) throws Exception{
		String sDescription = "";
		if(this.dimension.getType()==Dimension.维度值类型_字符型){
			Hashtable<String,String> descTable = new Hashtable<String,String>();
//			PreparedStatement psmtCode = null;
			String[] codeList = null;
			String sItemNo = "";
			String sItemName = "";
			switch(dimension.getOptionType()){
				
				case Dimension.取值来源类型_SQL:
					
//					ARE.getLog().debug("sql:"+dimension.getOptionSource());
					//将指定sql转化为一个一维数组：偶数为值，奇数为显示值
					codeList = CodeManager.getItemArrayFromSql(dimension.getOptionSource());
					for(int i=0; i<codeList.length; i++){
						sItemNo = codeList[i];
						sItemName = codeList[++i];
//						ARE.getLog().debug("sItemNo="+sItemNo+" sItemName="+sItemName);
						descTable.put(sItemNo, sItemName);
					}
					
					break;
				case Dimension.取值来源类型_JSON:
					
					break;
				default:
					
//					ARE.getLog().debug("code:"+dimension.getOptionSource());
					if(dimension.getOptionSource()!=null && dimension.getOptionSource().trim().length()>0){
						//将指定代码转化为一个一维数组：偶数为值，奇数为显示值
						codeList = CodeManager.getItemArray(dimension.getOptionSource());
						for(int i=0; i<codeList.length; i++){
							sItemNo = codeList[i];
							sItemName = codeList[++i];
//							ARE.getLog().debug("sItemNo="+sItemNo+" sItemName="+sItemName);
							descTable.put(sItemNo, sItemName);
						}
					}
			}
			
			//-------字符型需要根据取值范围转换为中文
			String[] targetDef = this.target.split(",");
//			ARE.getLog().info("this.target="+this.target);
			for(int i=0; i<targetDef.length; i++){
				String temp = descTable.get(targetDef[i]);
				if(temp == null || temp.length()==0){
					sDescription += (","+targetDef[i]);
				}else{
					sDescription += (","+temp);
				}
			}
			if(sDescription.length()>0) sDescription = sDescription.substring(1);
			
		}else if(this.dimension.getType()==Dimension.维度值类型_精度数){
			if(target==null || target.length()==0){
				sDescription = this.target;
			}else if(target.indexOf("${")<0){
				//-------精度数转换为3位一逗
				sDescription = DataConvert.toMoney(this.target);
			}else{
				//-------针对金额表达式中的授权参数替换
				sDescription = pickupExpressionVar(this.target);
			}
			
		}else{
			//整数型/布尔型不做额外处理
			sDescription = this.target;
		}
		return sDescription;
	}
	
	/**
	 * 存储格式为"${default.getxxx}*0.1",需将其中的参数表达式替换为参数名称
	 * @param expression 参数表达式
	 * @return
	 */
	private String pickupExpressionVar(String expression){
		if(expression==null || expression.length()==0) return expression;
		
		StringBuffer sb = new StringBuffer();
		String var = "(\\$\\{[a-zA-Z0-9]+\\.[[a-zA-Z0-9]]+\\})";
		Pattern p = Pattern.compile(var);
		Matcher m = p.matcher(expression);
		while(m.find()){
			//System.out.println(expression+" - "+m.group(1));
			String pv = null;
			if(m.group(1)==null){
				continue;
			}else{
				pv = getDimensionName(m.group(1));
				if(pv==null) continue;
			}
			m.appendReplacement(sb,pv);
		}
		m.appendTail(sb);
		
		return sb.toString();	
	}
	
	private String getDimensionName(String impl){
		Iterator<Dimension> tk = Dimensions.getDimensions().values().iterator();
		while(tk.hasNext()){
			Dimension tmp = tk.next();
			if(tmp.getImpl().equalsIgnoreCase(impl)){
				return tmp.getName();
			}
		}
		return null;
	}
//	
//	public static void main(String[] args){
//		ARE.init();
//		SADREService.init();
//		
//		try {
//			Dimensions.getInstance().load();
//		} catch (SADREException e) {
//			e.printStackTrace();
//		}
//		
//		Assumption as = new Assumption(null,"","");
//		System.out.println(as.pickupExpressionVar("${defalut.getxxx}*0.1"));
//		System.out.println(as.pickupExpressionVar("1+${default.getCustomerType}*0.5"));
//		System.out.println(as.pickupExpressionVar("{$defalut.getxxx}"));
//		System.out.println(as.pickupExpressionVar("${defalut.getx.xx}"));
//		System.out.println(as.pickupExpressionVar("${defalutgetxxx}"));
//	}
}
