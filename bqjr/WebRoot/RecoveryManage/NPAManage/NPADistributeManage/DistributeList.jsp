<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: hxli 2005-8-4
*	Tester:
*	Describe:�ѷַ������ʲ���Ϣ�б�
*	Input Param:
*
*	Output Param:     
*		sShiftType���ƽ�����
*		sOldOrgID��ԭ�������ID
*		sOldUserID��ԭ������ID
*		sOldOrgName��ԭ�������
*		sOldUserName��ԭ������
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ѷַ������ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sCurItemID ;    
	String sWhereClause=""; //Where����
	String sSql="";

	//����������
	sCurItemID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo"));
	if(sCurItemID == null) sCurItemID = "";
	String sSortNo = CurOrg.getSortNo();
	String sUserID = CurUser.getUserID();
	String sTempletNo = "";
 	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	
 	if(sCurItemID.equals("010"))	//�ͻ��ƽ�
	{
 		sTempletNo = "DistributeList01";
	}else if(sCurItemID.equals("020")){
		sTempletNo = "DistributeList02";	
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
	 Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo+","+sUserID);//������ʾģ�����
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
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		{"true","","Button","���������","������ͬ��ȫ�������˸���","my_ChangeUser()",sResourcesPath},
		{"false","","Button","����ƽ�����","��ͬ��������ת��","my_ShiftManage()",sResourcesPath},
		{"true","","Button","�鿴�����˱����¼","������ͬ��ȫ�������˸��ļ�¼","my_ChangeUserRec()",sResourcesPath},
		{"false","","Button","�鿴�ƽ����ͱ����¼","�鿴�ƽ����ͱ����¼","my_ChangeType()",sResourcesPath}
		};
	
	if(sCurItemID.equals("020"))	//�����ƽ�
	{
		sButtons[1][0]="false";
		sButtons[3][0]="false";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
   	
   	/*~[Describe=���ı�ȫ��������;InputParam=��;OutPutParam=��;]~*/
	function my_ChangeUser()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{
			sOldOrgID = getItemValue(0,getRow(),"RecoveryOrgID");
			sOldUserID = getItemValue(0,getRow(),"RecoveryUserID");
			sOldOrgName	= getItemValue(0,getRow(),"RecoveryOrgName");
			sOldUserName = getItemValue(0,getRow(),"RecoveryUserName");
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserInfo.jsp?OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&OldOrgID="+sOldOrgID+"&OldUserID="+sOldUserID+"&ObjectType=BusinessContract&ObjectNo="+sSerialNo,"right",OpenStyle);
		}
	}

	/*~[Describe=����ƽ�����;InputParam=��;OutPutParam=��;]~*/
	function my_ShiftManage()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			//�����Ի�ѡ���
			sOldShiftType = getItemValue(0,getRow(),"ShiftType");
			sShiftType = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/ManageShiftChoice.jsp","","dialogWidth=19;dialogHeight=07;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sShiftType)!="undefined" && sShiftType.length!=0)
			{
				if(sShiftType == sOldShiftType)
				{
					alert(getBusinessMessage("761"));	//��δ�ı��ƽ��������ͣ�����ȡ����
					return;
				}else if(confirm(getBusinessMessage("762")))   //�Ƿ�����滻�ƽ���������?
				{
					sReturn = PopPageAjax("/RecoveryManage/NPAManage/NPADistributeManage/ManageShiftActionAjax.jsp?ShiftType="+sShiftType+"&SerialNo="+sSerialNo+"&OldShiftType="+sOldShiftType+"","","");
					if(sReturn == "true")//ˢ��ҳ��
					{
						alert(getBusinessMessage("763"));//�ƽ����ͱ���ɹ���
						reloadSelf();
					}else{
						alert("�ƽ����ͱ��ʧ�ܣ�");
					}
				}
			}
		}	
	}

    /*~[Describe=�鿴���������α����¼;InputParam=��;OutPutParam=��;]~*/
	function my_ChangeUserRec()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectNo="+sSerialNo,"right",OpenStyle);			
		}
	}

	/*~[Describe=�鿴�ƽ��������α����¼;InputParam=��;OutPutParam=��;]~*/
	function my_ChangeType()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectNo="+sSerialNo+"&Flag=ShiftType","right",OpenStyle);			
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>