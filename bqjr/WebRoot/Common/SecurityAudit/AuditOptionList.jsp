<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
*	Describe: 安全选项修改及查看页面
*/
	String sCodeType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeType"));
	
	String sItemNo = "";  //规则编号
	if(sCodeType.equals("06010")){  //密码校验规则
		sItemNo = "01%";
	}else if(sCodeType.equals("06030")){  //强制更新规则
		sItemNo = "03%";
	}else if(sCodeType.equals("06040")){  //错误锁定设置
		sItemNo = "04%";
	}else if(sCodeType.equals("06050")){  //用户角色设置
		sItemNo = "05%";
	}else if(sCodeType.equals("065")){  //安全选项查看
		sItemNo = "%";  //全部
	}

 	String sSql = "select ItemName,ItemValue,IsInUse,ItemNo from SECURITY_AUDIT where ItemNo like :ItemNo order by ItemNo";
	String[][] auditArray = Sqlca.getStringMatrix(new SqlObject(sSql).setParameter("ItemNo",sItemNo));
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<title>安全选项一览</title>
<style>
body{
	
}
</style>
</head>
<body>
	<form>
	<table border="1" width="100%" bordercolor="#FFFFFF">
		<tr>
			<td width="40%"><b>规则名称</b></td>
			<td width="35%"><b>规则值</b></td>
			<td width="10%"><b>是否启用</b></td>
			<%if(!sItemNo.equals("%")){ %>
			<td width="15%" colspan="2"><b>操作</b></td>
			<%}%>
		</tr>
		<%for(int i=0;i<auditArray.length;i++){
			String ItemName = auditArray[i][0];
			String ItemValue = auditArray[i][1];
			String isInUse = auditArray[i][2];
			if("Y".equalsIgnoreCase(isInUse)) isInUse = "已启用";
			if("N".equalsIgnoreCase(isInUse)) isInUse = "已停用";
			String ItemNo = auditArray[i][3];
		%>
			<tr>
				<td><%=ItemName%><input type="hidden" value="<%=ItemNo%>" id="ItemNo<%=++i%>"></td>
				<td><table>
						<%if("0101".equals(ItemNo) || "0301".equals(ItemNo) || "0401".equals(ItemNo)){%>
						  <tr>
						  	<%if(!sItemNo.equals("%")){ %>
						  	<td><input type="text" id="ItemValue<%=i%>" value="<%=ItemValue %>"></td>
						  	<td><%=HTMLControls.generateButton("保存","保存规则值","javascript:saveValue("+"'"+isInUse+"'"+");",sResourcesPath) %></td>
						  	<%}else{ %><%=ItemValue%>
						  	<%} %>
						<%}else{ %>&nbsp;<%} %></tr>
					</table></td>
				<td><%=isInUse%></td>
				<%if(!sItemNo.equals("%")){ %>
				<td><%=HTMLControls.generateButton("启用","启用该条目","javascript:beginUse("+"'"+ItemNo+"','"+ItemValue+"'"+");",sResourcesPath) %></td>
				<td><%=HTMLControls.generateButton("停用","停用该条目","javascript:stopUse("+"'"+ItemNo+"','"+ItemValue+"'"+");",sResourcesPath) %></td>
				<%}%>
			</tr>
		<%}%>
	</table>
	</form>
</body>
<script type="text/javascript">
	var changeUserId = "<%=CurUser.getUserID()%>";
	var changeUserName = "<%=CurUser.getUserName()%>";
	
	//保存规则值
	function saveValue(sIsInUse){
		if(document.getElementById("button1").title == "保存规则值"){
			sItemNo = document.forms[0].elements[0].value;
			sItemValue = document.forms[0].elements[1].value;
			if("已启用" == (sIsInUse)) sIsInUse = "Y";
			if("已停用" == (sIsInUse)) sIsInUse = "N";
			flag1 = checkNumber(sItemNo,sItemValue);
			if(flag1 == "0")return;
			flag2 = RunMethod("PublicMethod","SaveAuditOption",sItemNo+","+sItemValue+","+sIsInUse+","+changeUserId+","+changeUserName);
			if(flag2=="1"){
				alert("数据保存成功！");
				self.location.reload();
			}else{
				alert("保存出错，请检查！");
			}
		}
	}
		
	//启用该条目
	function beginUse(ItemNo,ItemValue){
		IsInUse = 'Y';
		flag = RunMethod('PublicMethod','SaveAuditOption',ItemNo+','+ItemValue+','+IsInUse+','+changeUserId+','+changeUserName);
		if(flag=='1'){
			alert('启用成功！');
			self.location.reload();
		}else{
			alert('启用出错，请检查！');
		}
	}

	//停用该条目
	function stopUse(ItemNo,ItemValue){
		IsInUse = 'N';
		flag = RunMethod('PublicMethod','SaveAuditOption',ItemNo+','+ItemValue+','+IsInUse+','+changeUserId+','+changeUserName);
		if(flag=='1'){
			alert('停用成功！');
			self.location.reload();
		}else{
			alert('停用出错，请检查！');
		}
	}

	//规则值校验
	function checkNumber(ItemNo,ItemValue){
		if(ItemNo=="0101"){
			var patrn=/^[0-9]{1,2}$/;
			if(!patrn.exec(ItemValue)){
				alert("密码长度不符合规范！");
				return "0";
			}
			if(ItemValue>20 || ItemValue<0){
				alert("密码长度不符合规范！");
				return "0";
			}
		}else if(ItemNo=="0301"){
			var patrn1=/^[0-9]{1,3}$/;
			if(!patrn1.exec(ItemValue)){
				alert("密码最长使用期限不符合规范！");
				return "0";
			}
			if(ItemValue>180 || ItemValue<0){
				alert("密码最长使用期限不符合规范！");
				return "0";
			}
		}else if(ItemNo=="0401"){
			var patrn2=/^[0-9]{1,2}$/;
			if(!patrn2.exec(ItemValue)){
				alert("错误容忍次数不符合规范！");
				return "0";
			}
			if(ItemValue>10 || ItemValue<0){
				alert("错误容忍次数不符合规范！");
				return "0";
			}
		}
		return "1";
	}
</script>
<%@include file="/IncludeEnd.jsp"%>