<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "电话催收任务列表界面";
 
	//获得页面参数
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));
	String sButtonM1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("buttonM1"));
	String sButtonM2 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("buttonM2"));
	String sButtonM3 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("buttonM3"));
	System.out.println(sButtonM1+","+sButtonM2+","+sButtonM3);
	if(sButtonM1==null) sButtonM1="";
	if(sButtonM2==null) sButtonM2="";
	if(sButtonM3==null) sButtonM3="";
	if(sPhaseType1==null) sPhaseType1="";
	

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ConsumeCollectionTelList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//分配多选
	if(sPhaseType1.equals("0011") && sButtonM1.equals("false")){
		doTemp.multiSelectionEnabled=true;
	}
	if(sPhaseType1.equals("0012") && sButtonM2.equals("false")){
		doTemp.multiSelectionEnabled=true;
	}
	if(sPhaseType1.equals("0013") && sButtonM3.equals("false")){
		doTemp.multiSelectionEnabled=true;
	}
	doTemp.setHTMLStyle("CUSTOMERID", "style={width:80px}");
	doTemp.setHTMLStyle("CustomerName","style={width:120px} ");  
	doTemp.setHTMLStyle("Sex","style={width:30px} ");  
	//根据角色进入页面显示的合同数量 
	if(sPhaseType1.equals("0011") && sButtonM1.equals("true")){
		doTemp.WhereClause+=" and INPUTUSERID='"+CurUser.getUserID()+"'";
	}
	if(sPhaseType1.equals("0012") && sButtonM2.equals("true")){
		doTemp.WhereClause+=" and INPUTUSERID='"+CurUser.getUserID()+"'";
	}
	if(sPhaseType1.equals("0013") && sButtonM3.equals("true")){
		doTemp.WhereClause+=" and INPUTUSERID='"+CurUser.getUserID()+"'";
	}

	// doTemp.generateFilters(Sqlca);
	
	doTemp.setFilter(Sqlca, "0020", "CUSTOMERID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0023", "CerdID", "Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	
	// 客户编号和身份证必须有一个有值作为查询条件，保证查询效率
	boolean flag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null){
			flag = false;
			break;
		}
	}
	if(!doTemp.haveReceivedFilterCriteria()) {
		doTemp.WhereClause += " and 1=2";
	} else if(flag) {
		%>
		<script type="text/javascript">
			alert("为了快速查询，客户编号、身份证至少输入一个！");
		</script>
		<%
		doTemp.WhereClause += " and 1=2";
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseType1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","查看合同","查看合同","OverDuelContractList()",sResourcesPath},
		{"true","","Button","行动代码录入","行动代码录入","viewAndEdit()",sResourcesPath},
		{"true","","Button","历史查询","历史查询","viewHistory()",sResourcesPath},
		{"true","","Button","分配任务","分配任务","toUser()",sResourcesPath},
		{"false","","Button","再次代扣","再次代扣","B()",sResourcesPath},
		{"false","","Button","费用减免","费用减免","q()",sResourcesPath},
		{"false","","Button","案件转移","案件转移","w()",sResourcesPath},
		{"false","","Button","逾期记录统计查询","逾期记录统计查询","a()",sResourcesPath},
		{"false","","Button","短信发送","短信发送","b()",sResourcesPath},
		{"false","","Button","电邮发送","电邮发送","c()",sResourcesPath},
	};
	
	if(sPhaseType1.equals("0011") && sButtonM1.equals("true")){
		sButtons[3][0]="false";
	}
	if(sPhaseType1.equals("0012") && sButtonM2.equals("true")){
		sButtons[3][0]="false";
	}
	if(sPhaseType1.equals("0013") && sButtonM3.equals("true")){
		sButtons[3][0]="false";
	}

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


	//行动代码录入
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");//催收流水号
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");//客户编号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		sCompID = "ConsumeCollectionRegistInfo";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeCollectionRegistInfo.jsp";
	    popComp(sCompID,sCompURL,"CollectionSerialNo="+sSerialNo+"&CustomerID="+sCustomerID+"&PhaseType1=<%=sPhaseType1%>","dialogWidth=400px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	
	//查看催收历史 
	function viewHistory(){
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ConsumeCollectionRegistList.jsp", "CustomerID="+sCustomerID+"&PhaseType1=<%=sPhaseType1%>&&buttonM1=<%=sButtonM1%>&&buttonM2=<%=sButtonM2%>&&buttonM3=<%=sButtonM3%>", "_self","");
		
	}
	
	function toUser(){
		sSerialNo=getItemValueArray(0, "SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条！");
			return;
		}
		var roleID="";
		if("<%=sPhaseType1%>"=="0011"){
			roleID="1510";
		}else if("<%=sPhaseType1%>"=="0012"){
			roleID="1511";
		}else{
			roleID="1512";
		}
		var sRetVal = setObjectValue("SelectConsumeUserID", "RoleID,"+roleID, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("请选择一个催收专员！");
			return;
		}
		sRetVal=sRetVal.split("@");
		for(var i=0;i<sSerialNo.length;i++){
			RunMethod("ModifyNumber","GetModifyNumber","CONSUME_COLLECTION_INFO,INPUTUSERID='"+sRetVal[0]+"',SERIALNO='"+sSerialNo[i]+"'");
		}
	    reloadSelf();
	}
	
	
	/*查看客户项下所有逾期合同*/
	function OverDuelContractList(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("该催收任务信息不完整，客户号为空！");
			return;
		}

		sCompID = "ConsumeOverDuelBCList";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeOverDuelBCList.jsp";
		sParamString = "CustomerID="+sCustomerID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		reloadSelf();
	}


	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
