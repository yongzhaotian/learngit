<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		ҳ��˵��: ��Ϣ����ʾ��ҳ��
	 */
	String PG_TITLE = "��Ϣ����ʾ��ҳ��";

	//���ҳ�����	
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleId"));
	if(sExampleId==null) sExampleId="";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ExampleInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����һ��HTMLģ��
	/* String sHTMLTemplate = "<table border=0 width='100%'  cellspacing='0' cellpadding='0'>";
	sHTMLTemplate += "<tr onclick='parent.my_toggle_n(this)' height=1 ><td class='dw_title'>����һ</td></tr>";
	sHTMLTemplate += "<tr><td class='dw_conacte'> ${DOCK:PART1} </td></tr>";
	sHTMLTemplate += "<tr onclick='parent.my_toggle_n(this)' height=1><td class='dw_title'>�����</td></tr>";
	sHTMLTemplate += "<tr><td  class='dw_conacte'> ${DOCK:PART2} </td></tr>";
	sHTMLTemplate += "<tr onclick='parent.my_toggle_n(this)' height=1><td class='dw_title'>������Ϣ</td></tr>";
	sHTMLTemplate += "<tr><td class='dw_conacte'> ${DOCK:default} </td></tr>";
	sHTMLTemplate += "</table>"; */
	//��ģ��Ӧ����Datawindow
	//dwTemp.setHarborTemplate(sHTMLTemplate);
	
	//��DW���ֶηŵ�ģ��Ĳ�λ(Dock)��
	//doTemp.setColumnAttribute("ExampleId,SortNo,ExampleName,ParentExampleId,BeginDate","DockOptions","DockID=PART1");
	//doTemp.setColumnAttribute("AuditUser,AuditUserName,InputUser,InputUserName,InputTime,ApplySum,CustomerType","DockOptions","DockID=PART2");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleId);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","���沢����","���������޸�,�������б�ҳ��","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
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
		AsControl.OpenView("/FrameCase/ExampleList.jsp","","_self","");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,getRow(),"ExampleId",getSerialNo("EXAMPLE_INFO","ExampleId"));//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	<%/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;]~*/%>
	function initRow(){
		if(getRowCount(0)==0){
			as_add("myiframe0");
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