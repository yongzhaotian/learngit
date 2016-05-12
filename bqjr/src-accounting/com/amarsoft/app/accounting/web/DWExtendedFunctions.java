package com.amarsoft.app.accounting.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.control.model.Parameter;
import com.amarsoft.web.dw.ASDataObject;
import com.amarsoft.context.ASUser;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
import com.amarsoft.web.dw.ASColumn;
import com.amarsoft.web.dw.ASDataWindow;

/**
 * 用于实现显示模板一些个性化功能
 * @author ygwang
 *
 */
public class DWExtendedFunctions {
	
	public static String setDataWindowValues(BusinessObject rootObject,BusinessObject businessobject,ASDataWindow dwTemp,Transaction Sqlca) throws Exception{
		ArrayList<BusinessObject> list=new ArrayList<BusinessObject>();
		if(businessobject!=null) list.add(businessobject);
		return DWExtendedFunctions.setDataWindowValues(rootObject,list, dwTemp,Sqlca);
	}
	
	public static ASValuePool getDataObjectLibrary(String templetNo,Transaction sqlca) throws Exception{
		ASValuePool t=new ASValuePool();
		String sql1 = "select * from DATAOBJECT_LIBRARY where dono=:dono ";
		ASResultSet rs= sqlca.getASResultSet(new SqlObject(sql1).setParameter("dono", templetNo));
		while(rs.next()){
			ASValuePool c=new ASValuePool();
			c.setAttribute("ColName", rs.getString("ColName"));
			c.setAttribute("Attribute1", rs.getString("Attribute1"));
			t.setAttribute(rs.getString("ColName"), c);
		}
		rs.getStatement().close();
		return t;
	}
	
	public static String setDataWindowValues(BusinessObject rootObject,List<BusinessObject> businessobjectList,ASDataWindow dwTemp,Transaction Sqlca) throws Exception{
		if(businessobjectList==null||businessobjectList.isEmpty())return "";
		ASValuePool dwvaluePool = DWExtendedFunctions.getDataObjectLibrary(dwTemp.DataObject.getDoNo(), Sqlca);
		StringBuffer sb=new StringBuffer();
		
		int i=0;
		for(BusinessObject businessObject:businessobjectList){
			sb.append("DZ[i][2]["+i+"]=new Array(");
			for(Iterator itColumns = dwTemp.DataObject.Columns.iterator();itColumns.hasNext();){
				
				ASColumn column = (ASColumn) itColumns.next();
				String value="",name=((column.getItemName() == null || "".equals(column.getItemName())) ? column.getActualName() : column.getItemName());
				
				//从扩展属性中获取
				String newValue="";
				ASValuePool c=(ASValuePool)dwvaluePool.getAttribute(name);
				if(c!=null){
					String attribute1=c.getString("Attribute1");
					if(attribute1!=null&&attribute1.length()>0){
						String[] s=attribute1.split(";");
						ASValuePool m=new ASValuePool();
						for(String s1:s){
							String[] ss=s1.split("=");
							m.setAttribute(ss[0], ss[1]);
						}
						String valueScript=m.getString("Value");
						if(valueScript!=null&&valueScript.length()>0){
							try{
								newValue=ExtendedFunctions.getScriptValue(valueScript,rootObject,Sqlca).toStringValue();
							}
							catch(Exception e){
								try{
									newValue=ExtendedFunctions.getScriptValue(valueScript,businessObject,Sqlca).toStringValue();
								}
								catch(Exception e1){
									throw new Exception(new Exception(valueScript+"定义错误，"+e1.getMessage()));
								}
							}
							
						}
						
						if(m.getString("CodeNo")!=null&&m.getString("CodeNo").length()>0){
							String itemColName=m.getString("AttributeID");
							newValue=CodeCache.getItemName(m.getString("CodeNo"), businessObject.getString(itemColName));
						}
						String visible=m.getString("Visible");
						if(visible!=null&&visible.length()>0){
							if(visible.equalsIgnoreCase("TRUE"))
								dwTemp.DataObject.setVisible(column.getItemName(), true);
							else {
								dwTemp.DataObject.setVisible(column.getItemName(), false);
								dwTemp.DataObject.setRequired(column.getItemName(), false);
							}
						}
					}
				}
				
				
				String checkFormat = column.getAttribute("CheckFormat");
				if((checkFormat.startsWith("1")&&checkFormat.length()>1)||checkFormat.equals("2")){//小数
					if(newValue==null||newValue.length()==0)
						value = String.valueOf(businessObject.getDouble(name));
					else value = newValue;
					if(value == null || value.length()==0)
						value = String.valueOf(rootObject.getDouble(name));
				}
				else if(checkFormat.equals("5")){//整数
					if(newValue==null||newValue.length()==0)
						value = String.valueOf(businessObject.getInt(name));
					else value = newValue;
					
					if(value == null || value.length()==0)
						value = String.valueOf(rootObject.getInt(name));
				}
				else{
					if(newValue==null||newValue.length()==0)
						value = businessObject.getString(name);
					else value = newValue;
					if(value == null || value.length()==0)
						value = rootObject.getString(name);
					if(value!=null) value="'"+value+"'";
				}

				if(itColumns.hasNext()){
					sb.append(value+",");
				}
				else sb.append(value);
				
			}
			sb.append(");");
			i++;
		}
		
		return sb.toString();
	}
	
	private static String genDataWindowControlScript(ASValuePool term,ASDataWindow dwTemp,int rownum) throws Exception{
		StringBuffer sb=new StringBuffer();
		String rightType = (String)dwTemp.CurComp.getAttribute("RightType",10);
		if(rightType == null) rightType = "All";
		ASValuePool termPara = (ASValuePool)term.getAttribute("TermParameters");// 得到PRODUCT_term_para表
		Object[] para_keys=termPara.getKeys();
		for(int k=0;k<para_keys.length;k++){
			String paraID = (String)para_keys[k];//term_para的ParaID
			String accountControl = ProductConfig.getTermParameterAttribute(term, paraID, "APermission");
			String valueList = ProductConfig.getTermParameterAttribute(term, paraID, "ValueList");
			String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//字段关联对象属性
			if(refAttributeID==null||refAttributeID.length()==0) continue;
			String[] ars = refAttributeID.split(",");
			for(int n=0;n<ars.length;n++){
				String str1 = ars[n];
				String attributeID = str1.substring(str1.lastIndexOf(".")+1,str1.length());
				ASColumn column = dwTemp.DataObject.getColumn(attributeID);
				if(column==null) continue;
				//1.控制是否只读和可见
				if("Hide".equals(accountControl)){
					//dwTemp.DataObject.setVisible(attributeID, false);
					if(!"ReadOnly".equals(rightType))
					{
						sb.append("try{setItemReadOnly(0,"+rownum+",'"+column.getItemName()+"',true);\r\n}catch(e){}");
						sb.append("try{setItemDisabled(0,"+rownum+",'"+column.getItemName()+"',true);\r\n}catch(e){}");
					}
				}
				else if("ReadOnly".equals(accountControl)){
					dwTemp.DataObject.setVisible(attributeID, true);
					if(!"ReadOnly".equals(rightType))
					{
						sb.append("try{setItemReadOnly(0,"+rownum+",'"+column.getItemName()+"',true);\r\n}catch(e){}");
						sb.append("try{setItemDisabled(0,"+rownum+",'"+column.getItemName()+"',true);\r\n}catch(e){}");
					}
				}
				else if("Required".equals(accountControl)){
					dwTemp.DataObject.setVisible(attributeID, true);
					if(!"ReadOnly".equals(rightType))
					{
						sb.append("try{setItemRequired(0,"+rownum+",'"+column.getItemName()+"',true);\r\n}catch(e){}");
						sb.append("try{setItemReadOnly(0,"+rownum+",'"+column.getItemName()+"',false);\r\n}catch(e){}");
						sb.append("try{setItemDisabled(0,"+rownum+",'"+column.getItemName()+"',false);\r\n}catch(e){}");
					}
				}
				else if("All".equals(accountControl)){
					dwTemp.DataObject.setVisible(attributeID, true);
					if(!"ReadOnly".equals(rightType))
					{
						sb.append("try{setItemReadOnly(0,"+rownum+",'"+column.getItemName()+"',false);\r\n}catch(e){}");
						sb.append("try{setItemDisabled(0,"+rownum+",'"+column.getItemName()+"',false);\r\n}catch(e){}");
					}
				}
				//2.如果是选项，则根据valueList进行过滤，暂未实现，因为同一字段，不同记录的选项可能有差异。datawindow只能按列设置，不能针对记录设定格式，所以无法实现这个功能。
				String colEditStyle = column.getAttribute("EditStyle");
				String colEditSource = column.getAttribute("EditSource");
				StringBuffer opinion = new StringBuffer();
				if("2".equals(colEditStyle) && colEditSource!=null && colEditSource.startsWith("Code") && valueList != null && !"".equals(valueList))
				{
					Item[] items = CodeCache.getItems(colEditSource.replaceAll("Code:", ""));
					for(Item item:items)
					{
						if(valueList.indexOf(item.getItemNo()) >=0)
						{
							opinion.append(item.getItemNo()+","+item.getItemName()+",");
						}
					}
					String s = opinion.toString();
					if(s!=null && s.length() > 1) s = s.substring(0, s.length()-1);
					sb.append("try{setItemOption(0,"+rownum+",'"+column.getItemName()+"','"+s+"');\r\n}catch(e){}");
				}
			}
		}
		return sb.toString();
	}
		
	public static String genDataWindowControlScript(ASValuePool term,ASDataWindow dwTemp) throws Exception{
		String termID = term.getString("TermID");
		String setFlag = term.getString("SetFlag");
		StringBuffer sb=new StringBuffer();
		
		if(setFlag.equalsIgnoreCase("SET")){//组合组件
			List<ASValuePool> termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
			if(termRelativeList==null||termRelativeList.isEmpty())
				throw new Exception("未找到组合组件{"+termID+"}的子组件，请确认组件定义是否正确！");
			
			int rownum=0;
			for(ASValuePool termRelationShip:termRelativeList){
				ASValuePool relativeTerm = ProductConfig.getTerm(term.getString("ObjectType"), term.getString("ObjectNo"), termRelationShip.getString("RelativeTermID"));
				String segNo = relativeTerm.getString("SEGNo");
				//因为SEGNo在组件中没有配置，因此先用rowNum++;
				rownum++;
				//try{
				//	rownum=Integer.parseInt(segNo);
				//	if(rownum<=0) continue;
				//}
				//catch(Exception e){
				//	continue;
				//}
				sb.append(genDataWindowControlScript(relativeTerm,dwTemp,rownum-1));//此处递归调用
			}
			sb.append(genDataWindowControlScript(term,dwTemp,999));//此处递归调用
		}
		else if(setFlag.equalsIgnoreCase("BAS")){//单一组件，获取所有参数
			sb.append(genDataWindowControlScript(term,dwTemp,0));//此处递归调用
		}
		return sb.toString();
	}
	
	public static String getDWDockHTMLTemplate(String templetNo,String templetFilter, Transaction Sqlca) throws Exception{
		if(templetFilter==null||templetFilter.trim().length()==0)templetFilter=" 1=1";
		StringBuffer HTMLTemplate =  new StringBuffer();
		HTMLTemplate.append("<table  width='100%'>");
		HTMLTemplate.append("<tr><td>${DOCK:default}</td></tr>");
		ASResultSet rs = Sqlca.getASResultSet("select * from DATAOBJECT_GROUP where DoNo='"+templetNo+"' and ("+templetFilter+") " +
				" and (DockType='frame' or exists(select 1 from DATAOBJECT_LIBRARY where DoNo='"+templetNo+"' and ("+templetFilter+") and ColVisible='1' and DATAOBJECT_LIBRARY.DockID=DATAOBJECT_GROUP.DockID)) order by SortNo");
		while(rs.next()){
			String dockID=rs.getString("DockID");
			String dockName=rs.getString("DockName");
			String sStyle=rs.getString("StyleID");
			if(dockName==null||dockName.length()==0)dockName="";
			String dockType=rs.getString("DockType");
			HTMLTemplate.append("<tr><td><div id='ContentFrame_"+dockID+"' style='"+sStyle+"'><fieldset><legend class=rrr><em><font color=blue><b>"+dockName+"</b></font></em></legend>${DOCK:"+dockID+"}");
			if(dockType!=null&&dockType.length()>0&&dockType.equalsIgnoreCase("frame")){
				HTMLTemplate.append("");
				HTMLTemplate.append("<iframe id=\""+dockID+"\" name=\""+dockID+"\" src=\"\" style='"+sStyle+"' scrolling=auto frameborder=1></iframe>");
				HTMLTemplate.append("");
			}
			HTMLTemplate.append("</fieldset></div></td></tr>");
		}
		rs.getStatement().close();

		HTMLTemplate.append("</table>");
		return HTMLTemplate.toString();
	}
	
	public static String getDWDockHTMLTemplate(String templetNo,Transaction Sqlca) throws Exception{
		return getDWDockHTMLTemplate(templetNo,"",Sqlca);
	}
	
	public static void exinitASDataObject(ASDataWindow dwTemp,Page curPage,ASValuePool valuePool,Transaction sqlca, ASUser user) throws Exception{
		//1.替换sql选择框的参数，以支持选择范围根据传入参数自动调整
	    for (int i = 0; i < dwTemp.DataObject.Columns.size(); ++i){
	    	ASColumn column = (ASColumn) dwTemp.DataObject.Columns.get(i);
	    	
	    	String editStyle = column.getAttribute("EditStyle");
	    	if(editStyle!=null&&(editStyle.equals("2")||editStyle.equals("5"))) {;//如果不为选择框
		    	String editSource = column.getAttribute("EditSource");
		    	if(editSource==null||!editSource.toUpperCase().startsWith("SQL:")) {
		    		//continue;//如果不为Sql
		    	}
		    	else{
			    	//替换参数，以避免目前无法传入参数的情况，优先使用传入的参数，否则使用page参数，最后使用comp参数替换
			    	editSource = ExtendedFunctions.replaceAllIgnoreCase(editSource, valuePool);
			    	editSource = replaceAllIgnoreCase(editSource, curPage,user);
			    	column.setAttribute("EditSource",editSource);
		    	}
	    	}
	    	//2.设置默认值
	    	String colDefaultValue = column.getAttribute("DefaultValue");
	    	if(colDefaultValue!=null&&colDefaultValue.startsWith("${")){
	    		colDefaultValue = ExtendedFunctions.replaceAllIgnoreCase(colDefaultValue, valuePool);
	    		colDefaultValue = replaceAllIgnoreCase(colDefaultValue, curPage,user);
	    		column.setAttribute("DefaultValue",colDefaultValue);
	    	}
	    	//3.替换选择按钮传入的参数
	    	String colUnit = column.getAttribute("Unit");
	    	if(colUnit==null) colUnit="";
	    	if(colUnit.indexOf("${")>=0){
	    		colUnit = ExtendedFunctions.replaceAllIgnoreCase(colUnit, valuePool);
	    		colUnit = replaceAllIgnoreCase(colUnit,curPage,user);
	    		column.setAttribute("Unit",colUnit);
	    	}
	    	//4.替换html，主要指onchange事件等
	    	String htmlStyle = column.getAttribute("HTMLStyle");
	    	if(htmlStyle==null) htmlStyle="";
	    	if(htmlStyle.indexOf("${")>=0){
	    		htmlStyle = ExtendedFunctions.replaceAllIgnoreCase(htmlStyle, valuePool);
	    		htmlStyle = replaceAllIgnoreCase(htmlStyle,curPage,user);
	    		column.setAttribute("HTMLStyle",htmlStyle);
	    	}
	    	
	    	
	    }
	    //2.设置group样式
	    dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(dwTemp.DataObject.getDoNo(),"",sqlca));
	}
	
	public static String replaceAllIgnoreCase(String s1, Page curPage, ASUser user)
			throws Exception {
		s1 = s1.trim();
		if(s1.indexOf("${")<0) return s1;
		for (int i = 0; i < curPage.getParameterList().size(); ++i) {
			Parameter tmpPara = (Parameter)curPage.parameterList.get(i);
			if(tmpPara.paraValue == null) tmpPara.paraValue = "";
			String value=tmpPara.paraValue.toString();
			s1 = ExtendedFunctions.replaceAllIgnoreCase(s1,"${"+tmpPara.paraName+"}",value);
		}
		if(s1.indexOf("${")<0) return s1;
		if(curPage.getCurComp()==null) return s1;
		return replaceAllIgnoreCase(s1, curPage.getCurComp(),user);
	}
	
	public static String replaceAllIgnoreCase(String s1, Component curComp, ASUser user)
			throws Exception {
		if(s1==null||s1.length()<=0) return s1;
		s1 = s1.trim();
		if(s1.indexOf("${")<0) return s1;
		
		s1=ExtendedFunctions.replaceAllIgnoreCase(s1,"${CurUserID}",user.getUserID());
		s1=ExtendedFunctions.replaceAllIgnoreCase(s1,"${CurOrgID}",user.getOrgID());
		if(s1.indexOf("${")<0) return s1;
		
		for (int i = 0; i < curComp.getParameterList().size(); ++i) {
			Parameter tmpPara = (Parameter)curComp.getParameterList().get(i);
			if(tmpPara.paraValue == null) tmpPara.paraValue = "";
			String value=tmpPara.paraValue.toString();
			s1 = ExtendedFunctions.replaceAllIgnoreCase(s1,"${"+tmpPara.paraName+"}",value);
		}
		return s1;
	}
	
	public static HashMap<String,String> getHeader(ASValuePool term) throws Exception{
		HashMap<String,String> header = new HashMap<String,String>();
		String termID = term.getString("TermID");
		String setFlag = term.getString("SetFlag");
		String termType = term.getString("TermType");
		List<ASValuePool> termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
		if(termRelativeList==null||termRelativeList.isEmpty())
			throw new Exception("未找到组合组件{"+termID+"}的子组件，请确认组件定义是否正确！");
		
		if(setFlag.equalsIgnoreCase("SET")){//组合组件
			for(ASValuePool termRelationShip : termRelativeList){
				ASValuePool relativeTerm = ProductConfig.getTerm(term.getString("ObjectType"), term.getString("ObjectNo"), termRelationShip.getString("RelativeTermID"));
				ASValuePool termPara = (ASValuePool)relativeTerm.getAttribute("TermParameters");// 得到PRODUCT_term_para表
				
				Object[] para_keys=termPara.getKeys();
				for(int k = 0; k < para_keys.length; k ++){
					String paraID = (String)para_keys[k];//term_para的ParaID
					String accountControl = ProductConfig.getTermParameterAttribute(relativeTerm, paraID, "APermission");
					String paraName = ProductConfig.getTermParameterAttribute(relativeTerm, paraID, "ParaName");
					String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//字段关联对象属性
					if(refAttributeID==null||refAttributeID.length()==0) continue;
					String[] ars = refAttributeID.split(",");
					String attributeID=null;
					for(int n  =0; n < ars.length; n ++){
						String parameter = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
						if(!ars[n].startsWith(parameter)) continue;
						String str1 = ars[n];
						attributeID = str1.substring(str1.lastIndexOf(".")+1,str1.length());
					}
					if(attributeID==null||("").equals(attributeID))	continue;
					if(!("").equals(accountControl)&&!"Hide".equals(accountControl)){
						header.put("\""+termRelationShip.getString("RelativeTermID")+"|"+attributeID+"\"",paraName);
					}
				}
			}
		}
		return header;
	}
	
	public static String getSelectHeaderSQL(String[][] header){
		if(header.length == 0)
			return "";
		String str = "select ";
		String para ="";
		for(int i = 0; i < header.length; i ++) {
			para = " '' as " + header[i][0] + "," + para;
		}
		para = para.substring(0, para.lastIndexOf(","));
		String from = " from system_setup";
		return str + para + from;
	}
	
	public static void exinitSETASDataWindow(ASValuePool term, ASDataWindow dwTemp, Transaction sqlca) throws Exception{			
		String str = " select ColEditStyle,ColEditSourceType,ColEditSource,ColDefaultValue,ColUnit," +
				"ColHTMLStyle,ColAlign,ColUpdateable,ColType,ColCheckFormat" +
				" from dataobject_library where dono=:DoNo";
		String termType = term.getString("TermType");
		String dono= ProductConfig.getTermTypeAttribute(termType, "InfoTempletNo");
		if(dono == null || dono.equals(""))
			return;
	    for (int i = 0; i < dwTemp.DataObject.Columns.size(); ++i){
	    	ASColumn column = (ASColumn) dwTemp.DataObject.Columns.get(i);
	    	String para = column.getItemName().substring(column.getItemName().indexOf("|")+1, column.getItemName().length()-1);
	    	SqlObject sql = new SqlObject(str + " and upper(colname)= '" + para.toUpperCase() + "'").setParameter("DoNo", dono);
	    	ASResultSet rs = sqlca.getASResultSet(sql);
	    	while(rs.next()){
	    		//1.设置EditStyle
		    	String editStyle = rs.getString("ColEditStyle");
		    	column.setAttribute("EditStyle", editStyle);
		    	//2.设置EditSourceType
		    	String editSourceType = rs.getString("ColEditSourceType");
		    	column.setAttribute("EditSourceType", editSourceType);
		    	//3.设置EditSource
		    	String editSource = rs.getString("ColEditSource");
		    	if(editSource != null && editSourceType.equals("Code")) {
		    		dwTemp.DataObject.setDDDWCode(column.getItemName(), editSource);
		    	}else if(editSourceType != null && editSourceType.equals("SQL")) {
		    		dwTemp.DataObject.setDDDWSql(column.getItemName(), editSource);
		    	}		    	
		    	//4.设置默认值
		    	String colDefaultValue = rs.getString("ColDefaultValue");
	
		    	column.setAttribute("DefaultValue",colDefaultValue);
		    	
		    	//5.替换选择按钮传入的参数
		    	String colUnit = rs.getString("ColUnit");
		    	if(colUnit==null) colUnit="";
		   
		    	column.setAttribute("Unit",colUnit);
		    	//6.替换html，主要指onchange事件等
		    	String htmlStyle = rs.getString("ColHTMLStyle");
		    	if(htmlStyle==null) htmlStyle="";

		    	column.setAttribute("HTMLStyle",htmlStyle);
		    	//7.设置ALIGN
		    	column.setAttribute("Align", rs.getString("ColAlign"));
		    	//8.设置Updateable
		    	column.setAttribute("Updateable", rs.getString("ColUpdateable"));
		    	//9.设置Type
		    	column.setAttribute("Type", rs.getString("ColType"));
		    	//10.设置CheckFormat
		    	column.setAttribute("CheckFormat", rs.getString("ColCheckFormat"));
		    	
	    	}
	    	rs.getStatement().close();
	    }
	  //2.设置group样式
	    dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(dwTemp.DataObject.getDoNo(),"",sqlca));
	}
	
	public static String initSETASDataObject(ASValuePool term, ASDataWindow dwTemp, Transaction sqlca, String sObjectNo, String sObjectType) throws Exception{
		//1.初始化字段控制格式
		DWExtendedFunctions.exinitSETASDataWindow(term, dwTemp, sqlca);
		//2.初始化字段参数
		StringBuffer sb=new StringBuffer();
		String termType = term.getString("TermType");
		String relativeObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType").trim();
		String table = relativeObjectType.substring(relativeObjectType.lastIndexOf(".") + 1, relativeObjectType.length());
		if(table == null || table.equals(""))
			return null;
		
		String relativeAttributeID = ProductConfig.getTermTypeAttribute(termType, "RelativeAttributeID");
		String str = "select * from " + table + " where objecttype=:ObjectType and objectno=:ObjectNo";
		SqlObject sql = new SqlObject(str);
		sql.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		ASResultSet rs = sqlca.getASResultSet(sql);
		while(rs.next()){
			for (int i = 0; i < dwTemp.DataObject.Columns.size(); ++i){				
		    	ASColumn column = (ASColumn) dwTemp.DataObject.Columns.get(i);		    	
		    	String attributeID = column.getItemName().substring(column.getItemName().indexOf("\"")+1,column.getItemName().indexOf("|"));
		    	if(!rs.getString(relativeAttributeID).equals(attributeID)) continue;
		    	String para = column.getItemName().substring(column.getItemName().indexOf("|")+1, column.getItemName().length()-1);
		    	if(rs.getString(para.toUpperCase())==null || ("").equals(rs.getString(para.toUpperCase()))) continue;
		    	sb.append("try{setItemValue(0,0,'"+column.getItemName()+"','"+rs.getString(para.toUpperCase())+"');\r\n}catch(e){}");
			}
		}
		rs.getStatement().close();
		return sb.toString();
	}
	
	public static String genSETDataWindowControlScript(ASValuePool term, ASDataWindow dwTemp) throws Exception {
		String termID = term.getString("TermID");
		String setFlag = term.getString("SetFlag");
		StringBuffer sb=new StringBuffer();
		List<ASValuePool> termRelativeList = null;
		if(setFlag.equalsIgnoreCase("SET")){//组合组件
			termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
			if(termRelativeList==null||termRelativeList.isEmpty())
				throw new Exception("未找到组合组件{"+termID+"}的子组件，请确认组件定义是否正确！");
		}
			
		for(ASValuePool termRelationShip : termRelativeList){
			ASValuePool relativeTerm = ProductConfig.getTerm(term.getString("ObjectType"), term.getString("ObjectNo"), termRelationShip.getString("RelativeTermID"));
			String rightType = (String)dwTemp.CurComp.getAttribute("RightType",10);
			if(rightType == null) rightType = "All";
			ASValuePool termPara = (ASValuePool)relativeTerm.getAttribute("TermParameters");// 得到PRODUCT_term_para表
			Object[] para_keys=termPara.getKeys();
			for(int k=0;k<para_keys.length;k++){
				String paraID = (String)para_keys[k];//term_para的ParaID
				String accountControl = ProductConfig.getTermParameterAttribute(relativeTerm, paraID, "APermission");
				String valueList = ProductConfig.getTermParameterAttribute(relativeTerm, paraID, "ValueList");
				String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//字段关联对象属性
				if(refAttributeID==null||refAttributeID.length()==0) continue;
				String[] ars = refAttributeID.split(",");
				for(int n=0;n<ars.length;n++){
					String str1 = ars[n];
					String attributeID = str1.substring(str1.lastIndexOf(".")+1,str1.length());
					ASColumn column = dwTemp.DataObject.getColumn("\""+termRelationShip.getString("RelativeTermID")+"|"+attributeID+"\"");
					if(column==null) continue;
					//1.控制是否只读和可见
					if("Hide".equals(accountControl)){
						//dwTemp.DataObject.setVisible(attributeID, false);
						if(!"ReadOnly".equals(rightType))
						{
							sb.append("try{setItemReadOnly(0, 0,'"+column.getItemName()+"',true);\r\n}catch(e){}");
							sb.append("try{setItemDisabled(0, 0,'"+column.getItemName()+"',true);\r\n}catch(e){}");
						}
					}
					else if("ReadOnly".equals(accountControl)){
						//dwTemp.DataObject.setVisible(attributeID, true);
						if(!"ReadOnly".equals(rightType))
						{
							sb.append("try{setItemReadOnly(0, 0,'"+column.getItemName()+"',true);\r\n}catch(e){}");
							sb.append("try{setItemDisabled(0, 0,'"+column.getItemName()+"',true);\r\n}catch(e){}");
						}
					}
					else if("Required".equals(accountControl)){
						//dwTemp.DataObject.setVisible(attributeID, true);
						if(!"ReadOnly".equals(rightType))
						{
							sb.append("try{setItemRequired(0, 0,'"+column.getItemName()+"',true);\r\n}catch(e){}");
							sb.append("try{setItemReadOnly(0, 0,'"+column.getItemName()+"',false);\r\n}catch(e){}");
							sb.append("try{setItemDisabled(0, 0,'"+column.getItemName()+"',false);\r\n}catch(e){}");
						}
					}
					else if("All".equals(accountControl)){
						//dwTemp.DataObject.setVisible(attributeID, true);
						if(!"ReadOnly".equals(rightType))
						{
							sb.append("try{setItemReadOnly(0, 0,'"+column.getItemName()+"',false);\r\n}catch(e){}");
							sb.append("try{setItemDisabled(0, 0,'"+column.getItemName()+"',false);\r\n}catch(e){}");
						}
					}
					//2.如果是选项，则根据valueList进行过滤，暂未实现，因为同一字段，不同记录的选项可能有差异。datawindow只能按列设置，不能针对记录设定格式，所以无法实现这个功能。
					String colEditStyle = column.getAttribute("EditStyle");
					String colEditSource = column.getAttribute("EditSource");
					StringBuffer opinion = new StringBuffer();
					if("2".equals(colEditStyle) && colEditSource!=null && colEditSource.startsWith("Code") && valueList != null && !"".equals(valueList))
					{
						Item[] items = CodeCache.getItems(colEditSource.replaceAll("Code:", ""));
						for(Item item:items)
						{
							if(valueList.indexOf(item.getItemNo()) >=0)
							{
								opinion.append(item.getItemNo()+","+item.getItemName()+",");
							}
						}
						String s = opinion.toString();
						if(s!=null && s.length() > 1) s = s.substring(0, s.length()-1);
						sb.append("try{setItemOption(0, 0,'"+column.getItemName()+"','"+s+"');\r\n}catch(e){}");
					}
				}
			}
		}
		return sb.toString();
	}	
	
	public static ASDataObject genSETDataObject(ASValuePool term) throws Exception {
		HashMap<String,String> hashMap = DWExtendedFunctions.getHeader(term);
		if(hashMap.keySet().size()==0) 
			throw(new Exception("请配置有效的参数字段！"));
		String[][] sHeaders = new String[hashMap.keySet().size()][2];
	 	int iCount = 0;
	 	Object[] key = hashMap.keySet().toArray();
	 	Arrays.sort(key);
		while(iCount<hashMap.keySet().size()) {
			sHeaders[iCount][0] = key[iCount].toString();
			sHeaders[iCount][1] = hashMap.get(sHeaders[iCount][0]);
			iCount ++ ;
		}
		
		//利用Sql生成窗体对象	
		String str = DWExtendedFunctions.getSelectHeaderSQL(sHeaders);
		ASDataObject doTemp = new ASDataObject(str);
		doTemp.setHeader(sHeaders);

		for(int i = 0 ; i < hashMap.keySet().size(); i ++){
			doTemp.setVisible(sHeaders[i][0], true);
		}
		return doTemp;
	}
	
	public static int getVisibleRowCount(ASDataWindow dwTemp){
		int iCount = dwTemp.DataObject.Columns.size();
		int rolCount = 0;
		for(int i = 0; i < iCount; i ++) {
			if(dwTemp.DataObject.getColumn(i).getAttribute("Visible").equals("1"))
				rolCount ++;
		}
		return rolCount;
	}
	
	public static String setSETDataWindowValues(ASDataWindow dwTemp, ASValuePool term, BusinessObject bo, Transaction sqlca) throws Exception{
		StringBuffer sb=new StringBuffer();
		String termType = term.getString("TermType");
		String setFlag = term.getString("SetFlag");
		String termID = term.getString("TermID");
		List<ASValuePool> termRelativeList = new ArrayList<ASValuePool>();
		if(setFlag.equals("SET"))
			termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
		else if(setFlag.equals("SEG")||setFlag.equals("BAS"))
			termRelativeList.add(term);		
		else throw new Exception(termID+"组件类型配置错误！");
		
		String relativeAttributeID = ProductConfig.getTermTypeAttribute(termType, "RelativeAttributeID");			
		List<BusinessObject> boList = bo.getRelativeObjects();
		
		for(ASValuePool termRelationShip : termRelativeList){
			String relativeTermID;
			if(setFlag.equals("SET"))
				relativeTermID = termRelationShip.getString("RelativeTermID");
			else relativeTermID = termID;
			BusinessObject relativeBusinessObject = null;
			for(BusinessObject businessObject : boList) {
				if(businessObject.getString("ObjectNo").equals(bo.getObjectNo())&&businessObject.getString("ObjectType").equals(bo.getObjectType())&&businessObject.getString(relativeAttributeID).equals(relativeTermID))
				{
					relativeBusinessObject = businessObject;
					break;
				}
			}
			
			if(relativeBusinessObject == null) throw new Exception("未找到子组件{"+relativeTermID+"}的关联对象，请确认定义是否正确！");
			
			for(int i = 0; i < dwTemp.DataObject.Columns.size(); i ++) {
				ASColumn column = dwTemp.DataObject.getColumn(i);
				if(column.getItemName().startsWith("\""+relativeTermID)){
					String value = relativeBusinessObject.getString(column.getItemName().substring(column.getItemName().indexOf("|")+1,column.getItemName().length()-1));
					if(value == null) continue;
					sb.append("try{setItemValue(0,0,'"+column.getItemName()+"','"+value+"');\r\n}catch(e){}");
				}
			}
		}
		return sb.toString();
	}
	
	public static String genExtendedDataWindowControlScript(BusinessObject businessObject, String termID, ASDataWindow dwTemp) throws Exception{
		StringBuffer sb=new StringBuffer();
		String productVersion = businessObject.getString("ProductVersion");
		String productID = businessObject.getString("BusinessType");
		String termType = ProductConfig.getProductTerm(productID, productVersion, termID).getString("TermType"); 
		String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
		String relativeAttributeID = ProductConfig.getTermTypeAttribute(termType, "RelativeAttributeID");
		List<BusinessObject> boList = businessObject.getRelativeObjects(termObjectType);
		if(boList != null && !boList.isEmpty()) {
			int rownum=0;
			for(BusinessObject bo : boList) {								
				ASValuePool relativeTerm = ProductConfig.getProductTerm(productID, productVersion, bo.getString(relativeAttributeID));
				rownum++;
				sb.append(genDataWindowControlScript(relativeTerm,dwTemp,rownum-1));//此处递归调用		
				}
		}
		return sb.toString();
	}
	
	public static String genSEGDataWindowControlScript(ASValuePool term,ASDataWindow dwTemp) throws Exception{
		StringBuffer sb=new StringBuffer();
		sb.append(genDataWindowControlScript(term,dwTemp,0));
		return sb.toString();
	}
}
