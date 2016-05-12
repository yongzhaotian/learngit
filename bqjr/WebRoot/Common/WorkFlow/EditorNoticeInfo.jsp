<%@page import="org.bouncycastle.jce.provider.JDKKeyFactory.RSA"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<script charset="utf-8"
	src="<%=sWebRootPath%>/Common/WorkFlow/editor/kindeditor.js"></script>
<script charset="utf-8"
	src="<%=sWebRootPath%>/Common/WorkFlow/editor/lang/zh_CN.js"></script>
<script charset="utf-8"
	src="<%=sWebRootPath%>/Common/WorkFlow/editor/plugins/code/prettify.js"
	type="text/javascript"></script>
<link
	href="<%=sWebRootPath%>/Common/WorkFlow/editor/plugins/code/prettify.css"
	rel="stylesheet" type="text/css" />

<%
	/* ҳ��˵��: ʾ������ҳ�� */
		String PG_TITLE = "ʾ������ҳ��";
		String sNoticeId = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("NoticeId"));
		//add by byang CCS-1252 �������ɼ��Ŷӱ���
		String noticetitle = "", noticepeople = "", noticecontent = "", noticedate = "", inputorg = "", updateuser = "", updatetime = "",visibleTeam="";
		String uname = "";
		String oname = "";
		String nname = "";
		String clob = null;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		if (sNoticeId == null) {
			sNoticeId = "";
		} else {
			String sql = "SELECT t.noticeid,t.noticetitle,t.noticepeople,t.noticedate,t.inputorg,t.updateuser,t.updatetime,t.noticecontent,t.visibleRole FROM notice_info t where t.noticeid='"
					+ sNoticeId + "'";
			conn = Sqlca.getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				noticetitle = rs.getString("noticetitle");
				noticepeople = rs.getString("noticepeople");
				noticedate = rs.getString("noticedate");
				inputorg = rs.getString("inputorg");
				updateuser = rs.getString("updateuser");
				updatetime = rs.getString("updatetime");
				clob = rs.getString("noticecontent");
				visibleTeam = rs.getString("visiblerole");
				/*
				Reader is = clob.getCharacterStream();// �õ���
				BufferedReader br = new BufferedReader(is);
				String s = br.readLine();
				StringBuffer sb = new StringBuffer();
				while (s != null) {// ִ��ѭ�����ַ���ȫ��ȡ����ֵ��StringBuffer��StringBufferת��STRING
					sb.append(s);
					s = br.readLine();
				}*/
				noticecontent = clob.toString();
				noticecontent = noticecontent.replaceAll("hzp", "=");
				noticecontent = noticecontent.replaceAll("tlg", "\"");
				noticecontent = noticecontent.replaceAll("rlt", "#");
				noticecontent = noticecontent.replaceAll("nbsp", "&nbsp;");
				noticecontent = noticecontent.replaceAll("lt", "&lt;");
				noticecontent = noticecontent.replaceAll("gt", "&gt;");
				noticecontent = noticecontent.replaceAll("amp", "&amp;");
			}
			//�û���Ӧ����
			uname = Sqlca.getString("SELECT T.USERNAME FROM USER_INFO T WHERE T.USERID='"+ updateuser + "'");
			//���Ŷ�Ӧ����
			oname = Sqlca.getString("SELECT T.ORGNAME FROM ORG_INFO T WHERE T.ORGID='"+ inputorg + "'");
			//����������
			nname = Sqlca.getString("SELECT T.USERNAME FROM USER_INFO T WHERE T.USERID='"+ noticepeople + "'");
		}
		//���ҳ�����
		String sButtons[][] = {
				{ "true", "", "Button", "����", "���������޸�","saveAndGoBack()", sResourcesPath },
				{ "true", "", "Button", "����", "�����б�ҳ��", "goBack()",sResourcesPath } 
				};
		if (rs != null) {
			rs.getStatement().close();
		}
		
		//add by binyang CCS-1252 ������ ��ɫ����
		ArrayList roleList = CurUser.getRoleTable();
%>


<body class="InfoPage" leftmargin="0" topmargin="0">
	<form name="NoticeForm" id="NoticeForm" action="NoticeAction"
		method="post">
		<table border="0" width="100%" height="99%" cellspacing="0"
			cellpadding="0" id="InfoTable"
			style="margin-left: 10px; margin-top: 5px;">
			<tr>
				<td colspan="4" valign=top id="InfoButtonArea"
					class="infodw_buttonarea_td" align="left"><%@ include
						file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
				</td>
			</tr>
			<tr style="background-color: rgb(247, 251, 255)">
				<input type="hidden" type="text" name="noticeId" id="noticeId" />
				<td>�������</td>
				<td><input type="text" name="noticeTitle" id="noticeTitle"
					value="<%=noticetitle%>" /></td>
				<td>���淢��������</td>
				<td><input type="text" name="noticePeople" id="noticePeople"
					readonly="readonly" /> <input type="hidden" name="noticePeopleId"
					id="noticePeopleId" /></td>
			</tr>
			<tr>
				<td>���淢��ʱ��</td>
				<td><input type="text" name="noticeDate" id="noticeDate"
					readonly="readonly" /></td>
				<td>��������</td>
				<td><input type="text" name="inputOrg" id="inputOrg"
					readonly="readonly" /> <input type="hidden" name="inputOrgId"
					id="inputOrgId" /></td>
			</tr>
			<tr style="background-color: rgb(247, 251, 255)">
				<td>����������</td>
				<td><input type="text" name="updateUser" id="updateUser"
					readonly="readonly" /> <input type="hidden" name="updateUserId"
					id="updateUserId" />
				</td>
				
				<% 
				//add by byang CCS-1252 �ͷ����Ĺ�������ѡ��ĳ���Ŷ�������
				if(CurUser.getOrgID().equals("14")){ %>
				<td>�ɼ��Ŷ�</td>
				<td>
					<input type='checkbox' name='visibleTeam' value=1036 >�ͷ�����
					<input type='checkbox' name='visibleTeam' value=1064 >�ͷ��鳤
					<input type='checkbox' name='visibleTeam' value=1035 >�ͷ�רԱ<br>
					<input type='checkbox' name='visibleTeam' value=1059 >�����鳤
					<input type='checkbox' name='visibleTeam' value=1058 >����רԱ<br>
					<input type='checkbox' name='visibleTeam' value=1060 >Ͷ����
					<input type='checkbox' name='visibleTeam' value=1061 >�ʼ���
					<input type='checkbox' name='visibleTeam' value=1062 >��ѵ��	
				</td>
				<%} %>
			</tr>
			<tr height="20px">
				<td colspan="4"></td>
			</tr>
			<tr>
				<td style="vertical-align: top;">��������</td>
				<td style="vertical-align: top;" colspan="3"><textarea
						id="contentqq" name="noticeContent"
						style="width: 723px; height: 300px; visibility: hidden;"><%=noticecontent%></textarea>
				</td>
			</tr>
		</table>
	</form>
</body>
<script type="text/javascript">
/***********�����ı��༭����������Դ  CCS-960 20150731 huzp******************/
  var editor = null;//�����ȫ�ֱ���
  KindEditor.ready(function(K) {
    editor = K.create('textarea[name="noticeContent"]', {
      cssPath : '../plugins/code/prettify.css',
      allowFileManager : true,
      filterMode : true,
      items : [
              'source', '|','fontname','fontsize','forecolor','hilitecolor','bold','italic','removeformat','clearhtml','emoticons','fullscreen'  
           ],//���Ʊ༭���Ĳ˵�
      afterCreate : function() {
        var self = this;
        K.ctrl(document, 13, function() {
          self.sync();
          document.forms['NoticeForm'].submit();
        });
        K.ctrl(self.edit.doc, 13, function() {
          self.sync();
          document.forms['NoticeForm'].submit();
        });
      }
    });
    prettyPrint();
  });
</script>
<script type="text/javascript">
	//��ҵ���߼���Ҫ�������޷���ģ�����á�ֻ����ԭ��jdbc�����沢����listҳ��
  	function saveAndGoBack(){
		//�ֻ�ù���ID���ж��Ƿ���ֵ����ֵ�����޸Ĳ�����ûֵ��Ϊ����״̬
		var noticeId = document.getElementById('noticeId').value;
		var noticeTitle = document.getElementById('noticeTitle').value;
		//add by byang CCS-1252 ������ ���ⲻ��Ϊ�ո�
		var tempNoticeTitle = noticeTitle;
		for(var i=0;i<noticeTitle.length;i++){
			if("��"===noticeTitle.substr(i,1)){
				tempNoticeTitle = tempNoticeTitle.replace("��","");
			}
		}
		tempNoticeTitle = tempNoticeTitle.trim();
		if(tempNoticeTitle==""||tempNoticeTitle==null){
			alert("�����빫����⣡");
			return;
		}
		editor.sync();//�ı��༭�����ֵǰ����ͬ���£���Ȼȡ����ֵ
		var noticeContent = document.getElementById('noticeContent').value; // ���html�������ñ����ʽ��ֹ��ת��
		noticeContent = noticeContent.replace(/\s+/g,"");//add by byang CCS-1252 ������ ���ݲ���Ϊ��ͨ�Ŀո�
		if(noticeContent==""||noticeContent==null){
			alert("�����빫�����ݣ�");
			return;
		}
		//add by byang CCS-1252 �ͷ�����������ѡ�����Ŷ�
		var orgid = "<%=CurUser.getOrgID()%>";
		if(orgid == "14"){
			var visibleTeam=document.getElementsByName("visibleTeam");
			var cheStr="";
			for (i=0;i<visibleTeam.length;i++){
			  if(visibleTeam[i].checked == true)
			  {
			   cheStr+=visibleTeam[i].value+",";
			  }
			}
			if(cheStr == "")
			{
			  alert("����ѡ��ɼ��Ŷӣ�");
			  return;
			}
		}
		
		/*******��Ϊ�ı��༭���ϳ�html����.java�Ὣ����������ʽ���ض�ת�塣�ʲ����滻�ַ�����********/
		noticeContent = replaceAll(noticeContent, "\"", "tlg");
		noticeContent = replaceAll(noticeContent, "=", "hzp");
		noticeContent = replaceAll(noticeContent, "#", "rlt");
		noticeContent = replaceAll(noticeContent, "&nbsp;", "nbsp");
		noticeContent = replaceAll(noticeContent, "&lt;", "lt");
		noticeContent = replaceAll(noticeContent, "&gt;", "gt");
		noticeContent = replaceAll(noticeContent, "&amp;", "amp");
		var formData = $('#NoticeForm').serialize();
		$.ajax({
			type:"post",
			url:"NoticeAction?visibleRole="+cheStr,
			data:formData,
			success: function(result) {
				if(result=="SUCCESS"){
					goBack();
				}else{
					alert('����ʧ�ܣ������ѳ�������ƣ�1000���֣����뾫������');
					goBack();
				}
			},
			error:function(){
				alert("����ʧ�ܣ������ѳ�������ƣ�1000���֣����뾫������");
				goBack();
			}
		});
	}
	//���html���ݽ��и�ʽ��������
	function replaceAll(obj, str1, str2) {
		var result = obj.replace(eval("/" + str1 + "/gi"), str2);
		return result;
	}
	function goBack() {
		AsControl.OpenView("/Common/WorkFlow/NoticeList.jsp", "", "_self");
	}
	//��ʼ����������
	function loading() {
		//sNoticeIdΪ�������������ݡ���Ҫ��Խ��渳Ĭ��ֵ
		if ("<%=sNoticeId%>"==""){
		  document.getElementById('noticePeople').value="<%=CurUser.getUserName()%>";
		  document.getElementById('noticePeopleId').value="<%=CurUser.getUserID()%>";
		  document.getElementById('noticeDate').value="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
		  document.getElementById('inputOrg').value="<%=CurUser.getOrgName()%>";
		  document.getElementById('inputOrgId').value="<%=CurUser.getOrgID()%>";
		  document.getElementById('updateUser').value="<%=CurUser.getUserName()%>";
		  document.getElementById('updateUserId').value="<%=CurUser.getUserID()%>";

	  }else{//�޸�ʱ���ظ���sNoticeId��ѯ����Ӧ��������䵽�����У��洢��IDҪ��ʾ�ɶ�Ӧ��������ʽ
		  document.getElementById('noticeId').value="<%=sNoticeId%>";
		  document.getElementById('noticeDate').value="<%=noticedate%>";
		  document.getElementById('inputOrg').value="<%=oname%>";
		  document.getElementById('updateUser').value="<%=CurUser.getUserName()%>";
		  document.getElementById('updateUserId').value="<%=CurUser.getUserID()%>";
		  document.getElementById('noticePeople').value="<%=nname%>";
		  
		  //add by byang CCS-1252  ������������Ҫ������ѡ��Ŀɼ��Ŷ�
		  var sVisibleTeam = "<%=visibleTeam%>";
		  var array= new Array; 
		  array=sVisibleTeam.split(","); 
		  
		  var visibleTeam=document.getElementsByName("visibleTeam");
		  
		  for (i=0;i<array.length ;i++ ) { 
			for (j=0;j<visibleTeam.length;j++){
			  if(array[i] == visibleTeam[j].value)
			  {
			   visibleTeam[j].checked = true;
			   break;
			  }
			}
		  }
		  
		}
	}
	$(document).ready(function() {
		loading();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>