<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: Ԥ���źŷַ���ϸ��Ϣ_Info
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
	String PG_TITLE = "Ԥ���ź�����"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"SignalTypeName","Ԥ������"},
							{"SignalStatusName","Ԥ��״̬"},	
							{"MessageOriginName","Ԥ����Ϣ��Դ"},	
							{"MessageContent","Ԥ����Ϣ����"},	
							{"ActionFlagName","�Ƿ�����ж�"},	
							{"ActionTypeName","�����ж�"},
							{"FreeFlag","�Ƿ���"},							
							{"Remark","��ע"},												
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
			" getItemName('ActionType',ActionType) as ActionTypeName,'' as FreeFlag, "+
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
	doTemp.setVisible("SerialNo,ObjectType,SignalNo,SignalType,SignalStatus,MessageOrigin,ActionFlag",false);
	doTemp.setVisible("ActionType,ObjectNo,SignalChannel,InputUserID,InputOrgID",false);    	
	if(!sSignalStatus.equals("30"))
		doTemp.setVisible("FreeFlag",false);		
	//���ø�ʽ	
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setHTMLStyle("SignalName"," style={width:400px;} ");
	doTemp.setHTMLStyle("InputUserName,InputDate,UpdateDate"," style={width:80px;} ");
	doTemp.setHTMLStyle("MessageContent,Remark"," style={height:100px;width:400px;overflow:auto} ");
 	doTemp.setLimit("MessageContent,Remark",100);
 	doTemp.setEditStyle("MessageContent,Remark","3");
	  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
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
		OpenPage("/CreditManage/CreditAlarm/RiskSignalDistributeList.jsp","_self","");
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{		
		setItemValue(0,0,"FreeFlag","<%=sFreeFlag%>");	
    }
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>