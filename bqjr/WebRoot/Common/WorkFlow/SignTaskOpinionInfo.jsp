<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: ǩ�����
	Input Param:
		TaskNo��������ˮ��
		ObjectNo��������
		ObjectType����������
	Output param:
	History Log: zywei 2005/07/31 �ؼ�ҳ��
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ǩ�����";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	//�������
	String sSql = "";//--���sql���
	String sCustomerID = "";//--��ſͻ����   
	ASResultSet rs = null;//-- ��Ž����

	//��ȡ���������������ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sFlowNo == null) sFlowNo = "";
%>
<%/*~END~*/%>

	<%
		//ȡ�ÿͻ����
		sSql = "select CustomerID from Business_Contract where SerialNo= :serialno ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sObjectNo));
		if(rs.next()){
			sCustomerID = rs.getString("CustomerID");
		}
		rs.getStatement().close();
		if(sCustomerID == null) sCustomerID = ""; 

		
		sFlowNo = Sqlca.getString(new SqlObject("select FlowNo  from FLOW_TASK where SerialNo ='"+sSerialNo+"'"));

	   // ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sTempletNo = "SignTaskOpinionInfo";//ģ�ͱ��
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		if(sObjectType.equals("TransactionApply")){
			doTemp.setRequired("SVRESULT",false);
			doTemp.setVisible("SVRESULT",false);
		}
		//��������ǩ���������
		if(sFlowNo.startsWith("CarFlow")){
			doTemp.setVisible("SVRESULT", false);
			doTemp.setVisible("ISSCENE", false);
			
			doTemp.setRequired("SVRESULT",false);
			doTemp.setRequired("ISSCENE",false);
			
			doTemp.setHeader("PhaseOpinion", "ǩ�����");
		}
		
		
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
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
			{"true","","Button","ɾ��","ɾ�����","deleteRecord()",sResourcesPath},
			{"true","","Button","�绰�ֿ�","�绰�ֿ�","getPhoneCode()",sResourcesPath},
		};
	
	if(sObjectType.equals("TransactionApply")){
		sButtons[2][0] ="false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=����ǩ������;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		//������ǩ������Ϊ�հ��ַ�
		if(/^\s*$/.exec(getItemValue(0,0,"PhaseOpinion"))){
			alert("��ǩ�������");
			setItemValue(0,0,"PhaseOpinion","");
			return;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0");
	}
	
	/*~[Describe=ɾ����ɾ�����;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    //δǩ�����,���ɾ��������ʾ��Ϣ�󣬲�����ҳ��ˢ�²���
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0){
	   		alert("����û��ǩ�������������ɾ�����������");
	 	}else if(confirm("��ȷʵҪɾ�������"))	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1){
	    		alert("���ɾ���ɹ�!");
	  		}else{
	    		alert("���ɾ��ʧ�ܣ�");
	   		}
			reloadSelf();
		}
	} 
	
	/*~[Describe=�绰¼��;InputParam=��;OutPutParam=��;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		
	 }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initOpinionNo() 
	{
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		var sTableName = "FLOW_OPINION";//����
		var sColumnName = "OpinionNo";//�ֶ���
		var sPrefix = "";//��ǰ׺
								
		//��ȡ��ˮ��
		var sOpinionNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sOpinionNo);*/
		
		//��ȡ��ˮ��
		var sOpinionNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
		/** --end --*/
	}
	
	/*~[Describe=����һ���¼�¼;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		//���û���ҵ���Ӧ��¼��������һ���������������ֶ�Ĭ��ֵ
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");			
		}        
	}
	</script>
<%/*~END~*/%>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>