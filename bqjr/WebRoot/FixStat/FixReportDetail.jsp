<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginReport.jsp"%>
<%
/* Copyright 2001-2007 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: Rink ( zllin@amarsoft.com ) 
 * Tester:
 * Content: 
 * Input Param:
 *
 * Output param:
 *
 * History Log:
 *
 */
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�̶������ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�̶������ѯ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>

<html>
<head>
<title>�����Ŵ�ҵ��̶�ͳ�Ʊ���</title>


<script type="text/javascript">
	function doAction(sAction){
		if(sAction == "back"){
			if (confirm("��ȷ��Ҫ�˳�����ϵͳ��")){
				window.open("<%=sWebRootPath%>/Main.jsp","_top");  
			}
		}
		else{
			OpenPage("/FixStat/FixSheetShow.jsp?SheetID="+sAction+"&DisplayCriteria=true&rand="+randomNumber(),"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	function setTitle(sTitle){
		
		document.getElementById("table0").cells(0).innerHTML="<font class=pt9white> &nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	

	function startMenu(){
	<%
		/* TREEVIEW ����չ�ַ�Χ����
		 * ͨ������ģ����Ȩ�ޱ�־RightInfo��ϵͳ���û��Ľ�ɫRoleID����
		 * �������ֿ����ֶΣ�1��������嵽��ɫ���𣬼�һ�ű����Ӧ�����ɵķ��ʽ�ɫ
		 *				2��������嵽�������򣬼�һ�ű���򵥶�Ӧ������ͬ��ɫ�����ķ��ʽ�ɫ
		 */
		 //���Ʒ���1
		
		String sUserRole = "and EXISTS ("
									+" select RI.RoleID "
									+" from USER_ROLE UR,ROLE_INFO RI "
									+" where RI.RoleID=UR.RoleID "
									//+" and S_SHEET_MODEL.RightInfo like '%UR.RoleID%' "
									//+" and UR.UserID='"+CurUser.getUserID()+"' "
									+" ) ";
		
		//���Ʒ���2
		/*
		String sUserRole = "and RightInfo like '%'||( "
							+" select RI.RoleID[1,1] "
							+" from USER_ROLE UR,ROLE_INFO RI "
							+" where RI.RoleID=UR.RoleID "
							//+" and UR.RoleID like R_SHEET_MODEL.RightInfo||'%' "
							+" and UR.UserID='"+CurUser.getUserID()+"' "
							+" )||'%'";
		*/
		HTMLTreeView tviTemp = new HTMLTreeView("�̶������ѯ�б�","right");
		tviTemp.initWithSql("OrderNo", "SheetTitle", "", "Describe", "", "FROM R_SHEET_MODEL where OrderNo not like 'h%' AND OrderNo not like 'H%' and  (OrderNo is not null and   OrderNo <> ' ') ", Sqlca);
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');
		//expandNode('1');
	}	
</script> 

</head>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


</html>

<script type="text/javascript">
	myleft.width=200;
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>