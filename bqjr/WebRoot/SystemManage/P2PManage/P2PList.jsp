<%
/* Copyright 2001-2014 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: 	jli5   P2PList页面
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
	String PG_TITLE = "P2PList页面";

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
	        {"INPUTORGID","登记机构"},
	        {"INPUTDATE","登记日期"},
	        {"UPDATEUSERID","更新人"},
	        {"UPDATEDATE","更新日期"},
	        {"UPDATEORGID","更新机构"},
		}; 
	sSql = "SELECT SERIALNO,TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM,CAPITALSOURCE,EFFECTIVEDATE,getUserName(INPUTUSERID) as  INPUTUSERID,getOrgName(INPUTORGID) as INPUTORGID,INPUTDATE,getUserName(UPDATEUSERID) as UPDATEUSERID,UPDATEDATE,getOrgName(UPDATEORGID) as UPDATEORGID FROM P2PCREDIT_INFO order by EFFECTIVEDATE desc";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "P2PCREDIT_INFO";
	doTemp.setKey("SERIALNO", true);
	doTemp.setHeader(sHeaders);
	doTemp.setReadOnly("*", false);
	doTemp.setRequired("*", false);
// 	doTemp.setCheckFormat("TOTALSUM,HAVEUSESUM", "2");
// 	doTemp.setType("TOTALSUM,HAVEUSESUM", "String");
	doTemp.setCheckFormat("EFFECTIVEDATE", "3");
	doTemp.setAlign("TOTALSUM,HAVEUSESUM,CAPITALSOURCE,EFFECTIVEDATE,INPUTUSERID,INPUTORGID,INPUTDATE,UPDATEUSERID,UPDATEDATE,UPDATEORGID", "3");
	//增加过滤器			
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca, "10", "SERIALNO", "");
	doTemp.setFilter(Sqlca, "20", "TOTALSUM", "");
	doTemp.setFilter(Sqlca, "30", "HAVEUSESUM", "");
	doTemp.setFilter(Sqlca, "32", "UNSIGNEDTOTALSUM", "");
	doTemp.setFilter(Sqlca, "35", "CAPITALSOURCE", "");
	doTemp.setFilter(Sqlca, "40", "INPUTDATE", "");
	doTemp.setFilter(Sqlca, "50", "UPDATEDATE", "");
	doTemp.setFilter(Sqlca, "60", "EFFECTIVEDATE", "");
	
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	    	{"true", "", "Button", "新增", "新增一条记录", "newRecord()",	sResourcesPath},
			{"true", "", "Button", "详情", "查看/修改详情","viewAndEdit()", sResourcesPath},
			{"true", "", "Button", "删除", "删除所选中的记录","deleteRecord()", sResourcesPath}
			};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
<%/*~[Describe=执行更新操作前执行的代码;]~*/%>

/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord() {
		OpenPage("/SystemManage/P2PManage/P2PInfo.jsp", "_self", "");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord() {
		sSerialNo = getItemValue(0, getRow(), "SERIALNO");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	
		if (confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0"); //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit() {
		sSerialNo = getItemValue(0, getRow(), "SERIALNO");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenPage("/SystemManage/P2PManage/P2PInfo.jsp?SerialNo="+ sSerialNo, "_self", "");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
// 		showFilterArea();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
