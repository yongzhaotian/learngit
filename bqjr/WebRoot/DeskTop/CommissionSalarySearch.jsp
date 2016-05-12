<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sObjectType = DataConvert.toRealString(
			iPostChange,(String)CurComp.getParameter("ObjectType"));
	// 获取加密后的
	String userId = CurUser.getUserID();
	String sql = "SELECT WORKID FROM USER_INFO WHERE USERID = '" + userId + "'";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql));
	String workid = "";
	if (rs.next()) {
		workid = rs.getString(1);
	} else {
		out.print("找不到员工号！");
	}
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>提成工资查询界面</title>
<style>
	.bluebuttoncss {
		font-family: "tahoma", "宋体";
		font-size: 9pt; 
		color: #003366;
		border: 0px #93bee2 solid;
		border-bottom: #93bee2 1px solid;
		border-left: #93bee2 1px solid;
		border-right: #93bee2 1px solid;
		border-top: #93bee2 1px solid;*/
		background-color: #ffffff;
		cursor: hand;
		font-style: normal;
		margin-right: 10px;
		margin-top: 50px;
		height: 20px;
	}
	
	.fontcss {
		font-family: "tahoma", "宋体";
		font-size: 9pt; 
		color: #003366;
		vertical-align: center;
		line-height: 20px;
		height: 20px;
		margin-right: 10px;
		margin-left: 100px;
		margin-top: 50px;
	}
</style>
<script type="text/javascript">
document.onkeydown=function(event){            
	var e = event || window.event || arguments.callee.caller.arguments[0];           
	if(e && e.keyCode==13){ 
		if (document.activeElement.id == 'ym') {
			searchRes();
		}
	}        
}; 
// 查询结果
function searchRes() {
	var format = /^(\d{4})(\d{2})$/
	if (!format.test(document.getElementById("ym").value)) { 
		alert("日期格式不正确!");
		return false;
	} else {
		var sObjectType = '<%=sObjectType %>';
		var userId = '<%=userId %>';
		var workid = '<%=workid %>';
		var MyCSURL = "<%=CurConfig.getConfigure("MyCSURL") %>";
		if (sObjectType == "MySalary" && workid == null) {
			alert("无法获取工号，请联系管理员!");
			return false;
		}
		var ym = document.getElementById("ym").value;
		var fileName = RunMethod("BusinessManage", "CommissionSalaryEncrypt", userId + ","
				+ ym + "," + sObjectType + "," + workid + ",SUM");
		OpenComp("UserDefineList", "/DeskTop/CommissionSalarySum.jsp", "ym=" + ym + "&param=" + fileName, "right");
	}
}

function CheckStatus(url) {
	try {
		XMLHTTP = new ActiveXObject("Microsoft.XMLHTTP");
		XMLHTTP.open("HEAD", url, false);
		XMLHTTP.send();
		
		if (XMLHTTP.status == 200) {
			return true;
		} else {
			return false;
		}
	} catch(e) {
		return false;
	}
}
</script>
</head>
<body style="margin: 0 auto;">
	<span class="fontcss">请输入查询年月: </span>
	<input id="ym" type="text" style="color: #999;" class="bluebuttoncss" onFocus="if(value==defaultValue){value='';this.style.color='#000'}" onBlur="if(!value){value=defaultValue;this.style.color='#999'}" value="YYYYMM" />
	<button id="searBtn" class="bluebuttoncss" style="background-color: #93bee2; width: 50px;" onclick="searchRes();">查询</button>
	<span style="color: red; font-size: 13px; font-family: 'tahoma', '宋体';">(格式：YYYYMM)</span>
</body>
<%@ include file="/IncludeEnd.jsp"%>