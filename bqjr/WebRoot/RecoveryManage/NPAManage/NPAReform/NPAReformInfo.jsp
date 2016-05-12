<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   SLLIUA  2005.02.02
		Tester:
		Content: ���鷽��ִ��̨��
		Input Param:
			sSerialNo ���鷽����ˮ��
		Output param:

		History Log: 

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���鷽��ִ��̨��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	
	//���ҳ�����(���鷽����ˮ��)	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));	
	
	if(sSerialNo == null) sSerialNo = "";
	
	String sSql="";
	String sSql1="";
	
	ASResultSet rs;
	ASResultSet rs1;
	
	String sFlag3="";
	String sOtherCondition="";
	String sFlag2="";
	String sImmediacyPaySource="";
	String sPaySource="";
	String sArtificialNo="";
	String sCustomerName="";
	String sVouchType="";
	String sContractNo="";
	
	double sReformSum=0.00;
	double sBusinessSum=0.00;
	double sDayCount=0.00;
	
	sSql1 =   " select BC.SerialNo as SerialNo,BC.ArtificialNo as ArtificialNo,BC.OverdueDays as OverdueDays, "+
	          " BC.CustomerName as CustomerName," + 
	          " isnull(BC.BusinessSum,0) as BusinessSum," +
	          " BC.VouchType " + 
	          " from BUSINESS_CONTRACT BC ,CONTRACT_RELATIVE CR " +
			  " where BC.SerialNo = CR.SerialNo "+
			  " and  CR.ObjectType = 'RelativeReform' " +
			  " and CR.ObjectNo = :ObjectNo  order by SerialNo" ;
	rs1 = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("ObjectNo",sSerialNo)); 
   	while(rs1.next()){
		//��ͬ��š��½���ˡ����鷢�Ž���Ҫ������ʽ
		sContractNo = DataConvert.toString(rs1.getString("SerialNo"));
		sArtificialNo = DataConvert.toString(rs1.getString("ArtificialNo"));
		sCustomerName = DataConvert.toString(rs1.getString("CustomerName"));
		sVouchType = DataConvert.toString(rs1.getString("VouchType"));
		sBusinessSum = rs1.getDouble("BusinessSum");
		sDayCount = rs1.getDouble("OverdueDays");
		sReformSum = sReformSum+sBusinessSum;
	}
	rs1.getStatement().close();
	
	sSql =  "  select Flag3,ImmediacyPaySource,PaySource,OtherCondition,Flag2 from BUSINESS_APPLY "+
            "  where SerialNo =:SerialNo ";
   	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo)); 
   	if(rs.next()){
		//��������1����������2����������3
		sFlag3 = DataConvert.toString(rs.getString("Flag3"));
		sImmediacyPaySource = DataConvert.toString(rs.getString("ImmediacyPaySource"));
		sPaySource = DataConvert.toString(rs.getString("PaySource"));
		
		//�����ջر������
		sOtherCondition = DataConvert.toString(rs.getString("OtherCondition"));
		
		//�Ƿ����ջش�����Ϣ
		sFlag2 = DataConvert.toString(rs.getString("Flag2"));
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ReformBook";        

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		//{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
	
			//��ͬ��š��½���ˡ���Ҫ������ʽ
			setItemValue(0,0,"ContractNo","<%=sArtificialNo%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"VouchID","<%=sVouchType%>");
			
			//���鷽����ˮ�š���������1����������2����������3
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");
			setItemValue(0,0,"ReformCond1","<%=sFlag3%>");
			setItemValue(0,0,"ReformCond2","<%=sImmediacyPaySource%>");
			setItemValue(0,0,"ReformCond3","<%=sPaySource%>");
			
			//�����ջر���������Ƿ����ջش�����Ϣ
			setItemValue(0,0,"TakeBack","<%=sOtherCondition%>");
			setItemValue(0,0,"InterestFlag","<%=sFlag2%>");
			
			setItemValue(0,0,"ReformSum","<%=DataConvert.toMoney(sReformSum)%>");
			setItemValue(0,0,"DayCount","<%=sDayCount%>");
			
			//�Ǽ��ˡ��Ǽǻ���
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
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
