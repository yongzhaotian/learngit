<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ������Ϣ����
	 */
	String PG_TITLE = "������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//���ҳ�����	
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CurOrgID"));
	if(sOrgID == null) sOrgID = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "OrgInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sOrgID.equals("")) doTemp.setReadOnly("OrgID,OrgLevel", false);
	
	doTemp.appendHTMLStyle("OrgID,SortNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//��������¼�
	//dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sOrgID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(CurUser.hasRole("099")?"true":"false"),"","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","���ص��б����","doReturn()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false;
	function saveRecord(){
		if(bIsInsert && checkPrimaryKey("ORG_INFO","OrgID")){
			alert("�û������Ѵ��ڣ��������룡");
			return;
		}
		
	    var sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
	    if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0){
        	alert(getBusinessMessage("901"));//��ѡ�񼶱�
        	return;
        }else{
        	if(sOrgLevel != '0'){
        		var sBelongOrgName = getItemValue(0,getRow(),"BelongOrgName");
			    if (typeof(sBelongOrgName) == 'undefined' || sBelongOrgName.length == 0){
		        	alert("��ѡ���ϼ�������");
		        	return;
		        }
        	}
        }
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
       setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
       as_save("myiframe0","");
	}
	
	function checkOrgSortNo(){
		var sSortNo=getItemValue(0,getRow(),"SortNo");
		if(!(typeof(sSortNo) == "undefined" || sSortNo.length==0)){
			var Return=RunMethod("BusinessManage","checkOrgUnique",sSortNo);
			if(Return!=0){
				alert("������Ѵ��ڣ����������룡");
				setItemValue(0,0,"SortNo","");
			}
			
		}
		
	}
    
	function doReturn(){
		if(parent.reloadView){
			parent.reloadView();
		}else{
			OpenPage("/AppConfig/OrgUserManage/OrgList.jsp","_self","");
		}
	}

	<%/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;]~*/%>
	function getOrgName(){
		var sOrgID = getItemValue(0,getRow(),"OrgID");
		var sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0){
        	alert(getBusinessMessage("900"));//�����������ţ�
        	return;
        }
		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0){
        	alert(getBusinessMessage("901"));//��ѡ�񼶱�
        	return;
        }
		sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;
		
		if(<%=sOrgID.startsWith("10")%>){	
			setObjectValue("SelectOrgFunction","","@BelongOrgID@0@BelongOrgName@1",0,0,"");//�������ְ�ܲ���
	    }else{
	    	setObjectValue("SelectOrg",sParaString,"@BelongOrgID@0@BelongOrgName@1",0,0,"");//���һ�����
		}
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>