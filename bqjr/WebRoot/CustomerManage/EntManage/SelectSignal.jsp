<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xuzhang 2005-1-21
		Tester:
		Describe:ѡ������Ԥ���źŷ�����ʾ;
		Input Param:
			CustomerID���ͻ����
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ѡ�������ʾ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//out.println(sCustomerID);
	//���ñ�ͷ
	String sHeaders[][] = {{"signalName","�����ź�����"}};
	//ȡ���û�δѡ��ķ�����ʾ�����б�
	String sSql="select itemname as signalName ,itemno as SignalType from code_library where codeno='AlertSignal'"+
				" and itemno not in ("+
				" select Signaltype from risk_signal where objectNo='"+sCustomerID+"')";
	//ͨ��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setHTMLStyle("signalName"," style={width:400px} ");
	doTemp.setVisible("SignalType",false);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));



	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����


%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼���һ��
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		{"true","","Button","ѡ��","ѡ��һ��Ԥ����Ϣ","Next_Step()",sResourcesPath},
		//{"true","","Button","ȡ��","ȡ��","Cancel()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	function Next_Step()
	{
		sRecordNo = getItemValue(0,getRow(),"SignalType");
		if (typeof(sRecordNo) != "undefined" && sRecordNo != "" )
		{
			returnValue=sRecordNo;
			self.close();
		}
		else
		{
			alert("��ѡ��һ��Ԥ����Ϣ");
		}
	}
	/*
	function Cancel()
	{
		if(confirm("��ȷ��Ҫȡ����Ӳ�����"))
		{
			OpenComp("SignalList","/CustomerManage/EntManage/CustomerSignalList.jsp","CustomerID=<%=sCustomerID%>","_self");
		}
	}*/
</script>

<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>

