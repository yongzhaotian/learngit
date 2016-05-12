<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
	/*
		Author: sjchuan 2009-10-20
		Tester:
		Content: ��������б�ҳ��,���ݿͻ����͡�����·ݲ�ѯ���м����־Ϊ��������ᡱ�ļ�¼
		Input Param:
			CustomerType: �ͻ�����
				01 ��˾�ͻ� 
				03 ���˿ͻ�
		Output param:
			����·ݣ�AccountMonth
			��ݱ�ţ�DuebillNo
		History Log: 
	*/
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
<%
	// ��������ڱ��� <title> PG_TITLE </title>
	String PG_TITLE = "��������б�"; 
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������:��һ���·�,�ͻ�����
	String sCustomerType; 		
	//����������
	//���ҳ�����
	//CustomerType:�ͻ�����
	sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	String sTempletNo = "ReserveSingleList";
   String sManagerUserID=CurUser.getUserID();
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca)); 
	
	if(!doTemp.haveReceivedFilterCriteria())
	{
		doTemp.WhereClause += " and AccountMonth = (select max(AccountMonth) from RESERVE_TOTAL where CalculateFlag = '20'  and CustomerType like '"+sCustomerType+"%')";
	}			
	
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1"; 
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д     
	dwTemp.ReadOnly = "1"; 
	dwTemp.setPageSize(10);	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerType+","+sManagerUserID);
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
		{"true","","Button","����","��ϼ���ת�������","newRecord()",sResourcesPath},
		{"true","","Button","��������","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
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
	function newRecord(){
		var sCustomerType= "<%=sCustomerType%>";
		var sCompID = "ReserveSingleNew";
		var sCompURL = "/Reserve/ReserveSingle/ReserveSingleNew.jsp";
		var sReturn = popComp(sCompID,sCompURL,"CustomerType="+sCustomerType,"dialogWidth=650px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn) == "undefined" || sReturn.length == 0){
			return;
		}

		if(sReturn == "_SUCCESSFUL_") {
			alert("������ϼ���ת�������ɹ���");
			reloadSelf();
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        var sDueBillNo = getItemValue(0,getRow(),"DuebillNo");
        var sCustomerType = getItemValue(0,getRow(),"CustomerType");
        var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if((typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0) 
            || (typeof(sDueBillNo) == "undefined" || sDueBillNo.length == 0))
        {
            alert("��ѡ��һ����¼��");
            return;
        }
        var sCompID = "ReserveTab";
        var sURL = "/Reserve/ReserveTab.jsp";
        var sParameter = "AccountMonth=" + sAccountMonth +
                         "&DueBillNo=" + sDueBillNo +
                         "&CustomerType=" + sCustomerType +
                         "&ReserveFlag=20" +
                         "&CustomerID=" + sCustomerID;
        popComp(sCompID,sURL,sParameter,"");
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
