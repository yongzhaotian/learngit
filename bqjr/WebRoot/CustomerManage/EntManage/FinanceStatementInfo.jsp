<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jbye 2004-12-16 20:40
		Tester:
		Describe: �޸ı�����Ϣ
		Input Param:
			--sRecordNo:	������ˮ��
			
		Output Param:

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����˵��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sRecordNo = "";//--������ˮ��
	boolean isEditable=true;
	String sSql = "";//--���sql���
	//����������,������ˮ��
	sRecordNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sEditable =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable"));
	if("false".equals(sEditable))isEditable=false;
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sHeaders[][] = {
							{"CustomerID","�ͻ���"},
							{"RecordNo","��¼��"},
							{"ReportDate","��������"},
							{"ReportScope","����ھ�"},
							{"ReportPeriod","��������"},
							{"ReportCurrency","�������"},
							{"ReportUnit","����λ"},
							{"ReportStatus","����״̬"},
							{"ReportFlag","�������־"},
							{"ReportOpinion","����ע��"},
							{"AuditFlag","�Ƿ����"},
							{"AuditOffice","��Ƶ�λ"},
							{"AuditOpinion","������"},
							{"InputDate","�Ǽ�����"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},
							{"UpdateDate","�޸�����"},
							{"Remark","��ע"}

						  };

	sSql = 	" select CustomerID,RecordNo,ReportDate,ReportScope,ReportPeriod,ReportCurrency,"+
			" ReportUnit,ReportStatus,ReportFlag,ReportOpinion,AuditFlag,AuditOffice,AuditOpinion,"+
			" getUserName(UserID) as UserName,"+
			" getOrgName(OrgID) as OrgName,"+
			" InputDate,OrgID,UserID,UpdateDate,Remark "+
			" from CUSTOMER_FSRECORD "+
			" where RecordNo='"+sRecordNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_FSRECORD";
	doTemp.setKey("RecordNo",true);	
	doTemp.setUpdateable("UserName,OrgName",false);
	
	doTemp.setRequired("ReportScope,ReportPeriod,ReportUnit,ReportCurrency",true);
	doTemp.setVisible("CustomerID,RecordNo,OrgID,UserID,Remark,ReportStatus,ReportFlag",false);
	//�����б�
	doTemp.setDDDWCode("ReportPeriod","ReportPeriod");
	doTemp.setDDDWCode("ReportCurrency","Currency");
	doTemp.setDDDWCode("ReportStatus","ReportStatus");
	doTemp.setDDDWCode("ReportScope","ReportScope");
	doTemp.setDDDWCode("ReportUnit","ReportUnit");
	doTemp.setDDDWCode("AuditFlag","YesNo");
	
	doTemp.setEditStyle("ReportOpinion,AuditOpinion","3");
	doTemp.setReadOnly("ReportDate,UserName,OrgName,InputDate,UpdateDate",true);
	doTemp.appendHTMLStyle("ReportDate"," style={width=55px} ");
	doTemp.appendHTMLStyle("ReportOpinion,AuditOpinion","  style={height:100px;width:400px;overflow:auto} ");
    doTemp.setLimit("ReportOpinion,AuditOpinion",200);
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.setEvent ("AfterUpdate","!CustomerManage.SaveFinanceReport(#CustomerID,#RecordNo,#ReportScope,#ReportDate)");
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{isEditable?"true":"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�-----------------------//
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		//��ǰ�·ݲ��񱨱��Ѵ���
		if(checkFSMonth()){
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		alert(sReportDate +" �Ĳ��񱨱��Ѵ��ڣ�");
		return;
		}
		setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"OrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		as_save("myiframe0");
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function goBack()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		OpenComp("CustomerFSList","/CustomerManage/EntManage/CustomerFSList.jsp","CustomerID="+sCustomerID,"_self",OpenStyle);
	}
	
	/*~[Describe=��ȡ�·�;InputParam=�����¼�;OutPutParam=��;]~*/
	function getMonth(sObject)
	{
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined")
		{
			setItemValue(0,0,sObject,sReturnMonth);
		}
	}
	/*~[Describe=��ⱨ���·��Ƿ��Ѵ���;InputParam=�����¼�;OutPutParam=��;]~*/
	function checkFSMonth(){
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReturn=RunMethod("CustomerManage","CheckFSRecord",sCustomerID+","+sRecordNo+","+sReportDate);
		if(sReturn>0)return true;
		return false;
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
