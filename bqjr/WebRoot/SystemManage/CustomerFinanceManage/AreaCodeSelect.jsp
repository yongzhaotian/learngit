<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	/*
		ҳ��˵��: ѡ����������
	 */
	String sAreaCodeValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaCodeValue"));//�ڸ�ҳ��򿪺�򿪶�������ʱ��ֵ��
	String sAreaCode = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaCode"));//����ֵʱ������ʼ�����롣
	String sOpen = "";
	String sDefaultItem = "";
	String sDefaultItem2 = "";
	
	if(sAreaCode.length()>3) sDefaultItem = sAreaCode.substring(0,4);
	if(sAreaCode!=null&&sAreaCode.length()>4){
		sOpen = "YES";//�ݲ������ơ�
		sDefaultItem2 =sAreaCode;
	}
%>
<html>
<head>
<title>��ѡ���������� </title>
<style>
.black9pt {font-size: 11pt; font-weight: bolder; color: #000000; text-decoration: none;}
</style>
</head>
<script type="text/javascript">
	//��ȡ�û�ѡ�����ҵ����
	function TreeViewOnClick(){
		var sAreaCode=getCurTVItem().value;
		var sAreaCodeName=getCurTVItem().name;
		var sAreaCodeID=getCurTVItem().id;
		buff.AreaCode.value=sAreaCode+"@"+sAreaCodeName+"@"+sAreaCodeID;

		//ѡ�������ҵ����ʱ�����Զ������ұ߽�Ŀ
	<%	if(sAreaCodeValue == null){	%>
			newBusiness();
	<%	}%>
	}
	
	//modify by hwang,�޸�˫����Ӧ������function TreeViewOnDBClick()�޸�Ϊfunction TreeViewOnDBLClick() 
	function TreeViewOnDBLClick(){
		newBusiness();
	}
	
	//��ѡһ����������
	function newBusiness(){
		//ѡ�������滮����ʱ�����Զ������ұ߽�Ŀ
	<%	if(sAreaCodeValue == null){	%>
			if(buff.AreaCode.value!=""){
				sReturnValue = buff.AreaCode.value;			
				parent.OpenPage("/SystemManage/CustomerFinanceManage/AreaCodeSelect.jsp?AreaCodeValue="+getCurTVItem().id,"frameright","");
			}else{
				alert("��ѡ����������ϸ�");//��ѡ�������滮ϸ�
			}
	<%	}else{	%>
			var s,sValue,sName;
			var sReturnValue = "";
			s=buff.AreaCode.value;

			s = s.split('@');
			sValue = s[0];
			sName = s[1];
			sID = s[2];
			if(typeof(sID)=="undefined" || sID.length<5){
				alert("��ѡ����������ϸ�");//��ѡ����������ϸ�
			}else{
				if(sID.length==6){				
					top.returnValue = sValue+"@"+sName;
					top.close();
				}
				else{
					alert("��ѡ����������ϸ�");//��ѡ����������ϸ�
				}
			}
	<%	}%>	
	}
	
	//���
	function clearAll(){
		top.returnValue='_CLEAR_';
		top.close();
	}
	
	function goBack(){
		top.close();
	}

	//����ѯ������ҵ���Ͱ���TreeViewչʾ
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("���������б�","right");
		tviTemp.TriggerClickEvent=true;
		//ѡ����ҵ����һ
		if(sAreaCodeValue == null)
			tviTemp.initWithSql("SortNo","ItemName","ItemNo","","from Code_Library where CodeNO='AreaCode' and length(SortNo) <= 4",Sqlca);
		else
			tviTemp.initWithSql("SortNo","ItemName","ItemNo","","from Code_Library where CodeNO='AreaCode' and SortNo like '"+sAreaCodeValue+"%'",Sqlca);
		
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		out.println(tviTemp.generateHTMLTreeView());
	%>
	}
</script>
<body bgcolor="#DCDCDC">
<center>
<form  name="buff">
<input type="hidden" name="AreaCode" value="">
<table width="90%" align=center border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
	<td id="myleft"  colspan='3' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
<tr height=4%>
	<%
		if(sAreaCodeValue == null){
	%>
	<span class="STYLE9"></span>
	<p align="left" class="black9pt">������������</p>
	<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ></td>
	<%
		}else{
	%>
	<span class="STYLE9"></span>
	<p align="left" class="black9pt">������������</p>
	<td nowrap align="center" valign="baseline">
		<table>
	        <tr>
		       <td><%=HTMLControls.generateButton("ȷ��","ȷ��","javascript:newBusiness()",sResourcesPath)%></td>
		       <td><%=HTMLControls.generateButton("ȡ��","ȡ��","javascript:goBack()",sResourcesPath)%></td>
		       <td><%=HTMLControls.generateButton("���","���","javascript:clearAll()",sResourcesPath)%></td>
	        </tr>
	    </table>
	</td>
	<%}%>
</tr>
</table>
</form>
</center>
</body>
</html>
<script type="text/javascript">
	startMenu();
	expandNode('root');		
	selectItem('<%=sDefaultItem%>');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	selectItem('<%=sDefaultItem2%>');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
</script>
<%@ include file="/IncludeEnd.jsp"%>