<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�˵�����ҳ��";
	//��ò���	
	String sMenuID =  CurPage.getParameter("MenuID");
	if(sMenuID==null) sMenuID="";

	String sTempletNo = "MenuInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//�����Ϊ����ҳ�棬�������ID�����޸�
	if(sMenuID.length() != 0 ){
		doTemp.setReadOnly("MenuID",true);
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setRightType(); //����Ȩ��
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sMenuID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","All","Button","����","","saveRecord()","","","",""},
		{"true","All","Button","���ÿɼ���ɫ","","selectMenuRoles()","","","",""},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","afterOpen();"); //ˢ��treeʹ��
	}
	
	function afterOpen(){
		AsControl.OpenView("/AppConfig/MenuManage/MenuTree.jsp", "DefaultNode="+getItemValue(0,0,"SortNo"), "frameleft", "");
	}
	
	<%/*~[Describe=ѡ��˵��ɼ���ɫ;InputParam=��;OutPutParam=��;]~*/%>
	function selectMenuRoles(){
		var sMenuID=getItemValue(0,0,"MenuID");
		var sMenuName=getItemValue(0,0,"MenuName");
		AsControl.PopView("/AppConfig/MenuManage/SelectMenuRoleTree.jsp","MenuID="+sMenuID+"&MenuName="+sMenuName,"dialogWidth=440px;dialogHeight=500px;center:yes;resizable:no;scrollbars:no;status:no;help:no");
	}

	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	var bFreeFormMultiCol = true;//����
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>