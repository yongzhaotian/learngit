<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: Ԥ����Ϣ_Info
		Input Param:	
			SignalType��Ԥ�����ͣ�01������02�������		
			SignalStatus��Ԥ��״̬��10��������15�����ַ���20�������У�30����׼��40������� 
			SerialNo��Ԥ����ˮ��    
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
		
	//����������		
	String sSignalType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));	
	String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));	
	//����ֵת��Ϊ���ַ���	
	if(sSignalType == null) sSignalType = "";
	if(sSignalStatus == null) sSignalStatus = "";
	//���ҳ�����	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));	
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {							
							{"CustomerName","�ͻ�����"},
							{"SignalName","Ԥ���ź�"},
							{"SignalType","Ԥ������"},
							{"SignalStatus","Ԥ��״̬"},	
							{"MessageOrigin","Ԥ����Ϣ��Դ"},	
							{"MessageContent","Ԥ����Ϣ����"},	
							{"ActionFlag","�Ƿ�����ж�"},	
							{"ActionType","�����ж�"},
							{"FreeFlag","�Ƿ���"},	
							{"Remark","��ע"},						
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�ʱ��"},
							{"UpdateDate","����ʱ��"}
							};
		
	sSql =  " select ObjectNo,GetCustomerName(ObjectNo) as CustomerName,SignalNo, "+
			" SignalName,SignalType,SignalStatus,MessageOrigin,MessageContent, "+
			" ActionFlag,ActionType,'' as FreeFlag,Remark, "+
			" GetOrgName(InputOrgID) as InputOrgName,InputOrgID, "+
			" GetUserName(InputUserID) as InputUserName,InputUserID, "+
			" InputDate,UpdateDate,SerialNo,ObjectType,SignalChannel "+
			" from RISK_SIGNAL "+
			" where SerialNo = '"+sSerialNo+"' ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,SignalNo",false);
	if(!sSignalStatus.equals("30"))
		doTemp.setVisible("FreeFlag",false);
	//��������������
	doTemp.setDDDWCode("SignalType","SignalType");
	doTemp.setDDDWCode("SignalStatus","SignalStatus");
	doTemp.setDDDWCode("MessageOrigin","MessageOrigin");
	doTemp.setDDDWCode("ActionFlag","YesNo");
	doTemp.setDDDWCode("ActionType","ActionType");
	
	//���ø�ʽ
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setHTMLStyle("SignalName"," style={width:400px;} ");
	doTemp.setEditStyle("MessageContent,Remark","3");
 	doTemp.setLimit("MessageContent,Remark",200);
	doTemp.setReadOnly("SignalType,SignalStatus,ObjectNo,CustomerName,SignalName,InputUserName,InputOrgName,InputDate,UpdateDate",true);
 	doTemp.setRequired("CustomerName,SignalName,MessageOrigin,ActionFlag",true);
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,SignalChannel,InputUserID,InputOrgID",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,CustomerName,FreeFlag",false);
  	if(sSignalStatus.equals("10"))
  	{	  			
	  	doTemp.setUnit("CustomerName","<input type=button value=\"...\" onClick=parent.selectCustomer()>");		
		doTemp.setUnit("SignalName","<input type=button value=\"...\" onClick=parent.selectAlertSignal()>");		
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(!sSignalStatus.equals("10"))
		dwTemp.ReadOnly="1";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��ȡ����׼��Ԥ����Ϣ�Ƿ��ѱ����
	String sFreeFlag = "��";
	ASResultSet rs = null;
	if(sSignalStatus.equals("30")){ //��׼
		sSql = 	" select Count(SerialNo) from RISK_SIGNAL "+
				" where RelativeSerialNo = :RelativeSerialNo "+				
				" and SignalStatus = '30' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeSerialNo",sSerialNo));
		if(rs.next()){
			int iCount = rs.getInt(1);
			if(iCount > 0) sFreeFlag = "��";
			else sFreeFlag = "��";		
		} 
		rs.getStatement().close();
	}
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
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
		sActionFlag = getItemValue(0,getRow(),"ActionFlag");
		if(sActionFlag == "1") //��Ҫ��ȡ�����ж�
		{
			sActionType = getItemValue(0,getRow(),"ActionType");
			if (typeof(sActionType)=="undefined" || sActionType.length==0)
			{
				alert("��ѡ������ж���"); 
				return;
			}
		}else
		{
			setItemValue(0,0,"ActionType",""); //������д�Ľ����ж�������Ϊ���ַ���
		}	
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyList.jsp","_self","");
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
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectType","Customer");	
			setItemValue(0,0,"SignalType","<%=sSignalType%>");	
			setItemValue(0,0,"SignalStatus","<%=sSignalStatus%>");
			setItemValue(0,0,"SignalChannel","01");		//01:�ֹ�¼�룻02��ϵͳ�Զ�				
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}
		setItemValue(0,0,"FreeFlag","<%=sFreeFlag%>");	
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "RISK_SIGNAL";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=����Ԥ���ź�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAlertSignal()
	{			
		sParaString = "CodeNo"+","+"AlertSignal";
		setObjectValue("SelectCode",sParaString,"@SignalNo@0@SignalName@1",0,0,"");
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{	
		var sParaStr = "CertType, ";
		setObjectValue("SelectOwner",sParaStr,"@ObjectNo@0@CustomerName@1",0,0,"");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>