<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 已选择用户列表
	 */
	String PG_TITLE = "已选择用户列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获得组件参数	
	String sUsersSelected =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UsersSelected",1));
	if(sUsersSelected==null) sUsersSelected="";

	String[][] sHeaders = {
		{"CustomerID","客户编号"},
		{"CustomerName","客户名称"},
		{"UserName","人员"},
		{"BelongAttribute","有效"},
		};
	String sSql = "select UserID,UserName "+
		"from USER_INFO "+
		"where  '"+sUsersSelected+"@' like '%@'||UserID||'@%'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.multiSelectionEnabled=true;
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("UserID,OrgID,BelongAttribute",false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确认分发","将该警示信息分发至选中的人员","confirmDistribution()",sResourcesPath},
		{"true","","Button","从列表中去除","从已选择用户列表中去除","removeUsers()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function removeUsers(){
		var sUsers = getUnselectedItemValueArray(0,"UserID");
		var sUserString="";
		for(i=0;i<sUsers.length;i++){
			//alert(sUsers[i]);
			sUserString += "@" + sUsers[i];
		}
		parent.saveParaToComp("UsersSelected="+sUserString,"reloadLeftAndRight()");
	}
	
	function confirmDistribution(){
		sRequirement = PopPage("/CreditManage/CreditAlarm/GetRequirementDialog.jsp","","dialogWidth:400px;dialogHeight:300px");
		if(typeof(sRequirement)=="undefined" || sRequirement=="" || sRequirement=="_CANCEL_") return;
		sReturn = PopPageAjax("/CreditManage/CreditAlarm/ConfirmAlertDistributeActionAjax.jsp?UserSelected=<%=sUsersSelected%>&Requirement="+sRequirement,"","dialogWidth:400px;dialogHeight:300px");
		if(typeof(sReturn)=="undefined"||sReturn=="failed") return;
		if(sReturn=="succeeded") self.close();
	}

	function getUnselectedItemValueArray(iDW,sColumnID){
		var b = getRowCount(iDW);
		var countSelected = 0;
		var sMemberIDTemp = "";
		var sSelected = new Array(1000);
		for(var iMSR = 0 ; iMSR < b ; iMSR++){
			var a = getItemValue(iDW,iMSR,"MultiSelectionFlag");
			if(a != "√"){
				sSelected[countSelected] = getItemValue(iDW,iMSR,sColumnID);
				countSelected++;
			}
		}
		var sReturn = new Array(countSelected);
		for(var iReturnMSR = 0;iReturnMSR < countSelected; iReturnMSR++){
			sReturn[iReturnMSR] = sSelected[iReturnMSR];
		}
		return sReturn;
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%@ include file="/IncludeEnd.jsp"%>