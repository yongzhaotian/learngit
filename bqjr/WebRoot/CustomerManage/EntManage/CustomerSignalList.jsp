<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xuzhang 2005-1-21
		Tester:
		Describe:Ԥ���źŷ�����ʾ;
		Input Param:
			CustomerID���ͻ����
		Output Param:
			
		HistoryLog:
	 */ 
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�������ʾ��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sEnter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Enter"));
	if(sEnter == null) sEnter = "";
	//���ñ�ͷ
	String sHeaders[][] = {	{"CustomerName","�ͻ�����"},
							{"signalName","�����ź�����"},
							{"serialNO","��ˮ��"},
							{"SignalStatus","Ԥ���ź�״̬"}
							};
	
	
	String sSql =	" select serialNo,getCustomerName(objectNo) as CustomerName,"+
					" getItemName('AlertSignal',Signaltype) as signalName, "+
					" getItemName('SignalStatus',SignalStatus) as SignalStatus,"+
					" InputUserID"+
					" from risk_signal" +
					" where objectNo='"+sCustomerID+"'";
	//ͨ��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "risk_signal";
	doTemp.setKey("serialNo",true);	

	doTemp.setVisible("serialNo,InputUserID,SignalStatus",false);
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("signalName"," style={width:280px} ");


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
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		{"true","","Button","����","��������Ԥ��","Signal_add()",sResourcesPath},
		{"true","","Button","����Ԥ������","�鿴����Ԥ������ϸ��Ϣ","Signal_Detail()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���÷���Ԥ��","Signal_Delete()",sResourcesPath},
		};
		if(sEnter.equals("80"))
		{
		    sButtons[0][0] = "false";
		    sButtons[2][0] = "false";
		}
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	//��������Ԥ���ź�
	function Signal_add()
	{
		sReturn =popComp("SelectSignal","/CustomerManage/EntManage/SelectSignal.jsp","CustomerID=<%=sCustomerID%>","dialogWidth=28;dialogHeight=32;center:yes;status:no;statusbar:no;scrollbars:yes");
		if(typeof(sReturn) != "undefined" && sReturn != "" )
		{	
			sReturnValue=popComp("AddSignalInfo","/CustomerManage/EntManage/AddSignalInfo.jsp","CustomerID=<%=sCustomerID%>&SignalType="+sReturn,"dialogWidth=38;dialogHeight=32;center:yes;status:no;statusbar:no");
			OpenComp("SignalInfoList","/CustomerManage/EntManage/CustomerSignalList.jsp","CustomerID=<%=sCustomerID%>","_self",OpenStyle);
		}
	}

	//�鿴����Ԥ������ϸ��Ϣ
	function Signal_Detail()
	{
		sRecordNo = getItemValue(0,getRow(),"serialNo");
		if (typeof(sRecordNo) != "undefined" && sRecordNo != "" )
		{
			OpenComp("SignalInfo","/CustomerManage/EntManage/SignalInfo.jsp","serialNo="+sRecordNo+"&Enter=<%=sEnter%>","_self");
		}else
		{
			alert("��ѡ��һ����¼");
		}
	}

	//ɾ���÷���Ԥ��
	function Signal_Delete()
	{
		sUserID=getItemValue(0,getRow(),"InputUserID");
		sRecordNo = getItemValue(0,getRow(),"serialNo");
		if (typeof(sRecordNo) == "undefined" && sRecordNo == "" )
		{
			alert("��ѡ��һ����¼");
		}
		else if(sUserID=='<%=CurUser.getUserID()%>')
		{
			if(confirm("��ȷ��Ҫɾ����Ԥ����Ϣ��"))
			{			
				sReturn = PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Delete&SerialNo="+sRecordNo,"_self",OpenStyle);
				if(sReturn=="ok")
				{
					reloadSelf();
				}
			}
		}else alert(getHtmlMessage('3'));
	}
</script>
	
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>

