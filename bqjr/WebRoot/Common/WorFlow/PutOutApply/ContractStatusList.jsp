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
    String roleID="";
    String storeID="";
    String doWhere="";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	String userID=CurUser.getUserID();
	StringBuffer sb=new StringBuffer();
	rs=Sqlca.getASResultSet(new SqlObject("select roleid from user_role where userid=:userid").setParameter("userid", userID));
	while(rs.next()){
		roleID=rs.getString("roleid");
		//如果登陆人员为销售经理 
		if("1005".equals(roleID)){
			storeID=Sqlca.getString(new SqlObject("select stores from business_contract where inputuserid=:inputuserid").setParameter("inputuserid", userID));
/*			rs1=Sqlca.getASResultSet(new SqlObject("select inputuserid from business_contract  where stores=:stores").setParameter("stores", storeID));
			while(rs1.next()){
				sb.append("'"+rs1.getString("inputuserid"));
				sb.append("',");
			}
			sb.append("'"+userID+"'");*/
			
//			rs1.getStatement().close();
//			doWhere=" and inputuserid in ("+sb.toString()+")";
            doWhere=" and stores='"+storeID+"'";
		}
	
		//如果登录人为销售代表 
	    if("1006".equals(roleID)){
	    	sb.append("'"+userID+"'");
	    	doWhere=" and inputuserid in ("+sb.toString()+")";
	    }
		
	}
	rs.getStatement().close();
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "ContractStatus";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 if(!doTemp.haveReceivedFilterCriteria()){
		 doTemp.WhereClause+=" and 1=2"; 
	 }else{
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
		{"true","","Button","修改合同状态","修改合同状态","editContract()",sResourcesPath},
		{"true","","Button","修改地标状态","修改地标状态","editLandMark()",sResourcesPath},	
		{"true","","Button","取消申请","取消申请","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function editContract(){
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		if(confirm("您真的确定修改合同状态吗？")){
			var sTemp=checkCStatus();
			alert(sTemp);
			reloadSelf();
		}
	}
	
	function editLandMark(){
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
	    var sEntInfoValue=setObjectValue("SelectLandMarkStatus","","",0,0,"");
	    sEntInfoValue=sEntInfoValue.split("@");
		if (typeof(sEntInfoValue)=="undefined" || sEntInfoValue.length==0){
			alert("请选择你一条地标状态");
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","business_contract,LandMarkStatus='"+sEntInfoValue[0]+"',serialNo='"+sSerialNo+"'");
		alert("修改成功！");
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
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
		var sContractStatus =getItemValue(0,getRow(),"ContractStatus");
		
		if(sContractStatus!="已签署" && sContractStatus!="审批通过" && sContractStatus!="已注册" && sContractStatus!="超期未注册"){
			sTemp="不在修改范围内！";
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
			var allowApplyFlag = RunMethod("LoanAccount","GetAllowApplyFlag","00,"+relativeObjectType+","+sLoanSerialNo);
			if(allowApplyFlag != "true"){
				return "该业务已经存在一笔未生效的交易记录，不允许同时申请！";
			}
			//执行冲放款交易
			var daysFlag = RunMethod("LoanAccount","GetBusinessContractPutOutDays","SerialNo,"+sSerialNo);//大于15天不允许冲放款
			if(daysFlag){
				var returnValue = runTransaction(sLoanSerialNo,sTransSerialNo);
				if(!returnValue){
					return "合同状态修改失败！";
				}
			}else{
				return "计息超过十五天不允许做撤销！";
			}
			
		}
			
		if(sContractStatus=="已签署"){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='080',serialNo='"+sSerialNo+"'");//审批通过
			sTemp="修改成功！";
			return sTemp;
		}
		if(sContractStatus=="审批通过"){
			//现在审批通过后需要再进行一次判断。判断撤销时间是否超过注册时间十五日以上。否则不允许被撤销CCS-730 add huzp 20150423
			//获得合同注册时间并与当前撤销时间做处理。
			var Registrationdate =getItemValue(0,getRow(),"Registrationdate");
			var EditDate =getItemValue(0,getRow(),"EditDate");
			//根据注册时间与审批通过时的修改时间来进行判断，若超过十五日以上。不允许被撤销CCS-730 add huzp 20150423
			if(EditDate==null||EditDate==""){
				var d2="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//获取系统当前日期
				EditDate=d2;
			 }
			if(GetDateDiff(Registrationdate,EditDate,'day')>15){
				sTemp="计息超过十五天不允许做撤销！";
			}else{
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='210',serialNo='"+sSerialNo+"'");//已撤销
				sTemp="修改成功！";
			}
			return sTemp;
		}
		if(sContractStatus=="已注册"){			
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='210',serialNo='"+sSerialNo+"'");//已撤销
			sTemp="修改成功！";
			return sTemp;
		}
		if(sContractStatus=="超期未注册"){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='020',serialNo='"+sSerialNo+"'");//已签署
			sTemp="修改成功！";
			return sTemp;
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
			return false;
		}
		//执行交易
		var transactionSerialNo = returnValue.split("@")[1];	
		var returnTransValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
		if(typeof(returnTransValue)=="undefined"||returnTransValue.length==0||returnTransValue.split("@")[0]=="false"){
			//如果交易执行失败则删除交易信息和单据信息
			RunMethod("PublicMethod","DeleteColValue",returnValue.split("@")[1]);//"ACCT_TRANSACTION,SerialNo,"
			var documentserialno = RunMethod("PublicMethod","GetColValue","documentserialno,ACCT_TRANSACTION,String@transcode@4015@String@SerialNo@"+returnValue.split("@")[1]+"@String@relativeobjectno@"+sLoanSerialNo);
			RunMethod("PublicMethod","DeleteAcctPaymentValue",documentserialno);//"acct_trans_payment,SerilNo,"
			alert("系统处理异常！");
			return false;
		}
		var message=returnValue.split("@")[1];	
		return true;		
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

