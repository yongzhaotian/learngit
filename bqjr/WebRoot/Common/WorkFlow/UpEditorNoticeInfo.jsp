<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
  /* 页面说明: 示例详情页面 */
  String PG_TITLE = "示例详情页面";
  String sNoticeId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NoticeId"));
  String sflag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));
	boolean sButton =false;
	if(sNoticeId==null) sNoticeId="";
	if(sflag.equals("0")){//若sflag参数为0时则显示下面已阅按钮出来证明是未阅的公告信息
		sButton=true;
	}
  //add by byang CCS-1252 公告栏可见团队变量
  String  noticetitle = "",noticepeople="", noticecontent = "", noticedate = "",inputorg = "",updateuser="",updatetime="",visibleTeam="";
  String uname="";
  String oname="";
  String nname="";
  if(sNoticeId==null)
  {
	  sNoticeId="";
  }else{
		String clob = "";  		
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
		uname=Sqlca.getString("SELECT T.USERNAME FROM USER_INFO T WHERE T.USERID='"+updateuser+"'");
		//部门对应名称
	    oname=Sqlca.getString("SELECT T.ORGNAME FROM ORG_INFO T WHERE T.ORGID='"+inputorg+"'");
		//发布人名称
		nname=Sqlca.getString("SELECT T.USERNAME FROM USER_INFO T WHERE T.USERID='"+noticepeople+"'");
  }
		//获得页面参数
	  String sButtons[][] = {
			{sButton?"true":"false","","Button","已阅","返回列表页面","saveAndGoBack()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
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
				<td>公告标题</td>
				<td><input type="text" name="noticeTitle" id="noticeTitle"
					value="<%=noticetitle%>" /></td>
				<td>公告发布人名称</td>
				<td><input type="text" name="noticePeople" id="noticePeople"
					readonly="readonly" /></td>
			</tr>
			<tr>
				<td>公告发布时间</td>
				<td><input type="text" name="noticeDate" id="noticeDate"
					readonly="readonly" /></td>
				<td>机构名称</td>
				<td><input type="text" name="inputOrg" id="inputOrg"
					readonly="readonly" /></td>
			</tr>
			<tr style="background-color: rgb(247, 251, 255)">
				<td>更新人名称</td>
				<td><input type="text" name="updateUser" id="updateUser"
					readonly="readonly" /></td>
				<% 
				//add by byang CCS-1252 客服部的公告栏有选择某个团队来公布
				if(CurUser.getOrgID().equals("14")){ %>
				<td>可见团队</td>
				<td>
					<input type='checkbox' name='visibleTeam' value=1036 >客服主管
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
      items : [
              'source', '|','formatblock','fontname','fontsize','forecolor','hilitecolor','bold','italic', 'underline','removeformat','hr','clearhtml','quickformat','selectall','emoticons','fullscreen'  
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
	  <%/*~点击已阅按钮后在公告与员工关联表USER_NOTICE中添加当前员工已阅的公告信息，并讲该公告标识字段flag置为1~*/%>
		var userID = "<%=CurUser.getUserID()%>";
		var noticeId ="<%=sNoticeId%>";
		var args = "userID="+userID+",noticeId="+noticeId;
		RunJavaMethodSqlca("com.amarsoft.app.billions.InsertUserNoticeInfo","addUser_Notice",args);
		goBack();
  }
	//针对html内容进行格式化处理函数
  function replaceAll(obj,str1,str2){         
		var result  = obj.replace(eval("/"+str1+"/gi"),str2);        
		return result;  
  }
  function goBack(){
		AsControl.OpenView("/Common/WorkFlow/UpNoticeList.jsp","","_self");
  }
  //初始化加载数据
  function loading()
  {
	  //sNoticeId为空则是新增数据。则要针对界面赋默认值
	  if("<%=sNoticeId%>"==""){
		  document.getElementById('noticePeople').value="<%=CurUser.getUserName()%>";
		  document.getElementById('noticeDate').value="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
		  document.getElementById('inputOrg').value="<%=CurUser.getOrgName()%>";
		  document.getElementById('updateUser').value="<%=CurUser.getUserName()%>";
	  }else{//修改时加载根据sNoticeId查询出对应的数据填充到界面中，存储的ID要显示成对应的名称形式
		  document.getElementById('noticeId').value="<%=sNoticeId%>";
		  document.getElementById('noticeDate').value="<%=noticedate%>";
		  document.getElementById('inputOrg').value="<%=oname%>";
		  document.getElementById('updateUser').value="<%=uname%>";
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