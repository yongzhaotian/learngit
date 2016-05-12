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
	String sSignalType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));
	//out.println(sCustomerID+"   "+sSignalType);
	//�Ȳ���һ����¼�Թ���ʾ�༭
	String sSerialNo=DBKeyHelp.getSerialNo("RISK_SIGNAL","SerialNo",Sqlca);

	String sSql="insert into RISK_SIGNAL(ObjectType,ObjectNo,SerialNo,SignalType) values('Customer',:ObjectNo,:SerialNo,:SignalType)";
	SqlObject so = new SqlObject(sSql);
	so.setParameter("ObjectNo",sCustomerID).setParameter("SerialNo",sSerialNo).setParameter("SignalType",sSignalType);
	Sqlca.executeSQL(so);

	//���ñ�ͷ
	String sHeaders[][] = {	{"CustomerName","�ͻ�����"},
						{"signalName","�����ź�����"},
						{"ObjectNo","�ͻ���"},
						{"Remark","��ϸ��Ϣ"},
						{"SignalStatus","Ԥ���ź�״̬"}
						};
	
	
	sSql =	"select getCustomerName(objectNo) as CustomerName,"+
			" getItemName('AlertSignal',Signaltype) as signalName,ObjectNo,Remark,SignalStatus,"+
			" InputUserID"+
			" from risk_signal" +
			" where serialNo='"+sSerialNo+"'";
	//ͨ��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "risk_signal";

	doTemp.setReadOnly("CustomerName,signalName", true);//ֻ����Ŀ
	doTemp.setVisible("ObjectNo,InputUserID",false);
	doTemp.setEditStyle("Remark","3");//��ʾ����Ϊtextarea
	//����������
	doTemp.setDDDWSql("SignalStatus","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'EffStatus'");
	//����Ĭ��ֵ
	doTemp.setDefaultValue("SignalStatus","01");

	doTemp.setHTMLStyle("CustomerName"," style={width:400px} ");
	doTemp.setHTMLStyle("signalName"," style={width:400px} ");


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����ΪFree���
	//dwTemp.ReadOnly = "1"; //����Ϊֻ��


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
		{"true","","Button","����","�����Ԥ����Ϣ","Save()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ��","Cancel()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	function Save(){
		sRemark=getItemValue(0,getRow(),"Remark");
		sSignalStatus=getItemValue(0,getRow(),"SignalStatus");
		//���û��ѡ��״̬��Ϣ����Ĭ��״̬δ��Ч
		if(typeof(sSignalStatus) == "undefined" || sSignalStatus == "" )
			sSignalStatus="01";
		if(confirm("��ȷ����Ӹ�Ԥ����Ϣ��")){
			PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Add&SerialNo=<%=sSerialNo%>&Remark="+sRemark+"&SignalStatus="+sSignalStatus,"_self",OpenStyle);
			self.close();
		}
	}
	
	function Cancel(){
		if(confirm("��ȷ��ȡ�����Ԥ����Ϣ������")){
			PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Delete&SerialNo=<%=sSerialNo%>","_self",OpenStyle);
			self.close();
		}
	}
	//�رմ���ǰ��ʾ�Ƿ񱣴���ӵ���Ϣ
	document.onbeforeunload = function(){
		if(event.clientX>360&&event.clientY<0||event.altKey){
			if(confirm("�����Ԥ����Ϣ��")){
				sRemark=getItemValue(0,getRow(),"Remark");
				sSignalStatus=getItemValue(0,getRow(),"SignalStatus");
				//���û��ѡ��״̬��Ϣ����Ĭ��״̬δ��Ч
				if(typeof(sSignalStatus) == "undefined" || sSignalStatus == "" )
					sSignalStatus="01";
				PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Add&SerialNo=<%=sSerialNo%>&Remark="+sRemark+"&SignalStatus="+sSignalStatus,"_self",OpenStyle);
			}else
				PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Delete&SerialNo=<%=sSerialNo%>","_self","");
		}
	};
	
  	function initRow(){
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
	}
</script>

<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>

<%@ include file="/IncludeEnd.jsp"%>
