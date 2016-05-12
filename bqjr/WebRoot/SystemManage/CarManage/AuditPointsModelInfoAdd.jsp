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
		History Log:  CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ҫ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ҫ����Ϣ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	//����������
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	if (null == sFlowNo) sFlowNo = "";
	if (null == sPhaseNo) sPhaseNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
										{"AuditpointsNO","���"},
										{"FlowNo","���̱��"},
										{"PhaseNo","�׶α��"},
										{"Time","����ʱ��"},
						   }; 
	sSql = 	" select ap.AuditpointsNO as AuditpointsNO,ap.flowno as FlowNo,ap.phaseno as PhaseNo, "+
			" ap.time as Time "+	
			" from auditpoints ap "+
			" where ap.flowno='"+sFlowNo+"' and ap.phaseno='"+sPhaseNo+"'"+
			" order by Time desc ";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ùؼ���
	doTemp.setKeyFilter("AuditpointsNO");
	doTemp.setKey("AuditpointsNO",true);	
	//�����ֶ� 
	//doTemp.setVisible("FlowNo,PhaseNo",false); CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
	//doTemp.multiSelectionEnabled=true;// �����ѡ
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","Time","");
	doTemp.parseFilterData(request,iPostChange);
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(6);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","����","�������Ҫ��","AddAuditPoints()",sResourcesPath},
		{"true","","Button","�鿴","�鿴���Ҫ��","FindAuditPoints()",sResourcesPath},//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
		{"true","","Button","ɾ��","ɾ�����Ҫ��","DeleteAuditPoints()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------//
	
	function AddAuditPoints()
	{
		//OpenPage("/SystemManage/CarManage/AuditPointsModelInfo1.jsp","_self","");
		AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelInfo1.jsp","","_self","");

	}
	//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
	function FindAuditPoints()
	{
		var FlowNo = getItemValue(0,getRow(),"FlowNo");
		var PhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var Time = getItemValue(0,getRow(),"Time");
		if (typeof(FlowNo)=="undefined" || FlowNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/CarManage/FindAuditPointsModelInfo.jsp","FlowNo="+FlowNo+"&PhaseNo="+PhaseNo+"&Time="+Time,"_self","");
	}

	function DeleteAuditPoints()
	{
		var AuditpointsNO =getItemValue(0,getRow(),"AuditpointsNO");
		if (typeof(AuditpointsNO)=="undefined" || AuditpointsNO.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷʵɾ���ò�Ʒ��")){
			RunMethod("���÷���","DelByWhereClause","AUDITPOINTS,AuditpointsNO='"+AuditpointsNO+"'");
			as_del("myiframe0");
			reloadSelf();
		}
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

<%@ include file="/IncludeEnd.jsp"%>
