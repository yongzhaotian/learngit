<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author:   xswang 201505
		Tester:
		Content: 文件质量检查审核要点功能维护
		Input Param:
		Output param:
		History Log: CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
	*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
<%
	String PG_TITLE = "新增审核要点"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sToday = StringFunction.getTodayNow();
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：流程编号、阶段编号
		String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
		if (null == sTypeNo) sTypeNo = "";

		//根据流程模型编号和阶段编号查询阶段名称
		String sTypeName = Sqlca.getString("select TypeName from ecm_image_type where TypeNo = '"+ sTypeNo+ "' ");
		if (null == sTypeName) sTypeName = "";
		//审核要点内容 
		String points = Sqlca.getString("SELECT t.auditpoints FROM ecm_image_type t WHERE t.TYPENO='"+ sTypeNo+ "' ");
		if (null == points) points = ""; //CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804

		

%>
<%/*~END~*/%>

<html>
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
        });
        K.ctrl(self.edit.doc, 13, function() {
          self.sync();
        });
      }
    });
    prettyPrint();
  });
</script>
<head>
<title>请输入审核要点信息</title>
<script type="text/javascript">
	function doSubmit() {//CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
		 editor.sync();//文本编辑器获得值前必须同步下，不然取不到值
		    var sAuditPoints = document.getElementById('AuditPoints').value; // 针对html代码设置编码格式防止被转义
		    /*
		    sAuditPoints = replaceAll(sAuditPoints, "\"", "tlg");
			sAuditPoints = replaceAll(sAuditPoints, "=", "hzp");
			sAuditPoints = replaceAll(sAuditPoints, "#", "rlt");
			sAuditPoints = replaceAll(sAuditPoints, "&nbsp;", "nbsp");
			sAuditPoints = replaceAll(sAuditPoints, "&lt;", "lt");
			sAuditPoints = replaceAll(sAuditPoints, "&gt;", "gt");
			sAuditPoints = replaceAll(sAuditPoints, "&amp;", "amp");
		    */
		    var formData = $('#DocAuditPointsForm').serialize();
			$.ajax({
				type:"post",
				url:"DocAuditPointsAction",
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
	
	function goBack() {
		AsControl.OpenView("/SystemManage/CarManage/DocAuditPointsModelInfoAdd.jsp","TypeNo=<%=sTypeNo%>", "frameright", "");
	}
</script>
</head>
<body bgcolor="#D3D3D3">
<form name="DocAuditPointsForm" id="DocAuditPointsForm"  action="" method="post">
	<table align="left" style="margin-top: 20px;">
		<tr>
			<td align="left"><input type="button" style="width: 50px"
				name="ok" value="确认" onclick="javascript:doSubmit()">
			</td>
		</tr>
		<tr>
			<td align="left"><font size="2">【<%=sTypeName%>】审核要点【汉字最大限制1000内】:</font>
			</td>
			<td rows="10" cols="60">
			</td>
		</tr>
		<tr>
			<td align="left">
			<textarea  id="contentqq" name="AuditPoints" rows="10" cols="61" style="width:700px;height:400px;visibility:hidden;"><%=points %></textarea>
			</td>		
		</tr>
		<tr>
			<input type="hidden" name="TypeNo" id="TypeNo" value="<%=sTypeNo%>">
		</tr>
	</table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>