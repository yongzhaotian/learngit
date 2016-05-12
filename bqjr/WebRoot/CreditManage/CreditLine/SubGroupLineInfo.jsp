<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jgao1 2009-10-26
		Tester:
		Content: ���Ŷ�ȷ��������Ϣҳ��
		Input Param:
			ParentLineID����ȱ��
			LineID����ȷ�����
		Output param:
		History Log: gftang 2013-05-09 �ĳ�ģ������

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ�ȷ��������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	ASResultSet rs = null;
	String sCustomerID = "";//�ͻ�ID
	double dLineSum = 0;//���Э����
	String sCustomerName = "";//�ͻ�����
	String sTable = "";//��ر�

	//���ҳ�����	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sParentLineID == null) sParentLineID = "";
	if(sSubLineID == null) sSubLineID = "";	
	
	//���ݶ�������������Ż�ȡ��˾�ͻ�״̬,����������С��ҵ�ͻ��빫˾�ͻ�
	if("CreditApply".equals(sObjectType)){
		sTable="BUSINESS_APPLY";
	}else if("ApproveApply".equals(sObjectType)){
		sTable="BUSINESS_APPROVE";
	}else{
		sTable="BUSINESS_CONTRACT";
	}
	
	//���ݶ�ȱ�Ż�ȡ���Э���������ˮ�š��������������ˮ�š���ͬ��ˮ�š�������͡�������ơ��ͻ���š��ͻ����ơ�����ұ���
	String sApplySerialNo = "",sApproveSerialNo = "",sContractSerialNo = "",sCLTypeID = "",sCLTypeName = "",sCurrencyName="";
	sSql = 	" select LineSum1,getItemName('Currency',Currency) as CurrencyName,ApplySerialNo,ApproveSerialNo,BCSerialNo,CLTypeID,CLTypeName,CustomerID,CustomerName "+
			" from CL_INFO where "+
			" LineID = :LineID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("LineID",sParentLineID));
	if(rs.next()){
		dLineSum = rs.getDouble("LineSum1");
		sCurrencyName = rs.getString("CurrencyName");
		sApplySerialNo = rs.getString("ApplySerialNo");
		sApproveSerialNo = rs.getString("ApproveSerialNo");
		sContractSerialNo = rs.getString("BCSerialNo");
		sCLTypeID = rs.getString("CLTypeID");
		sCLTypeName = rs.getString("CLTypeName");
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
	}
	rs.getStatement().close();
	//����ֵת��Ϊ���ַ���
	if(sApplySerialNo == null) sApplySerialNo = "";
	if(sApproveSerialNo == null) sApproveSerialNo = "";
	if(sContractSerialNo == null) sContractSerialNo = "";
	if(sCLTypeID == null) sCLTypeID = "";
	if(sCLTypeName == null) sCLTypeName = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerName == null) sCustomerName = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//������ʾ����				
    String sTempletNo = "SubGroupLineInfo";
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  	
  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSubLineID+","+sParentLineID);
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","���ص���ȷ����б�","goBack()",sResourcesPath}
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

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{		
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditLine/SubGroupLineList.jsp?ParentLineID=<%=sParentLineID%>","_self","");
	}	
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{	
		if(CheckSubCreditLine()) return true;
		else return false;
	}
	
	/*~[Describe=�����޶�ͳ����޶���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function CheckSubCreditLine()
	{
		sParentLineID = "<%=sParentLineID%>";
		sSubLineCurrency=getItemValue(0,getRow(),"Currency");//��ǰ�Ӷ�ȱ���
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//ȡ��ǰ���ų�Ա�ͻ���
		sLineID = getItemValue(0,getRow(),"LineID");//ȡ��ǰ�Ӷ�ȶ�ȱ��
		sLineSum1 = getItemValue(0,0,"LineSum1");//ȡ��ǰֵ
		sBailRatio = getItemValue(0,0,"BailRatio");//ȡ��ǰֵ
		//���ȡ������ֵΪ��ʱ�����Զ���λ��0.00
		if (typeof(sBailRatio)=="undefined" || sBailRatio.length==0)
		{
			sBailRatio = 0.00;
			setItemValue(0,0,"BailRatio","0.00");
		}
		//���ȡ�������޶�Ϊ��ʱ�����Զ���λ��0.00
		if (typeof(sLineSum1)=="undefined" || sLineSum1.length==0)
		{
			sLineSum1 = 0.00;
			setItemValue(0,0,"LineSum1","0.00");
		}
	
		sReturn = RunMethod("CreditLine","CheckGroupLine",sParentLineID+","+sLineID+","+sCustomerID+","+sLineSum1+","+sSubLineCurrency);
		if(sReturn == "10")	
		{
			alert("��ǰ���ų�Ա�����޶���������Ŷ���ܶ�������");
			return false;					
		}
		if(sReturn == "99")	
		{
			alert("�ѷ���ü��ų�Ա�������������!");
			return false;					
		}
		if(sReturn == "00")	
		{
			return true;					
		}
		return false;
	}

	/*~[Describe=�������ų�Աѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getGroupCustomer()
	{
		sCustomerID = "<%=sCustomerID%>";
		setObjectValue("SelectGroupCustomer","CustomerID,"+sCustomerID,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ParentLineID","<%=sParentLineID%>");	
			setItemValue(0,0,"ApplySerialNo","<%=sApplySerialNo%>");
			setItemValue(0,0,"ApproveSerialNo","<%=sApproveSerialNo%>");
			setItemValue(0,0,"BCSerialNo","<%=sContractSerialNo%>");			
			setItemValue(0,0,"CLTypeID","<%=sCLTypeID%>");	
			setItemValue(0,0,"CLTypeName","<%=sCLTypeName%>");									
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Rotative","2");
			bIsInsert = true;			
		}		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "GLINE_INFO";//����
		var sColumnName = "LineID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
