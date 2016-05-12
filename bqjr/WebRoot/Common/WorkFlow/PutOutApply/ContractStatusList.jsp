<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 修改合同状态
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "修改合同状态"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	
	//获得页面参数
	String sProductID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productID"));	
    if(sProductID==null) sProductID="";
    
    ASResultSet rs = null;
    ASResultSet rs1 = null;
    ASResultSet rs2 = null;
    String roleID="";
    String storeID="";
    String doWhere="";
    String flag="false";
    String vetoFlag="false";
    String sStatus1="false";
    String sStatus2="false";
    String sStatus3="false"; //控制修改合同状态（区域运营）
    boolean managerStatus=false;
    
    String BusinessDate = SystemConfig.getBusinessDate();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	String userID=CurUser.getUserID();
	StringBuffer sb=new StringBuffer();
	StringBuffer snos=new StringBuffer();//门店 拼接 
	if(CurUser.hasRole("1005")){//如果登陆人员为销售经理 
		managerStatus=true;
		rs1=Sqlca.getASResultSet(new SqlObject("select sno from store_info where salesmanager=:salesmanager").setParameter("salesmanager", userID));
		while(rs1.next()){
	    		snos.append("'"+rs1.getString("sno")+"',");
	    	}
	  	    if(snos.toString().equals("")){
    	   doWhere=" and 1=2 ";
        }else{
 	       doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")" ;
        }
	    rs1.getStatement().close();
        doWhere +=  "  and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
	}else if(CurUser.hasRole("1006")){
		//如果登录人为销售代表 
	    sb.append("'"+userID+"'");
	    doWhere=" and inputuserid in ("+sb.toString()+")"+ " and  (bc.isbaimingdan <> '1' or bc.isbaimingdan is null)";
	}
	
	/* ---1.修改 *为修改合同状态（区域运营）添加"修改合同状态"按钮*  by xiaoqing.fang  20151117--- */
	if(CurUser.hasRole("1111")||CurUser.hasRole("1112")||CurUser.hasRole("1113")){
		flag="true"; //如果有修改合同状态角色 显示按钮 
	}
	if(CurUser.hasRole("1112")){ //修改合同状态（运营）
		sStatus2="true";
	}else if(CurUser.hasRole("1111")){ //修改合同状态（销售）
		sStatus1="true"; 
	}else if(CurUser.hasRole("1113")){ //修改合同状态（区域运营）
		sStatus3="true";
	}
	/* ---end xiaoqing.fang--- */
	//如果有否决申请角色 (高级销售经理、销售经理等经理级的人) 显示按钮 add PRM-477销售经理可以否决审核中的申请 by huanghui 20150720
	if(CurUser.hasRole("1005")){
		vetoFlag="true";
	}
	 ASDataObject doTemp = null;
	 String sTempletNo = "ContractStatus";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//判断符合该条件是否数据比较多，影响查询条件
	boolean myflag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null &&doTemp.Filters.get(k).sFilterInputs[0][1].length()>0 && (("BC.SERIALNO").equals(doTemp.getFilter(k).sFilterColumnID)||("BC.CustomerName").equals(doTemp.getFilter(k).sFilterColumnID))){
			myflag = false;
			break;
		}
	}
	if(doTemp.haveReceivedFilterCriteria()&& myflag)
	{
		%>
		<script type="text/javascript">
			alert("合同编号,客户名称至少输入一项！");
		</script>
		<%
		doTemp.WhereClause+=" and 1=2 ";
	
	}
	
	 if(!doTemp.haveReceivedFilterCriteria()){
		 doTemp.WhereClause+=" and 1=2 "; 
	 }else{
		 for(int k=0;k<doTemp.Filters.size();k++){
			 	if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].indexOf("%")>=0){
			 		%>
					<script type="text/javascript">
						alert("条件不能包含%！");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2 "; 
					break;
			 	}
				if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].length()>0 && doTemp.Filters.get(k).sFilterInputs[0][1].length()<8 && (("BC.SERIALNO").equals(doTemp.getFilter(k).sFilterColumnID))){
					%>
					<script type="text/javascript">
						alert("合同编号必须大于等于8位！");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2 "; 
					break;
				}
				if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].indexOf("%")>=0 && (("BC.CustomerName").equals(doTemp.getFilter(k).sFilterColumnID))){
					%>
					<script type="text/javascript">
						alert("客户名不能以%开始！");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2 "; 
					break;
				}
			}
		 doTemp.WhereClause+=doWhere;
	 }
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
		{"false","","Button","修改合同状态","修改合同状态","editContract()",sResourcesPath},
		{"false","","Button","否决申请","否决申请","vetoApply()",sResourcesPath},
		{"true","","Button","修改地标状态","修改地标状态","editLandMark()",sResourcesPath},	
		{managerStatus? "true":"false","","Button","提交注册","提交注册","doSubmit()",sResourcesPath},	
		{"false","","Button","取消申请","取消申请","deleteRecord()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},

		};
	if(flag.equals("true")){
		sButtons[0][0]="true";
	}
	if(vetoFlag.equals("true")){
		sButtons[1][0]="true";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	var bReverseTrans = false;
	//---------------------定义按钮事件------------------------------------
	
		//Excel导出功能呢	
	function exportExcel(){
		amarExport("myiframe0");
	}

	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function editContract(){
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
		var sContractStatus =getItemValue(0,getRow(),"ContractStatus");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		if(sContractStatus!="已签署" && sContractStatus!="审批通过" && sContractStatus!="已注册" && sContractStatus!="超期未注册"){
			alert("不在修改范围内！");
			return;
		}
		if(sContractStatus=="已注册" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			alert("对不起！您没有修改权限！");
			return ;
		}
		/*---2.修改  *为“修改合同状态（区域运营）”添加只有将超期未注册改为已签署的权限* by xiaoqing.fang  20151117---  */ 
		if(sContractStatus=="已注册" && "<%=sStatus3%>"=="true"){
			alert("对不起！您没有修改权限！");
			return ;
		}
		if(sContractStatus=="已签署" && "<%=sStatus3%>"=="true"){
			alert("对不起！您没有修改权限！");
			return ;
		}
		if(sContractStatus=="审批通过" && "<%=sStatus3%>"=="true"){
			alert("对不起！您没有修改权限！");
			return ;
		}
		/* -- end -- */
		
		if(sContractStatus=="超期未注册" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			alert("对不起！您没有修改权限！");
			return;
		}
		//验证是否存在未完成的交易
		var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
		if(returnValue!="0"){
			alert(returnValue);
			reloadSelf();
			return;
		}
		var params ="serialNo="+sSerialNo+",userId=<%=CurUser.getUserID()%>";
		if(sContractStatus=="超期未注册"){
			if(confirm("合同将被调整为“已签署”状态，是否确认修改？")){
				/***********CCS-1041,系统跑批时不能登录系统 huzp 20151217**************************************/
				var sTaskFlag = RunMethod("公用方法","GetColValue","system_setup,taskflag,1=1");
				if(sTaskFlag=="1"){
					alert("系统正在跑批，暂时无法将合同调整为“已签署”状态!");
					return;
				}else{
				var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","statusChange",params);
				alert(result.split("@")[1]);
				if("true"==result.split("@")[0]){
					reloadSelf();
				}
			   }
				return;
			}else{
				return;
			}
		}
		
		if(sContractStatus=="已注册"){
			if(confirm("合同将被调整为“已撤销”状态，是否确认修改？")){
				var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","statusChange",params);
				alert(result.split("@")[1]);
				if("true"==result.split("@")[0]){
					reloadSelf();
				}
				return;
			}else{
				return;
			}
		}
		if(sContractStatus=="审批通过"){
			if(confirm("合同将被调整为“已撤销”状态，是否确认修改？")){
				var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","statusChange",params);
				alert(result.split("@")[1]);
				if("true"==result.split("@")[0]){
					reloadSelf();
				}
				return;
			}else{
				return;
			}
		}
		
		if(sContractStatus=="已签署"){
			if(confirm("合同将被调整为“审批通过”状态，是否确认修改？")){
				var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","statusChange",params);
				alert(result.split("@")[1]);
				if("true"==result.split("@")[0]){
					reloadSelf();
				}
				return;
			}else{
				return;
			}
		}
	}
	
	// 点击"否决申请"按钮进入否决阶段 PRM-477 销售经理可以否决审核中的申请 add by huanghui 20150722
	/*~[Describe=否决申请;InputParam=无;OutPutParam=无;]~*/
	function vetoApply(){
		//手动取得审核中1020的FT表的字段
		//获得合同流水号、申请类型、流程编号、阶段编号
		var sObjectNo = getItemValue(0, getRow(), "SerialNo");//合同流水号
		var sObjectType = RunMethod("公用方法", "GetColValue", "FLOW_OBJECT,ObjectType,ObjectNo='"+sObjectNo+"'");
		var sFlowNo = RunMethod("公用方法", "GetColValue", "FLOW_OBJECT,FlowNo,ObjectNo='"+sObjectNo+"'");
		var sFlowName = RunMethod("公用方法", "GetColValue", "FLOW_OBJECT,FlowName,ObjectNo='"+sObjectNo+"'");
		var sPhaseNo = RunMethod("公用方法", "GetColValue", "FLOW_OBJECT,PhaseNo,ObjectNo='"+sObjectNo+"'");
		var sApplyType = RunMethod("公用方法", "GetColValue", "FLOW_OBJECT,ApplyType,ObjectNo='"+sObjectNo+"'");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if (confirm("你确定要否决该笔申请吗？")) {
			var sContractStatus =getItemValue(0,getRow(),"ContractStatus");
			if(sContractStatus!="审核中"){
				var sTemp="只有审核中的申请才能否决！";
				alert(sTemp);
				return;
			}
			
			//获取当前业务的流程阶段编号  edit by pli2
			var sTaskNo = RunMethod("公用方法", "GetColValue", "FLOW_TASK,MAX(SerialNo), ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'");	
			
			//var OpenStyle = "width=100px,height=60px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
			//弹出选择取消意见界面
			var sReturn = popComp("VetoApplyInfo","/Common/WorkFlow/VetoApplyInfo.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&PhaseNo="+sPhaseNo+"&FlowNo="+sFlowNo+"&FlowName="+sFlowName+"&TaskNo="+sTaskNo+"&Type=1"+"&ApplyType="+sApplyType,"dialogWidth=600px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			window.returnValue = sReturn;
			window.close();
			reloadSelf();
		}
	}
	
	function editLandMark(){
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
	    var sEntInfoValue = setObjectValue("SelectLandMarkStatus","","",0,0,"");
	    sEntInfoValue = sEntInfoValue.split("@");
		if (typeof(sEntInfoValue)=="undefined" || sEntInfoValue.length==0){
			alert("请选择你一条地标状态");
			return;
		}
		//如果选择的地标状态为空时不能更改地标状态add by qizhong.chi
		if(!isNaN(sEntInfoValue[0]) && sEntInfoValue[0] != '_CLEAR_'){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,LandMarkStatus='"+sEntInfoValue[0]+"',serialNo='"+sSerialNo+"'");
			alert("修改成功！");
		}
		reloadSelf();
	}
	
	function deleteRecord(){
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");//获取删除记录的单元值
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			 reloadSelf();
		}
	}
	
	function checkCStatus(){
		var sTemp;
		
		var editName='<%=CurUser.getUserID()%>'; //修改人
		var editDate='<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>'; //修改时间
		var signedDate = '<%=BusinessDate%>'; //签署日期
		
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
		var sContractStatus =getItemValue(0,getRow(),"ContractStatus");
		
		if(sContractStatus!="已签署" && sContractStatus!="审批通过" && sContractStatus!="已注册" && sContractStatus!="超期未注册"){
			sTemp="不在修改范围内！";
			return sTemp;
		}
		
		if(sContractStatus=="已注册" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			sTemp="对不起！您没有修改权限！";
			return sTemp;
		}
		
		if(sContractStatus=="超期未注册" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			sTemp="对不起！您没有修改权限！";
			return sTemp;
		}
		
		//获取合同借据号、原交易信息
		var sLoanSerialNo = RunMethod("PublicMethod","GetColValue","SerialNo,ACCT_LOAN,String@PutOutNo@"+sSerialNo);
		
		//var sLoanSerialNo = RunMethod("GetElement","GetElementValue","SerialNo,ACCT_LOAN,PutOutNo='"+sSerialNo+"'");
		var sTransReturn = RunMethod("公用方法","GetColValue","ACCT_TRANSACTION,SerialNo,documentserialno='"+sSerialNo+"' and relativeobjectno='"+sLoanSerialNo.split("@")[1]+"' " );
		var sTransSerialNo = sTransReturn;
		
		if (typeof(sLoanSerialNo) !="undefined" && sLoanSerialNo.length >0 && sLoanSerialNo != "Null" && (sContractStatus=="审批通过" || sContractStatus=="已注册")){
			var relativeObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.loan%>";
			//校验是否存在未完成的交易
			var allowApplyFlag = RunMethod("LoanAccount","GetAllowApplyFlag","00,"+relativeObjectType+","+sLoanSerialNo.split("@")[1]);
			if(allowApplyFlag != "true"){
				return "该业务已经存在一笔未生效的交易记录，不允许同时申请！";
			}
			//执行冲放款交易
			if(confirm("合同将被调整为“已撤销”状态，是否确认修改？")){
				var daysFlag = RunMethod("LoanAccount","GetBusinessContractPutOutDays",sSerialNo);//大于15天不允许冲放款
				if(daysFlag=="true"){
						var returnValue = runTransaction(sLoanSerialNo.split("@")[1],sTransSerialNo);
						bReverseTrans = returnValue;
						if(!returnValue){
							return "合同状态修改失败！";
						}
					
				}else if(daysFlag=="false"){
					return "计息超过十五天不允许做撤销！";
				}
			}else{
				sTemp= "合同状态修改放弃!";
				return sTemp;
			}
			
		}
		
// 		1040	审批通过合同
// 		1045	附条件通过合同
// 		1050	审批拒绝合同
// 		1060	已取消合同
// 		1070	已签署合同
// 		1080	已注册合同
// 		1090	已撤销合同
// 		1100	超期未注册合同
// 		1110	已结清合同
// 		1120	退回补充资料申请
// 		1130	已归档申请

		var sObjectType = "BusinessContract";
		
		if(sContractStatus=="已签署"){
			if(confirm("合同将被调整为“审批通过”状态，是否确认修改？")){
				/*update CCS-859：PRM-446 修改数据非同一事物问题 start*/
				//审批通过
				RunMethod("PublicMethod","UpdateColValue","String@ContractStatus@080@String@editName@"+editName+"@String@editDate@"+editDate+",business_contract,String@serialNo@"+sSerialNo);
				//RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='080',serialNo='"+sSerialNo+"'");//审批通过
				/*update CCS-859：PRM-446 修改数据非同一事物问题 end*/
				
				//edit  by pli2 20141118   注 :由于在申请树图中采用了一种修改Flow_Object中PhaseType来展示上述不同列表的方式，
				//因此在修改合同状态的同时需要同步修改
				RunMethod("BusinessManage","UpdateApplyPhaseType",sSerialNo+","+sObjectType+","+"1040");//修改阶段类型
				sTemp="修改成功！";
				return sTemp;
			}else{
				sTemp= "合同状态修改撤销";
				return sTemp;
			}

		}
		if(sContractStatus=="审批通过"){
				//检查是否需要返回p2p额度   add by dahl 
				RunJavaMethodSqlca("com.amarsoft.proj.action.P2PCredit", "checkReturnP2pSum", "ContractSerialNo="+sSerialNo);
				//end by dahl
				/*update CCS-859：PRM-446 修改数据非同一事物问题 start*/
				//已撤销
				RunMethod("PublicMethod","UpdateColValue","String@ContractStatus@210@String@editName@"+editName+"@String@editDate@"+editDate+",business_contract,String@serialNo@"+sSerialNo);
				//RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='210',serialNo='"+sSerialNo+"'");//已撤销
				/*update CCS-859：PRM-446 修改数据非同一事物问题 end*/
				
				sTemp="修改成功！";
			return sTemp;
		}
		if(sContractStatus=="已注册" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			sTemp="对不起！您没有修改权限！";
			return sTemp;
			
		}else if(sContractStatus=="已注册"){	
			//现在审批通过后需要再进行一次判断。判断撤销时间是否超过注册时间十五日以上。否则不允许被撤销CCS-730 add huzp 20150513
			//获得合同注册时间并与当前撤销时间做处理。
			var Registrationdate =getItemValue(0,getRow(),"Registrationdate");
			var EditDate =getItemValue(0,getRow(),"EditDate");
			//根据注册时间与审批通过时的修改时间来进行判断，若超过十五日以上。不允许被撤销 add huzp 20150513
			if(EditDate==null||EditDate==""){
				var d2="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//获取系统当前日期
				EditDate=d2;
			 }
			if(GetDateDiff(Registrationdate,EditDate,'day')>15){
				sTemp="计息超过十五天不允许做撤销！";
			}else{
				/*update CCS-859：PRM-446 修改数据非同一事物问题 start*/
				//已撤销
				RunMethod("PublicMethod","UpdateColValue","String@ContractStatus@210@String@editName@"+editName+"@String@editDate@"+editDate+",business_contract,String@serialNo@"+sSerialNo);
				//RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='210',serialNo='"+sSerialNo+"'");//已撤销
				/*update CCS-859：PRM-446 修改数据非同一事物问题 end*/
				
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,biaoshi='<%=sStatus1%><%=sStatus2%>',serialNo='"+sSerialNo+"'");
				sTemp="修改成功！";
			}
				return sTemp;
		}
		if(sContractStatus=="超期未注册"){
			var sReturnValue = RunMethod("PublicMethod","CheckContractDays",sSerialNo+",10");//系统时间大于发放日加一个月-10天不允许做
			if(sReturnValue=="false"){
				return "该笔合同不可再做状态更改！";
			}
			//RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='020',serialNo='"+sSerialNo+"'");//已签署
			//修改合同状态为已签署时，把合同签署日期也置上去。
			if(confirm("合同将被调整为“已签署”状态，是否确认修改？")){
				/*update CCS-859：PRM-446 修改数据非同一事物问题 start*/
				RunMethod("PublicMethod","UpdateColValue","String@ContractStatus@020@String@editName@"+editName+"@String@editDate@"+editDate+"@String@signedDate@"+signedDate+"@String@shiftdocdescribe@"+editDate+",business_contract,String@serialNo@"+sSerialNo);
				/*update CCS-859：PRM-446 修改数据非同一事物问题 end*/
				
				sTemp="修改成功！";
				return sTemp;
			}else{
				sTemp= "合同状态修改撤销";
				return sTemp;
			}

		}
	
		return sTemp;
	}
	
	function runTransaction(sLoanSerialNo,sTransSerialNo){
		var objectType = "";
		var transactionCode = "4015";
		var relativeObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.transaction%>";
		
		var relativeObjectNo = sTransSerialNo;
		var transactionDate = "<%=SystemConfig.getBusinessDate()%>";

		//创建交易同时创建单据信息
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>,2");
		if(returnValue.substring(0,5) != "true@") {
			alert("创建交易失败！错误原因-"+returnValue);
			return;
		}
		//执行交易
		var transactionSerialNo = returnValue.split("@")[1];	
		var returnTransValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
		if(typeof(returnTransValue)=="undefined"||returnTransValue.length==0||returnTransValue.split("@")[0]=="false"){
			//如果交易执行失败则删除交易信息和单据信息
			var documentserialno = RunMethod("PublicMethod","GetColValue","documentserialno,ACCT_TRANSACTION,String@transcode@4015@String@SerialNo@"+returnValue.split("@")[1]);
			RunMethod("PublicMethod","DeleteAcctPaymentValue",documentserialno.split("@")[1]);//"acct_trans_payment,SerilNo,"
			RunMethod("PublicMethod","DeleteColValue",returnValue.split("@")[1]);//"ACCT_TRANSACTION,SerialNo,"
			alert("系统处理异常！");
			return false;
		}
		var message=returnValue.split("@")[1];	
		return true;		
	}
	
	
	function doSubmit(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var inputUserID=getItemValue(0,getRow(),"InputUser");
		var sContractStatus=getItemValue(0,getRow(),"ContractStatus"); 
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var userType=RunMethod("GetElement","GetElementValue","userType,user_info,userID='"+inputUserID+"' and isCar='02'");
		if(userType=="01"){
			alert("此合同是内部员工合同，不允许提交！");
			return;
		}
		if(sContractStatus!="审批通过"){
			alert("该合同不是审批通过合同,不允许提交!");
			return;
		}
	
		if(confirm("您真的确定提交注册吗？")){
			/***********CCS-1041,系统跑批时不能登录系统 huzp 20151217**************************************/
			var sTaskFlag = RunMethod("公用方法","GetColValue","system_setup,taskflag,1=1");
			if(sTaskFlag=="1"){
				alert("系统正在跑批，暂时无法提交注册!");
				return;
			}else{
			var params ="serialNo="+sSerialNo+",userId=<%=CurUser.getUserID()%>";
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","approvedToRegister",params);
			alert(result.split("@")[1]);
			if("true"==result.split("@")[0]){
				reloadSelf();
			}
			}
			return;
		}
	}
	//获得2个时间天数之差CCS-730 add huzp 20150424
	 function GetDateDiff(startTime, endTime, diffType) {   
		 //将xxxx-xx-xx的时间格式，转换为 xxxx/xx/xx的格式          
		 startTime = startTime.replace(/\-/g, "/");          
		 endTime = endTime.replace(/\-/g, "/");             
		 //将计算间隔类性字符转换为小写           
		 diffType = diffType.toLowerCase();           
		 var sTime = new Date(startTime);      //开始时间           
		 var eTime = new Date(endTime);  //结束时间           
		 //作为除数的数字           
		 var divNum = 1;           
		 switch (diffType) {                
			 case "second":                   
			 	divNum = 1000;                   
			 break;                
			 case "minute":                   
				 divNum = 1000 * 60;                 
				 break;              
			 case "hour":                
					 divNum = 1000 * 3600;             
				 break;              
			 case "day":                
					divNum = 1000 * 3600 * 24;      
				 break;            
					default:                  
					break;         
			 }          
		 return parseInt((eTime.getTime() - sTime.getTime()) / parseInt(divNum));    
		 } 
	
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

