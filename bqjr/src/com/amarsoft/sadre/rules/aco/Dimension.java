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

import java.util.Hashtable;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.rules.es.ESParser;
import com.amarsoft.sadre.rules.op.Operator;
import com.amarsoft.web.ui.HTMLControls;

 /**
 * <p>Title: Dimension.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-15 上午11:42:18
 *
 * logs: 1. 
 */
public class Dimension {
	
	public static final int 维度值类型_字符型 	= 0;
	public static final int 维度值类型_整数型 	= 1;
	public static final int 维度值类型_精度数 	= 2;
//	public static final int 维度值类型_布尔值 	= 3;
	
//	public static final int 维度源类型_POJO 			= 0;
//	public static final int 维度源类型_BIZLET		= 1;
//	public static final int 维度源类型_AMARSCRIPT 	= 2;
	
	public static final int 取值来源类型_CODE 	= 0;
	public static final int 取值来源类型_SQL		= 1;
	public static final int 取值来源类型_JSON 	= 2;
	public static final int 取值来源类型_无 		= -1;
	
	private String id;
	private String name;
	private String impl;
	private int type		= 维度值类型_字符型;
//	private int sourceType	= 维度源类型_POJO;
//	private String args;		//变量序列
	private int optionType;			//取值范围类型
	private String optionSource;		//取值范围定义
//	private String runtimeName;
//	private String binding;
	//add xqkong
	private String sourceimpl;
	//end
	
	public String getSourceimpl() {
		return sourceimpl;
	}

	public void setSourceimpl(String sourceimpl) {
		this.sourceimpl = sourceimpl;
	}

	public Dimension(String id,String name){
		this.id = id;
		this.name = name;
	}
	
	public int getOptionType() {
		return optionType;
	}

	public void setOptionType(String optionType) {
		if(optionType==null || optionType.length()==0) return;
		
		if(optionType.equalsIgnoreCase("sql")){
			setOptionType(取值来源类型_SQL);
		}else if(optionType.equalsIgnoreCase("json")){
			setOptionType(取值来源类型_JSON);
		}else if(optionType.equalsIgnoreCase("code")){
			setOptionType(取值来源类型_CODE);
		}else {
			setOptionType(取值来源类型_无);
		}
	}
	
//	public String getRuntimeName() {
//		return runtimeName;
//	}
//
//	public void setRuntimeName(String runtimeName) {
//		this.runtimeName = runtimeName;
//	}
//
//	public String getBinding() {
//		return binding;
//	}
//
//	public void setBinding(String binding) {
//		this.binding = binding;
//	}

	public void setOptionType(int optionType) {
		this.optionType = optionType;
	}

	public String getOptionSource() {
		return optionSource==null?"":optionSource.trim();
	}

	public void setOptionSource(String optionSource) {
		this.optionSource = optionSource;
	}

//	public String getArgs() {
//		return args;
//	}
//
//	public void setArgs(String args) {
//		this.args = args;
//	}
//
//	public int getSourceType() {
//		return sourceType;
//	}
//
//	private void setSourceType(int source) {
//		this.sourceType = source;
//	}
//	
//	public void setSourceType(String source) {
//		if(source.equalsIgnoreCase("Bizlet")){
//			setSourceType(维度源类型_BIZLET);
//		}else if(source.equalsIgnoreCase("AmarScript")){
//			setSourceType(维度源类型_AMARSCRIPT);
//		}else {
//			setSourceType(维度源类型_POJO);
//		}
//	}

	public int getType() {
		return type;
	}

	private void setType(int type) {
		this.type = type;
	}
	
	public void setType(String type) {
		if(type.equalsIgnoreCase("Integer")){
			setType(维度值类型_整数型);
		}else if(type.equalsIgnoreCase("Number")){
			setType(维度值类型_精度数);
//		}else if(type.equalsIgnoreCase("Boolean")){
//			setType(维度值类型_布尔值);
		}else {
			setType(维度值类型_字符型);
		}
	}

	public String getImpl() {
		return impl;
	}
	
	public void setImpl(String impl) {
		this.impl = impl;
	}

	public String getId() {
		return id;
	}

	public String getName() {
		return name;
	}
	
	/**
	 * 
	 * @return
	 * @throws SADREException 
	 */
	public String calculateValue(Hashtable<String,Object> workingMemory) throws SADREException{
		String calcValue = null;
//		switch(getSourceType()){
//			case 维度源类型_BIZLET:
//				
//				break;
//			case 维度源类型_AMARSCRIPT:
//				
//				break;
//			case 维度源类型_POJO:
				calcValue = ESParser.parseESValue(getImpl(), workingMemory);
//				break;
//		}
		
		return calcValue;
	}
	
	/**
	 * add xqkong
	 * calculateSourceValue
	 * @return
	 * @throws SADREException 
	 */
	public String calculateSourceValue(Hashtable<String,Object> workingMemory) throws SADREException{
		String calcValue = null;
//		switch(getSourceType()){
//			case 维度源类型_BIZLET:
//				
//				break;
//			case 维度源类型_AMARSCRIPT:
//				
//				break;
//			case 维度源类型_POJO:
				calcValue = ESParser.parseESValue(getSourceimpl(), workingMemory);
//				break;
//		}
		
		return calcValue;
	}
	public String toString(){
		return "Dimension:id="+getId()+"|name="+getName()+"|type="+getType()+"|impl="+this.getImpl()+" "+getOptionType()+" / "+getOptionSource();
	}
	
	public String getHTMLScript(Transaction sqlca) throws Exception{
		return getHTMLScript(null, sqlca);
	}
	
	/**
	 * 返回该维度的HTML描述,用于动态生成维度条件
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String getHTMLScript(Assumption assumption,Transaction sqlca) throws Exception{
		boolean isNewOne = (assumption==null);
		StringBuffer HTMLScript = new StringBuffer();
		HTMLScript.append("      <tr>");
		HTMLScript.append("        <td class=\"titw2\">").append(this.getName()).append("</td>");
		HTMLScript.append("        <td class=\"titw1\"><select class=\"sel1\" name=\"sadre_op_"+this.getId()+"\" id=\"sadre_op_"+this.getId()+"\">");
//		ARE.getLog().info(".............0="+this.getId()+" rule="+rule);
		
//ARE.getLog().info(".............1");	
		//-----------根据类型控制下拉框的选项,并赋值
		switch(this.getType()){
			case Dimension.维度值类型_字符型:
//				HTMLScript.append(new ComboBox("OperatorType",sqlca,
//						"select ItemNo,ItemName from CODE_LIBRARY where CodeNo='AssumptionOperator' and trim(Attribute1) in ('String','All') order by SortNo",
//						1,2,isNewOne?Operator.忽略:assumption.getOperator()).getOptionString());
				HTMLScript.append(HTMLControls.generateDropDownSelect(sqlca, 
						"select ItemNo,ItemName from CODE_LIBRARY where CodeNo='AssumptionOperator' and trim(Attribute1) in ('String','All') order by SortNo", 
						1, 2, isNewOne?Operator.忽略:assumption.getOperator()));

				break;
			case Dimension.维度值类型_整数型:
			case Dimension.维度值类型_精度数:
//				HTMLScript.append(new ComboBox("OperatorType",sqlca,
//						"select ItemNo,ItemName from CODE_LIBRARY where CodeNo='AssumptionOperator' and trim(Attribute1) in ('Number','All') order by SortNo",
//						1,2,isNewOne?Operator.忽略:assumption.getOperator()).getOptionString());
				HTMLScript.append(HTMLControls.generateDropDownSelect(sqlca, 
						"select ItemNo,ItemName from CODE_LIBRARY where CodeNo='AssumptionOperator' and trim(Attribute1) in ('Number','All') order by SortNo", 
						1, 2, isNewOne?Operator.忽略:assumption.getOperator()));

				break;
			default:
//				HTMLScript.append(new ComboBox("OperatorType",sqlca,
//						"select ItemNo,ItemName from CODE_LIBRARY where CodeNo='AssumptionOperator' and ItemNo='eq'",
//						1,2,isNewOne?Operator.忽略:assumption.getOperator()).getOptionString());
				HTMLScript.append(HTMLControls.generateDropDownSelect(sqlca, 
						"select ItemNo,ItemName from CODE_LIBRARY where CodeNo='AssumptionOperator' and ItemNo='eq'", 
						1, 2, isNewOne?Operator.忽略:assumption.getOperator()));
	
		}
		HTMLScript.append("        </select></td>");
//ARE.getLog().info(".............2="+(this.getType()+" = "+Dimension.维度值类型_字符型)+" | "+(this.getOptionType()+" = "+Dimension.取值来源类型_无)+" | "+(this.getOptionSource().length()));
		//-------------控制字符串类型时的弹出选择项控制:当有取值范围时,通过弹出对话框选择的方式赋值
		if(this.getType()==Dimension.维度值类型_字符型
				&& this.getOptionType()!=Dimension.取值来源类型_无
				&& this.getOptionSource().length()>0){
			//----------当出现选择框时sadre_text_xxx作为隐藏域
			HTMLScript.append("    <td><input name=\"sadre_value_"+this.getId()+"\" type=\"hidden\" id=\"sadre_value_"+this.getId()+"\" value=\"").append(isNewOne?"":assumption.getTarget()).append("\"/>");
			//----------新增textarea显示名称,并提供选择按钮
			HTMLScript.append("        <textarea name=\"name_text_"+this.getId()+"\" id=\"name_text_"+this.getId()+"\" class=\"texta2\" cols=\"40\" rows=\"4\" style=\"overflow:auto\" readonly=\"readonly\">").append(isNewOne?"":assumption.getTargetDescription(sqlca)).append("</textarea>");
			HTMLScript.append("	</td>");
			HTMLScript.append("	<td>");
			HTMLScript.append("		<input type=\"button\" class=\"btncss3\" name=\"button_v"+this.getId()+"\" value=\"...\" onclick=\"javascript:doSelection('"+this.getId()+"')\"/>");
			HTMLScript.append("	</td>");
			
		}else{
			HTMLScript.append(" <td><input name=\"sadre_value_"+this.getId()+"\" type=\"text\" id=\"sadre_value_"+this.getId()+"\" value=\"").append(isNewOne?"":assumption.getTarget()).append("\" size=\"40\" /></td>");
			//add 变量表达式引入 at 20120223
			HTMLScript.append("	<td>");
			HTMLScript.append("		<input type=\"button\" class=\"btncss3\" name=\"button_n"+this.getId()+"\" value=\"<<<\" onclick=\"javascript:doImportVar('"+this.getId()+"')\"/>");
			HTMLScript.append("	</td>");
		}
		
		HTMLScript.append("        </tr>");
		
		return HTMLScript.toString();
	}
}
