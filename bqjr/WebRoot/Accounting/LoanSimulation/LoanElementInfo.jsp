<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  	ttyu 2013.8.26
		Tester:
		Content: �����Ҫ��Ϣ
		Input Param:
			productID�� ��Ʒ���
			productVersion����Ʒ�汾
		Output param:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ѯ"; 
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String displayTemplet = "LoanElementInfo";
	ASDataObject doTemp = new ASDataObject(displayTemplet,Sqlca);
	//����DataWindow����
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";
	
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
		{"true","All","Button","���ɻ���ƻ�","���ɻ���ƻ�","makePlan()","","","",""},
		{"true","All","Button","���滹��ƻ�","���滹��ƻ�","as_save(0)","","","",""},
		{"true","All","Button","����Execl","����Execl","as_save(0)","","","",""}
	};
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	function makePlan(){
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		var sRateYear = getItemValue(0,getRow(),"RateYear");
		var sRepayFrequency = getItemValue(0,getRow(),"RepayFrequency");
		var sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
		var sTermMonth = getItemValue(0,getRow(),"TermMonth");
		var sFirstRepaymentDate = getItemValue(0,getRow(),"FirstRepaymentDate");
		
		var sParam = "BusinessSum="+sBusinessSum+"&RateYear="+sRateYear+"&RepayFrequency="+sRepayFrequency+"&PutOutDate="+sPutOutDate+"&TermMonth="+sTermMonth+"&FirstRepaymentDate="+sFirstRepaymentDate;
		AsControl.OpenView("/Accounting/LoanSimulation/LoanPlanInfo.jsp",sParam,"rightdown","");
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
		}
    }
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	bCheckBeforeUnload=false;
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>