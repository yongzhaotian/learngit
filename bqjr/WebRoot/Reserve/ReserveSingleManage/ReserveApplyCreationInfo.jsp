<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-09
		Tester:
		Content: ���������ֵ׼������
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�
		Output param:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������ֵ׼��������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α�š�������ʽ����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
	//���������SQL���
	String sSql = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ReserveApplyCreationInfo";
	String sTempletFilter = "1=1";	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);		
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+")+!ReserveManage.InitReserveApply(#SerialNo)");
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
		{"true","","Button","ȷ��","������ʼ�ֵ׼������","doCreation()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ����ʼ�ֵ׼����ʽ����","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	var bIsInsert = false;
	
	/*~[Describe=ȡ���������÷�ʽ���뷽��;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel(){		
		top.returnValue = "_CANCEL_";
		top.close();
	}

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function doCreation(){			
		saveRecord("doReturn()");
	}
	
	/*~[Describe=ȷ���������÷�������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sSerialNo = getItemValue(0,0,"SerialNo");//������ˮ��
		top.returnValue = "_SUCCESSFUL_"+"@"+sSerialNo;
		top.close();
	}	

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
			if (getRowCount(0)==0) {//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
				as_add("myiframe0");//����һ���ռ�¼			
				setItemValue(0,0,"ManagerUserID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"ManagerOrgID","<%=CurOrg.getOrgID()%>");
				setItemValue(0,0,"ManagerOrgName","<%=CurOrg.getOrgName()%>");
				setItemValue(0,0,"ManagerUserName","<%=CurUser.getUserName()%>");
				setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
				bIsInsert = true;	
			}
	}
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�			
		bIsInsert = false;
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "RESERVE_APPLY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
	
	<script type="text/javascript">
	
	/*~[Describe=������ͬѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectReserveContract(){
		setObjectValue("selectReserveContract","UserID,"+"<%=CurUser.getUserID()%>","@AccountMonth@0@DuebillNo@1@CustomerType@2@CustomerID@3@CustomerName@4@Balance@5@FiveClassify@6",0,0,"");
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