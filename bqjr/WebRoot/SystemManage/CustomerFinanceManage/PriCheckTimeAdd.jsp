<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		Author:  xswang 2015/07/16
		Tester:
		Content: �������ʱ������
		Input Param:
		Output param:
		History Log: 
	*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	String PG_TITLE = "�����������ʱ������";
	//���ҳ�����
	String sPriority =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Priority"));
	String sTime =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Time"));
	if(sPriority==null) sPriority="";
	if(sTime==null) sTime="";
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PriCheckTimeInfo1";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPriority);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","����ҳ��", "backRecord()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(){
		var sPriority =  getItemValue(0,0,"Priority");
		var sTime =  getItemValue(0,0,"Time");
		if(!(/^[1-9]\d*$/).test(sPriority)){
			alert("���ȼ�ӦΪ������!");
			return;
		}
		if(bIsInsert && checkPrimaryKey("PriCheckTimeInfo","Priority")){
			alert("�����ȼ��Ѵ���!");
			return;
		}
		if(!(/^[1-9]\d*$/).test(sTime)){
			alert("ʱ��ӦΪ������!");
			return;
		}
		setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		as_save("myiframe0","");
		alert("����ɹ�!");
		window.close();
	}

	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");

			setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			bIsInsert = true;
		}else{
			setItemReadOnly(0, 0, "Priority", true);
			setItemValue(0, 0, "Priority", "<%=sPriority%>");
			setItemValue(0, 0, "Time", "<%=sTime%>");
		}
    }
	
	function backRecord(){
		window.close();
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>