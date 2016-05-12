<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sProvinceNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProvinceNo"));
	String sTypeCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeCode"));
	String sAreaNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaNo"));
	String sCityNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CityNo"));
	String sPrevUrl =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrevUrl"));
	String sProvinceManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProvinceManager"));
	
	if (sSerialNo == null) sSerialNo = "";
	if (sProvinceNo == null) sProvinceNo = "";
	if (sPrevUrl == null) sPrevUrl = "";
	if (sTypeCode == null) sTypeCode = "";
	if (sCityNo == null) sCityNo = "";
	if (sAreaNo == null) sAreaNo = "";
	if (sProvinceManager == null) sProvinceManager = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CityCodeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	// Attrstr1 省份 AttrStr2 区域 Attr1 省份负责人 Attr2 城市 Attr3 城市负责人
	/* ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Attr2 from Basedataset_Info where typecode='CityCode' and Attrstr1=:ProvinceNo and Attrstr2=:AreaNo and Attr1=:ProvinceManager")
						.setParameter("ProvinceNo", sProvinceNo).setParameter("AreaNo", sAreaNo).setParameter("ProvinceManager", sProvinceManager));
	StringBuffer sbSql = new StringBuffer("");
	while (rs.next()) {
		sbSql.append(rs.getString("Attr2")).append(",");
	} */
	
	String sCityChoiceSql = "select itemno,itemname from Code_Library where codeno='AreaCode' and itemno like '"+sProvinceNo.substring(0,2)+"__00' and itemno!='"+sProvinceNo+"' or itemno='"+sCityNo+"'";
	/* if (sbSql.length()>0) {
		sCityChoiceSql += " and itemno not in ("+sbSql.substring(0,sbSql.length()-1)+") or itemno='"+sCityNo+"'";
	} */
	doTemp.setDDDWSql("Attr2", sCityChoiceSql) ;
	
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
	var sPrevUrl = "<%=sPrevUrl %>";
	var sRawUserId = "";
	
	// 根据角色获得销售人员 add by tbzeng 2014/05/15
	function selectSalesmanByRole() {

		var sRetVal = setObjectValue("SelectSalesmanByRole", "RoleId,<%=CommonConstans.CITY_MANAGER%>","",0,0,"");
		if (typeof(sRetVal)=='undefined' || sRetVal=="_CLEAR_") {
			return;
		}
		var sUserId = sRetVal.split("@")[0];
		var sUserName = sRetVal.split("@")[1];
		setItemValue(0, 0, "Attr3", sUserId);
		setItemValue(0, 0, "CityManager", sUserName);
	}
	
	function getCityCode() {
		
		setItemValue(0, 0, "CityNo", getItemValue(0, 0, "Attr2"));
	}
	
	function saveRecord(sPostEvents){
		
		// 判断该区域，该省份是否已经添加该城市负责人
		if ("<%=sSerialNo%>" == "") {
			var sProvinceSerialNo = RunMethod("公用方法", "GetColValue", "Basedataset_Info,SerialNo,TypeCode='CityCode' and AttrStr1='"+getItemValue(0, 0, "AttrStr1")+"' and AttrStr2='"+getItemValue(0, 0, "AttrStr2")+"'and Attr1='"+getItemValue(0, 0, "Attr1")+"' and Attr2='"+getItemValue(0, 0, "Attr2")+"' and Attr3='"+getItemValue(0, 0, "Attr3")+"'");
			//alert(sProvinceSerialNo+"|"+typeof(sProvinceSerialNo));
			if (sProvinceSerialNo != "Null") {
				alert("该区域该省份该城市已经添加该负责人！");
				return;
			}
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		// 更新城市管理人员上级及原区域管理人员上级
		RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateCitySuper", "roleId=<%=CommonConstans.CITY_MANAGER%>,cityUserId="+getItemValue(0, 0, "Attr3")+",rawUserId="+sRawUserId+",cityNo="+getItemValue(0, 0, "Attr2")+",provinceUserId="+getItemValue(0, 0, "Attr1"));

	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityList.jsp","ProvinceNo=<%=sProvinceNo %>&ProvinceManager=<%=sProvinceManager%>","_self");
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
			setItemValue(0, 0, "AttrStr1", "<%=sProvinceNo %>");
			setItemValue(0, 0, "AttrStr2", "<%=sAreaNo %>");
			setItemValue(0, 0, "Attr1", "<%=sProvinceManager%>");
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
