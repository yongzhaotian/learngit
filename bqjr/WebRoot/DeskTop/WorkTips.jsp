<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  
		Tester:
		Content: �ҵĹ���̨
		Input Param:
			          
		Output param:
			      
		History Log: syang 2009/09/28 ҳ����������ȥ���������õ�HTML
								 syang 2009/10/20ҳ�����������ʾ��������Щҳ�������
								 				��ο��������룺PlantformTask�����������
								 												����һ��δ��ɹ�����ʾ��ֻ��Ҫ���ú���Ӧҳ��URL��ַ���ɣ�����Ҫ�����޸Ĵ�ҳ��
								 syang 2009/12/10 ����̨style��ʽ�ļ�������������ƿ⣬����ʹ��HTML�����Ч��
		ע�⣺����������ʾ���벻Ҫ�޸Ĵ�ҳ�棬��ο�����[PlantformTask]�����ã�ֻ��Ҫ�ڸô��������ú���Ӧҳ�漴��
					xswang 20150429 CCS-433 PRM-146 ��˶ϵͳ������ϢȨ������
	 */
	%>
<%/*~END~*/%>
<html>
<head>
	<title>�ճ�������ʾ</title>
	<link rel="stylesheet" href="<%=sResourcesPath%>/css/worktips.css">
	<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/marquee-1.0.js'></script>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody">
<%
	String sAllItemNo = "";

	//ȡ���������
	//Item[] codeDef = CodeManager.getItems("PlantformTask");
%>
	<div id="WindowDiv">
		<!-- ���� -->
		<div id="CalendarDiv">
			<table cellspacing='0' cellpadding='0' width='100%' height="100%" style="border:1px solid #ccc">
		   	<tr>
					<td align="center" nowrap    height="20">�ҵ�����</td>
				</tr>
				<tr>
					<td bgcolor= #dcdcdc width=100% height=160 valign="top" align="center">
						<iframe name="MyCalendar" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�" width=100% height=100% frameborder=0 scrolling="no" /> </iframe>
					</td>
				</tr>
			</table>
			<span style="font-size:12px;">[<a href="javascript:void(0);" onclick="viewWorkRecord()">ȫ�������ʼ�</a>]</span>
		</div>
		
		
		
		<% // add by xswang 20150429 CCS-433 PRM-146 ��˶ϵͳ������ϢȨ������ %>
		<!-- ����֪ͨ -->
		<% // �Թ������������ƣ����ܽ��и��ơ���ӡ%> 
		<div id="NoticeDiv" oncopy="document.selection.empty()">
			<h1>�ܲ�֪ͨ</h1>
			<div>
			<ul id="NoticeUL">
			<%
	      	String sNotice = "";
	      	String sIsNew = "",sIsEject = "";
	      	
	      	// ��ȡ����ǰ�û����ڵĻ���
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
	      	
	      	if("1".equals(sBelongOrg)){ // ��Ϊ�ܹ�˾������Կ���ȫ���Ĺ���
	      		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select BoardNo,BoardTitle,BoardDesc,IsNew,IsEject,DocNo from BOARD_LIST where IsPublish = '1' and (ShowToRoles is null or ShowToRoles in (select RoleID from USER_ROLE where UserID=:UserID)) order by BoardNo desc").setParameter("UserID",CurUser.getUserID()));
	      		int i=0;
				while(rs.next()){
					i++;
		        	sIsNew = DataConvert.toString(rs.getString("IsNew"));
		        	sIsEject = DataConvert.toString(rs.getString("IsEject"));
		        	sNotice += ("<li style='cursor:pointer;' >");
		        	sNotice += (i+".");
		        	if(sIsEject.equals("1")){
		        		sNotice += ("<span onclick='javascript:openFile(\""+rs.getString("DocNo")+"\")'>"+rs.getString("BoardTitle")+" "+DataConvert.toString(rs.getString("BoardDesc"))+"</span>");//update CCS-243(��ҳ�е��ܲ�֪ͨģ�飬�޷���ʾ������Ϣ����ֻ֪ͨ�ܽ������Ը�������ʽ�������뽫����֪ͨʱ��д�Ĺ��������е��ı���Ϣ��Ϊ��������һ����ʾ)
		        	}else{
		        		sNotice += ("<span>"+rs.getString("BoardTitle")+" "+DataConvert.toString(rs.getString("BoardDesc"))+"</span>");//update CCS-243(��ҳ�е��ܲ�֪ͨģ�飬�޷���ʾ������Ϣ����ֻ֪ͨ�ܽ������Ը�������ʽ�������뽫����֪ͨʱ��д�Ĺ��������е��ı���Ϣ��Ϊ��������һ����ʾ)
		        	}
		        	if(sIsNew.equals("1")){
		        		sNotice += ("<img src='"+sResourcesPath+"/new.gif' border=0>");
				}
				sNotice += "</li>";
				}
				rs.getStatement().close();
				out.println(sNotice);
	      	}else{ // ���������������ţ�������һ��Լ��������ֻ����ʾ�����ڱ����ŵĹ�����Ϣ���������ŵĹ�����Ϣ����ʾ
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
	        			sNotice += ("<span onclick='javascript:openFile(\""+rs.getString("DocNo")+"\")'>"+rs.getString("BoardTitle")+" "+DataConvert.toString(rs.getString("BoardDesc"))+"</span>");//update CCS-243(��ҳ�е��ܲ�֪ͨģ�飬�޷���ʾ������Ϣ����ֻ֪ͨ�ܽ������Ը�������ʽ�������뽫����֪ͨʱ��д�Ĺ��������е��ı���Ϣ��Ϊ��������һ����ʾ)
	        		}else{
	        			sNotice += ("<span>"+rs.getString("BoardTitle")+" "+DataConvert.toString(rs.getString("BoardDesc"))+"</span>");//update CCS-243(��ҳ�е��ܲ�֪ͨģ�飬�޷���ʾ������Ϣ����ֻ֪ͨ�ܽ������Ը�������ʽ�������뽫����֪ͨʱ��д�Ĺ��������е��ı���Ϣ��Ϊ��������һ����ʾ)
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
		//���й���֪ͨ
		$("#NoticeUL").ScrollAction(50, false);
		//��������
		OpenComp("MyCalendar","/DeskTop/MyCalendar.jsp","","MyCalendar","");
		
	});
	//--------------------------
</script>
<script type="text/javascript">
	function openFile(sDocNo){
	    AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo+"&RightType=ReadOnly", "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	//�鿴ȫ�������ʼ�
	function viewWorkRecord(){
		PopComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","NoteType=All","","");
	}
	/**
	 *ͳ�ƴ������ҵ������
	 *@ItemNo ���
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
	 *�����Ӧ��Tripʱ��չʾ��Ӧ������
	 *@ItemNo ���
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