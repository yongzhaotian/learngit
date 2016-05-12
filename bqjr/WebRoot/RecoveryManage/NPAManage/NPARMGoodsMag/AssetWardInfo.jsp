<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
/*
*	Author: SLLIU 2005-01-15
*	Tester:
*	Describe: �ʲ������Ϣ;
*	Input Param:
*		ObjectType���������ͣ���ȫ�GuarantyInfo������ʲ���AssetInfo��											
*		ObjectNo���ʲ����
		SerialNo�������Ϣ��ˮ��
*	Output Param:     
*        	
*	HistoryLog: zywei 2006/01/24 �ؼ����
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʲ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//����������	
	 String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));   
	//��ȡ��ͬ�ս�����
    String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
    if(sFinishType == null) sFinishType = "";
	if(sObjectType == null) sObjectType = "";		
	if(sObjectNo == null) sObjectNo = "";
	if(sAssetStatus ==  null) sAssetStatus = "";
	//��ȡҳ�����	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); //ȡ��ˮ��
	if(sSerialNo==null) sSerialNo="";	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	String sTempletNo = "AssetWardInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����ʱ�����¼�

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);	
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
			{sAssetStatus.equals("04")?"false":(sFinishType.equals("")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardList.jsp","_self","");
	}
    	
     

</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
			bIsInsert = true;
			
			
			//�Ǽ��ˡ��Ǽǻ���
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
		}		
    }
    
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSETWARD_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);	
	}
	
  	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(sParam,sUserID,sUserName,sOrgID,sOrgName)
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectUserBelongOrg",sParaString,"@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0,"");		
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
