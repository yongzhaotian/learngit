<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*	Author: hxli 2005-8-4
*	Tester:
*	Describe: �����ʲ������˱����¼����;
*	Input Param:
*		ObjectNo����ͬ��ˮ���
*	Output Param:     
*		SerialNo	:��ˮ��       
*		OldOrgName	:���ǰ���� 
*		OldUserName	:���ǰ��Ա
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ������˱����¼����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";

	//����������
	//���ҳ�����
	String sObjectType = "BusinessContract"	;  //��������
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); //ȡ��ˮ��
	
	//Flag=ShiftType��ʾ�鿴�ƽ����ͱ����ʷ������鿴�ܻ��˱����ʷ
	String sFlag =  DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag")); 
	if(sFlag==null)	sFlag="";
	String sTempletNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	
	if(sFlag.equals("ShiftType"))
	{
		//�ܻ������α���б�
		sTempletNo = "NPAChangeUserList02";
	}else
	{
		//�ƽ��������α���б�
		sTempletNo = "NPAChangeUserList01";
	}

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);//20��һ��ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);//������ʾģ�����
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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
			{"true","","Button","����","�鿴��¼��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","����","����","goBack()",sResourcesPath},
  		  };
	
	if(sFlag.equals("ShiftType"))
	{
		sButtons[0][0] = "false";
	}
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			sOldOrgName = getItemValue(0,getRow(),"OldOrgName");
			sOldUserName = getItemValue(0,getRow(),"OldUserName");
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserInfo.jsp?OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"","right",OpenStyle);
		}
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/DistributeList.jsp","_self","");
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
