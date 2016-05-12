<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: ��������(������С��)��Ա�ѽ�������ҵ���б�;
		Input Param:
			CustomerID����ǰ�ͻ����
			NoteType������  �������ţ�Aggregate
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
	String PG_TITLE = "�������ų�Ա�ѽ�������ҵ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sCon="";
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
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerName","��Ա�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"ArtificialNo","�ı���ͬ���"},
							{"OccurTypeName","��������"},
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"FinishDate","��������"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"OperateOrgName","�������"}
						  };

	String sSql =   " select SerialNo,"+
					" CustomerID,getCustomerName(CustomerID) as CustomerName,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" ArtificialNo,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" FinishDate,PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where CustomerID in " 
					+ sCon +
					" and FinishDate is not null "+
					" and (BusinessType like '1%' or BusinessType like '2%' or BusinessType like '3%') ";
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BusinessType,OccurType,VouchType,BusinessCurrency,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("VouchTypeName","2");
	doTemp.setCheckFormat("BusinessSum","2");
	//����html��ʽ
	doTemp.setHTMLStyle("OccurTypeName,Currency,FinishDate,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:180px} ");
	doTemp.setHTMLStyle("VouchTypeName"," style={width:350px} ");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	
	//����datawindow
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
		{"true","","Button","����","�鿴�ѽ�������ҵ������","viewAndEdit()",sResourcesPath},
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
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			sObjectType = "AfterLoan";
			OpenComp("CreditTab","/CreditManage/CreditApply/ObjectTab.jsp","ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"_blank","OpenStyle");
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

<%@	include file="/IncludeEnd.jsp"%>
