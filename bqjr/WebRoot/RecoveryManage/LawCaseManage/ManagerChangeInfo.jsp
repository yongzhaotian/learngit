<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: �����˱��������Ϣ
		Change Param:
				ObjectNo: ������
				ObjectType����������
				SerialNo�������¼��ˮ��
				ManageUserID��ԭ������
				ManageOrgID��ԭ�������		       		
		Output param:
		               
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����˱��������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	String sSerialNo = "";  	//��¼��ˮ��
	String sManageUserID = ""; 	//ԭ������
	String sManageOrgID = "";	//ԭ�������
	String sUserName = "";  	//ԭ����������
	String sOrgName = "";	//ԭ�����������
	String sObjectNo = "";	//������
	String sObjectType = "";	//��������
	String sTableName = "";
	
	//���ҳ�����
	//�����¼��ˮ��
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));  
	//ԭ������,ԭ�������
	sManageUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ManageUserID"));  
	sManageOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ManageOrgID"));  
    //ԭ����������,ԭ�����������
	sUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserName"));  
	sOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgName"));  
    //�����ţ�������ţ�,��������
	sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sFlag = DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag"));
	if(sFlag==null) sFlag="";
%>
<%/*~END~*/%>


<%

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ManagerChangeInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����ʱ�����¼�
	//��������¼���Ҫ����ı�
	sTableName = "LAWCASE_INFO";
	dwTemp.setEvent("AfterInsert","!BusinessManage.ChangeManagerAction("+sObjectNo+",#NewUserID,#NewOrgID,"+sTableName+")");
	
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
		
	if(sFlag.equals("Y")) 
	{
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;ChangeParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	
	/*~[Describe=�����б�ҳ��;ChangeParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		var Flag="<%=sFlag%>";
		if(Flag=='Y') 
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseHistoryChangeList.jsp","right","");
		else
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseManagerChangeList.jsp","right","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;ChangeParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;ChangeParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼			
			//��¼��ˮ��
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");			
			//�����š���������
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");			
			//ԭ�����ˡ�ԭ���������ơ�ԭ���������ԭ�����������
			setItemValue(0,0,"OldUserID","<%=sManageUserID%>");
			setItemValue(0,0,"OldUserName","<%=sUserName%>");
			setItemValue(0,0,"OldOrgID","<%=sManageOrgID%>");
			setItemValue(0,0,"OldOrgName","<%=sOrgName%>");		
			//�Ǽ��ˡ��Ǽ������ơ��Ǽǻ������Ǽǻ�������
			setItemValue(0,0,"ChangeUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ChangeUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"ChangeOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"ChangeOrgName","<%=CurOrg.getOrgName()%>");			
			//�Ǽ�����						
			setItemValue(0,0,"ChangeTime","<%=StringFunction.getToday()%>");			
		}
    }
    	
    /*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/	
	function getNewUserName()
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectUserLaw",sParaString,"@NewUserID@0@NewUserName@1@NewOrgID@2@NewOrgName@3",0,0,"");
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

