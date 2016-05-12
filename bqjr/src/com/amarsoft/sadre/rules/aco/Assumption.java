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
 * @date 2011-4-15 ����03:48:44
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
	 * ��ά������ԭֵ������������Ƚ�
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
		String sourceValue = this.dimension.calculateValue(workingMemory);		//�����˱����滻֮��ıȽ�Դ���ʽ
		String targetValue = ESParser.parseESValue(getTarget(), workingMemory);	//�����˱����滻֮��ıȽ�Ŀ����ʽ ${apply.getBusinessSum}*0.9 -> 100*0.9
		boolean validateIt = doValidate(sourceValue, targetValue);
		
		String displaySourceValue = sourceValue;
		//add xkqong Դά�����Ķ��� 2012-09-11
		String sourcename = this.dimension.calculateSourceValue(workingMemory);
		if(sourcename == null) sourcename = displaySourceValue;
		//end
		if(this.dimension.getType()==Dimension.ά��ֵ����_������){
			try{
				displaySourceValue = DecimalUtil.formatNumber(Double.valueOf(sourceValue));
			}catch(Exception e){
				ARE.getLog().trace(sourceValue+" not legal number.",e);
			}
		}
		ARE.getLog().trace(" >> "+this.dimension.getName()+" sourceValue="+displaySourceValue+" |op="+this.getOperator()+" |targetValue="+targetValue+" |result="+validateIt);
		//----------------------add at 2011-07-12 for ���Ӷ�jsp�����֧��
		try {
			if(out!=null){
				String ico="<img src=../../Resources/1/arrow.gif></img>";
				String message="";
			  if (validateIt && sourcename!=null){
				  message="<img src=../../Resources/1/alarm/icon7.gif></img>";
				  out.write("&nbsp;&nbsp;"+ico+" ά�ȹ���:��"+this.dimension.getName()+"��Ϊ��"+sourcename+"�� "+message+"<br>");
			  }else {   
				  message="<img src=../../Resources/1/alarm/icon10.gif></img>";
				  out.write("&nbsp;&nbsp;"+ico+" ά�ȹ���:��"+this.dimension.getName()+"��Ϊ��"+sourcename+"�� "+message+"<br>");
			  }
			}
		} catch (IOException e) {
			ARE.getLog().warn("��־��Ϣ�������!",e);
		}
		//----------------------add end
		
		return validateIt;
	}

	/**
	 * ά���������ʽ��α�ж�
	 * @param sourceValue	�Ƚ�Դά��ֵ
	 * @param workingMemory 
	 * @return
	 * @throws SADREException
	 */
	public boolean doValidate(String sourceValue, String targetValue) throws SADREException{
		
		Operator op = OperatorFactory.getOperator(getOperator());
		boolean validateIt = false;
		switch(this.dimension.getType()){
			case Dimension.ά��ֵ����_������:
				try{
					//-------------------������ѧ���ʽ����ת������
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
			case Dimension.ά��ֵ����_������:
				try{
					//-------------------������ѧ���ʽ����ת������
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
//			case Dimension.ά��ֵ����_����ֵ:
//				try {
//					validateIt = op.validateString(sourceValue, targetValue);
//				} catch (OperationNotSupportedException e) {
//					ARE.getLog().error(e);
//					throw new SADREException(e);
//				}
//				break;
			case Dimension.ά��ֵ����_�ַ���:
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
	 * ������Ȩά�����ͷ����������ʽ�е�Ŀ������<p>
	 * ������xxx in 14,01,13 -->  xxx ��...֮�� ��Ԫ,�����
	 * @return
	 */
	public String getTargetDescription(Transaction Sqlca) throws Exception{
		String sDescription = "";
		if(this.dimension.getType()==Dimension.ά��ֵ����_�ַ���){
			Hashtable<String,String> descTable = new Hashtable<String,String>();
//			PreparedStatement psmtCode = null;
			String[] codeList = null;
			String sItemNo = "";
			String sItemName = "";
			switch(dimension.getOptionType()){
				
				case Dimension.ȡֵ��Դ����_SQL:
					
//					ARE.getLog().debug("sql:"+dimension.getOptionSource());
					//��ָ��sqlת��Ϊһ��һά���飺ż��Ϊֵ������Ϊ��ʾֵ
					codeList = CodeManager.getItemArrayFromSql(dimension.getOptionSource());
					for(int i=0; i<codeList.length; i++){
						sItemNo = codeList[i];
						sItemName = codeList[++i];
//						ARE.getLog().debug("sItemNo="+sItemNo+" sItemName="+sItemName);
						descTable.put(sItemNo, sItemName);
					}
					
					break;
				case Dimension.ȡֵ��Դ����_JSON:
					
					break;
				default:
					
//					ARE.getLog().debug("code:"+dimension.getOptionSource());
					if(dimension.getOptionSource()!=null && dimension.getOptionSource().trim().length()>0){
						//��ָ������ת��Ϊһ��һά���飺ż��Ϊֵ������Ϊ��ʾֵ
						codeList = CodeManager.getItemArray(dimension.getOptionSource());
						for(int i=0; i<codeList.length; i++){
							sItemNo = codeList[i];
							sItemName = codeList[++i];
//							ARE.getLog().debug("sItemNo="+sItemNo+" sItemName="+sItemName);
							descTable.put(sItemNo, sItemName);
						}
					}
			}
			
			//-------�ַ�����Ҫ����ȡֵ��Χת��Ϊ����
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
			
		}else if(this.dimension.getType()==Dimension.ά��ֵ����_������){
			if(target==null || target.length()==0){
				sDescription = this.target;
			}else if(target.indexOf("${")<0){
				//-------������ת��Ϊ3λһ��
				sDescription = DataConvert.toMoney(this.target);
			}else{
				//-------��Խ����ʽ�е���Ȩ�����滻
				sDescription = pickupExpressionVar(this.target);
			}
			
		}else{
			//������/�����Ͳ������⴦��
			sDescription = this.target;
		}
		return sDescription;
	}
	
	/**
	 * �洢��ʽΪ"${default.getxxx}*0.1",�轫���еĲ������ʽ�滻Ϊ��������
	 * @param expression �������ʽ
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
