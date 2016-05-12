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
	if (sSerialNo == null) sSerialNo = "";
	if (sProvinceNo == null) sProvinceNo = "";
	if (sPrevUrl == null) sPrevUrl = "";
	if (sTypeCode == null) sTypeCode = "";
	if (sCityNo == null) sCityNo = "";
	if (sAreaNo == null) sAreaNo = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CityCodeInfo1";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Attr2 from Basedataset_Info where typecode='CityCodeCar' and Attrstr1=:ProvinceNo and Attrstr2=:AreaNo")
						.setParameter("ProvinceNo", sProvinceNo).setParameter("AreaNo", sAreaNo));
	StringBuffer sbSql = new StringBuffer("");
	while (rs.next()) {
		sbSql.append(rs.getString("Attr2")).append(",");
	}
	rs.getStatement().close();
	String sCityChoiceSql = "select itemno,itemname from Code_Library where codeno='AreaCode' and itemno like '"+sProvinceNo.substring(0,2)+"__00' and itemno!='"+sProvinceNo+"'";
	if (sbSql.length()>0) {
		sCityChoiceSql += " and itemno not in ("+sbSql.substring(0,sbSql.length()-1)+") or itemno='"+sCityNo+"'";
	}
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
	
	function getCityCode() {
		
		setItemValue(0, 0, "Attr1", getItemValue(0, 0, "Attr2"));
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
		
		AsControl.OpenView("/DistributorInfo/RegionCityList1.jsp","ProvinceNo=<%=sProvinceNo %>","_self");
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
