<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author:   xswang 201505
		Tester:
		Content: �ļ�����������Ҫ�㹦��ά��
		Input Param:
		Output param:
		History Log: CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
	*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "�������Ҫ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String sToday = StringFunction.getTodayNow();
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	�����̱�š��׶α��
		String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
		if (null == sTypeNo) sTypeNo = "";

		//��������ģ�ͱ�źͽ׶α�Ų�ѯ�׶�����
		String sTypeName = Sqlca.getString("select TypeName from ecm_image_type where TypeNo = '"+ sTypeNo+ "' ");
		if (null == sTypeName) sTypeName = "";
		//���Ҫ������ 
		String points = Sqlca.getString("SELECT t.auditpoints FROM ecm_image_type t WHERE t.TYPENO='"+ sTypeNo+ "' ");
		if (null == points) points = ""; //CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804

		

%>
<%/*~END~*/%>

<html>
<script charset="utf-8" src="<%=sWebRootPath%>/Common/WorkFlow/editor/kindeditor.js"></script>
<script charset="utf-8" src="<%=sWebRootPath%>/Common/WorkFlow/editor/lang/zh_CN.js"></script>
<script charset="utf-8" src="<%=sWebRootPath%>/Common/WorkFlow/editor/plugins/code/prettify.js" type="text/javascript"></script>
<link href="<%=sWebRootPath%>/Common/WorkFlow/editor/plugins/code/prettify.css" rel="stylesheet" type="text/css" /> 
<script type="text/javascript">
/***********�����ı��༭����������Դ  CCS-960 20150731 huzp******************/
  var editor = null;//�����ȫ�ֱ���
  KindEditor.ready(function(K) {
    editor = K.create('textarea[name="AuditPoints"]', {
      cssPath : '../plugins/code/prettify.css',
      allowFileManager : true,
      items : [
              'fontname','fontsize','forecolor','hilitecolor','bold','italic','removeformat','clearhtml','emoticons','fullscreen'  
			  ],//���Ʊ༭���Ĳ˵�
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
<title>���������Ҫ����Ϣ</title>
<script type="text/javascript">
	function doSubmit() {//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
		 editor.sync();//�ı��༭�����ֵǰ����ͬ���£���Ȼȡ����ֵ
		    var sAuditPoints = document.getElementById('AuditPoints').value; // ���html�������ñ����ʽ��ֹ��ת��
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
						alert('����ɹ�');
						goBack();
					} else {
						alert('����ʧ��');
					}
				},
				error:function() {
					alert("����ʧ��");
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
				name="ok" value="ȷ��" onclick="javascript:doSubmit()">
			</td>
		</tr>
		<tr>
			<td align="left"><font size="2">��<%=sTypeName%>�����Ҫ�㡾�����������1000�ڡ�:</font>
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