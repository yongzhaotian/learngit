<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: Ԥ���źŽ����Ϣ_Info
		Input Param:						
			SerialNo��Ԥ�������ˮ�� 
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
		
	//����������	
	
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
							{"SignalTypeName","Ԥ������"},
							{"SignalStatusName","Ԥ��״̬"},	
							{"MessageOriginName","Ԥ����Ϣ��Դ"},	
							{"MessageContent","Ԥ����Ϣ����"},	
							{"ActionFlagName","�Ƿ�����ж�"},	
							{"ActionTypeName","�����ж�"},							
							{"FreeReason","������Ԥ��ԭ��"},							
							{"Remark","��ע"},
							{"CheckOrg2Name","��׼����"},
							{"CheckUser2Name","��׼��"},
							{"CheckDate2","��׼ʱ��"},						
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�ʱ��"},
							{"UpdateDate","����ʱ��"}
							};
		
	sSql =  " select ObjectNo,GetCustomerName(ObjectNo) as CustomerName,SignalNo,SignalName, "+
			" SignalType,getItemName('SignalType',SignalType) as SignalTypeName,SignalStatus, "+
			" getItemName('SignalStatus',SignalStatus) as SignalStatusName,MessageOrigin, "+
			" getItemName('MessageOrigin',MessageOrigin) as MessageOriginName,MessageContent, "+
			" ActionFlag,getItemName('YesNo',ActionFlag) as ActionFlagName,ActionType, "+
			" getItemName('ActionType',ActionType) as ActionTypeName,FreeReason, "+
			" Remark,GetOrgName(InputOrgID) as InputOrgName,InputOrgID,InputUserID, "+
			" GetUserName(InputUserID) as InputUserName,InputDate,UpdateDate, "+
			" SerialNo,ObjectType,SignalChannel "+
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
	doTemp.setVisible("SerialNo,ObjectType,SignalNo,SignalType,SignalStatus,MessageOrigin",false);
	doTemp.setVisible("ActionFlag,ActionType,ObjectNo,SignalChannel,InputUserID,InputOrgID",false);    	
		
	//���ø�ʽ
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setHTMLStyle("SignalName"," style={width:400px;} ");
	doTemp.setHTMLStyle("InputUserName,InputDate,UpdateDate"," style={width:80px;} ");
	doTemp.setHTMLStyle("MessageContent,FreeReason,Remark"," style={height:100px;width:400px;overflow:auto} ");
 	doTemp.setLimit("MessageContent,FreeReason,Remark",100);
 	doTemp.setEditStyle("MessageContent,FreeReason,Remark","3"); 	
  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly="1";
	
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
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditAlarm/RiskSignalFreeApproveList.jsp","_self","");
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	        	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>