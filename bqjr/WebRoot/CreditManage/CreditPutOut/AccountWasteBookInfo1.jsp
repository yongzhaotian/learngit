<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hwang 2009-06-15
		Tester:
		Describe: ҵ����ˮ��Ϣ;
		Input Param:
			SerialNo:��ˮ��
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = " ҵ����ˮ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";

	//����������
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	 //��ˮ����,OccurDirection=1��������ˮ��OccurDirection=2�������ˮ��
	String sOccurDirection = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDirection"));
	if(sOccurDirection == null) sOccurDirection = "";

	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { {"SerialNo","��ˮ��"},
	                        {"RelativeSerialNo","��ؽ����ˮ��"},
                            {"RelativeContractNo","��غ�ͬ��ˮ��"},
                            {"TransactionFlag","���ױ�־"},
                            {"OccurType","��������"},
                            {"OccurDirection","��������"},
                            {"OccurDirectionName","��������"},
                            {"OccurDate","��������"},
                            {"BackType","���շ�ʽ"},
                            {"OccurSubject","����ժҪ"},
                            {"ActualDebitSum","���Ž��(Ԫ)"},
                            {"ActualCreditSum","���ս��(Ԫ)"},
                            {"OrgName","�Ǽǻ���"},
                            {"UserName","�Ǽ���"},
                          };

	if(sOccurDirection == null || sOccurDirection.length() == 0){
		sSql ="select OccurDirection from BUSINESS_WASTEBOOK where SerialNo=:SerialNo";
		sOccurDirection = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
		if(sOccurDirection==null || sOccurDirection.length() == 0) sOccurDirection="1"; //1.�ǻ���
	}

	if(sOccurDirection.equals("1")){
		sSql=	" select SerialNo,RelativeContractNo,OccurDate,ActualCreditSum, "+
				" OccurType,TransactionFlag,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,OccurSubject,BackType,OrgID,"+
				" getOrgName(OrgID) as OrgName,UserID,getUserName(UserID) as UserName "+
				" from BUSINESS_WASTEBOOK where SerialNo='"+sSerialNo+"'";
	}else{
		sSql=	" select SerialNo,RelativeContractNo,OccurDate,ActualDebitSum, "+
				" OccurType,TransactionFlag,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,OccurSubject,BackType,OrgID,"+
				" getOrgName(OrgID) as OrgName,UserID,getUserName(UserID) as UserName "+
				" from BUSINESS_WASTEBOOK where SerialNo='"+sSerialNo+"'";
	}

	//ͨ��sql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ÿɸ��µı�
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK";
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//����ֻ��ѡ��
	doTemp.setReadOnly("SerialNo,RelativeContractNo,OccurDirectionName,OrgID,UserID,OrgName,UserName",true);	
	//���ò��ɼ���
	doTemp.setVisible("OrgID,UserID,OccurDirection",false);
	if("0".equals(sOccurDirection))
	{
		doTemp.setVisible("BackType",false);
		//���ñ�����
		doTemp.setRequired("RelativeSerialNo,RelativeContractNo,OccurDate,ActualCreditSum,ActualDebitSum,OccurType,TransactionFlag,OccurSubject",true);
	}else{	
		//���ñ�����
		doTemp.setRequired("RelativeSerialNo,RelativeContractNo,OccurDate,ActualCreditSum,ActualDebitSum,OccurType,TransactionFlag,OccurSubject,BackType",true);
	}
		
	//���ò��ɸ����ֶ�
	doTemp.setUpdateable("OrgName,UserName,OccurDirectionName",false);
	//��������ѡ��
	doTemp.setDDDWCode("OccurSubject","OccurSubjectName");
	doTemp.setDDDWCode("OccurType","WasteOccurType");
	//doTemp.setDDDWCode("OccurDirection","OccurDirection");
	doTemp.setDDDWCode("TransactionFlag","TransactionFlag");
	doTemp.setDDDWCode("BackType","ReclaimType");
	doTemp.setCheckFormat("OccurDate","3");
    doTemp.setType("ActualCreditSum,ActualDebitSum","Number");
	doTemp.setCheckFormat("ActualCreditSum,ActualDebitSum","2");
	doTemp.setAlign("ActualCreditSum,ActualDebitSum","3");
	doTemp.setHTMLStyle("OrgName,UserName"," style={width:80px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	
	sSql="select BusinessType from BUSINESS_CONTRACT where SerialNo=:SerialNo";
	String sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	
	sSql="select attribute4 from BUSINESS_TYPE where TypeNo=:TypeNo";
	String sOrigin = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
	if (sOrigin == null) sOrigin = "";

	//����Ϊ������������Դ����628
	if(!sOrigin.equals("010")) {
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}
	else {
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}
	
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	
	//����Ϊ������������Դ����628
	if (!sOrigin.equals("010")) {
		sButtons[0][0] = "true";
	}
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditPutOut/AccountWasteBookList1.jsp","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_WASTEBOOK";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			var occurDirection = "<%=sOccurDirection%>";
			setItemValue(0,0,"OccurDirection",occurDirection);
			if(occurDirection == "1"){
				setItemValue(0,0,"OccurDirectionName","����");
			}else{
				setItemValue(0,0,"OccurDirectionName","����");
			}			
			setItemValue(0,0,"RelativeContractNo","<%=sObjectNo%>");
			setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
		}
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

