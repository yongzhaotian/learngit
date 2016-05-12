<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "�ֽ����б�"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������
	String sSql = "";
	//���ҳ�����
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")));
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));
	String sPayType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PayType")));
	
	if(objectNo==null) objectNo="";
	if(objectType==null) objectType="";
	if(sPayType==null) sPayType="";
	
	// ����̨���б�
	ASDataObject doTemp = new ASDataObject("PaymentScheduleList",Sqlca);

	
	// ���ò�ѯ��
    doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType+","+sPayType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
		{"true","","Button","����ƻ���","����ƻ���","viewPayment()",sResourcesPath},
		};
	%>


<%@include file="/Resources/CodeParts/List05.jsp"%>

	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	
	function exportAll()
	{
		amarExport("myiframe0");
	}
	
	/*~[Describe=��ѯ����ƻ���;InputParam=��;OutPutParam=��;]~*/
	function viewPayment(){
		PopComp("SimulationPaymentSchedule","/Accounting/Transaction/SimulationPaymentSchedule.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&RightType=ReadOnly","");
	}
	
	/*~[Describe=ҳ���ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		//����Ӧ���ܽ�ʵ���ܽ��
			var num = getRowCount(0);
			for(var i=0;i<num;i++){
			var PayPrincipalAmt=getItemValue(0,i,"PayPrincipalAmt");
			var PayInteAMT=getItemValue(0,i,"PayInteAMT");
			var PayFineAMT=getItemValue(0,i,"PayFineAMT");
			var PayCompdInteAMT=getItemValue(0,i,"PayCompdInteAMT");
			var sPayAll=PayPrincipalAmt+PayInteAMT+PayFineAMT+PayCompdInteAMT;
			setItemValue(0,i,"PayAll",sPayAll);
			var ActualPayPrincipalAmt=getItemValue(0,i,"ActualPayPrincipalAmt");
			var ActualPayInteAMT=getItemValue(0,i,"ActualPayInteAMT");
			var ActualPayFineAMT=getItemValue(0,getRow(),"ActualPayFineAMT");
			var ActualPayCompdInteAMT=getItemValue(0,i,"ActualPayCompdInteAMT");
			var sActualAll=ActualPayPrincipalAmt+ActualPayInteAMT+ActualPayFineAMT+ActualPayCompdInteAMT;
			setItemValue(0,i,"ActualAll",sActualAll);
		}
	}
	/*~[Describe=ҳ���ҳ��ֵ;InputParam=��;OutPutParam=��;]~*/
	function MR1_s(myobjname,myact,my_sortorder,sort_which,need_change){
		if(!beforeMR1S(myobjname,myact,my_sortorder,sort_which,need_change)) return;
	 	var s = getDWData(myobjname,myact);
	 	if(typeof(s)!="undefined") my_load(2,0,myobjname);
	 	initRow();
	}
	</script>


<script	language=javascript>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	initRow();
</script>


<%@	include file="/IncludeEnd.jsp"%>