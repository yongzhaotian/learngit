<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --���޲���
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���޲���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ�����
	String sTypeNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));	
	String sCurItemID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("curItemID"));	
	if(sCurItemID==null)  sCurItemID="";
	if(sTypeNo==null) sTypeNo="";
	String sTempletNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	if(sCurItemID.equals("01")){
		sTempletNo = "TermInfo";
	}else{
		sTempletNo = "TermInfo1";
	};
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setUnit("loanFixedRate,highestFixedRate,shouFuRatio,floatingRate,sectionRatio,dealerCommissionRate,salesCommission,discountFixedRate,sectionFixedRate,salvageRate,BondRate", "%");
	doTemp.setAlign("loanFixedRate,highestFixedRate,shouFuRatio,floatingRate,sectionRatio,dealerCommissionRate,salesCommission,discountFixedRate,sectionFixedRate,salvageRate,BondRate", "3");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
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
			{"true","","Button","����","����","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","back()",sResourcesPath}

		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{	
		var sTerm =getItemValue(0,getRow(),"term");
		var sUnique = RunMethod("Unique","uniques","term,count(1),term='"+sTerm+"' and typeNo='<%=sTypeNo %>'");
		if(bIsInsert && sUnique>="1.0"){
			alert("�������Ѵ���,�������µ����ޣ���");
			return;
		}
	    as_save("myiframe0");
	    OpenComp("","/BusinessManage/BusinessType/CarLoan/TermList.jsp","typeNo=<%=sTypeNo%>&curItemID=<%=sCurItemID%>","right");
	}
    
    function back(){
		OpenPage("/BusinessManage/BusinessType/CarLoan/TermList.jsp","_self","");
    }

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
		setItemValue(0,0,"termID", getSerialNo("term", "termID", " "));
		setItemValue(0,0,"typeNo", "<%=sTypeNo%>");
		setItemValue(0,0,"inputOrg", "<%=CurOrg.orgID%>");
		setItemValue(0,0,"inputOrgName", "<%=CurOrg.orgName%>");
		setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"updateOrg", "<%=CurOrg.orgID%>");
		setItemValue(0,0,"updateOrgName", "<%=CurOrg.orgName%>");
		setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
