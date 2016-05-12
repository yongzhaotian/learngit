<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
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
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ProvinceCodeInfo";//ģ�ͱ��
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
	var sPrevUrl = "<%=sPrevUrl%>";
	var sRawUserId = "";
	
	// ���ݽ�ɫ���������Ա add by tbzeng 2014/05/15
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
		
		// �жϸ����򣬸�ʡ���Ƿ��Ѿ����Ӹø�����
		if ("<%=sSerialNo%>" == "") {
			var sProvinceSerialNo = RunMethod("���÷���", "GetColValue", "Basedataset_Info,SerialNo,typecode='ProvinceCode' and AttrStr1='"+getItemValue(0, 0, "AttrStr1")+"' and Attr1='"+getItemValue(0, 0, "Attr1")+"' and Attr3='"+getItemValue(0, 0, "Attr3")+"'");
			//alert(sProvinceSerialNo+"|"+typeof(sProvinceSerialNo));
			if (sProvinceSerialNo != "Null") {
				alert("�������ʡ���Ѿ����Ӹø����ˣ�");
				return;
			}
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		// ����ʡ��������Ա�ϼ���ԭ���������Ա�ϼ�
		var sCurUserId = getItemValue(0, 0, "Attr3");
		var sAreaNo = getItemValue(0, 0, "AttrStr1");
		var sProvinceNo = getItemValue(0, 0, "Attr1");
		
		//alert("|" + sCurUser + "|" + sAreaNo + "|"+ sProvinceNo + "|");
		if (sCurUserId!=null && sCurUserId) {
			RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateProvinceSuper", "roleId=<%=CommonConstans.PROVINCE_MANAGER%>,provinceUserId="+getItemValue(0, 0, "Attr3")+",rawUserId="+sRawUserId+",provinceNo="+getItemValue(0, 0, "Attr1")+",areaUserId=<%=sAreaUserId%>");
		}
		
		// �ж��Ƿ�����û�
		if (sRawUserId!=null && sCurUserId!=null && sRawUserId && sCurUserId && (sCurUserId!=sRawUserId)) {
			RunMethod("���÷���", "updateCitySuper", sCurUserId+","+sProvinceNo+","+sAreaNo);
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