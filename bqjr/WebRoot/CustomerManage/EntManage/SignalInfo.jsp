<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xuzhang 2005-1-21
		Tester:
		Describe:Ԥ���źŷ�����ʾ����;
		Input Param:
			serialNo��Ԥ����Ϣ��ˮ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�������ʾ��Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));
	String sEnter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Enter"));
	if(sSerialNo == null) sSerialNo = "";
	if(sEnter == null) sEnter = "";
	//���ñ�ͷ
	String sHeaders[][] = {
							{"CustomerName","�ͻ�����"},
							{"signalName","�����ź�����"},
							{"ObjectNo","�ͻ���"},
							{"Remark","��ϸ��Ϣ"}
						   };
	
	
	String sSql =	"select getCustomerName(objectNo) as CustomerName,"+
					" getItemName('AlertSignal',Signaltype) as signalName, "+
					" ObjectNo,Remark"+
					" from risk_signal" +
					" where serialNo='"+sSerialNo+"'";
	//ͨ��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "risk_signal";


	doTemp.setVisible("ObjectNo",false);
	doTemp.setEditStyle("Remark","3");//��ʾ����Ϊtextarea
	doTemp.setHTMLStyle("CustomerName"," style={width:100px} ");
	doTemp.setHTMLStyle("signalName"," style={width:280px} ");


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����ΪFree���
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
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		{"true","","Button","����","������������Ԥ���б�","Back()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
//������������Ԥ���б�
	function Back()
	{
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		//alert("��ѡ��һ����¼"+sObjectNo);
		OpenComp("SignalInfoList","/CustomerManage/EntManage/CustomerSignalList.jsp","CustomerID="+sObjectNo+"&Enter=<%=sEnter%>","_self",OpenStyle);
	}

</script>
	
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>

