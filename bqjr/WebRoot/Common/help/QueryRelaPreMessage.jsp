<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>��ѡ���������</title>
</head>
<%
	ASResultSet rs = null;
	String sSql = "";
	String sCommentItemID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentItemID"));
%>
<script type="text/javascript">
	var sCompID ;
	var sType ;
	function TreeViewOnClick(){
	
		sCompID = getCurTVItem().value ;
		sType = getCurTVItem().type;
		if(sType == "page"){
			buff.CompID.value = sCompID;
		}
	}
	function newBusiness(){
	
		if(buff.CompID.value!=""){
			sReturnValue = PopPageAjax("/Common/help/InsertCompValueAjax.jsp?CompID="+sCompID+"&ObjectType=ComponentDefinition&CommentItemID=<%=sCommentItemID%>&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
			if(sReturnValue == 'true') {
				alert("��ӳɹ���");
				self.close() ;
			}else if(sReturnValue == 'false') {
				alert("�ð��������δ�ɹ���������ѡ��");
				return;
			}else {
				alert("�ð��������δ�ɹ���������ѡ��");
				return;
			}
		}
		else{
			alert("��ѡ���������ϸ�");
		}
	}
	
	function startMenu() 
	{
	<%
		sSql = "select OrderNo from Reg_comp_def where Orderno not like '99%' group by orderno Having Count(*) > 1";
		rs = SqlcaRepository.getResultSet(sSql);
		if(rs.next()) {
	%>
			alert("������������ϵϵͳ����Ա��");
			return ;
	<%	}else{
			HTMLTreeView tviTemp = new HTMLTreeView("����б�","right");
			tviTemp.TriggerClickEvent=true;

			tviTemp.initWithSql("OrderNo","CompName","CompID","","from REG_COMP_DEF where OrderNO <> '999999'",Sqlca);

			tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
			out.println(tviTemp.generateHTMLTreeView());
		}
	%>
		
	}
	
	
</script>

<body >
<center>
<form  name="buff" method=post action="">
<input type="hidden" name="CompID" value="">
<table width="90%" align=center border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr> 
        <td id="myleft"  align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
    <tr>
      <td nowarp bgcolor="#F0F1DE" height="25" align=center> 
        <input type="button" name="ok" value="ȷ��" onClick="javascript:newBusiness()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DCDCDC;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DCDCDC;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
</table>
</form>
</center>
</body>
</html> 

<script type="text/javascript">
	startMenu();
	expandNode('root');
</script>

<%@ include file="/IncludeEnd.jsp"%>
