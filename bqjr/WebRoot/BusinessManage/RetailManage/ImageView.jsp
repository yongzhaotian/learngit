<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ϣ"; //-- ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������Ϣ&nbsp;&nbsp;"; //--Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//--Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//--Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = "";	//--���sql���
	ASResultSet rs = null;//--��Ž����
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sRegCode = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RegCode"));
	String sPhaseType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	
	if (sPhaseType == null) sPhaseType = "";
	//���ҳ�����	

    if (sSerialNo == null) sSerialNo="";
    if (sRegCode == null) sRegCode="";
	String sTreeViewTemplet = "RetailApplyFileView";//

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
<%
	

	ARE.getLog().debug("===============sTreeViewTemplet="+sTreeViewTemplet);
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView ="";

	sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeViewTemplet+"' and isinuse = '1'  ";
	tviTemp.initWithSql("ItemNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By ItemNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style>
</head>
<body leftmargin="0" topmargin="0" class="windowbackground" onload="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<!-- for refresh this page -->
<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
</form>
	<tr>
		<td valign="top">
			<table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="content_table"  id="content_table">
				<tr> 
					<td id="myleft_leftMargin" class="myleft_leftMargin"></td>
					<td width="2" id="myleft" <%=(Integer.parseInt(PG_LEFT_WIDTH)<10?"style=\"display:none;\"":"")%>>
						<table style="height:100%;width:100%;" cellspacing="0" cellpadding="0">
						<tr height="100%"><td><iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no></iframe></td></tr>
						</table>
					</td>
			</table>
		</td>
	</tr>
</table>
<div id="myboard" style="position: absolute; left: 0; top: 0; width: 100%; height: 100%; cursor: w-resize; display: none;"></div>
</body>
</html>
<script type="text/javascript">
	function setTitle(sTitle){
		document.getElementById("table0").rows[0].cells[0].innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}
	
	myleft.width=<%=PG_LEFT_WIDTH%>;
	
	$(function(){
		$("#divDrag").bind("mousedown", function(e){
			var myboard = $("#myboard").show();
			var mybody = $("body").addClass("no_select");
			$(document).bind("mousemove", dragmove).bind("mouseup", dragup);
			var x = e.clientX;
			var width = window.parseInt(myleft.width, 10);
			function dragmove(e){
				myleft.width = width + e.clientX - x;
			}
			function dragup(){
				$(document).unbind("mousemove", dragmove).unbind("mouseup", dragup);
				myboard.hide();
				mybody.removeClass("no_select");
			}
		});
	});
	setTimeout(function(){
		if(myleft.width<10){
			myleft.style.display = "none";
			mycenter.style.display = "none";
		}
	}, 100);
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 

	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name+"&RegCode="+"<%=sRegCode%>";
		OpenComp(sCompID,sURL,sParaStringTmp,"frameright");
		
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		openChildComp("RetailAttachmentList","/BusinessManage/RetailManage/ImageViewFrameRetail.jsp","ComponentName="+sCurItemName+"&AccountType=ALL&Type="+sCurItemDescribe+"&SerialNo=<%=sSerialNo%>&RegCode=<%=sRegCode%>&PhaseType=<%=sPhaseType%>");
	}
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
