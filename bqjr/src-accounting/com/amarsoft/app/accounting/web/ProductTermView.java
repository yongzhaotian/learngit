package com.amarsoft.app.accounting.web;

import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
import com.amarsoft.web.dw.ASDataObject;
import com.amarsoft.web.dw.ASDataWindow;


public class ProductTermView{
	
	
	
	public static void appendTermParaToDataWindow(ASDataObject doTemp,String objectType,String objectNo,String termID,Transaction sqlca,Page curPage) throws Exception{
		
	}
	
	public static ASDataWindow createTermDataWindow(String objectType,String objectNo,String termID,Transaction sqlca,Page curPage) throws Exception{
		//构建一个HTML模版
		String htmlTemplate = "<table align='center' width='100%' border='0' Backgroundcolor='#red' cellpadding='1' cellspacing='2' bodercolor='#red' bordercolorlight='#FFFFFF'   bordercolordark='#FFFFFF'>";
		htmlTemplate += "<tr><td>${DOCK:default}</td></tr>";
		htmlTemplate += "</table>";
		
		String sql = ProductTermView.genTermParaSql(objectType, objectNo, termID, sqlca);
		ASDataObject doTemp = new ASDataObject(sql);
		//更新表
		doTemp.UpdateTable="PRODUCT_TERM_LIBRARY";
		//设置主键
		doTemp.setKey("TermID,ObjectType,ObjectNo",true);
		doTemp.setVisible("ObjectType,ObjectNo", false);
		ProductTermView.initTermParameterDataObject(objectType, objectNo, termID, doTemp, sqlca,curPage);
		ASDataWindow dwTemp = new ASDataWindow(curPage ,doTemp,sqlca);
		dwTemp.harbor.getDock(0).setAttribute("TotalColumns", "12");
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		
		dwTemp.setHarborTemplate(htmlTemplate);
		return dwTemp;
	}
	
	private static void initTermParameterDataObject(String objectType,String objectNo,String termID,ASDataObject doTemp,Transaction sqlca,Page curPage) throws Exception{
		String sql="select * from PRODUCT_TERM_PARA where termID='"+termID+"' and objectType='"+objectType+"' and objectNo='"+objectNo+"' order by sortno ";
		ASResultSet rs=sqlca.getASResultSet(sql);
		while(rs.next()){
			String parameterID = rs.getString("ParaID");
			//取参数基本定义
			Item parameterDef = CodeCache.getItem("TermAttribute", parameterID);
			if(parameterDef==null) continue;
			String dataType = parameterDef.getBankNo();//数据类型
			if(dataType==null) throw new Exception("属性-"+parameterID+"未定义数据类型！");
			String codeOpition = parameterDef.getRelativeCode();//代码选项
			String htmlAttribute = parameterDef.getAttribute2();//Html风格
			String multiSelector = parameterDef.getAttribute4();//多选的javascript函数
			if(codeOpition == null) codeOpition = "";
			if(htmlAttribute == null) htmlAttribute="";
			if(multiSelector == null) multiSelector="";
			
			String parameterName = rs.getString("ParaName");
			String valueList = rs.getString("ValueList");if(valueList==null) valueList="";//可选范围
			String defaultValue = rs.getString("DefaultValue");if(defaultValue==null)defaultValue="";
			
			doTemp.setHeader(parameterID+"_DV",parameterName+"");
			doTemp.setHeader(parameterID+"_Max",parameterName+"-最大");
			doTemp.setHeader(parameterID+"_Min",parameterName+"-最小");
			doTemp.setHeader(parameterID+"_VL",parameterName+"-范围");
			doTemp.setHeader(parameterID+"_VLN",parameterName+"-范围");
			doTemp.setVisible(parameterID+"_VL", false);
			
			doTemp.setEditStyle(parameterID+"_VLN","3");
			doTemp.setReadOnly(parameterID+"_VLN", true);
			doTemp.setHTMLStyle(parameterID+"_VLN", htmlAttribute);
			
			if(dataType.equals("2")||dataType.equals("5")||dataType.length()>1){//数字或整数
				doTemp.setType(parameterID+"_Max,"+parameterID+"_Min,"+parameterID+"_DV","Number");
				doTemp.setCheckFormat(parameterID+"_Max,"+parameterID+"_Min,"+parameterID+"_DV",dataType);
			}
		
			if(codeOpition.length()>0&&codeOpition!=null){//选项
				
				String codeNo=ExtendedFunctions.replaceAllIgnoreCase(codeOpition, "Code:", "");
				if(codeOpition.toUpperCase().startsWith("CODE:")){
					if(valueList.length()>0){
						doTemp.setDDDWSql(parameterID+"_DV", "select ItemNo,ItemName from Code_Library where Codeno='"+codeNo+"' and IsInUse='1' and ItemNo in('"+valueList.replaceAll(",", "','")+"')");
					}
					else doTemp.setDDDWCode(parameterID+"_DV",codeNo);
				}
				if(codeOpition.toUpperCase().startsWith("CODE:")){
					doTemp.setUnit(parameterID+"_VLN", 
							"<input class=inputdate type=Button value=..." +
							" onClick=parent.setMultiObjectTreeValue(\"SelectCode\",\"CodeNo,"+codeNo+"\",\"@"+parameterID+"_VL@0@"+parameterID+"_VLN@1\",0,0,\"\")>");
				}
				if(codeOpition.toUpperCase().startsWith("SQL:")){
					doTemp.setDDDWSql(parameterID+"_DV",ExtendedFunctions.replaceAllIgnoreCase(codeOpition, "SQL:", ""));
				}
			}
			/*if(multiSelector.length()>0&&multiSelector!=null){//选项
				multiSelector = ExtendedFunctions.replaceAllIgnoreCase(multiSelector,curPage);
				doTemp.setUnit(parameterID+"_VLN", 
						"<input class=inputdate type=button value=... onClick="+multiSelector+">");
			}*/
			String pPermission = rs.getString("PPermission");
			if(pPermission==null||pPermission.length()==0) pPermission="All";
			String aPermission = rs.getString("APermission");
			if(aPermission==null||aPermission.length()==0) aPermission="All";
			if(pPermission.equalsIgnoreCase("Hide"))
				aPermission=pPermission;
			if(pPermission.equalsIgnoreCase("ReadOnly")&&aPermission.equalsIgnoreCase("All"))
				aPermission=pPermission;
			
			//取条款中的参数定义，主要是权限
			if(objectType.equals("Product")){
				if(pPermission.equals("Hide")) continue;
				else if(pPermission.equals("ReadOnly")){
					doTemp.setReadOnly(parameterID+"_DV", true);
				}
				else{//可修改权限
					if(aPermission.equals("All")){//账户也可修改时
						doTemp.setVisible(parameterID+"_Max,"+parameterID+"_Min,"+parameterID+"_VL,"+parameterID+"_VLN", true);
					}
				}
			}
			else if(objectType.equals("Term")){
				if(pPermission.equals("Hide")||pPermission.equals("ReadOnly")){
					doTemp.setReadOnly(parameterID+"_DV", false);
					doTemp.setVisible(parameterID+"_DV", true);
					doTemp.setVisible(parameterID+"_Max,"+parameterID+"_Min,"+parameterID+"_VL,"+parameterID+"_VLN", false);
				}
			}
		}
		rs.getStatement().close();
	}
	
	private static String genTermParaSql(String objectType,String objectNo,String termID,Transaction sqlca) throws Exception{
		String sql="select * from PRODUCT_TERM_PARA where termID='"+termID+"' and objectType='"+objectType+"' and objectNo='"+objectNo+"' order by sortno ";
		String doTempSql="";
		ASResultSet rs=sqlca.getASResultSet(sql);
		while(rs.next()){
			String parameterID = rs.getString("ParaID");
			//取参数基本定义
			Item parameterDef = CodeCache.getItem("TermAttribute", parameterID);
			if(parameterDef==null) continue;
			String dataType = parameterDef.getBankNo();//数据类型
			if(dataType==null) throw new Exception("属性-"+parameterID+"未定义数据类型！");
			String ctrlFlag = parameterDef.getAttribute1();//是否控制参数
			
			//取条款中的参数定义，主要是权限
			if(objectType.equals("Product")){
				String sql1="select PPermission from PRODUCT_TERM_PARA where termID='"+termID+"' and ParaID='"+parameterID+"' and objectType='"+objectType+"' and objectNo='"+objectNo+"'";
				ASResultSet rs1=sqlca.getASResultSet(sql1);
				if(!rs1.next()){
					rs1.close();
					continue;
				}
				String pPermission = rs1.getString("PPermission");
				rs1.close();
				if(pPermission==null||pPermission.length()==0) pPermission="Hide";
				if(pPermission.equals("Hide")) continue;
			}

			String defaultValue = rs.getString("DefaultValue");if(defaultValue==null)defaultValue="";
			String minValue = rs.getString("MinValue");if(minValue==null||"".equals(minValue))minValue="0";
			String maxValue = rs.getString("MaxValue");if(maxValue==null||"".equals(maxValue))maxValue="0";
			String valueList = rs.getString("ValueList");if(valueList==null) valueList="";//可选范围
			String valueListName = rs.getString("ValueListName");if(valueListName==null) valueListName="";
			if(ctrlFlag.indexOf("MinValue")>=0) doTempSql += minValue+" as "+parameterID+"_Min,";
			if(ctrlFlag.indexOf("MaxValue")>=0) doTempSql += maxValue+" as "+parameterID+"_Max,";
			if(ctrlFlag.indexOf("DefaultValue")>=0) doTempSql += "'"+defaultValue+"' as "+parameterID+"_DV,";
			if(ctrlFlag.indexOf("ValueList")>=0) {
				doTempSql += "'"+valueList+"' as "+parameterID+"_VL,";
				doTempSql += "'"+valueListName+"' as "+parameterID+"_VLN,";
			}
		}
		rs.getStatement().close();
		if(doTempSql.endsWith(",")) doTempSql=doTempSql.substring(0,doTempSql.length()-1);
		if("".equals(doTempSql)) doTempSql = " '' as tmp ";
		return "select ObjectType,ObjectNo,"+doTempSql+ " from PRODUCT_TERM_LIBRARY where TermID='"+termID+"' and ObjectType='"+objectType+"' and ObjectNo='"+objectNo+"' ";
	}
}
