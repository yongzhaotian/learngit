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
	if (sSerialNo == null) sSerialNo = "";
	if (sProvinceNo == null) sProvinceNo = "";
	if (sPrevUrl == null) sPrevUrl = "";
	if (sTypeCode == null) sTypeCode = "";
	if (sCityNo == null) sCityNo = "";
	if (sAreaNo == null) sAreaNo = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CityCodeInfo1";//ģ�ͱ��
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
