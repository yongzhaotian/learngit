<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
  /* ҳ��˵��: ʾ������ҳ�� */
  String PG_TITLE = "ʾ������ҳ��";
  String sNoticeId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NoticeId"));
//add by byang CCS-1252 �������ɼ��Ŷӱ���
  String  noticetitle = "",noticepeople="", noticecontent = "", noticedate = "",inputorg = "",updateuser="",updatetime="",visibleTeam="";
  String uname="";
  String oname="";
  String nname="";
  if(sNoticeId==null)
  {
	  sNoticeId="";
  }else{
		String clob = null;  		
	    String sql="SELECT t.noticeid,t.noticetitle,t.noticepeople,t.noticedate,t.inputorg,t.updateuser,t.updatetime,t.noticecontent,t.visibleRole FROM notice_info t where t.noticeid='"+sNoticeId+"'";
		Connection conn =Sqlca.getConnection();
		PreparedStatement ps=conn.prepareStatement(sql);  
		ResultSet rs = ps.executeQuery(); 
	  if(rs.next())
		{
		    noticetitle=rs.getString("noticetitle");
			noticepeople=rs.getString("noticepeople");
			noticedate=rs.getString("noticedate");
			inputorg=rs.getString("inputorg");
			updateuser=rs.getString("updateuser");
			updatetime=rs.getString("updatetime");
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
		uname=Sqlca.getString("SELECT T.USERNAME FROM USER_INFO T WHERE T.USERID='"+updateuser+"'");
		//���Ŷ�Ӧ����
	    oname=Sqlca.getString("SELECT T.ORGNAME FROM ORG_INFO T WHERE T.ORGID='"+inputorg+"'");
		//����������
		nname=Sqlca.getString("SELECT T.USERNAME FROM USER_INFO T WHERE T.USERID='"+noticepeople+"'");
  }
		//���ҳ�����
	  String sButtons[][] = {
	      {"flase","","Button","����","���������޸�","saveAndGoBack()",sResourcesPath},
	      {"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	    };
%>

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

<body class="InfoPage" leftmargin="0" topmargin="0">
	<form name="NoticeForm" style="margin-bottom: 0px;"
		enctype="multipart/form-data" action="" method="post">
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
					readonly="readonly" /></td>
			</tr>
			<tr>
				<td>���淢��ʱ��</td>
				<td><input type="text" name="noticeDate" id="noticeDate"
					readonly="readonly" /></td>
				<td>��������</td>
				<td><input type="text" name="inputOrg" id="inputOrg"
					readonly="readonly" /></td>
			</tr>
			<tr style="background-color: rgb(247, 251, 255)">
				<td>����������</td>
				<td><input type="text" name="updateUser" id="updateUser"
					readonly="readonly" /></td>
				<% 
				//add by byang CCS-1252 �ͷ����Ĺ�������ѡ��ĳ���Ŷ�������
				if(CurUser.getOrgID().equals("14")){ %>
				<td>�ɼ��Ŷ�</td>
				<td>
					<input type='checkbox' name='visibleTeam' value=1036 >�ͷ�����
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
	//��ҵ���߼���Ҫ�������޷���ģ�����á�ֻ����ԭ��jdbc�������沢����listҳ��
  function saveAndGoBack(){
		//�ֻ�ù���ID���ж��Ƿ���ֵ����ֵ�����޸Ĳ�����ûֵ��Ϊ����״̬
    var noticeId=document.getElementById('noticeId').value;
    if(!noticeId){//��������
	      noticeId =getSerialNo("Notice_INFO","NoticeId","");
	      var noticeTitle =document.getElementById('noticeTitle').value;
	      var noticePeople="<%=CurUser.getUserID()%>";
	      editor.sync();//�ı��༭�����ֵǰ����ͬ���£���Ȼȡ����ֵ
	      var noticeContent = document.getElementById('noticeContent').value; // ���html�������ñ����ʽ��ֹ��ת��
	      //noticeContent= encodeURIComponent(noticeContent);//encodeURIComponent�������ñ���
	  	  /*******��Ϊ�ı��༭���ϳ�html����.java�Ὣ����������ʽ���ض�ת�塣�ʲ����滻�ַ�����********/
	      noticeContent=replaceAll(noticeContent,"\"", "tlg");
	      noticeContent=replaceAll(noticeContent,"=", "hzp");
	  	  noticeContent=replaceAll(noticeContent,"#", "rlt");
	  	  noticeContent=replaceAll(noticeContent,"&nbsp;", "nbsp");
	  	  noticeContent=replaceAll(noticeContent,"&lt;", "lt");
	  	  noticeContent=replaceAll(noticeContent,"&gt;", "gt");
	  	  noticeContent=replaceAll(noticeContent,"&amp;", "amp");
	      var inputOrg="<%=CurUser.getOrgID()%>";
	      var updateUser="<%=CurUser.getUserID()%>";
	      var updateTime="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
	      var noticeDate=document.getElementById('noticeDate').value;
	      var args = "noticeId="+noticeId+",noticeTitle="+noticeTitle+",noticePeople="+noticePeople+",noticeContent="+noticeContent +",inputOrg="+inputOrg+",updateUser="+updateUser+",noticeDate="+noticeDate+",updateTime="+updateTime;
	      RunJavaMethodSqlca("com.amarsoft.app.billions.InsertOrUpdateNoticeInfo","addNotice",args);
	      goBack();
    }else{//�޸ı���
          var noticeId =document.getElementById('noticeId').value;
	      var noticeTitle =document.getElementById('noticeTitle').value;
	      var updateUser=<%=CurUser.getUserID()%>;
	      var updateTime="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
	      editor.sync();//�ı��༭�����ֵǰ����ͬ���£���Ȼȡ����ֵ
	      var noticeContent = document.getElementById('noticeContent').value; // ���html�������ñ����ʽ��ֹ��ת��
	  	  /*******��Ϊ�ı��༭���ϳ�html����.java�Ὣ����������ʽ���ض�ת�塣�ʲ����滻�ַ�����********/
	      noticeContent=replaceAll(noticeContent,"\"", "tlg");
	      noticeContent=replaceAll(noticeContent,"=", "hzp");
	  	  noticeContent=replaceAll(noticeContent,"#", "rlt");
	  	  noticeContent=replaceAll(noticeContent,"&nbsp;", "nbsp");
	  	  noticeContent=replaceAll(noticeContent,"&lt;", "lt");
	  	  noticeContent=replaceAll(noticeContent,"&gt;", "gt");
	  	  noticeContent=replaceAll(noticeContent,"&amp;", "amp");
	  	  var args = "noticeId="+noticeId+",noticeTitle="+noticeTitle+",noticeContent="+noticeContent +",updateUser="+updateUser+",updateTime="+updateTime;
	  	  RunJavaMethodSqlca("com.amarsoft.app.billions.InsertOrUpdateNoticeInfo","updateNotice",args);
		  goBack();
    }
   
  }
	//���html���ݽ��и�ʽ����������
  function replaceAll(obj,str1,str2){         
		var result  = obj.replace(eval("/"+str1+"/gi"),str2);        
		return result;  
  }
  function goBack() {
    AsControl.OpenView("/Common/WorkFlow/ReadNoticeList.jsp", "", "_self");
  }
  //��ʼ����������
  function loading()
  {
	  //sNoticeIdΪ�������������ݡ���Ҫ��Խ��渳Ĭ��ֵ
	  if("<%=sNoticeId%>"==""){
		  document.getElementById('noticePeople').value="<%=CurUser.getUserName()%>";
		  document.getElementById('noticeDate').value="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
		  document.getElementById('inputOrg').value="<%=CurUser.getOrgName()%>";
		  document.getElementById('updateUser').value="<%=CurUser.getUserName()%>";
	  }else{//�޸�ʱ���ظ���sNoticeId��ѯ����Ӧ��������䵽�����У��洢��IDҪ��ʾ�ɶ�Ӧ��������ʽ
		  document.getElementById('noticeId').value="<%=sNoticeId%>";
		  document.getElementById('noticeDate').value="<%=noticedate%>";
		  document.getElementById('inputOrg').value="<%=oname%>";
		  document.getElementById('updateUser').value="<%=uname%>";
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