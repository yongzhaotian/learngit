<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
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
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CityCodeInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	// Attrstr1 ʡ�� AttrStr2 ���� Attr1 ʡ�ݸ����� Attr2 ���� Attr3 ���и�����
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
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	var sPrevUrl = "<%=sPrevUrl %>";
	var sRawUserId = "";
	
	// ���ݽ�ɫ���������Ա add by tbzeng 2014/05/15
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
		
		// �жϸ����򣬸�ʡ���Ƿ��Ѿ���Ӹó��и�����
		if ("<%=sSerialNo%>" == "") {
			var sProvinceSerialNo = RunMethod("���÷���", "GetColValue", "Basedataset_Info,SerialNo,TypeCode='CityCode' and AttrStr1='"+getItemValue(0, 0, "AttrStr1")+"' and AttrStr2='"+getItemValue(0, 0, "AttrStr2")+"'and Attr1='"+getItemValue(0, 0, "Attr1")+"' and Attr2='"+getItemValue(0, 0, "Attr2")+"' and Attr3='"+getItemValue(0, 0, "Attr3")+"'");
			//alert(sProvinceSerialNo+"|"+typeof(sProvinceSerialNo));
			if (sProvinceSerialNo != "Null") {
				alert("�������ʡ�ݸó����Ѿ���Ӹø����ˣ�");
				return;
			}
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		// ���³��й�����Ա�ϼ���ԭ���������Ա�ϼ�
		RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateCitySuper", "roleId=<%=CommonConstans.CITY_MANAGER%>,cityUserId="+getItemValue(0, 0, "Attr3")+",rawUserId="+sRawUserId+",cityNo="+getItemValue(0, 0, "Attr2")+",provinceUserId="+getItemValue(0, 0, "Attr1"));

	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityList.jsp","ProvinceNo=<%=sProvinceNo %>&ProvinceManager=<%=sProvinceManager%>","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"InputOrg","<%=CurOrg.orgID%>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("Basedataset_Info","SerialNo");// ��ȡ��ˮ��
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
