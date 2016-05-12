<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
		Input Param:
		Output param:
		History Log: CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
	*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "�������Ҫ��"; // ��������ڱ��� <title> PG_TITLE </title>
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	�����̱�š��׶α��CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
		String sFlowNo = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("FlowNo"));
		String sPhaseNo = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("PhaseNo"));
		String sRightType = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("RightType"));
		
		
		

		//����ֵת���ɿ��ַ���
		if (sFlowNo == null)
			sFlowNo = "";
		if (sPhaseNo == null)
			sPhaseNo = "";
		if (sRightType == null)
			sRightType = "";

		//��������ģ�ͱ�źͽ׶α�Ų�ѯ�׶�����
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
<title>���������Ҫ����Ϣ</title>
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

	function doSubmit() {//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
		editor.sync();//�ı��༭�����ֵǰ����ͬ���£���Ȼȡ����ֵ
		var sAuditPoints = document.getElementById('AuditPoints').value; // ���html�������ñ����ʽ��ֹ��ת��
		if(sAuditPoints==""||sAuditPoints==null){
			alert("���������Ҫ�����ݣ�");
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
	
	//���html���ݽ��и�ʽ��������
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
				<td align="left"><input type="button" style="width: 50px" name="ok" value="ȷ��" onclick="javascript:doSubmit()"></td>
			</tr>
			<tr>
				<td align="left"><font size="2">��<%=sPhaseName%>�����Ҫ�㡾�����������1000�ڡ�:
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