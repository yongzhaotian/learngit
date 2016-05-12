<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: ծȨ���ֵǼǹ���;
*	Input Param:
*		ObjectType:��������															
*		ObjectNo  :��ͬ���
*	Output Param:     
*        	SerialNo  :������ˮ��
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ծȨ���ֵǼǹ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//����������	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));     //��ͬ���	
	
	String sSql="";
	String sArtificialNo="";
	String sCustomerName="";
	String sCurrency="";
	
	sSql =  "  select ArtificialNo,CustomerName,BusinessCurrency "+
   	 	 	"  from BUSINESS_CONTRACT "+
            "  where SerialNo =:SerialNo ";
   	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo)); 
   	if(rs.next()){
		//��ͬ��š��ͻ����ơ�����
		sArtificialNo = DataConvert.toString(rs.getString("ArtificialNo"));
		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
		sCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
   	String sHeaders[][] = {
					{"SerialNo","������ˮ��"},
					{"CashBackType","�ջط�ʽ"},
					{"FormerCurrency","ԭ����"},
					{"ReclaimCurrency","���ֱ���"},
					{"ReclaimSum","���ֽ��(Ԫ)"},
					{"EnterAccountDate","��������"},			
					{"ReclaimDate","��������"},
					{"InputUserName","�Ǽ���"},
					{"InputOrgName","�Ǽǻ���"},
					{"InputDate","�Ǽ�����"}
			       };  

	sSql = 	" select  SerialNo,"+
			" getItemName('CashBackType2',CashBackType) as CashBackType,"+
			" getItemName('Currency',FormerCurrency) as FormerCurrency,"+
			" getItemName('Currency',ReclaimCurrency) as ReclaimCurrency,"+
			" ReclaimSum,"+
			" EnterAccountDate,"+			
			" ReclaimDate,"+
			" getUserName(InputUserID) as InputUserName," +	
			" getOrgName(InputOrgID) as InputOrgName," +																																																							
			" InputDate " +	
			" from RECLAIM_INFO " +
			" where ObjectType='"+sObjectType+"' "+
			" and ObjectNo='"+sObjectNo+"' "+
			" order by InputDate desc";

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "RECLAIM_INFO";

	doTemp.setType("ReclaimSum","Number");
	//����
	doTemp.setAlign("ReclaimSum","3");
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo",false);
    
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("ReclaimSum","2");
	doTemp.setHTMLStyle("CashBackType"," style={width:80px} ");
	doTemp.setHTMLStyle("FormerCurrency,ReclaimCurrency"," style={width:90px} ");
	doTemp.setHTMLStyle("SerialNo,ReclaimDate,EnterAccountDate,InputDate,InputUserName"," style={width:80px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);  //��������ҳ

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","����","�����ͻ�����ծȯ��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�ͻ�����ծȯ��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ͻ�����ծȯ��Ϣ","deleteRecord()",sResourcesPath},
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
	function newRecord()
	{
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/CashInfo.jsp?ArtificialNo=<%=sArtificialNo%>&Currency=<%=sCurrency%>&CustomerName=<%=sCustomerName%>","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/CashInfo.jsp?SerialNo="+sSerialNo+"&ArtificialNo=<%=sArtificialNo%>&Currency=<%=sCurrency%>&CustomerName=<%=sCustomerName%>","_self","");
		}
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
