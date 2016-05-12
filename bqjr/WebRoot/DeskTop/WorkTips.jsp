<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  
		Tester:
		Content: 我的工作台
		Input Param:
			          
		Output param:
			      
		History Log: syang 2009/09/28 页面重新整理，去除多余无用的HTML
								 syang 2009/10/20页面待处理工作提示整理，让这些页面可配置
								 				请参考代码表代码：PlantformTask的配置情况。
								 												增加一个未完成工作提示，只需要配置好相应页面URL地址即可，不需要再来修改此页面
								 syang 2009/12/10 工作台style样式文件分享，引入走马灯库，不再使用HTML走马灯效果
		注意：新增工作提示，请不要修改此页面，请参考代码[PlantformTask]的配置，只需要在该代码里配置好相应页面即可
					xswang 20150429 CCS-433 PRM-146 安硕系统公告信息权限设置
	 */
	%>
<%/*~END~*/%>
<html>
<head>
	<title>日常工作提示</title>
	<link rel="stylesheet" href="<%=sResourcesPath%>/css/worktips.css">
	<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/marquee-1.0.js'></script>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody">
<%
	String sAllItemNo = "";

	//取出代码对象
	//Item[] codeDef = CodeManager.getItems("PlantformTask");
%>
	<div id="WindowDiv">
		<!-- 日历 -->
		<div id="CalendarDiv">
			<table cellspacing='0' cellpadding='0' width='100%' height="100%" style="border:1px solid #ccc">
		   	<tr>
					<td align="center" nowrap    height="20">我的日历</td>
				</tr>
				<tr>
					<td bgcolor= #dcdcdc width=100% height=160 valign="top" align="center">
						<iframe name="MyCalendar" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在打开页面，请稍候" width=100% height=100% frameborder=0 scrolling="no" /> </iframe>
					</td>
				</tr>
			</table>
			<span style="font-size:12px;">[<a href="javascript:void(0);" onclick="viewWorkRecord()">全部工作笔记</a>]</span>
		</div>
		
		
		
		<% // add by xswang 20150429 CCS-433 PRM-146 安硕系统公告信息权限设置 %>
		<!-- 总行通知 -->
		<% // 对公告栏进行限制，不能进行复制、打印%> 
		<div id="NoticeDiv" oncopy="document.selection.empty()">
			<h1>总部通知</h1>
			<div>
			<ul id="NoticeUL">
			<%
	      	String sNotice = "";
	      	String sIsNew = "",sIsEject = "";
	      	
	      	// 先取出当前用户所在的机构
	      	String sBelongOrg = "",sBelongOrgName = "";
	      	ASResultSet rs1 = null;
	      	String sSql = "select ui.userid,ui.belongorg as BelongOrg,getOrgName(BelongOrg) as BelongOrgName from user_info ui where UserID=:UserID ";
	      	rs1 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", CurUser.getUserID()));
	      	while(rs1.next()){
	      		sBelongOrg = rs1.getString("BelongOrg");
	      		sBelongOrgName = rs1.getString("BelongOrgName");
	      	}
	      	if(sBelongOrg == null) sBelongOrg = "";
	      	if(sBelongOrgName == null) sBelongOrg = "";
	      	
	      	if("1".equals(sBelongOrg)){ // 若为总公司，则可以看到全部的公告
	      		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select BoardNo,BoardTitle,BoardDesc,IsNew,IsEject,DocNo from BOARD_LIST where IsPublish = '1' and (ShowToRoles is null or ShowToRoles in (select RoleID from USER_ROLE where UserID=:UserID)) order by BoardNo desc").setParameter("UserID",CurUser.getUserID()));
	      		int i=0;
				while(rs.next()){
					i++;
		        	sIsNew = DataConvert.toString(rs.getString("IsNew"));
		        	sIsEject = DataConvert.toString(rs.getString("IsEject"));
		        	sNotice += ("<li style='cursor:pointer;' >");
		        	sNotice += (i+".");
		        	if(sIsEject.equals("1")){
		        		sNotice += ("<span onclick='javascript:openFile(\""+rs.getString("DocNo")+"\")'>"+rs.getString("BoardTitle")+" "+DataConvert.toString(rs.getString("BoardDesc"))+"</span>");//update CCS-243(首页中的总部通知模块，无法显示文字信息，发通知只能将内容以附件的形式发布，请将新增通知时填写的公告描述中的文本信息作为公告内容一并显示)
		        	}else{
		        		sNotice += ("<span>"+rs.getString("BoardTitle")+" "+DataConvert.toString(rs.getString("BoardDesc"))+"</span>");//update CCS-243(首页中的总部通知模块，无法显示文字信息，发通知只能将内容以附件的形式发布，请将新增通知时填写的公告描述中的文本信息作为公告内容一并显示)
		        	}
		        	if(sIsNew.equals("1")){
		        		sNotice += ("<img src='"+sResourcesPath+"/new.gif' border=0>");
				}
				sNotice += "</li>";
				}
				rs.getStatement().close();
				out.println(sNotice);
	      	}else{ // 否则若是下属部门，则增加一个约束条件，只能显示发布在本部门的公告信息，其他部门的公告信息不显示
	      		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select BoardNo,BoardTitle,BoardDesc,IsNew,IsEject,DocNo from BOARD_LIST where IsPublish = '1' and (ShowToRoles is null or ShowToRoles in (select RoleID from USER_ROLE where UserID=:UserID)) and BoardObject like '%"+sBelongOrgName+"%' order by BoardNo desc").setParameter("UserID",CurUser.getUserID()));
	      	// end by xswang 20150429
	      		int i=0;
				while(rs.next()){
					i++;
	        		sIsNew = DataConvert.toString(rs.getString("IsNew"));
	        		sIsEject = DataConvert.toString(rs.getString("IsEject"));
	        		sNotice += ("<li style='cursor:pointer;' >");
	        		sNotice += (i+".");
	        		if(sIsEject.equals("1")){
	        			sNotice += ("<span onclick='javascript:openFile(\""+rs.getString("DocNo")+"\")'>"+rs.getString("BoardTitle")+" "+DataConvert.toString(rs.getString("BoardDesc"))+"</span>");//update CCS-243(首页中的总部通知模块，无法显示文字信息，发通知只能将内容以附件的形式发布，请将新增通知时填写的公告描述中的文本信息作为公告内容一并显示)
	        		}else{
	        			sNotice += ("<span>"+rs.getString("BoardTitle")+" "+DataConvert.toString(rs.getString("BoardDesc"))+"</span>");//update CCS-243(首页中的总部通知模块，无法显示文字信息，发通知只能将内容以附件的形式发布，请将新增通知时填写的公告描述中的文本信息作为公告内容一并显示)
	        		}
	        		if(sIsNew.equals("1")){
	        			sNotice += ("<img src='"+sResourcesPath+"/new.gif' border=0>");
				}
				sNotice += "</li>";
				}
				rs.getStatement().close();
				out.println(sNotice);
	      	}
	      	rs1.getStatement().close();
	      	%>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>



<script type="text/javascript">
	$(document).ready(function(){
		//总行滚动通知
		$("#NoticeUL").ScrollAction(50, false);
		//加载日历
		OpenComp("MyCalendar","/DeskTop/MyCalendar.jsp","","MyCalendar","");
		
	});
	//--------------------------
</script>
<script type="text/javascript">
	function openFile(sDocNo){
	    AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&RightType=ReadOnly", "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	//查看全部工作笔记
	function viewWorkRecord(){
		PopComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","NoteType=All","","");
	}
	/**
	 *统计待处理的业务数量
	 *@ItemNo 编号
 	 */
	function CountPlantform(ItemNo)
	{
		var xmlHttp = getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/InvokerAjax.jsp";
		url=url+"?CompClientID=<%=SpecialTools.amarsoft2Real(sCompClientID)%>&ItemNo="+ItemNo+"&Type=0";
		xmlHttp.onreadystatechange = function(){
			var message = "";
			if (xmlHttp.readyState == 4) {
				message = xmlHttp.responseText;
				message="<font color=red>"+message+"</font>";
			}else{
				message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
			}
			$("#CountSpan"+ItemNo).html(message);
		};
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		return;
	}
	/**
	 *点击相应的Trip时，展示相应的数据
	 *@ItemNo 编号
	 */
	function touchPlantform(ItemNo){
		var xmlHttp = getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(eid("DataList"+ItemNo).innerHTML == ""){
			var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/InvokerAjax.jsp";
			url=url+"?CompClientID=<%=SpecialTools.amarsoft2Real(sCompClientID)%>&ItemNo="+ItemNo+"&Type=1";
			xmlHttp.onreadystatechange = function(){
				var message = "";
				if (xmlHttp.readyState == 4) {
					//message = genDataList(xmlHttp.responseText);
					message = xmlHttp.responseText;
				}else{
					message = "<img border=0 bordercolordark='#CCCCCC' src='<%=sResourcesPath%>/33.gif'>";
				}
				eid("DataList"+ItemNo).innerHTML=message;
			};
			xmlHttp.open("GET", url, true);
			xmlHttp.send(null);
			eid("Plus"+ItemNo).style.display = "none";
			eid("Minus"+ItemNo).style.display = "block";
		}else{
			eid("DataList"+ItemNo).innerHTML = "";
			eid("Plus"+ItemNo).style.display = "block";
			eid("Minus"+ItemNo).style.display = "none";
		}
	}
	function eid(id){
		return document.getElementById(id);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>