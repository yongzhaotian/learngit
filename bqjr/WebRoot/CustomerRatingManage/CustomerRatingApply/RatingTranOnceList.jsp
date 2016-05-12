<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@ page import="com.amarsoft.are.jbo.BizObjectQuery"%>
<%@ page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@ page import="com.amarsoft.are.util.DataConvert"%>
<%@ page import="com.amarsoft.app.als.customer.evaluate.model.*"%>
<%@ page import="com.amarsoft.app.als.rating.action.*"%>
<%@ page import="com.amarsoft.app.als.rule.action.*"%>
<%@ page import="com.amarsoft.app.als.rule.data.*"%>
<%@ page import="com.amarsoft.app.als.rating.action.*"%>
<%@ page import="com.amarsoft.app.als.rule.util.*"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//获得组件参数
	String sRatingAppID = DataConvert.toRealString(iPostChange,(CurComp.getParameter("RatingAppID")));    
	if(sRatingAppID==null)sRatingAppID = "";
	String sViewFlag = DataConvert.toRealString(iPostChange,(CurComp.getParameter("ViewFlag")));
	if(sViewFlag==null)sViewFlag="";
	//定义变量
	String sCustomerName="",sCustomerID="",sCustomerType="";
	String sModelName="",sModelID="";
	String sRecord = "",sRecordID="";
	String ruleName = "",itemName = "",itemValue="";
	String sReportDate="",sReportScope="",sReportPeriod="",sAuditFlag="";
	
	List<RuleObject>  ruleObjects = null;
	List<RuleItem>   ruleItems = null;
	List<RuleAttribute> itemRuleAttributes = null;
	RuleObject ruleObject  = null;
	RuleItem ruleItem = null;
	RuleAttribute itemRuleAttribute = null;
	FinancialIndexCalculator rfic = null;
	FinancialIndexCalculator rfic1 = null;
	FinancialIndexCalculator rfic2 = null;
	
	String ruleObjectName = "";
	String ruleItemName = "";
	String ruleItemID = "",ruleItemIDs = "";
	String ruleItemValue = "";
	String ruleItemType = "";//用于判断Item获得值的形式
	String ruleItemStyle = "";
	
	GetRatingApplyInfo appInfo = new GetRatingApplyInfo();
	appInfo.setRatingAppID(sRatingAppID);
	if(appInfo.getApplyInfo()==true){
		sCustomerID = appInfo.getCustomerID();
		sCustomerName = appInfo.getCustomerName();
		sModelName = appInfo.getModelName();
		sRecordID = appInfo.getRecordID();
		sCustomerType = appInfo.getCustomerType();
		sReportDate = appInfo.getReportDate();
		sReportScope = appInfo.getReportScope();
		sReportPeriod = appInfo.getReportPeriod();
		sAuditFlag = appInfo.getAuditFlag();
		sModelID = appInfo.getModelID();
	}
	RuleOpAction roa = new RuleOpAction("rating_service");
	sRecord = roa.getHistoryRecord(sRecordID,"1");
	ruleObjects = roa.getObjectAllDetial(sModelID,"","1").getRuleObjects();
	rfic = new FinancialIndexCalculator(sCustomerID,sReportDate,sReportScope,sReportPeriod,sAuditFlag);

%>
<div style="overflow-y: scroll; height: 100%; width: 100%;">
<% if(!"1".equals(sViewFlag)){%>
<table>
	<tr>
		<td align="center"><input type="button" value="保存" onclick="saveRecord()" /></td>
		<td align="center"><input type="button" value=测算 onclick="doTransaction()" /></td>
	</tr>
</table>
<% }%>
<table border=0 width='100%'>
	<tr height=1>
		<td height="28" bgcolor=#d3ecf7><SPAN
			style="color: #4789fb; FONT-WEIGHT: Bold">基本信息</SPAN>
		<table id="imgexpand1" width="100%" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" class="dialog_table" cellspacing="0" cellpadding="0">
					<tr>
						<td bgcolor=#f6fbfe width="20%" height="30" align="left"
							valign="middle" nowrap="nowrap">流水号</td>
						<td bgcolor=#ffffff width="80%" align="left" valign="middle"
							nowrap="nowrap"><INPUT
							style="TEXT-ALIGN: left; WIDTH: 150px" id="a1"
							value="<%=sRatingAppID%>" disabled></td>
					</tr>
					<tr>
						<td bgcolor=#f6fbfe width="20%" height="30" align="left"
							valign="middle" nowrap="nowrap">客户名称</td>
						<td bgcolor=#ffffff width="80%" align="left" valign="middle"
							nowrap="nowrap"><INPUT
							style="TEXT-ALIGN: left; WIDTH: 150px" id="a2"
							value="<%=sCustomerName%>" disabled></td>
					</tr>
					<tr>
						<td bgcolor=#f6fbfe width="20%" height="30" align="left"
							valign="middle" nowrap="nowrap">评级模型</td>
						<td bgcolor=#ffffff width="80%" align="left" valign="middle"
							nowrap="nowrap"><INPUT
							style="TEXT-ALIGN: left; WIDTH: 150px" id="a3"
							value="<%=sModelName%>" disabled></td>
					</tr>
					<tr>
						<td bgcolor=#f6fbfe width="20%" height="30" align="left"
							valign="middle" nowrap="nowrap">客户编号</td>
						<td bgcolor=#ffffff width="80%" align="left" valign="middle"
							nowrap="nowrap"><INPUT
							style="TEXT-ALIGN: left; WIDTH: 150px" id="a4"
							value="<%=sCustomerID%>" disabled></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<%
	for(int i = 0;i < ruleObjects.size();i++){ 
		ruleObject = ruleObjects.get(i);
		ruleObjectName = ruleObject.getObjectName();
		ruleItems = ruleObject.getItems();
	%>
	<tr height=1>
		<td height="28" bgcolor=#d3ecf7><SPAN style="color: #4789fb; FONT-WEIGHT: Bold"><%=ruleObjectName %></SPAN>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<%
			for(int j = 0 ;j < ruleItems.size();j++){
				ruleItem = ruleItems.get(j);
				ruleItemName = ruleItem.getItemName();
				ruleItemID = ruleItem.getItemID();
				ruleItemType = ruleItem.getItemType();
				itemRuleAttributes = ruleItem.getRuleAttributes();
				ruleItemValue = StringFunction.getProfileString(sRecord,ruleItemID);
				ruleItemStyle=ruleItem.getItemStyle();
				ruleItemIDs +=ruleItemID+",";
		%>
			<tr>
				<td>
				<table width="100%"  class="dialog_table" border="0" cellspacing="0" cellpadding="0">
					<%
				if("Select".equals(ruleItemType)){
				%>
					<tr>
						<td bgcolor=#f6fbfe width="20%" height="30" align="left" valign="middle" nowrap="nowrap"><%=ruleItemName%></td>
						<td bgcolor=#ffffff width="80%" align="left" valign="middle" nowrap="nowrap">
						<select ID="<%=ruleItemID%>" SIZE="1">
							<option value="">---------请选择----------</option>
							<%
							for(int k = 0;k < itemRuleAttributes.size();k++){
								if(!"".equals(ruleItemValue)&& (k+1)==Integer.valueOf(ruleItemValue)){ %>
							<option value="<%=k+1%>" Selected><%=itemRuleAttributes.get(k).getAttributeName()%></option>
							<%}else{ %>
							<option value="<%=k+1%>"><%=itemRuleAttributes.get(k).getAttributeName()%></option>
							<%}
							}%>
						</select>
						</td>
					</tr>
					<%
			  }else if("Insert".equals(ruleItemType)){
				  String align = "";
			  		if(ruleItemValue==null)ruleItemValue = "";//判断是不是货币 ，是货币则控制格式为三位一斗
			  		if("M".equals(ruleItemStyle)){
			  			align="right";
			  			ruleItemValue = DataConvert.toMoney(ruleItemValue);
			  		}
			  		else align = "left";
			  %>
					<tr>
						<td bgcolor=#f6fbfe width="20%" height="30" align="left"valign="middle" nowrap="nowrap"><%=ruleItemName%></td>
						<td bgcolor=#ffffff width="80%" align="left" valign="middle"nowrap="nowrap">
						<INPUT style="TEXT-ALIGN:<%=align%>; WIDTH: 150px" id="<%=ruleItemID%>" value="<%=ruleItemValue%>"  <%if("M".equals(ruleItemStyle))%> onblur="changeStyle('<%=ruleItemID%>')" onkeyup="value=value.replace(/[^0-9\.,]/g,'')" />
						</td>
					</tr>
			<% }else if("Import".equals(ruleItemType)){

				Double d = rfic.getItemValue(ruleItem.getItemRelation());
				if("M".equals(ruleItemStyle))
					ruleItemValue =  DataConvert.toMoney(d);
				else
					ruleItemValue =(d+"").substring(0,4);//对年份的处理
		    %>
					<tr>
						<td bgcolor=#f6fbfe width="20%" height="30" align="left" valign="middle" nowrap="nowrap"><%=ruleItemName%></td>
						<td bgcolor=#ffffff width="80%" align="left" valign="middle"nowrap="nowrap">
						<INPUT style="TEXT-ALIGN: left; WIDTH: 150px" id="<%=ruleItemID%>"value="<%=ruleItemValue%>" disabled="disabled" />
						</td>
					</tr>
				<%}%>
				</table>
				</td>
			</tr>
			<%
			}
	     %>
		</table>
		</td>
	</tr>
<%} %>

</table>
</div>
<script type="text/javascript">
	//保存测算指标
	function saveRecord(tranFlag) {
		var sRuleItemIDs = "<%=ruleItemIDs%>";
		var sRuleItemValues = "";
		var sRecordID = "<%=sRecordID%>";
		//验证是否输入完成
		if (!checkValid()) {
			return false;
		}
		sRuleItemIDs = sRuleItemIDs.substr(0, sRuleItemIDs.length - 1);
		sRuleItemIDs = sRuleItemIDs.split(",");
		//拼装指标
		for ( var i = 0; i < sRuleItemIDs.length; i++) {
			sRuleItemValues += sRuleItemIDs[i] + ":"+toNumber(document.getElementById(sRuleItemIDs[i]).value) + "@";
		}
		sRuleItemValues = sRuleItemValues.substr(0, sRuleItemValues.length - 1);
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.rule.action.SaveModelRecord","saveRecord", "RecordID=" + sRecordID + ",BomTextIn="+ sRuleItemValues + ",DoTranStage=1");
		if (sReturn == "SUCCESS") {
			if(tranFlag != true){
			alert("保存成功！");
			}
			return true;
		}
		if (typeof (sReturn) == "undefined"||sReturn.length == 0||sReturn == "FAILURE") {
			alert("保存失败！");
			return false;
		}
	}

	//验证指标是否都有值。
	function checkValid() {
<%
		for(int i = 0; i < ruleObjects.size();i++){
			ruleItems = ruleObjects.get(i).getItems();
			for(int j=0 ;j<ruleItems.size();j++){
				ruleItemName = ruleItems.get(j).getItemName();
				ruleItemID = ruleItems.get(j).getItemID();
%>
				if (typeof (document.getElementById("<%=ruleItemID%>").value) == "undefined"|| document.getElementById("<%=ruleItemID%>").value == "") {
				alert("<%=ruleItemName%>" + "不能为空！");
					return false;
				}
<% 			}
		}
%>
	return true;
	}

	//点击测算
	function doTransaction() {
		var saveFlag = saveRecord(true);
		if(saveFlag == false)return;
		var sRatingAppID = "<%=sRatingAppID%>";
		var sRecordID = "<%=sRecordID%>";
		var sModelID = "<%=sModelID%>";
		var sRuleType = "RuleFlow";
		var sTestFlag = "0";
		var sCustomerType = "<%=sCustomerType%>";
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.rule.action.RatingAction", "rating","SerialNo=" + sRatingAppID + ",RecordID=" + sRecordID+ ",ModelID=" + sModelID + ",RuleType=" + sRuleType+ ",CustomerType=" + sCustomerType + ",TestFlag="+ sTestFlag + ",DoTranStage=1");
		sReturn = sReturn.split("@");
		if (sReturn[0] == "success"){
			alert("<%=sCustomerName%>" + "客户本次系统测算信用评估得分为：" + sReturn[1]+ ",评级结果为：" + sReturn[2]);
			RunJavaMethodTrans("com.amarsoft.app.als.rating.action.UpdateOnceResult","updateResult","RatingAppID="+sRatingAppID);
		}
		else
			alert("评级测算失败！");
		self.returnValue = sReturn[0];
	  top.close();
	}
	///*
	//验证是否可以进行测算。
	//function checkIsTran(){
	//	sReturn = RunJavaMethod("com.amarsoft.app.als.rule.action.CheckAllowedTran","checkAllowedTran","RatingAppID=<%=sRatingAppID%>");
		//if(sReturn != "Yes"){
			///alert("本次测算需要至少连续两期年报，请录入财报后再进行测算！");
			//top.close();
		//}
	//}
	//*/
	function changeStyle( id ){
		var sValue = document.getElementById(id).value;
		sValue = toNumber(sValue);
		sValue = amarMoney(sValue,2);
		document.getElementById(id).value=sValue;
	}

	function toNumber(str){
	if(str)
		str = str.replace(/\,/g,"");
	if(isNaN(str))
		return 0;
	else
		return parseFloat(str);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>