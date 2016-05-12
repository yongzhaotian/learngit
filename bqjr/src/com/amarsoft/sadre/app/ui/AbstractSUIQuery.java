/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2007 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.app.ui;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.sadre.app.ui.webo.Table;

 /**
 * @ AbstractSUIQuery.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-5 下午01:15:09
 *
 * logs: 1. 
 */
public abstract class AbstractSUIQuery implements SUIQuery {
	
	protected Table table = new Table(this.getClass().getSimpleName());
	
	protected Page CurPage;
	
	protected Transaction sqlca;
	
	protected String header = "";
	
	protected String url = "";
	
	protected Map<String,String> requestAttributes = new HashMap<String,String>();
	
	/**
	 * 生成的查询统计sql脚本
	 */
	protected String dynamicSql = "";
	
	/**
	 * 生成HTML脚本
	 */
	protected String htmlScript = "";
	
	protected boolean keyRadioFlag = true;

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.ISupportQuery#getDynamicSQL()
	 */
	public final String getDynamicSQL() {
		return dynamicSql;
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.ISupportQuery#generateHTMLScript()
	 */
	public String generateHTMLScript() throws IOException {
		table.updateKeyRadio(keyRadioFlag);		//是否生成radioflag
		return table.getHtmlScript(header);
	}
	
	public void executeQuery(Page page, Transaction to, String url) throws Exception{
		this.CurPage = page;
		this.sqlca = to;
		this.url = url;
		//table.setPropertie("style", "{overflow:scroll;overflow-x:visible;overflow-y:visible}");
		table.setPropertie("bgcolor", "#FFFFFF");
		table.setPropertie("border", "1");
		table.setPropertie("cellpadding", "1");
		table.setPropertie("cellspacing", "0");
		//table.setPropertie("cellspacing", "1");
		table.setPropertie("width", "95%");
		
		try {
			prepareRequest();
		} catch (Exception e) {
			ARE.getLog().debug(e);
			clearResource();
			throw new Exception("初始化查询参数失败!");
		}
		
		drawHeader();
		
		try {
			doQuery(url);
		} catch (Exception e) {
			ARE.getLog().debug(e);
			clearResource();
			throw new Exception("统计查询处理失败!");
		}
		
		clearResource();
	}
	
	/**
	 * 获取代码名称
	 * @param no
	 * @param code
	 * @return
	 * @throws Exception
	 */
	public String getCodeName(String code,String no, Transaction sqlca) throws Exception{
		if(no==null || no.length()==0) return "";
		//String codeName = this.sqlca.getString("select ItemName from CODE_LIBRARY where ItemNo='"+no+"' and CodeNo='"+code+"'");
		String codeName = CodeManager.getItemName(code, no);
		return codeName;
	}
	
	abstract public void drawHeader();
	
	abstract public void prepareRequest() throws Exception;
	
	abstract public void doQuery(String url) throws Exception;
	
	abstract public void clearResource();
	
	public void updateKeyRadio(boolean flag){
		keyRadioFlag = flag;
	}
	
	public void setRequestAttribute(String attrId,String attrValue){
		requestAttributes.put(attrId.toUpperCase(), attrValue);
	}
	
	public int getReqestAttributesCount(){
		return requestAttributes.size();
	}
	
	public boolean containsAttribute(String name){
		//ARE.getLog().debug("requestAttributes="+requestAttributes);
		return requestAttributes.containsKey(name.toUpperCase());
	}
	
	public String getAttributeValue(String name){
		if(containsAttribute(name)){
			return requestAttributes.get(name.toUpperCase()).toString();
		}
		return null;
	}
	
	public String getRequest(String paramName) throws Exception{
		String pValue = "";
		if(containsAttribute(paramName)){
			pValue = getAttributeValue(paramName);
		}else{
			pValue = this.CurPage.getParameter(paramName);
		}
		return DataConvert.toString(pValue);
	}
	
	public Table getTable(){
		return table;
	}
	
}
