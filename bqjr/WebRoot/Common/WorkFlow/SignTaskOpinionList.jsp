<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 
		
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	
// ���ҳ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,CurComp.getParameter("CustomerID"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	
    System.out.println("----"+sCustomerID+"----"+sObjectNo+"-----"+sObjectType);

	if(sCustomerID==null) sCustomerID="";
	if(sObjectNo==null) sObjectNo="";
	if(sObjectType==null) sObjectType="";

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "OldBusinessContractList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	// doTemp.WhereClause+=" and exists (select * from Formatdoc_Record where (objectType='ApplySettle' or objectType = 'CashLoanSettle') and objectno=BUSINESS_CONTRACT.Serialno) "+
	 //" and not exists(select objectno from flow_object where objectno = BUSINESS_CONTRACT.Serialno and phaseno = '9000' and (flowno = 'CreditFlow' or flowno = 'CashLoanFlow'))";
	doTemp.WhereClause+="and 1=1";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);//�����������ݣ�2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String AppUrl = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String JQMUrl = CodeCache.getItem("PrintAppUrl","0013").getItemAttribute();
	String FCUrl = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","�����¼","myDetail()",sResourcesPath},	
		{"false","","Button","�鿴���Ӻ�ͬ","�鿴���Ӻ�ͬ","",sResourcesPath},
		{"true","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ѯ�׶���Ϣ
		var sPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		var sFlowNo=RunMethod("BusinessManage","GetFlowObjectInfo",sObjectType+","+sObjectNo);
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function myDetail(){
		sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sObjectType = "ApplySettle";	
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		var sAppFlag = RunMethod("���÷���", "GetColValue", "Business_Contract,SureType,SerialNo='<%=sObjectNo%>'");
		var url = "";
		if(sAppFlag=="APP"){//APP���ύ����
			url="<%=AppUrl%>"+<%=sObjectNo%>;
			window.open(url);
			return;
		}else if(sAppFlag=="JQM"){
			url="<%=JQMUrl%>"+<%=sObjectNo%>;
			window.open(url);
			return;
		}else if(sAppFlag=="FC"){
			url="<%=FCUrl%>"+<%=sObjectNo%>;
			window.open(url);
			return;
		}
		
/*		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		var sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>";
//		if (sFlowNo=="PutOutFlow" && sPhaseNo != "0035") {
//			sParamString += "&ViewID=002";
//		}
		//OpenComp(sCompID,sCompURL,sParamString,"","maximize:yes;help:no;minimize:yes");
		AsControl.PopComp(sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
//		popComp(sCompID,sCompURL,"","dialogWidth=100%;dialogHeight=;resizable=no;scrollbars=no;status:yes;maximize:yes;help:no;minimize:yes");
     */ 
		//��ü��ܺ�ĳ�����ˮ��
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sSerialNo);
		//ͨ����serverlet ��ҳ��
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
	}
	
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

