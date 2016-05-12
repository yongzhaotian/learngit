<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sTypeCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeCode"));
	String sAreaNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaNo"));
	String sProvinceNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProvinceNo"));
	String sPrevUrl =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrevUrl"));
	String sAreaUserId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaUserId"));
	
	if(sSerialNo==null) sSerialNo = "";
	if(sTypeCode==null) sTypeCode = "";
	if(sAreaNo==null) sAreaNo = "";
	if (sProvinceNo == null) sProvinceNo = "";
	if(sPrevUrl==null) sPrevUrl = "";
	if (sAreaUserId == null) sAreaUserId = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ProvinceCodeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Attr1 from Basedataset_Info bi where bi.typecode='ProvinceCode' and bi.Attrstr1=:AreaCode")
	//				.setParameter("AreaCode", sAreaNo));
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Attr1 from Basedataset_Info bi where bi.typecode='ProvinceCode' and  bi.AttrStr1!=:AreaCode")
		.setParameter("AreaCode", sAreaNo));
	StringBuffer sbSql = new StringBuffer("");
	while (rs.next()) {
		sbSql.append(rs.getString("Attr1")).append(",");
	}
	rs.getStatement().close();
	
	String sSql = "select cl.itemno,cl.itemname from code_library cl where cl.codeno='AreaCode' and cl.isinuse='1' and substr(cl.itemno,3,4)='0000'";
	if (sbSql.length()>0) {
		sSql += " and cl.itemno not in ("+sbSql.substring(0,sbSql.length()-1)+") or cl.itemno='"+sProvinceNo+"'";
	}
	doTemp.setDDDWSql("Attr1", sSql);
	
	/* if (!"".equals(sSerialNo)) {
		doTemp.setReadOnly("Attr1", true);
	} */
	
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
	var sPrevUrl = "<%=sPrevUrl%>";
	var sRawUserId = "";
	
	// 根据角色获得销售人员 add by tbzeng 2014/05/15
	function selectSalesmanByRole() {

		var sRetVal = setObjectValue("SelectSalesmanByRole", "RoleId,<%=CommonConstans.PROVINCE_MANAGER%>","",0,0,"");
		if (typeof(sRetVal)=='undefined' || sRetVal=="_CLEAR_") {
			return;
		}
		var sUserId = sRetVal.split("@")[0];
		var sUserName = sRetVal.split("@")[1];
		setItemValue(0, 0, "Attr3", sUserId);
		setItemValue(0, 0, "ProvinceManagerName", sUserName);
	}
	
	function saveRecord(sPostEvents){
		
		// 判断该区域，该省份是否已经添加该负责人
		if ("<%=sSerialNo%>" == "") {
			var sProvinceSerialNo = RunMethod("公用方法", "GetColValue", "Basedataset_Info,SerialNo,typecode='ProvinceCode' and AttrStr1='"+getItemValue(0, 0, "AttrStr1")+"' and Attr1='"+getItemValue(0, 0, "Attr1")+"' and Attr3='"+getItemValue(0, 0, "Attr3")+"'");
			//alert(sProvinceSerialNo+"|"+typeof(sProvinceSerialNo));
			if (sProvinceSerialNo != "Null") {
				alert("该区域该省份已经添加该负责人！");
				return;
			}
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		// 更新省级管理人员上级及原区域管理人员上级
		var sCurUserId = getItemValue(0, 0, "Attr3");
		var sAreaNo = getItemValue(0, 0, "AttrStr1");
		var sProvinceNo = getItemValue(0, 0, "Attr1");
		
		//alert("|" + sCurUser + "|" + sAreaNo + "|"+ sProvinceNo + "|");
		if (sCurUserId!=null && sCurUserId) {
			RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateProvinceSuper", "roleId=<%=CommonConstans.PROVINCE_MANAGER%>,provinceUserId="+getItemValue(0, 0, "Attr3")+",rawUserId="+sRawUserId+",provinceNo="+getItemValue(0, 0, "Attr1")+",areaUserId=<%=sAreaUserId%>");
		}
		
		// 判断是否更改用户
		if (sRawUserId!=null && sCurUserId!=null && sRawUserId && sCurUserId && (sCurUserId!=sRawUserId)) {
			RunMethod("公用方法", "updateCitySuper", sCurUserId+","+sProvinceNo+","+sAreaNo);
		}
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		if(sPrevUrl){
			AsControl.OpenView(sPrevUrl,"AreaNo=<%=sAreaNo %>&AreaUserId=<%=sAreaUserId%>","_self");
			return;
		}
		
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"InputOrg","<%=CurOrg.orgID%>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
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
			setItemValue(0, 0, "AttrStr1", "<%=sAreaNo %>")
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
		
		setItemValue(0, 0, "Attr2", "<%=sAreaUserId%>");
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
