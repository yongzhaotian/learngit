<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//取集团客户编号、名称、母公司客户编号
	String sGroupID = CurPage.getParameter("GroupID");
	String sKeyMemberCustomerID = CurPage.getParameter("KeyMemberCustomerID");
	String sRightType=CurPage.getParameter("RightType");
	if(sGroupID == null) sGroupID = "";
	if(sKeyMemberCustomerID == null) sKeyMemberCustomerID = "";
	if(sRightType == null) sRightType = ""; 
	
	ASResultSet rsTemp = null;
	String sKeyMemberCustomerName = "";
	String sSql = "select CustomerName from CUSTOMER_INFO where CustomerID = :CustomerID";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sKeyMemberCustomerID));
	if (rsTemp.next()){
		sKeyMemberCustomerName  = DataConvert.toString(rsTemp.getString("CustomerName"));
		//将空值转化成空字符串
		if(sKeyMemberCustomerName == null) sKeyMemberCustomerName = "";
	 }
    rsTemp.getStatement().close();    
%>
<html>
<head>
    <script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.ui.js"></script>
    <link href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />
    <link href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/RelationSearch.css" rel="stylesheet" type="text/css" />
    <style>
    .main-header a{font-size:18px;font-weight: bold;text-decoration: none;}
    #searchArea{display:none;}
    </style>
</head>
<script type="text/javascript">
	function searchGroupRela(){
		var sFundRela = getRadioValue("fundRela");
		var sPersonRela = getRadioValue("personRela");
		var sOtherRela = getRadioValue("otherRela");
		var sAssureRela = getRadioValue("assureRela");
		//var sSearchlevel = getRadioValue("searchlevel");
		//var sPersonNode = getRadioValue("personNode");
		//var sLevel = document.getElementById("level").value;
		var sLowerLimit = document.getElementById("lowerLimit").value;
		/*if(sLevel.length != 0){
			patrn=/^[0-9]+$/;
			if(!patrn.exec(sLevel)){
				alert("搜索层次必须是数字！");
				document.getElementById("level").value = "";
				document.getElementById("level").focus();
				return;
			}
		}*/
		if(sLowerLimit.length != 0){
			if(sLowerLimit>100 || sLowerLimit<0){
				alert("比例下限必须是小于100的正值！");
				document.getElementById("lowerLimit").value = "";
				document.getElementById("lowerLimit").focus();
				return;
			}
		}
		if(sLowerLimit=="") sLowerLimit = "0";
		var sStarterID = document.getElementById("starterid").value;
		var sStarterName = document.getElementById("starterName").value;
		//$("#searchMassage").html("<i><font size=5>正在搜索...</font></i>");
		sArgs = "GroupID=<%=sGroupID%>&CustomerID="+sStarterID+"&CustomerName="+sStarterName
				+"&FundRela="+sFundRela+"&PersonRela="+sPersonRela+"&OtherRela="+sOtherRela+"&AssureRela="+sAssureRela
				+"&LowerLimit="+sLowerLimit+"&RightType=<%=sRightType%>";
		OpenComp("GroupRelationTree","/CustomerManage/GroupManage/GroupRelationTree.jsp",sArgs,"content");
	}
	
	function resume(){
		document.getElementById("allFundRela").checked="checked";
		document.getElementById("allPersonRela").checked="checked";
		//document.getElementById("PersonNodeNo").checked="checked";
		document.getElementById("allOtherRela").checked="checked";
		document.getElementById("allAssureRela").checked="checked";
		//document.getElementById("noLevel").checked="checked";
		document.getElementById("lowerLimit").value="";
		//document.getElementById("level").value="";
		//document.getElementById("level").style.display = "none";
		document.getElementById("starterid").value="<%=sKeyMemberCustomerID%>";
		document.getElementById("starterName").value="<%=sKeyMemberCustomerName%>";
	}

	function getRadioValue(radioName){
		var obj = document.getElementsByName(radioName);
		for(i=0; i<obj.length;i++){
			if(obj[i].checked){
				return obj[i].id;
			}
		}
	}

	/*function onsetLevel(){
		if(document.getElementById("noLevel").checked){
			document.getElementById("level").style.display = "none";
		}else if(document.getElementById("setLevel").checked){
			document.getElementById("level").style.display = "";
		}
	}*/

	//取当前集团客户的最新家谱
	function chooseGroupMember(sGroupID){
		try{
    		var sParaString = "GroupID"+","+sGroupID;
    		var o = AsDialog.OpenSelector("SelectKeyMember",sParaString,"@MemberCustomerID@0@MemberName@1",0,0,"");

			//var o = AsControl.SelectGridValue("SelectEntCustomer","","CustomerID@CustomerName");
			var oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				document.getElementById("starterid").value="";
				document.getElementById("starterName").value="";
				return;
			}
			document.getElementById("starterid").value = oArray[0];
			document.getElementById("starterName").value = oArray[1];
		}catch(e){
			return;
		}
	}
	
</script>
<body>
    <table cellspacing="0" cellpadding="0" class="main">
        <tr>
            <td class="main-header"><span><a href="#">＋</a>关联关系搜索</span></td>
        </tr>
        <tr id="searchArea">
            <td class="main-nav">
                <table cellspacing="0" cellpadding="0">
                    <tr>
                        <td>资金关联：</td>
                        <td colspan="2">
                            <input id="holder" type="radio" name="fundRela" value="52"><label for="holder">股东</label>
                            <input id="investor" type="radio" name="fundRela" value="02"><label for="investor">对外投资</label>
                            <input id="allFundRela" type="radio" name="fundRela" checked="checked"><label for="allFundRela">全部加入</label>
                            <input id="noFundRela" type="radio" name="fundRela"><label for="noFundRela">全部不加入</label>
                        </td>
                    </tr>
                    <tr>
                    	<td></td>
                        <td colspan="2">&nbsp;比例下限:<input id="lowerLimit" type="text"></td>
                    </tr>
                    <tr>
                        <td>人员关联：</td>
                        <td colspan="2">
                            <input id="keyMan" type="radio" name="personRela"><label for="keyMan">高管</label>
                            <input id="corpFamily" type="radio" name="personRela"><label for="corpFamily">法人代表家族成员</label>
                            <input id="allPersonRela" type="radio" name="personRela" checked="checked"><label for="allPersonRela">全部加入</label>
                            <input id="noPersonRela" type="radio" name="personRela"><label for="noPersonRela">全部不加入</label>
                        </td>
                    </tr>
                   <!-- <tr>
                    	<td></td>
                        <td colspan="2"><i><font size="2">&nbsp;人员是否作为节点显示:</font></i>
                        	<input id="PersonNodeYes" type="radio" name="personNode"><label for="PersonNodeYes">是</label>
                        	<input id="PersonNodeNo" type="radio" name="personNode" checked="checked"><label for="PersonNodeNo">否</label>
                        </td>
                    </tr> --> 
                    <tr>
                        <td>其他关联：</td>
                        <td colspan="2">
                            <input id="affiliated" type="radio" name="otherRela"><label for="affiliated">上下游关系</label>
                            <input id="otherRela" type="radio" name="otherRela"><label for="otherRela">其它</label>
                            <input id="allOtherRela" type="radio" name="otherRela" checked="checked"><label for="allOtherRela">全部加入</label>
                            <input id="noOtherRela" type="radio" name="otherRela"><label for="noOtherRela">全部不加入</label>
                        </td>
					</tr>
                    <tr>
                        <td>担保关联：</td>
                        <td colspan="2">
                            <input id="offerAssure" type="radio" name="assureRela"><label for="offerAssure">提供担保</label>
                            <input id="acceptAssure" type="radio" name="assureRela"><label for="acceptAssure">被担保</label>
                            <input id="allAssureRela" type="radio" name="assureRela" checked="checked"><label for="allAssureRela">全部加入</label>
                            <input id="noAssureRela" type="radio" name="assureRela"><label for="noAssureRela">全部不加入</label>
                        </td>                            
					</tr>
                    <!-- <tr>
                        <td>搜索层次：</td>
                        <td colspan="2">
                            <input id="noLevel" type="radio" name="searchlevel" checked="checked" onclick="javascript:onsetLevel();"><label for="noLevel">不设定</label>
                            <input id="setLevel" type="radio" name="searchlevel" onclick="javascript:onsetLevel();"><label for="setLevel">设定层次</label>
                            <input id="level" type="text" style="display:none">
                        </td>
					</tr> -->
           			<tr>
						<td>搜索起点：</td>
			           	<td colspan="2"><input id="starterid" type="hidden" value='<%=sKeyMemberCustomerID%>'>
			           		<input id='starterName' type='text' value='<%=sKeyMemberCustomerName%>' readonly style="width:200px;cursor:hand"> 
			           	    <input class="info_unit_button" value="..." type=button  onclick="javascript:chooseGroupMember(<%=sGroupID%>);">
			           	</td>
					</tr>
					<tr>
						<td><div id="searchMassage" style="color: red;"></div></td>
			           	<td>
			           		<input type="button" value="搜索" onclick="javascript:searchGroupRela();">
			           	</td>
			           	<td>			           	
			           		<input type="button" value="搜索条件恢复" onclick="javascript:resume();">
			           	</td>
					</tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="main-body">
                <div class="main-body-content"><iframe id="content" name="content" src="<%=sWebRootPath%>/AppMain/Blank.html"></iframe></div>
            </td>
        </tr>
        <tr>
            <td class="main-footer"><span>&nbsp;</span></td>
        </tr>
    </table>
</body>
</html>
<script language="javascript">
$(document).ready(function(){
	var anchor = $(".main-header span a");
	anchor.click(function(){
		if(anchor.text()=="＋"){
			$("#searchArea").show();
			anchor.text("－");
		}else if(anchor.text()=="－"){
            $("#searchArea").hide();
            anchor.text("＋");
        }
	});
	anchor.click();
});
</script>
<%@ include file="/IncludeEnd.jsp"%>