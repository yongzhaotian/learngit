<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: �����ٴδ���
		Input Param:
			ObjectType:
			ObjectNo:
			SerialNo��ҵ����ˮ��
		Output Param:
			SerialNo��ҵ����ˮ��
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ٴδ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sBusinessDate=SystemConfig.getBusinessDate();

	//���ҳ�����

	//����������
	String sCustomerID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")));
	
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	     	
		String sTempletNo = "withholdRecordQuery"; //ģ����
	    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
		//�����µ�from
	//	doTemp.FromClause = "from (select '����' as path,substr(serialno, 17, 8) as customerid,inputdate,payamt,replaceaccount,OPENBANKNAME,REPLACENAME as PAYACCOUNTNAME, manageresultmessage as withholdresult,"+
	//						"'�װ���' as Channel from import_file_ebu ife where not exists (select 1 from import_reconciliation_ebu ire where ife.serialno = ire.serialno)  "+
	//						"union all select '����' as path, substr(serialno, 17, 8) as customerid, inputdate, payamt,replaceaccount, OPENBANKNAME,REPLACENAME as PAYACCOUNTNAME, '���׳ɹ�' as withholdresult,"+
	//						" '�װ���' as Channel  from import_file_ebu ife  where ife.managereturncode='0000' and exists (select 1 from import_reconciliation_ebu ire where ife.serialno = ire.serialno) "+
	//						"union all select '����' as path, substr(ifk.additioninformation, 1, 8) as customerid, ifk.inputdate, ifk.payamt, replaceaccount, "+
	//						"(select a.bankname from bankput_info a where a.bankno=trim(ifk.payopenbankid)) as OPENBANKNAME,PAYACCOUNTNAME, bankreturnremark as withholdresult, "+
	//						"'�츶ͨ' as Channel from import_file_kft ifk union all select '����ֱ��' as path, (case when (bli.customerid is not null and bli.updatedate is not null) then "+
    //                        "bli.customerid else bli.frmcod end) as customerid,(case when (bli.customerid is not null and bli.updatedate is not null) then "+
    //              			"bli.updatedate else bli.inputdate end)as inputdate, "+
	//						"bli.trsamtc as payamt, bli.rpyacc as replaceaccount, bli.rpybnk as OPENBANKNAME,rpynam as PAYACCOUNTNAME, "+
	//						"(case when (bli.customerid is not null and bli.updatedate is not null) then '�ֹ�ƥ��' else 'ϵͳ����' end) as withholdresult, '' as Channel from bank_link_info bli)";
		//���ɲ�ѯ��
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		
		
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		dwTemp.setPageSize(16);  //��������ҳ

		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		//{"true","","Button","����","����","saveRecord()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","EXCEL()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; 
	
	/*~[Describe= ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		
		if(!vI_all("myiframe0")) return;
		as_save("myiframe0",sPostEvents);
	}
	
	//����EXECL
	function EXCEL(){
		amarExport("myiframe0");
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
		
			setItemValue(0, 0, "accountingorgid", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "digest", "<%=CurUser.getUserID()%>");
			setItemValue(0, 0, "payaccountorgid1", "<%=SystemConfig.getBusinessTime()%>");
			
			bIsInsert = true;
		}
	} 
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		//initRow();
	});

</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
