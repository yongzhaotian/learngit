<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-07
		Tester:
		Describe: ҵ�������Ϣ;
		Input Param:
			SerialNo:��ˮ��
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";

	//����������
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sSerialNo==null) sSerialNo="";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { {"SerialNo","��ͬ��ˮ��"},
	                        {"ArtificialNo","��ͬ���"},
							{"CustomerName","�ͻ�����"},
							{"CustomerID","�ͻ�����"},
							{"Currency","����"}, 
							{"BusinessSum","��ͬ���(Ԫ)"},
							{"ActualPutOutSum","ʵ�ʷ��Ž��(Ԫ)"},                           
							{"Balance","���(Ԫ)"}, 
							{"NormalBalance","�������(Ԫ)"},			
							{"OverDueBalance","�������(Ԫ)"}, 
							{"DullBalance","�������(Ԫ)"},  
							{"BadBalance","�������(Ԫ)"},                          
			                {"InterestBalance1","����ǷϢ(Ԫ)"},
			                {"InterestBalance2","����ǷϢ(Ԫ)"}
			       };

	sSql = 	" select SerialNo,ArtificialNo,CustomerName,CustomerID,"+
			" getItemName('Currency',BusinessCurrency) as Currency,BusinessSum,"+
			" ActualPutOutSum,Balance,NormalBalance,OverDueBalance,"+
	   		" DullBalance,BadBalance,InterestBalance1,InterestBalance2 "+
	    	" from BUSINESS_CONTRACT where SerialNo='"+sSerialNo+"'  ";


	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setHeader(sHeaders);
	doTemp.setKey("SerialNo",true);

	doTemp.setAlign("BusinessSum,ActualPutOutSum,Balance,NormalBalance,OverDueBalance,DullBalance,BadBalance,InterestBalance1,InterestBalance2","3");
	doTemp.setCheckFormat("BusinessSum,ActualPutOutSum,Balance,NormalBalance,OverDueBalance,DullBalance,BadBalance,InterestBalance1,InterestBalance2","2");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:180px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function initRow()
	{
    }
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

