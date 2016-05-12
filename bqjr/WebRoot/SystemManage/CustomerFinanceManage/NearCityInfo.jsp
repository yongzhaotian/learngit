<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "NearCityInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	String sSql = "select itemno,itemname from code_library where (codeno='AreaCode' and isinuse='1' and substr(itemno,3,4)!='0000' and substr(itemno,5,2)='00' and substr(itemno,1,2) not in ('11','12','31','50') or itemno in ('110000','120000','310000','500000') )";
	
	// 去除已经添加的城市,如果流水号不为空，说明是详情页面，此时当前城市不能去除
	StringBuffer sbSql = new StringBuffer(" and itemno not in (");
	String sStoreCitySql;
	ASResultSet rs;
	if(sSerialNo!=""){
		sStoreCitySql="select StoreCity from NearCity_Info where SerialNo!=:SerialNo";
        rs = Sqlca.getASResultSet(new SqlObject(sStoreCitySql).setParameter("SerialNo", sSerialNo));
	}else{
		sStoreCitySql="select StoreCity from NearCity_Info";
		rs = Sqlca.getASResultSet(new SqlObject(sStoreCitySql));
	}
	while (rs.next()) {
		sbSql.append("'").append(rs.getString("StoreCity")).append("'").append(",");
	}
    
	rs.getStatement().close();
	
	sSql += sbSql.substring(0, sbSql.length()-1)+")   order by SortNo";
	
	double dCnt = Sqlca.getDouble(new SqlObject("select count(StoreCity) from NearCity_Info"));
	if (dCnt <= 0.0) {
		sSql = "select itemno,itemname from code_library where codeno='AreaCode' and isinuse='1' and substr(itemno,3,4)!='0000' and substr(itemno,5,2)='00' and substr(itemno,1,2) not in ('11','12','31','50') or itemno in ('110000','120000','310000','500000')";
	}
	
		
	doTemp.setDDDWSql("StoreCity", sSql);
	
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
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sStoreCity = getItemValue(0, 0,"StoreCity");
		if (typeof(sStoreCity)=='undefined' || sStoreCity.length==0) {
			alert("请选择门店所在城市！");
			return;
		}
		<%
		if(sSerialNo==null||"".equals(sSerialNo)){%>
			var retVal =  PopPage("/SystemManage/CustomerFinanceManage/AddNearCity.jsp?SerialNo=1","","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;"); 
			<%}else{%>
				var retVal =  PopPage("/SystemManage/CustomerFinanceManage/AddNearCity.jsp?SerialNo="+<%=sSerialNo%>,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
				<%	
			}
		%>
		
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的城市！");
			return;
		}
		
		var cityItems = retVal.split(",");
		var sCityNos = "";
		var sCityNames = "";
		for (var i = 0;i<cityItems.length-1;i++) {
			sCityNos += cityItems[i].split(" ")[0]+",";
			sCityNames += cityItems[i].split("  ")[1]+",";/*------两个空格对应于IE浏览器，一个空格对应于火狐浏览器-------*/
		}
		setItemValue(0, 0, "NearCity", sCityNos);
		setItemValue(0, 0, "NearCityName", sCityNames);
		/* var sAreaCode = getItemValue(0,getRow(),"RegionCode");
		//由于行政规划代码有几千项，分两步显示行政规划
		sAreaCode = "110000"; 
		
		var sRetVal = PopPage("/Common/ToolsC/AllCityCodeNo.jsp","","dialogWidth=550px;dialogHeight=600px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if (sRetVal=='undefined' || sRetVal=='_none_' || sRetVal.length==0) {
			alert("请选择城市！");
			return;
		}
		setItemValue(0, 0, "NearCity", sRetVal);
		setItemValue(0, 0, "NearCityName", sRetVal);
		
		/* var sAreaCode = getItemValue(0,getRow(),"RegionCode");
		sAreaCodeInfo = PopComp("AreaVFrame1","/Common/ToolsA/AreaVFrame1.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		alert(sAreaCodeInfo);
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"RegionCode","");
			setItemValue(0,getRow(),"RegionName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"RegionCode",sAreaCodeValue);
					setItemValue(0,getRow(),"RegionName",sAreaCodeName);				
			}
		} */
		
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
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/NearCityList.jsp","","_self");
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
			as_add("myiframe0");
			var sSerialNo = getSerialNo("SocialInfoQuery","SerialNo");// 获取流水号
			setItemValue(0,getRow(),"SerialNo",sSerialNo);
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
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
