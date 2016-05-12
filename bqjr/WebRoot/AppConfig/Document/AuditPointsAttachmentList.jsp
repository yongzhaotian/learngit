<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ĵ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������                     
    String sSql = "";
	//���ҳ�����
	
	//����������
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String docTitle = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocTitle"));
	//��ȡ��ͬ�ս�����
    String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
    if(sFinishType == null) sFinishType = "";
    //��ȡ�鵵����
    String sPigeonholeDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PigeonholeDate"));   
    if(sPigeonholeDate == null) sPigeonholeDate = "";
	
	if(docTitle == null) docTitle = "";
	if(sDocNo == null) sDocNo = "";
	if(sUserID == null) sUserID = "";
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

 	String sTempletNo = "AuditPointsAttachmentList"; //ģ����

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);//25��һ��ҳ
	
	//ɾ����Ӧ�������ļ�;DelDocFile(����,where���)
	dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(DOC_ATTACHMENT,DocNo='#DocNo' and AttachmentNo='#AttachmentNo')");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sPhaseNo);//������ʾģ�����
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
		{(CurUser.getUserID().equals(sUserID)?(sFinishType.equals("")?(sPigeonholeDate.equals("")?"true":"false"):"false"):"false"),"All","Button","����","����һ����ظ�����Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","�鿴����","�鿴��������","viewFile()",sResourcesPath},
		{(CurUser.getUserID().equals(sUserID)?(sFinishType.equals("")?(sPigeonholeDate.equals("")?"true":"false"):"false"):"false"),"All","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/	
	function newRecord()
	{
		var sDocNo="<%=sDocNo%>";
		popComp("AttachmentChooseDialog","/AppConfig/Document/AttachmentChooseDialog.jsp","DocNo="+sDocNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
        		as_del('myiframe0');
        		as_save('myiframe0'); 
        		reloadSelf();
    		}
		}
		
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewFile()
	{
		sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		sDocNo= getItemValue(0,getRow(),"DocNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		else
		{
			popComp("AttachmentView","/AppConfig/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
	}
		
	function goBack()
	{
		self.close();
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
