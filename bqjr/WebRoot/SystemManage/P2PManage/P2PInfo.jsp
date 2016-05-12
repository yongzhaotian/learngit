<%
/* Copyright 2001-2014 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: 	jli5   P2PInfo页面
 * Tester:
 * Content: 
 * Input Param:
 * 				ObjectNo：	合同流水号
 * Output param:
 *				sReturnValue:	  
 * History Log:
 */%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "P2PInfo页面";
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	String sSql="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sHeaders[][] = { 
	        {"SERIALNO","流水号"},
	        {"TOTALSUM","总额度"},
	        {"HAVEUSESUM","已用额度"},
	        {"UNSIGNEDTOTALSUM","未签署金额"},
	        {"CAPITALSOURCE","资金来源"},
	        {"EFFECTIVEDATE","生效日"},
	        {"INPUTUSERID","登记人"},
	        {"INPUTUSERIDNAME","登记人"},
	        {"INPUTORGID","登记机构"},
	        {"INPUTORGIDNAME","登记机构"},
	        {"INPUTDATE","登记日期"},
	        {"UPDATEUSERID","更新人"},
	        {"UPDATEUSERIDNAME","更新人"},
	        {"UPDATEDATE","更新日期"},
	        {"UPDATEORGID","更新机构"},
	        {"UPDATEORGIDNAME","更新机构"},
		}; 
	
	sSql = "SELECT SERIALNO,TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM,CAPITALSOURCE,EFFECTIVEDATE,GETUSERNAME(INPUTUSERID) as  INPUTUSERIDNAME,GETORGNAME(INPUTORGID) as INPUTORGIDNAME,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEDATE,UPDATEORGID,GETUSERNAME(UPDATEUSERID) as UPDATEUSERIDNAME,GETORGNAME(UPDATEORGID) as UPDATEORGIDNAME    FROM P2PCREDIT_INFO  WHERE SERIALNO='"+sSerialNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "P2PCREDIT_INFO";
	doTemp.setKey("SERIALNO", true);
	
	doTemp.setHeader(sHeaders);
	doTemp.setReadOnly("SERIALNO,CAPITALSOURCE,HAVEUSESUM,UNSIGNEDTOTALSUM,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEDATE,UPDATEORGID,INPUTUSERIDNAME,INPUTORGIDNAME,UPDATEUSERIDNAME,UPDATEORGIDNAME", true);
	doTemp.setRequired("SERIALNO,TOTALSUM,CAPITALSOURCE,EFFECTIVEDATE", true);
	doTemp.setCheckFormat("TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM", "2");
	doTemp.setAlign("TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM", "3");
	doTemp.setAlign("CAPITALSOURCE,EFFECTIVEDATE,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEDATE,UPDATEORGID,INPUTUSERIDNAME,INPUTORGIDNAME,UPDATEUSERIDNAME,UPDATEORGIDNAME", "1");

	doTemp.setCheckFormat("EFFECTIVEDATE", "3");
	doTemp.setUnit("TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM", "&nbsp元");
	doTemp.setColumnType("TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM", "1");
	doTemp.setVisible("INPUTUSERID,INPUTORGID,UPDATEUSERID,UPDATEORGID", false);
	doTemp.setUpdateable("UNSIGNEDTOTALSUM,INPUTUSERIDNAME,INPUTORGIDNAME,UPDATEUSERIDNAME,UPDATEORGIDNAME", false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	        {"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInset = false;
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		var EFFECTIVEDATE = getItemValue(0,0,"EFFECTIVEDATE");
		var SERIALNO = getItemValue(0,0,"SERIALNO")
		
		if( EFFECTIVEDATE < "<%=StringFunction.getToday()%>"){
			alert("生效日必须大于等于今天");
			return;
		}
		
		var TableName="P2PCREDIT_INFO";
		var ColName = "count(1) ";
		var WhereClause = "EFFECTIVEDATE='" + EFFECTIVEDATE + "'";
		if( !bIsInset ){	//编辑详情
			WhereClause += " and SERIALNO not in ('" + SERIALNO + "')";//排除当前流水号
		}
		var returnValue =	RunMethod("公用方法","GetColValue",TableName+","+ColName+","+WhereClause);
		
		if((bIsInset&&returnValue>0) || !bIsInset&&returnValue>0){
			alert("日期:"+EFFECTIVEDATE+"已存在P2P额度，请选择其他生效日期！！");
			return;
		}
		
		setItemValue(0,getRow(),"UPDATEORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,getRow(),"UPDATEORGNAME","<%=CurOrg.getOrgName()%>");
		setItemValue(0,getRow(),"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"UPDATEUSERNAME","<%=CurUser.getUserName()%>");	
		setItemValue(0,getRow(),"UPDATEDATE","<%=StringFunction.getTodayNow()%>");		
		if(bIsInset){
			setItemValue(0,getRow(),"HAVEUSESUM",0);		
			//setItemValue(0,getRow(),"AVAILABLESUM",getItemValue(0,0,"TOTALSUM"));
		}
		as_save("myiframe0");		
	}
		
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/P2PManage/P2PList.jsp","_self","");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");
			initSerialNo();
			setItemValue(0,getRow(),"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"INPUTUSERNAME","<%=CurUser.getUserName()%>");	
			setItemValue(0,getRow(),"INPUTDATE","<%=StringFunction.getTodayNow()%>");
			setItemValue(0,getRow(),"CAPITALSOURCE","P2P平台");
			bIsInset = true; 
		} 
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "P2PCREDIT_INFO";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		bFreeFormMultiCol = true;
		init();
		my_load(2,0,'myiframe0');
		initRow(); //页面装载时，对DW当前记录进行初始化
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
