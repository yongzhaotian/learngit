<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: slliu 2004.12.08
*	Tester:
*	Describe: ���������˱���б�
*	Input Param:
*
*	Output Param:     
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������˱���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;
	
	//���ҳ�����

	//����������
		
%>
<%/*~END~*/%>

<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "LawCaseManagerChangeList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow(CurOrg.getSortNo()+","+CurUser.getUserID());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","��������","�鿴������ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","���������","//�����������Ϣ","my_ChangeUser()",sResourcesPath},
			{"true","","Button","�鿴�����¼","�鿴�����������ʷ","my_history()",sResourcesPath}
		};			
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		sObjectType = "LawCase";
		sObjectNo = sSerialNo;
		sViewID = "002";
		openObject(sObjectType,sObjectNo,sViewID);	
	}
	
	/*~[Describe=�����������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_ChangeUser()
	{   
		sLawCaseNo=getItemValue(0,getRow(),"SerialNo"); //��ð������
		sManageUserID=getItemValue(0,getRow(),"ManageUserID"); //���ԭ�����˱��
		sManageOrgID=getItemValue(0,getRow(),"ManageOrgID"); //���ԭ����������
		sUserName=getItemValue(0,getRow(),"ManageUserName"); //���ԭ����������
		sOrgName=getItemValue(0,getRow(),"ManageOrgName"); //���ԭ�����������
		
		if (typeof(sLawCaseNo)=="undefined" || sLawCaseNo.length==0)
		{
			alert(getHtmlMessage(1));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			//��ȡ��ˮ��
			var sTableName = "MANAGE_CHANGE";//����
			var sColumnName = "SerialNo";//�ֶ���
			var sPrefix = "";//ǰ׺
			var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		
			OpenPage("/RecoveryManage/LawCaseManage/ManagerChangeInfo.jsp?UserName="+sUserName+"&OrgName="+sOrgName+"&ManageUserID="+sManageUserID+"&ManageOrgID="+sManageOrgID+"&SerialNo="+sSerialNo+"&ObjectType=LawcaseInfo&ObjectNo="+sLawCaseNo+"","right","");
		}
	 }
	
	/*~[Describe=�鿴�����������ʷ;InputParam=��;OutPutParam=SerialNo;]~*/	
	function my_history()
	{
		sLawCaseNo=getItemValue(0,getRow(),"SerialNo"); //�������		
	    if (typeof(sLawCaseNo)=="undefined" || sLawCaseNo.length==0)
		{
			alert(getHtmlMessage(1));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenComp("LawCaseHistoryChangeList","/RecoveryManage/LawCaseManage/LawCaseHistoryChangeList.jsp","ComponentName=������ʷ����б�ComponentType=MainWindow&ObjectType=LawcaseInfo&ObjectNo="+sLawCaseNo+"","right",OpenStyle);
		}
		 
	}	

</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
