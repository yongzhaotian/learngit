<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sViewId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NoteType"));
	
	if (sCustomerID == null) sCustomerID = "";
	if(sSerialNo==null) sSerialNo="";
	if(sViewId==null) sViewId="";
	
	if ("002".equals(sViewId)) CurPage.setAttribute("RightType", "ReadOnly");
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "SocialInfoQueryInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
	
	// fixme 只能查看详情信息
	//if ("002".equals(sViewId)) sButtons[2][0] = "false";
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sRetVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//alert(retVal+"|"+typeof(retVal));
		if (typeof(sRetVal)=="undefined" || sRetVal=='_CLEAR_') {
			setItemValue(0, 0, "City", "");
			setItemValue(0, 0, "CityName", "");
			return;
		}
		sAreaCodeInfo = sRetVal.split('@');
		sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
		sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
		setItemValue(0, 0, "City", sAreaCodeValue);
		setItemValue(0, 0, "CityName", sAreaCodeName);
		
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/SocialInfoQueryList.jsp","","_self");
		//OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType=Customer&ObjectNo=<%=sCustomerID%>&ViewID=002","_parent","");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			
			if ("<%=sViewId%>"!="002") {
				as_add("myiframe0");
				var sSerialNo = getSerialNo("SocialInfoQuery","SerialNo");// 获取流水号
				setItemValue(0, 0, "SerialNo", sSerialNo);
			}
			setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

			setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
