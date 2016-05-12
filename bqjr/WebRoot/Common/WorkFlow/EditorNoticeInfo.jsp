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
	/* 页面说明: 示例详情页面 */
		String PG_TITLE = "示例详情页面";
		String sNoticeId = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("NoticeId"));
		//add by byang CCS-1252 公告栏可见团队变量
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
				Reader is = clob.getCharacterStream();// 得到流
				BufferedReader br = new BufferedReader(is);
				String s = br.readLine();
				StringBuffer sb = new StringBuffer();
				while (s != null) {// 执行循环将字符串全部取出付值给StringBuffer由StringBuffer转成STRING
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
			//用户对应名称
			uname = Sqlca.getString("SELECT T.USERNAME FROM USER_INFO T WHERE T.USERID='"+ updateuser + "'");
			//部门对应名称
			oname = Sqlca.getString("SELECT T.ORGNAME FROM ORG_INFO T WHERE T.ORGID='"+ inputorg + "'");
			//发布人名称
			nname = Sqlca.getString("SELECT T.USERNAME FROM USER_INFO T WHERE T.USERID='"+ noticepeople + "'");
		}
		//获得页面参数
		String sButtons[][] = {
				{ "true", "", "Button", "保存", "保存所有修改","saveAndGoBack()", sResourcesPath },
				{ "true", "", "Button", "返回", "返回列表页面", "goBack()",sResourcesPath } 
				};
		if (rs != null) {
			rs.getStatement().close();
		}
		
		//add by binyang CCS-1252 公告栏 角色集合
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
				<td>公告标题</td>
				<td><input type="text" name="noticeTitle" id="noticeTitle"
					value="<%=noticetitle%>" /></td>
				<td>公告发布人名称</td>
				<td><input type="text" name="noticePeople" id="noticePeople"
					readonly="readonly" /> <input type="hidden" name="noticePeopleId"
					id="noticePeopleId" /></td>
			</tr>
			<tr>
				<td>公告发布时间</td>
				<td><input type="text" name="noticeDate" id="noticeDate"
					readonly="readonly" /></td>
				<td>机构名称</td>
				<td><input type="text" name="inputOrg" id="inputOrg"
					readonly="readonly" /> <input type="hidden" name="inputOrgId"
					id="inputOrgId" /></td>
			</tr>
			<tr style="background-color: rgb(247, 251, 255)">
				<td>更新人名称</td>
				<td><input type="text" name="updateUser" id="updateUser"
					readonly="readonly" /> <input type="hidden" name="updateUserId"
					id="updateUserId" />
				</td>
				
				<% 
				//add by byang CCS-1252 客服部的公告栏有选择某个团队来公布
				if(CurUser.getOrgID().equals("14")){ %>
				<td>可见团队</td>
				<td>
					<input type='checkbox' name='visibleTeam' value=1036 >客服主管
					<input type='checkbox' name='visibleTeam' value=1064 >客服组长
					<input type='checkbox' name='visibleTeam' value=1035 >客服专员<br>
					<input type='checkbox' name='visibleTeam' value=1059 >电销组长
					<input type='checkbox' name='visibleTeam' value=1058 >电销专员<br>
					<input type='checkbox' name='visibleTeam' value=1060 >投诉组
					<input type='checkbox' name='visibleTeam' value=1061 >质检组
					<input type='checkbox' name='visibleTeam' value=1062 >培训组	
				</td>
				<%} %>
			</tr>
			<tr height="20px">
				<td colspan="4"></td>
			</tr>
			<tr>
				<td style="vertical-align: top;">公告内容</td>
				<td style="vertical-align: top;" colspan="3"><textarea
						id="contentqq" name="noticeContent"
						style="width: 723px; height: 300px; visibility: hidden;"><%=noticecontent%></textarea>
				</td>
			</tr>
		</table>
	</form>
</body>
<script type="text/javascript">
/***********加载文本编辑器相关组件资源  CCS-960 20150731 huzp******************/
  var editor = null;//这个是全局变量
  KindEditor.ready(function(K) {
    editor = K.create('textarea[name="noticeContent"]', {
      cssPath : '../plugins/code/prettify.css',
      allowFileManager : true,
      filterMode : true,
      items : [
              'source', '|','fontname','fontsize','forecolor','hilitecolor','bold','italic','removeformat','clearhtml','emoticons','fullscreen'  
           ],//控制编辑器的菜单
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
	//因业务逻辑需要，这里无法用模板配置。只能用原生jdbc处理保存并返回list页面
  	function saveAndGoBack(){
		//现获得公告ID。判断是否有值，有值就是修改操作。没值就为新增状态
		var noticeId = document.getElementById('noticeId').value;
		var noticeTitle = document.getElementById('noticeTitle').value;
		//add by byang CCS-1252 公告栏 标题不能为空格
		var tempNoticeTitle = noticeTitle;
		for(var i=0;i<noticeTitle.length;i++){
			if("　"===noticeTitle.substr(i,1)){
				tempNoticeTitle = tempNoticeTitle.replace("　","");
			}
		}
		tempNoticeTitle = tempNoticeTitle.trim();
		if(tempNoticeTitle==""||tempNoticeTitle==null){
			alert("请输入公告标题！");
			return;
		}
		editor.sync();//文本编辑器获得值前必须同步下，不然取不到值
		var noticeContent = document.getElementById('noticeContent').value; // 针对html代码设置编码格式防止被转义
		noticeContent = noticeContent.replace(/\s+/g,"");//add by byang CCS-1252 公告栏 内容不能为普通的空格
		if(noticeContent==""||noticeContent==null){
			alert("请输入公告内容！");
			return;
		}
		//add by byang CCS-1252 客服公告栏必须选择发送团队
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
			  alert("请先选择可见团队！");
			  return;
			}
		}
		
		/*******因为文本编辑器上成html代码.java会将下面三种形式给截断转义。故采用替换字符处理********/
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
					alert('保存失败！文字已超最大限制（1000汉字），请精减文字');
					goBack();
				}
			},
			error:function(){
				alert("保存失败！文字已超最大限制（1000汉字），请精减文字");
				goBack();
			}
		});
	}
	//针对html内容进行格式化处理函数
	function replaceAll(obj, str1, str2) {
		var result = obj.replace(eval("/" + str1 + "/gi"), str2);
		return result;
	}
	function goBack() {
		AsControl.OpenView("/Common/WorkFlow/NoticeList.jsp", "", "_self");
	}
	//初始化加载数据
	function loading() {
		//sNoticeId为空则是新增数据。则要针对界面赋默认值
		if ("<%=sNoticeId%>"==""){
		  document.getElementById('noticePeople').value="<%=CurUser.getUserName()%>";
		  document.getElementById('noticePeopleId').value="<%=CurUser.getUserID()%>";
		  document.getElementById('noticeDate').value="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
		  document.getElementById('inputOrg').value="<%=CurUser.getOrgName()%>";
		  document.getElementById('inputOrgId').value="<%=CurUser.getOrgID()%>";
		  document.getElementById('updateUser').value="<%=CurUser.getUserName()%>";
		  document.getElementById('updateUserId').value="<%=CurUser.getUserID()%>";

	  }else{//修改时加载根据sNoticeId查询出对应的数据填充到界面中，存储的ID要显示成对应的名称形式
		  document.getElementById('noticeId').value="<%=sNoticeId%>";
		  document.getElementById('noticeDate').value="<%=noticedate%>";
		  document.getElementById('inputOrg').value="<%=oname%>";
		  document.getElementById('updateUser').value="<%=CurUser.getUserName()%>";
		  document.getElementById('updateUserId').value="<%=CurUser.getUserID()%>";
		  document.getElementById('noticePeople').value="<%=nname%>";
		  
		  //add by byang CCS-1252  公告栏详情需要看到已选择的可见团队
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