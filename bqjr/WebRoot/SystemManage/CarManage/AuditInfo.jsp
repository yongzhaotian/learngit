<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�ŵ���Ϣ";

	// ���ҳ�����
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	if(sPhaseNo==null) sPhaseNo="";
	String sFlowNo = "ApproveManageFlow";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ApproveManageFlowInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseNo);//�������,���ŷָ�
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
		
		AsControl.OpenView("/SystemManage/CarManage/AuditList.jsp","PhaseNo=<%=sPhaseNo %>","_self","");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		//setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		//setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,0,"FLOWNO","<%=sFlowNo %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			//setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			//setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");

			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
