<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   rqiao 20141118
		Tester:
		Content:   �����ֽ���ά��
		Input Param:
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ֽ���ά��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
    //��Ʒ����
    String sEventStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EventStatus"));
    if(null == sEventStatus) sEventStatus = "";
    
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("CashLoanList",Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sEventStatus);
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
			{"false","","Button","����","�������ü�¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�����¼","myDetail()",sResourcesPath},
			{"false","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
			{"false","","Button","��Ч","��Ч","UpdateStatus(\'"+sEventStatus+"\')",sResourcesPath},
		    };
	//δ��ʼ�Ļ
	if("01".equals(sEventStatus))
	{
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
		sButtons[3][0] = "true";
	}
	//�����еĻ
	if("02".equals(sEventStatus))
	{
		sButtons[3][3] = "����";
		sButtons[3][4] = "����";
		sButtons[3][0] = "true";
	}
	
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
	
	function newRecord()
	{
		//����
		var sSerialNo = "<%=DBKeyHelp.getSerialNoXD("BUSINESS_CASHLOANEVENT", "SERIALNO", "yyyyMMdd", "000", new  Date(), Sqlca)%>";
		//�״̬
		var sEventStatus = "<%=sEventStatus%>";
		RunMethod("BusinessManage","InsertCashLoanEvent",sSerialNo+","+sEventStatus+",<%=CurUser.getUserID()%>,<%=CurOrg.orgID%>,<%=StringFunction.getToday()%>");
		AsControl.OpenView("/BusinessManage/Products/CashLoan/CashLoanTab.jsp","SerialNo="+sSerialNo+"&EventStatus="+sEventStatus,"_blank","");
		reloadSelf();
	}
    
    function myDetail(){
        var sEventStatus = "<%=sEventStatus%>";
    	var sSerialNo =getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/Products/CashLoan/CashLoanTab.jsp","SerialNo="+sSerialNo+"&EventStatus = "+sEventStatus,"_blank","");
		reloadSelf();
	}
    
	function deleteRecord(){
		var sSerialNo =getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷʵɾ���û��")){
			RunMethod("���÷���","DelByWhereClause","BUSINESS_CASHLOAN_RELATIVE,EVENTSERIALNO='"+sSerialNo+"'");
			as_del("myiframe0");
		    as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}

	function UpdateStatus(sEventStatus){
		var sSerialNo =getItemValue(0,getRow(),"SERIALNO");
		
		var Status = "��Ч";
		var NextEventStatus = "02";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		/*update tangyb CCS-817 ��ӡ������ϡ�״̬ start*/
		if("02" == sEventStatus) {
			Status = "����";
			
			var enddate =getItemValue(0,getRow(),"ENDDATE"); //��������
			start = enddate.split('/'); //�õ���ʱ��ؼ���ʽ��yyyy/MM/dd

			var date = new Date(); //��ǰ����
			
			//��Ϊ��ǰʱ����·���Ҫ+1�����ڴ�-1����Ȼ�͵�ǰʱ�����Ƚϻ��жϴ���
			var start1 = new Date(start[0], start[1] - 1, start[2]); 

			if (date > start1) {
				NextEventStatus = "03";//������Ч�ڻ�޸�״̬Ϊ"03:����"
			}else{
				NextEventStatus = "04";//��Ч���ڵĻ�޸�״̬Ϊ��04�������ϡ�
			}
		} else {
			var error = "";
			var eventname =getItemValue(0,getRow(),"EVENTNAME"); //�����
			var eventattribute =getItemValue(0,getRow(),"EVENTATTRIBUTE"); //�����
			var eventtype =getItemValue(0,getRow(),"EVENTTYPE"); //����
			var begindate =getItemValue(0,getRow(),"BEGINDATE"); //��ʼ����
			var enddate =getItemValue(0,getRow(),"ENDDATE"); //��������
			
			if(eventname == null || eventname == ""){
				error = "�����";
			}
			
			if(eventattribute == null || eventattribute == ""){
				if(error == ""){
					error = "�����";
				}else{
					error = error + "�������";
				}
			}
			
			if(eventtype == null || eventtype == ""){
				if(error == ""){
					error = "����";
				}else{
					error = error + "������";
				}
			}
			
			if(begindate == null || begindate == ""){
				if(error == ""){
					error = "��ʼ����";
				}else{
					error = error + "����ʼ����";
				}
			}
			
			if(enddate == null || enddate == ""){
				if(error == ""){
					error = "��������";
				}else{
					error = error + "����������";
				}
			}
			
			if(error != ""){ //��������
				alert("["+error+"]Ϊ�ղ�����Ч");
				return;
			}
			
			var count = RunMethod("���÷���", "GetColValue", "BUSINESS_CASHLOAN_RELATIVE,count(*),EVENTSERIALNO='"+sSerialNo+"'");
			if(typeof(count)=="undefined" || parseInt(count)==0){
				alert("�ͻ�����û�е��벻����Ч ");
				return;
			}
		}
		/*end*/

		if(confirm("ȷʵ��Ǹû"+Status+"��")){
			RunMethod("���÷���","UpdateColValue","BUSINESS_CASHLOANEVENT,EVENTSTATUS,"+NextEventStatus+",SERIALNO='"+sSerialNo+"'");
			alert("�����ɹ�"); //add tangyb ��ӳɹ���ʾ
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
