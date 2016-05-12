<%@page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/* 
		页面说明:
	 */	 
	//获得组件参数
	String sSerialNo  =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	//定义变量
	ASResultSet rs = null;
	String sRelaCustomerID = "";
	String sRelaCustomerID1 = "";
	String sRelaCustomerID2 = "";
	String sRelaCustomerID3 = "";
	String sRelaCustomerID4 = "";
	String sRelaCustomerID5 = "";
	String sJoinCustomerID = "";
	
	String sSql = "select CustomerID,RelaCustomerID1,RelaCustomerID2,RelaCustomerID3,RelaCustomerID4,RelaCustomerID5 from GROUP_RESULT where SerialNo = :SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if(rs.next()){
		sRelaCustomerID = rs.getString("CustomerID");
		sRelaCustomerID1 = rs.getString("RelaCustomerID1");
		sRelaCustomerID2 = rs.getString("RelaCustomerID2");
		sRelaCustomerID3 = rs.getString("RelaCustomerID3");
		sRelaCustomerID4 = rs.getString("RelaCustomerID4");
		sRelaCustomerID5 = rs.getString("RelaCustomerID5");
	}
	rs.getStatement().close(); 
	
	//由于sRelaCustomerID1-sRelaCustomerID1值的格式有可能不是单一客户号，而是使用@分割的多个客户ID
	//因此需要统一连接后统一处理
	sJoinCustomerID = sRelaCustomerID
					+"@"+sRelaCustomerID1
					+"@"+sRelaCustomerID2
					+"@"+sRelaCustomerID3
					+"@"+sRelaCustomerID4
					+"@"+sRelaCustomerID5;
	sJoinCustomerID = sJoinCustomerID.replaceAll("@+", "@");	//把字符串中可能存在的多个@换为单个@
	sJoinCustomerID = sJoinCustomerID.replaceAll("^@+", "");	//去除行首可能出现的@
	sJoinCustomerID = sJoinCustomerID.replaceAll("@+$", "");	//去除行末可能现在的@
	sJoinCustomerID = sJoinCustomerID.replaceAll("@","','");	//把@换为','
	sJoinCustomerID = "'"+sJoinCustomerID+"'";
	
	//用来生成待选择数据区
	sSql = "select CustomerID,CustomerName from Customer_info where CustomerID in ("+sJoinCustomerID+")";
	rs = Sqlca.getASResultSet(new SqlObject(sSql));

	String sButtons[][] = {	
		{"true","","Button","保存","保存申请认定书","save()",sResourcesPath},
		{"true","","Button","申请认定书预览","申请认定书预览","nextStep()",sResourcesPath},		
	};
%>
<HTML>
<HEAD>
<TITLE></TITLE>
<style>
body {
	margin-left: auto;
	margin-right: auto;
}
div { /*border:1px solid #0000FF;*/
	margin: 0px;
}
div#outter { /*border:1px solid #0000FF;*/
	width: 100%;
	height: 100%;
}
div#buttonBar {
	width: 100%;
	height: 1%;
}
/*内容容器*/
div#containBar {
	border: 1px solid #DDDDDD;
	margin-top: 1%;
	width:100%;
	height:50%;
	padding-top:1%;
}
div#buttonBar li {
	list-style: none;
	float: left;
	margin-left: 10px;
}
/*待选择的数据池样式定义*/
div#dataPoolDiv{
	/*border:1px solid #00FF00;*/
	width:40%;
	height:100%;
	float:left;
	padding-left:3%;
}
/*已选择的数据样式定义(母公司，子公司总容器)*/
div#selectedDiv{
	width:56%;
	height:100%;
	float:left;
	/*border:1px solid #FF0000;*/
}
/*母公司样式定义*/
div#selectedDiv div#parentCompany{
	width:100%;
	height:50%;
	/*border:1px solid #FF0000;*/ 
}
/*子公司样式定义*/
div#selectedDiv div#childCompany{
	width:100%; 
	height:50%;
	/*border:1px solid #FF0000;*/
}
h1{
	font-size: 14px;
	margin: 0px;
	padding-left:1%; 
}
h2{ /*border:1px solid #FF0000;*/
	font-size: 14px;
	padding-left:6%; 
	margin: 0px;
}
 /*标题的下划线*/
.lineSpan{
	border-bottom:1px solid #DDDDDD;
	width:97%;
}
/*标题的背景*/
h1 span span,h2 span span{
	padding:1%,3%;  
	background-color:#DDDDDD;
}
table{
	margin:0px;
	padding:0px;
}
p { /*border:1px solid #0000FF;*/
	margin: 0px;
}
select {
	width: 20%;
	heigth: 100;
	margin: 1%;
}
.poolSelect{
	width:98%;
	heigth:100%;
	font-size:14px;
}
.selectedSelect{
	width:98%;
	heigth:100%;
	font-size:14px;
}
</style>
</HEAD>
<body>
<div id="outter">
	<div id="buttonBar">
	<table>
	<tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top>
		<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
		</td>
	</tr>
	</table>
	</div>
	<div id="containBar">
		<!-- 可供选择的数据列表 -->
		<div id="dataPoolDiv">
			<h1><span class="lineSpan"><span>可供选择的数据</span></span></h1>
			<table width="100%" height="90%" cellpadding="0" cellspacing="0">   
				<tr>
					<td>
						<select name="allCustomerSle" id="allCustomerSle" multiple = true" class="poolSelect" size = "40">
						<%
						while(rs.next()){
							out.println("<option  value='"+rs.getString("CustomerID")+"'>"+rs.getString("CustomerID")+" "+rs.getString("CustomerName")+"</option>");
						}
						rs.getStatement().close(); 
						%>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<!-- 被选择的数据列表 -->
		<div id="selectedDiv">
			<div id="parentCompany">
				<h2><span class="lineSpan"><span>母公司列表</span></span></h2>
				<table width="100%" height="90%"> 
					<tr>
						<td text-align ="left" width="2%" height="100%"> 
							<table width="100%" height="100%"> 
								<tr><td height="50%">
										<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif'
											alt='移入母公司列表' title="移入母公司列表"
											style="cursor: pointer;"
											name='btnParentCompanyMoveIn' id="btnParentCompanyMoveIn"
											onmouseover ='swapImg("btnParentCompanyMoveIn","MOUSE_OVER");'
											onmousedown='swapImg("btnParentCompanyMoveIn","MOUSE_DOWN");'
											onmouseup='swapImg("btnParentCompanyMoveIn","MOUSE_UP");'
											onmouseout='swapImg("btnParentCompanyMoveIn","MOUSE_OUT");'
											onclick="parentMoveIn()" />
										</td></tr>
								<tr><td height="50%">
											<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif'
											alt='移出母公司列表' title="移出母公司列表"
											style="cursor: pointer;"
											name='btnParentCompanyMoveOut' id="btnParentCompanyMoveOut"
											onmouseover ='swapImg("btnParentCompanyMoveOut","MOUSE_OVER");'
											onmousedown='swapImg("btnParentCompanyMoveOut","MOUSE_DOWN");'
											onmouseup='swapImg("btnParentCompanyMoveOut","MOUSE_UP");'
											onmouseout='swapImg("btnParentCompanyMoveOut","MOUSE_OUT");'
											onclick="parentMoveOut()" />
										</td></tr>
							</table>							
						</td>
						<td text-align="left" width="98%" height="100%"> 
							<select multiple =true name="parentCompanySle" id="parentCompanySle" class="selectedSelect" size = "18">
							</select>
						</td>
					</tr>
				</table>
			</div>
			<div id="childCompany">
				<h2><span class="lineSpan"><span>子公司列表</span></span></h2>
				<table width="100%" height="90%"> 
					<tr>
						<td text-align="left" width="2%" height="100%">
							<table width="100%" height="100%">
								<tr><td height="50%">
										<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif'
											alt='移入子公司列表' title="移入子公司列表"
											style="cursor: pointer;"
											name='btnchildCompanyMoveIn' id="btnchildCompanyMoveIn"
											onmouseover ='swapImg("btnchildCompanyMoveIn","MOUSE_OVER");'
											onmousedown='swapImg("btnchildCompanyMoveIn","MOUSE_DOWN");'
											onmouseup='swapImg("btnchildCompanyMoveIn","MOUSE_UP");'
											onmouseout='swapImg("btnchildCompanyMoveIn","MOUSE_OUT");'
											onclick="childMoveIn()" />
										</td></tr>
								<tr><td height="50%">
										<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif'
											alt='移出子公司列表' title="移出子公司列表"
											style="cursor: pointer;"
											name='btnchildCompanyMoveOut' id="btnchildCompanyMoveOut"
											onmouseover ='swapImg("btnchildCompanyMoveOut","MOUSE_OVER");'
											onmousedown='swapImg("btnchildCompanyMoveOut","MOUSE_DOWN");'
											onmouseup='swapImg("btnchildCompanyMoveOut","MOUSE_UP");'
											onmouseout='swapImg("btnchildCompanyMoveOut","MOUSE_OUT");'
											onclick="childMoveOut()" />
										</td></tr>
							</table>
						</td>
						<td text-align="left" height="100%">
							<select multiple =true name="childCompanySle" id="childCompanySle" class="selectedSelect" size = "18">
							</select>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<script type="text/javascript">
	/**
	 *把一个select框的内容移到另一个select框
	 *@srcSle 源列表框
	 *@descSle 目标表框
	 *@options 被选择的值的
	 */
	function optionMove(srcSle,descSle,options){
		for(var i=0;i<options.length;i++){
			//1.删除源框
			for(var j=0;j<srcSle.length;j++){
				if(srcSle[j] == options[i]){
					bSaveFlag = false;
					srcSle[j] = null;
					break;
				}
			}
			options[i].selected = false;//取消其已选中属性
			//2.移入目标框
			descSle.options.add(options[i]);
		}
	}
	/**
	 *把一个select框的已的数据以option对象的形式返回
	 *@select 列表框引用
	 */
	function getSelectedOptions(select){
		var options = new Array();
		for(var i=0;i<select.length;i++){
			if(select[i].selected){
				options.push(select[i]); 
			}
		}
		return options;
	}

	/**
	 *图片交换，按钮动态效果
	 *图片样式：移入，按下，松开，移出
	 *@buttonId 按钮ID号
	 *@type 动作类型 ,MOUSE_OVER,MOUSE_DOWN,MOUSE_UP,MOUSE_OUT
	 */
	function swapImg(buttonId,type) {
		var img = document.getElementById(buttonId); 
		if (img == null) return; 
		var src = img.src; 
		var und = -1;											
		var oldSuffix = "";								//源图片的后缀
		var newSuffix = "";								//新图片的后缀
		var imgPrefix = ""; 							//图片前缀
		if(type == "MOUSE_OVER"){
			oldSuffix = "_disabled.gif";
			newSuffix = ".gif";
		}else if(type == "MOUSE_DOWN"){
			oldSuffix = ".gif";
			newSuffix = "_clicked.gif";
		}else if(type == "MOUSE_UP"){
			oldSuffix = "_clicked.gif";
			newSuffix = ".gif";
		}else if(type == "MOUSE_OUT"){
			//防止按下后就移出去了,执行不UP事件，造成图片名字拼接错误，这里打个补丁
			u = src.lastIndexOf("_clicked.gif");
			if(u == -1){
				oldSuffix = ".gif";
			}else{
				oldSuffix = "_clicked.gif";
			}
			newSuffix = "_disabled.gif";
		}else{
			return;
		}
		
		und = src.lastIndexOf(oldSuffix); 
		if (und == -1){
			return false;
		} 
		imgPrefix = src.substring(0,und);
		img.src = imgPrefix + newSuffix;
		
	}

	var bSaveFlag = false;
	
	/*~[Describe=移入母公司列表;]~*/
	function parentMoveIn(){
		var allCustomerSle = document.getElementById("allCustomerSle");
		var parentCompanySle = document.getElementById("parentCompanySle");
		var options = getSelectedOptions(allCustomerSle);
		//已选择数据里必需有数据且（已选择的数据不能多于1个，已有母公司列表数据不能多于一个）
		if(options.length > 0 &&(options.length > 1 || parentCompanySle.length >= 1 )){
			alert("母公司个数不能超过一个");
			return;
		}else{
			optionMove(allCustomerSle,parentCompanySle,options);
		}
	}
	/*~[Describe=移出母公司列表;]~*/
	function parentMoveOut(){
		var allCustomerSle = document.getElementById("allCustomerSle");
		var parentCompanySle = document.getElementById("parentCompanySle");
		var options = getSelectedOptions(parentCompanySle);
		optionMove(parentCompanySle,allCustomerSle,options);
	}
	/*~[Describe=移入子公司列表;]~*/
	function childMoveIn(){
		var allCustomerSle = document.getElementById("allCustomerSle");
		var childCompanySle = document.getElementById("childCompanySle");
		var options = getSelectedOptions(allCustomerSle);
		optionMove(allCustomerSle,childCompanySle,options);
	}
	/*~[Describe=移入子公司列表;]~*/
	function childMoveOut(){
		var allCustomerSle = document.getElementById("allCustomerSle");
		var childCompanySle = document.getElementById("childCompanySle");
		var options = getSelectedOptions(childCompanySle);
		optionMove(childCompanySle,allCustomerSle,options);
	}

	function save(){
		var parentCustomerID = new Array();
		var chileCustomerID = new Array();

		//取数据
		var parentCompanySle = document.getElementById("parentCompanySle");
		for(var i=0;i<parentCompanySle.length;i++){
			parentCustomerID.push(parentCompanySle[i].value);
		}
		var childCompanySle = document.getElementById("childCompanySle");
		for(var i=0;i<childCompanySle.length;i++){
			chileCustomerID.push(childCompanySle[i].value);
		}
		
		var boolvalue =RunMethod("CustomerManage","SaveGroupRela","<%=sSerialNo%>,"+parentCustomerID.join("@")+","+chileCustomerID.join("@"));
		if(boolvalue == "1" ){			
			alert("保存成功");
			bSaveFlag = true;
		}else if(boolvalue == "2"){
			alert("请先选择子公司再保存");	
		}else{
			alert("保存失败");
		}
	}
	
	/*~[Describe=生成申请认定书;]~*/
	function nextStep(){
		var sSerialNo = "<%=sSerialNo%>";
		if(bSaveFlag == false){
			alert("请先保存");
			return;
		}
		
		/* 保留此处，需要时可打开。注意：使用时传入的sSerialNo的值应不同，才能实时生成认定申请书。
		  //查集团客户认定申请书是否已经生成
		  sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer","","");
		  //未生成集团客户认定申请书
		  if (sReturn == "false"){ 
			PopPage("/FormatDoc/GroupManage/7502.jsp?DocID=7502&ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");	
		}*/
		PopPageAjax("/FormatDoc/GroupManage/7502.jsp?DocID=7502&ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");		
		//获得加密后的流水号
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sSerialNo);
		//通过　serverlet 打开页面
		if(navigator.appName=="Microsoft Internet Explorer"){
			var CurOpenStyle = "width=100,height=100,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			PopPage("/FormatDoc/POPreviewFile.jsp?TimeOut=1&EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer","_blank02",CurOpenStyle); 	
		}else{
			PopComp("POPreviewFile","/FormatDoc/POPreviewFile.jsp","TimeOut=1&EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer"); 	
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>