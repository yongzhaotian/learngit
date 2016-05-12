<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: ��������(������С��)��Աҵ����������б�;
		Input Param:
			NoteType������  �������ţ�Aggregate
            		   	   ����С�飺AssureGroup
			CustomerID����ǰ�ͻ����
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
	String PG_TITLE = "�������ų�Աҵ����������б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"CustomerName","��Ա�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
				            {"SerialNo","������ˮ��"},
				            {"PhaseName","��ǰ�����׶�"},
							{"Currency","����"},
				            {"BusinessSum","���"},
				            {"OccurDate","��������"},
							{"VouchTypeName","������ʽ"},
							{"OperateOrgName","�������"},
						  };

	String sSql =   " select"+
					" CustomerID,getCustomerName(CustomerID) as CustomerName,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" SerialNo,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,OccurDate,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_APPLY"+
					" where CustomerID in "
					+ sCon;

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessTypeName,Currency,VouchTypeName,OccurTypeName","2");
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");
	doTemp.setHTMLStyle("Currency","style={width:120px}");
	//����"��Ҫ������ʽ"�ֶγ���
	doTemp.setHTMLStyle("VouchTypeName","style={width:350px}");

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
		{"true","","Button","����","�鿴ҵ�������������","viewAndEdit()",sResourcesPath},
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
			sSerialNo   = getItemValue(0,getRow(),"SerialNo");
			
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			}else
			{
				openObject("CreditApply",sSerialNo,"001");
			}
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
