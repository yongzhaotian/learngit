<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: �˿��ѯ
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
	String PG_TITLE = "�˿��ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 
			{"serialno","��ˮ��"},
			{"oldcustomerid","�ͻ���"},
			{"newcontractno","�Ƽ���ͬ��"},
			{"putoutdate","�º�ͬ��������"},
			{"plannedawardamount","�ƻ��������"},
			{"awardresult","�������"},
			{"actualawardamount","ʵ�ʽ������"},
			{"failurecause","ʧ��ԭ��"},
			{"awarddate","���½����������"}
		};
	String sql = "select serialno,oldcustomerid,newcontractno,putoutdate,plannedawardamount,awardresult,actualawardamount,failurecause,awarddate " 
				+ " from customer_recommend_result crr "
				+ " where crr.oldcustomerid='"+sCustomerID+"' ";
	ASDataObject doTemp = new ASDataObject(sql);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("serialno", false);
	doTemp.setDDDWCodeTable("awardresult", "1,�ɹ�,2,ʧ��");
	doTemp.setAlign("plannedawardamount,actualawardamount","3");
	doTemp.setCheckFormat("plannedawardamount,actualawardamount","2");
	doTemp.setAlign("putoutdate,awarddate","2");
	doTemp.setCheckFormat("putoutdate,awarddate","3");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊ��д
	dwTemp.setPageSize(500);
	
	//����datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	
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
