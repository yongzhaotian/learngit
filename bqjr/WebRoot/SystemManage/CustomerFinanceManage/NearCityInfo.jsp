<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "NearCityInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	String sSql = "select itemno,itemname from code_library where (codeno='AreaCode' and isinuse='1' and substr(itemno,3,4)!='0000' and substr(itemno,5,2)='00' and substr(itemno,1,2) not in ('11','12','31','50') or itemno in ('110000','120000','310000','500000') )";
	
	// ȥ���Ѿ���ӵĳ���,�����ˮ�Ų�Ϊ�գ�˵��������ҳ�棬��ʱ��ǰ���в���ȥ��
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
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var sStoreCity = getItemValue(0, 0,"StoreCity");
		if (typeof(sStoreCity)=='undefined' || sStoreCity.length==0) {
			alert("��ѡ���ŵ����ڳ��У�");
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
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		
		var cityItems = retVal.split(",");
		var sCityNos = "";
		var sCityNames = "";
		for (var i = 0;i<cityItems.length-1;i++) {
			sCityNos += cityItems[i].split(" ")[0]+",";
			sCityNames += cityItems[i].split("  ")[1]+",";/*------�����ո��Ӧ��IE�������һ���ո��Ӧ�ڻ�������-------*/
		}
		setItemValue(0, 0, "NearCity", sCityNos);
		setItemValue(0, 0, "NearCityName", sCityNames);
		/* var sAreaCode = getItemValue(0,getRow(),"RegionCode");
		//���������滮�����м�ǧ���������ʾ�����滮
		sAreaCode = "110000"; 
		
		var sRetVal = PopPage("/Common/ToolsC/AllCityCodeNo.jsp","","dialogWidth=550px;dialogHeight=600px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if (sRetVal=='undefined' || sRetVal=='_none_' || sRetVal.length==0) {
			alert("��ѡ����У�");
			return;
		}
		setItemValue(0, 0, "NearCity", sRetVal);
		setItemValue(0, 0, "NearCityName", sRetVal);
		
		/* var sAreaCode = getItemValue(0,getRow(),"RegionCode");
		sAreaCodeInfo = PopComp("AreaVFrame1","/Common/ToolsA/AreaVFrame1.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		alert(sAreaCodeInfo);
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"RegionCode","");
			setItemValue(0,getRow(),"RegionName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
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

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		
		
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("SocialInfoQuery","SerialNo");// ��ȡ��ˮ��
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
