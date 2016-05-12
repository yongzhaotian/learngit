<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: ��������(������С��)��Ա���Ŷ����Ϣ�б�;
		Input Param:
			CustomerID����ǰ�ͻ����
			NoteType������ �������ţ�Aggregate
            		       ����С�飺AssureGroup
		Output Param:
          	ObjectType: �������͡�
        	ObjectNo: �����š�
        	BackType: ���ط�ʽ����(Blank)


		HistoryLog:
		��������С��
		2004-12-14
		jytian
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ų�Ա���Ŷ����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sCon = "";
	
	//���ҳ�����	
	
	//����������	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sNoteType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NoteType"));
	if(sCustomerID == null) sCustomerID = "";
	if(sNoteType == null) sNoteType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	if (sNoteType.equals("Aggregate"))
	{
		//��Ŀ�����CUSTOMER_RELATIVE��ΪGROUP_RELATIVE add by cbsu 2009-11-02
		sCon=" ( Select CustomerID from GROUP_RELATIVE where RelativeID='"+sCustomerID+"' and (RelationShip like '10%' or RelationShip like '20%') )";
	}
    //���������֧�Ǵ����ϵΪ"����С��"�Ŀͻ�����ALS6.5�汾�в�δ�ṩ�˹���ģ�顣������Ӵ˹��ܣ������и��ġ�
	//else if (sNoteType.equals("AssureGroup"))
	//{
	//	sCon=" (select CustomerID from CUSTOMER_RELATIVE where RelativeID='"+sCustomerID+"' and RelationShip='5501' ) ";
	//}
	
	String sHeaders[][] = { 
							{"SerialNo","���ź�ͬ��ˮ��"},
					    	{"CustomerName","��Ա�ͻ�����"},
	                        {"BusinessTypeName","ҵ��Ʒ��"},
	                        {"Currency","����"},
				            {"BusinessSum","���Ŷ�Ƚ��"},
				            {"TotalBalance","ʣ����"},
				            {"VouchTypeName","��Ҫ������ʽ"},
				            {"OperateOrgName","�������"},
				            {"PutOutDate","��ʼ����"},
				            {"Maturity","��������"},
			      		};   				   		
	//ȡ�ù�������(������С��)��ԱCustomerID�б�Sql
	String sSql =   " select SerialNo,"+
					" CustomerID,getCustomerName(CustomerID) as CustomerName,"+
					" BusinessType, getBusinessName(BusinessType) as BusinessTypeName,"+
					" getItemName('Currency',BusinessCurrency) as Currency,BusinessSum,TotalBalance,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,"+
					" PutOutDate,Maturity"+
					" from BUSINESS_CONTRACT "+
					" where CustomerID in  "
					+ sCon +
					" and BusinessType like '3%' and length(BusinessType)>1";

   	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BusinessType,VouchType,OperateOrgID,",false);
	doTemp.setAlign("BusinessSum,TotalBalance","3");
	doTemp.setAlign("BusinessTypeName,VouchTypeName,Currency","2");
	doTemp.setCheckFormat("BusinessSum,TotalBalance","2");
	//���ø�ʽ
	doTemp.setHTMLStyle("BusinessTypeName,CreditTypeName,VouchTypeName,PutOutDate,Maturity,Currency"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:150px} ");
	doTemp.setHTMLStyle("VouchTypeName"," style={width:350px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
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
		{"true","","Button","����","�鿴���Ŷ����Ϣ����","viewAndEdit()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("AfterLoan",sSerialNo,"001");
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

<%@ include file="/IncludeEnd.jsp"%>
