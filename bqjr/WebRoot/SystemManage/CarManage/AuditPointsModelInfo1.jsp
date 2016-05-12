<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: CCS-637 PRM-293 审核过程中审核要点功能维护
		Input Param:
		Output param:
		History Log: CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
	*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
<%
	String PG_TITLE = "新增审核要点"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：流程编号、阶段编号CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
		String sFlowNo = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("FlowNo"));
		String sPhaseNo = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("PhaseNo"));
		String sRightType = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("RightType"));
		
		
		

		//将空值转化成空字符串
		if (sFlowNo == null)
			sFlowNo = "";
		if (sPhaseNo == null)
			sPhaseNo = "";
		if (sRightType == null)
			sRightType = "";

		//根据流程模型编号和阶段编号查询阶段名称
		String sPhaseName = Sqlca
				.getString("select PhaseName from Flow_Model where FlowNo = '"
						+ sFlowNo
						+ "' and PhaseNo = '"
						+ sPhaseNo
						+ "'");
		if (null == sPhaseName)
			sPhaseName = "";
%>
<%/*~END~*/%>

<html>
<head>
<title>请输入审核要点信息</title>
<script charset="utf-8" src="<%=sWebRootPath%>/Common/WorkFlow/editor/kindeditor.js"></script>
<script charset="utf-8" src="<%=sWebRootPath%>/Common/WorkFlow/editor/lang/zh_CN.js"></script>
<script charset="utf-8" src="<%=sWebRootPath%>/Common/WorkFlow/editor/plugins/code/prettify.js" type="text/javascript"></script>
<link href="<%=sWebRootPath%>/Common/WorkFlow/editor/plugins/code/prettify.css" rel="stylesheet" type="text/css" /> 

<script type="text/javascript">
/***********加载文本编辑器相关组件资源  CCS-960 20150731 huzp******************/
  var editor = null;//这个是全局变量
  KindEditor.ready(function(K) {
    editor = K.create('textarea[name="AuditPoints"]', {
      cssPath : '../plugins/code/prettify.css',
      allowFileManager : true,
      items : [
               'fontname','fontsize','forecolor','hilitecolor','bold','italic','removeformat','clearhtml','emoticons','fullscreen'  
           ],//控制编辑器的菜单
      afterCreate : function() {
        var self = this;
        K.ctrl(document, 13, function() {
          self.sync();
          document.forms['AuditPointsForm'].submit();
        });
        K.ctrl(self.edit.doc, 13, function() {
          self.sync();
          document.forms['AuditPointsForm'].submit();
        });
      }
    });
    prettyPrint();
  });
</script>


<script type="text/javascript">

	function doSubmit() {//CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
		editor.sync();//文本编辑器获得值前必须同步下，不然取不到值
		var sAuditPoints = document.getElementById('AuditPoints').value; // 针对html代码设置编码格式防止被转义
		if(sAuditPoints==""||sAuditPoints==null){
			alert("请输入审核要点内容！");
			return;
		}
		/*
		sAuditPoints = replaceAll(sAuditPoints, "\"", "tlg");
		sAuditPoints = replaceAll(sAuditPoints, "=", "hzp");
		sAuditPoints = replaceAll(sAuditPoints, "#", "rlt");
		sAuditPoints = replaceAll(sAuditPoints, "&nbsp;", "nbsp");
		sAuditPoints = replaceAll(sAuditPoints, "&lt;", "lt");
		sAuditPoints = replaceAll(sAuditPoints, "&gt;", "gt");
		sAuditPoints = replaceAll(sAuditPoints, "&amp;", "amp");
		*/
		var formData = $('#AuditPointsForm').serialize();
		$.ajax({
			type:"post",
			url:"auditPointsAction",
			data:formData,
			success:function(result) {
				if (result == "SUCCESS") {
					alert('保存成功');
					goBack();
				} else {
					alert('保存失败');
				}
			},
			error:function() {
				alert("保存失败");
			}
		});
	}
	
	//针对html内容进行格式化处理函数
	function replaceAll(obj, str1, str2) {
		var result = obj.replace(eval("/" + str1 + "/gi"), str2);
		return result;
	}
	
	function goBack() {
		//AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelInfoAdd.jsp", "","rightup");
		AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelInfoAdd.jsp","FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&RightType=<%=sRightType%>","rightup");

	}
</script>
</head>
<body bgcolor="#D3D3D3">
     <form name="AuditPointsForm" id="AuditPointsForm"  action="" method="post">
		<table align="left" style="margin-top: 20px;">
			<tr>
				<td align="left"><input type="button" style="width: 50px" name="ok" value="确认" onclick="javascript:doSubmit()"></td>
			</tr>
			<tr>
				<td align="left"><font size="2">【<%=sPhaseName%>】审核要点【汉字最大限制1000内】:
				</font></td>
				<td rows="10" cols="60"></td>

			</tr>
			<tr>
				<td align="left"><textarea align="left" id="contentqq" name="AuditPoints" rows="10" cols="61" style="width: 300px; height: 150px; visibility: hidden;"></textarea>
				</td>
			</tr>
			<tr>
				<input type="hidden" name="FlowNo" id="FlowNo" value="<%=sFlowNo%>">
				<input type="hidden" name="PhaseNo" id="PhaseNo" value="<%=sPhaseNo%>">
				
			</tr>

	</table>
	</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>