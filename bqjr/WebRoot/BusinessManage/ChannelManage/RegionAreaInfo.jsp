<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sTypeCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeCode"));
	if (sSerialNo == null) sSerialNo="";
	if (sTypeCode == null) sTypeCode="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AreaCodeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	// 设置负责人下拉框
	doTemp.setDDDWSql("Attr3", "select UserId,UserName from User_Info where UserId in (select UserId from user_role where roleId='"+CommonConstans.AREA_MANAGER+"')");
	if (!"".equals(sSerialNo)) doTemp.setReadOnly("Attr1", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};
	
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	var sRawUserId = "";
	
	function saveRecord(sPostEvents){
	
		// 检测区域编号是否存在
		if ("<%=sSerialNo%>" == "") {
			var sAreadSerialNo = RunMethod("公用方法", "GetColValue", "BaseDataset_Info,SerialNo,TypeCode='AreaCode' and Attr1='"+getItemValue(0, 0, "Attr1")+"'");
			if ("Null" != sAreadSerialNo) {
				alert("该区域编号已经存在，请重新输入！");
				return;
			}
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		// 更新区域管理人员上级及原区域管理人员上级
		var sCurUserId = getItemValue(0, 0, "Attr3");
		var sAreaNo = getItemValue(0, 0, "Attr1");

		if (sCurUserId!=null && sCurUserId) {
			RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateAreaSuper", "roleId=<%=CommonConstans.CEO_MANAGER%>,userId="+sCurUserId+",rawUserId="+sRawUserId+",areaNo="+getItemValue(0, 0, "Attr1"));
		}
		
		// 判断是否更改用户
		if (sRawUserId!=null && sCurUserId!=null && sRawUserId && sCurUserId && (sCurUserId!=sRawUserId)) {
			RunMethod("公用方法", "updateProvinceSuper", sCurUserId+","+sAreaNo);
		}
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionAreaList.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var sSerialNo = getSerialNo("Basedataset_Info","SerialNo");// 获取流水号
			setItemValue(0,getRow(),"SerialNo",sSerialNo);
			setItemValue(0, 0, "TypeCode", "<%=sTypeCode %>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.orgID %>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID %>");
			setItemValue(0,0,"UpdateOrgName","<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
		
		sRawUserId = getItemValue(0, 0, "Attr3");
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
