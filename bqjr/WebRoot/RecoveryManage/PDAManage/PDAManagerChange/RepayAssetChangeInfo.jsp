<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   djia 2010-09-06
		Tester:
		Content: ��ծ�ʲ������˱��
		Input Param:
			ObjectType���������ͣ�AssetInfo��
			ObjectNo�������ţ��ʲ���ˮ�ţ�
			OldOrgID��ԭ����������
			OldOrgName��ԭ�����������
			OldUserID��ԭ�����˱��
			OldUserName��ԭ����������
			GoBackType���������ͣ�1--PDAAssetList.jsp��2--PDAManagerChangeHistory.jsp��			
			SerialNo    :�ʲ���ˮ��
		Output param:

		History Log: 

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ������˱��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	boolean isNewAddFlag=false;
	//���ҳ�����
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); //��������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); //������
	String sOldOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldOrgID")); //ԭ�������ID
	String sOldUserID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldUserID")); //ԭ������ID
	String sOldOrgName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldOrgName")); //ԭ�������
	String sOldUserName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldUserName")); //ԭ����Ա
	String sGoBackType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GoBackType")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); //�����¼��ˮ��
	//����ֵת��Ϊ���ַ���
	if (sObjectType == null) sObjectType = "";
	if (sObjectNo == null) sObjectNo = "";
	if (sOldOrgID == null) sOldOrgID = "";
	if (sOldUserID == null) sOldUserID = "";
	if (sOldOrgName == null) sOldOrgName = "";
	if (sOldUserName == null) sOldUserName = "";
	if (sGoBackType == null) sGoBackType = "";
	if (sSerialNo == null) sSerialNo = "";
	if(("").equals(sSerialNo))isNewAddFlag=true;

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "PDAManagerChangeInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//ѡ�����û�
	doTemp.setUnit("NewUserName"," <input type=button class=inputDate  value=... name=button onClick=\"javascript:parent.getNewUserName()\">");
	doTemp.appendHTMLStyle("NewUserName","  style={cursor:pointer;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getNewUserName()\" ");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+','+sObjectNo+','+sSerialNo);
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
		{isNewAddFlag?"true":"false","","Button","����","���������޸�","my_Save()",sResourcesPath},
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

	/*~[Describe=�����ʲ���������벿��;InputParam=�����¼�;OutPutParam=��;]~*/
	function my_ChangeUserAction()
	{
		var sManageOrgID = getItemValue(0,getRow(),"NewOrgID");
		var sManageUserID = getItemValue(0,getRow(),"NewUserID");

		var sReturn = PopPageAjax("/LAP/RepayAssetManage/PDAManagerChange/ChangeUserActionAjax.jsp?ManageOrgID="+sManageOrgID+"&ManageUserID="+sManageUserID+"&SerialNo=<%=sObjectNo%>","","");
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function my_Save()
	{
		saveRecord(my_ChangeUserAction())
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{	
		var sGoBackType = "<%=sGoBackType%>";
		if (sGoBackType == "1") 
			OpenPage("/LAP/RepayAssetManage/PDAManagerChange/RepayAssetList.jsp","right")
		else
			OpenPage("/LAP/RepayAssetManage/PDAManagerChange/RepayAssetChangeHistory.jsp","right")
 	}
  	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/	
	function getNewUserName()
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectUserPDA",sParaString,"@NewUserID@0@NewUserName@1@NewOrgID@2@NewOrgName@3",0,0,"");
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
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"OldOrgID","<%=sOldOrgID%>");
			setItemValue(0,0,"OldUserID","<%=sOldUserID%>");
			setItemValue(0,0,"OldOrgName","<%=sOldOrgName%>");
			setItemValue(0,0,"OldUserName","<%=sOldUserName%>");
			setItemValue(0,0,"ChangeUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ChangeOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"ChangeUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"ChangeOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"ChangeTime","<%=StringFunction.getToday()%>");
		}
   	}
    	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "MANAGE_CHANGE";//����
		var sColumnName = "SerialNo";//�ֶ���
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
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
