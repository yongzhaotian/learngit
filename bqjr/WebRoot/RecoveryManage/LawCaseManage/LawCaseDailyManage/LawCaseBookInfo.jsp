<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 台帐信息
		Input Param:
			        SerialNo:台帐编号
			        ObjectNo:案件编号或对象类型
			        ObjectType：对象类型
			        BookType ：台帐类型
		Output param:
		               
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "台帐信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String smyAppDate = "";
	String sAcceptedCourt = "";
	String sAcceptedDate = "";
	String sAcceptedNo = "";
	String sLawsuitStatus = "";
	
	String sJudgementNo = "";
	String sAppDate = "";
	String sCurrency = "";
	
	String sApplySum = "";
	String sApplyPrincipal = "";
	String sApplyInInterest = "";
	String sApplyOutInterest = "";
	
	String sApplyOtherSum = "";
	String sAcceptedCourt1 = "";
	
	String sLawCaseOrg = "";
	String sClaim = "";
	String sApplyDate = "";
	
	//获得页面参数
	//台帐编号、台帐类型
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sBookType == null) sBookType = "";
	
	//案件编号或对象编号、对象类型、案件类型
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sLawCaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LawCaseType"));
	String sDate = StringFunction.getToday();
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sLawCaseType == null) sLawCaseType = "";
	
	//获得立案台帐、诉讼保全台帐、一审台帐的相关信息，以作为下次台帐的默认值
	sSql =  " select AppDate,AcceptedCourt,AcceptedDate,AcceptedNo "+
	        " from LAWCASE_BOOK "+
	        " where ObjectNo =:ObjectNo "+ 
	        " and ObjectType =:ObjectType "+ 
	        " and (BookType='026' "+
	        " or BookType='030' "+
	        " or BookType='040' "+
	        " or BookType='050' "+
	        " or BookType='060') "+
	        " and AppDate = (select max(AppDate) "+
	        " from LAWCASE_BOOK "+
	        " where ObjectNo =:ObjectNo "+
	        " and ObjectType =:ObjectType "+
	        " and (BookType='026' "+
	        " or BookType='030' "+
	        " or BookType='040' "+
	        " or BookType='050' "+
	        " or BookType='060')) ";
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType)
	.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
   	rs = Sqlca.getASResultSet(so);   	
   	if(rs.next()){
		//受理法院、受理日期、受理案号
		sAcceptedCourt = DataConvert.toString(rs.getString("AcceptedCourt"));
		sAcceptedDate = DataConvert.toString(rs.getString("AcceptedDate"));
		sAcceptedNo = DataConvert.toString(rs.getString("AcceptedNo"));
		smyAppDate = DataConvert.toString(rs.getString("AppDate"));
	}
	//将空值转化为空字符串
	if(sAcceptedCourt == null) sAcceptedCourt = "";
	if(sAcceptedDate == null) sAcceptedDate = "";
	if(sAcceptedNo == null) sAcceptedNo = "";
	if(smyAppDate == null) smyAppDate = "";
	
 	rs.getStatement().close();
	 	 
	//获得执行台帐的相关信息，以作为下次执行台帐的默认值
	sSql =  " select JudgementNo,AppDate,Currency,ApplySum,ApplyPrincipal,ApplyInInterest,"+
			" ApplyOutInterest,ApplyOtherSum,AcceptedCourt "+
	        " from LAWCASE_BOOK "+
	        " where ObjectNo =:ObjectNo "+ 
	        " and ObjectType =:ObjectType "+ 
	        " and BookType='070' "+
	        " and AppDate=(select max(AppDate) from LAWCASE_BOOK "+
	        " where  ObjectNo =:ObjectNo "+
	        " and ObjectType =:ObjectType "+
	        " and BookType='070')";
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType)
	.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
   	rs = Sqlca.getASResultSet(so);    	
   	if(rs.next()){
		//生效判决书、申请执行日期、币种
		sJudgementNo = DataConvert.toString(rs.getString("JudgementNo"));
		sAppDate = DataConvert.toString(rs.getString("AppDate"));
		sCurrency = DataConvert.toString(rs.getString("Currency"));		
		//申请执行总标的(元)、其中：本金(元)、表内利息(元)、表外利息(元)
		sApplySum = DataConvert.toString(rs.getString("ApplySum"));
		sApplyPrincipal = DataConvert.toString(rs.getString("ApplyPrincipal"));
		sApplyInInterest = DataConvert.toString(rs.getString("ApplyInInterest"));
		sApplyOutInterest = DataConvert.toString(rs.getString("ApplyOutInterest"));		
		//其他(元)、执行法院
		sApplyOtherSum = DataConvert.toString(rs.getString("ApplyOtherSum"));
		sAcceptedCourt1 = DataConvert.toString(rs.getString("AcceptedCourt"));
	}
	//将空值转化为空字符串
	if(sJudgementNo == null) sJudgementNo = "";
	if(sAppDate == null) sAppDate = "";
	if(sCurrency == null) sCurrency = "";
	if(sApplySum == null) sApplySum = "";
	if(sApplyPrincipal == null) sApplyPrincipal = "";
	if(sApplyInInterest == null) sApplyInInterest = "";
	if(sApplyOutInterest == null) sApplyOutInterest = "";
	if(sApplyOtherSum == null) sApplyOtherSum = "";
	if(sAcceptedCourt1 == null) sAcceptedCourt1 = "";
	 
	rs.getStatement().close();
	 
	//获得对应案件的诉讼地位，如果为原告、则我行败诉未付金额不用自动计算
	sSql =  " select LawsuitStatus from LAWCASE_INFO where SerialNo =:SerialNo ";
	//我行的诉讼地位
	sLawsuitStatus = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sLawsuitStatus == null) sLawsuitStatus = "";
   	
   	//从破产案件基本信息中获得破产台帐的相关信息，以作为破产台帐的默认值
	if(sBookType.equals("080")){
		sSql =  " select LawCaseOrg,Claim,ApplyDate from LAWCASE_INFO where SerialNo =:SerialNo ";
	    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo)); 		
	   	if(rs.next()){
			//破产人名称、破产申请人、宣告破产日
			sLawCaseOrg = DataConvert.toString(rs.getString("LawCaseOrg"));
			sClaim = DataConvert.toString(rs.getString("Claim"));
			sApplyDate = DataConvert.toString(rs.getString("ApplyDate"));
		}
		//将空值转化为空字符串
		if(sLawCaseOrg == null) sLawCaseOrg = "";
		if(sClaim == null) sClaim = "";
		if(sApplyDate == null) sApplyDate = ""; 
		rs.getStatement().close();
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sItemdescribe = "";
	String sItemdescribe1 = "";
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//根据不同的案件类型显示不同的生效判决书
	if (sLawCaseType.equals("01"))	//一般案件
		sItemdescribe1="10";
	if (sLawCaseType.equals("02"))	//公证仲裁案件
		sItemdescribe1="20";		
		
	//根据不同的booktype（台帐类型）显示不同的模板		
	if (sBookType.equals("010")){	//支付令台帐
		sTempletNo="PaymentInfo";
		sItemdescribe="10";
	}else if (sBookType.equals("020")){	//诉前保全台帐
		sTempletNo="DamageInfo";
		sItemdescribe="10";		//根据不同的台帐类型过滤受理结果
	}else if (sBookType.equals("026")){	//诉讼保全台帐
		sTempletNo="DamageInfo";
		sItemdescribe="10";		//根据不同的台帐类型过滤受理结果
	}else if (sBookType.equals("030")){	//立案台帐
		sTempletNo="BeforeLawsuitInfo";
		sItemdescribe="10";
	}else if (sBookType.equals("040")){	//一审台帐
		sTempletNo="FirstLawsuitInfo";
		sItemdescribe="20";
	}else if (sBookType.equals("050")){	//二审台帐
		sTempletNo="SecondLawsuitInfo";
		sItemdescribe="20";
	}else if (sBookType.equals("060")){	//再审台帐
		sTempletNo="LastLawsuitInfo";
		sItemdescribe="20";
	}else if (sBookType.equals("070")){	//执行台帐
		sTempletNo="EnforceLawsuitInfo";
		sItemdescribe="30";
	}else if (sBookType.equals("080")){	//破产台帐
		sTempletNo="BankruptcyInfo";
	}else if (sBookType.equals("065")){	//公证台帐
		sTempletNo="ArbitrateInfo";
	}else if (sBookType.equals("068")){	//仲裁台帐
		sTempletNo="NotarizationInfo";
		sItemdescribe="40";
	}
		
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写	
	
	//如果是一审/二审/再审/执行台帐，那么，自动计算判决金额，考虑币种
	//定义自动累计字段
	if ((sBookType.equals("040"))||(sBookType.equals("050"))||(sBookType.equals("060")))
		doTemp.appendHTMLStyle("ConfirmPI,ConfirmFee,LawyerFee,OtherFee"," onChange=\"javascript:parent.getConfirmSum()\" ");

	
	//自动计算我行败诉未付金额(元)
	if(!sLawsuitStatus.equals("01"))   //我行诉讼地位为原告
		doTemp.appendHTMLStyle("JudgeSum,JudgePaySum"," onChange=\"javascript:parent.getJudgeSum()\" ");
	
	if(sLawsuitStatus.equals("01"))   
		doTemp.setReadOnly("JudgeNoPaySum",false);//设置只读


	//根据不同的台帐类型过滤受理结果
	doTemp.setDDDWSql("CognizanceResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CognizanceResult' and Itemdescribe like '%"+sItemdescribe+"%' ");
	
	//根据不同的案件类型过滤生效判决书
	doTemp.setDDDWSql("JudgementNo","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'JudgementNo' and Itemdescribe like '"+sItemdescribe1+"%' ");
	
	if(!(sBookType.equals("068"))){
		//选择主承办法官
		doTemp.setUnit("WithdrawProposerName"," <input type=button class=inputDate  value=... name=button onClick=\"javascript:parent.getAgentName()\">");
		doTemp.appendHTMLStyle("WithdrawProposerName","  style={cursor:pointer;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getAgentName()\" ");
	}
	
	
	//*****The below altered by FSGong 2005-03-01
	//设置比率范围
	if (sBookType.equals("070"))	//执行台帐
		doTemp.setVisible("RefusedReason,Received",true);
	
	//定义后续事件中要保存的表
	String sTableName = "LAWCASE_INFO";
	
	//保存时后续事件（传入案件编号、台帐类型）
  	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateLawCaseInfo("+sObjectNo+","+sBookType+","+sDate+")");
	
	//更新保存时后续事件（传入案件编号、台帐类型）
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateLawCaseInfo("+sObjectNo+","+sBookType+","+sDate+")");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	//---------------------定义按钮事件------------------------------------
		
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{

		//获得台帐类型
		var sBookType = getItemValue(0,getRow(),"BookType");		
		if (sBookType == "020" || sBookType == "026" || sBookType == "030")	//诉前保全、立案台帐
		{
			//获得受理结果、不予受理的原因
			var sCognizanceResult = getItemValue(0,getRow(),"CognizanceResult");
			var sChangeRequestReason = getItemValue(0,getRow(),"ChangeSuitReason");
			
			//如果受理结果为不予受理，要求必须录入不予受理的原因
			if(sCognizanceResult == "1002" && (sChangeRequestReason == null || sChangeRequestReason.length == 0))
			{
				 alert("请输入不予受理的原因！");
				 return;
			}
		}
		
		if (sBookType == "070")	//执行台帐
		{
			//获得受理结果、申领债权凭证效期、申领债权凭证金额(元)
			var sCognizanceResult = getItemValue(0,getRow(),"CognizanceResult");
			var sJudgedDate = getItemValue(0,getRow(),"JudgedDate");
			var sJudgePaySum = getItemValue(0,getRow(),"JudgePaySum");
			
			//如果受理结果为申领债权凭证，要求必须录入申领债权凭证相关信息
			if(sCognizanceResult == "3007" && (sJudgedDate == null || sJudgedDate.length == 0 || sJudgePaySum == null || sJudgePaySum.length == 0))
			{
				 alert("请输入申领债权凭证金额和申领债权凭证效期信息！");
				 return;
			}
		}
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}
		
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseBookList.jsp","_self","");	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=日期校验;InputParam=date1,data2,rule;OutPutParam=无;]~*/
	function compareDate(date1,date2,rule){
		if(typeof(date1) != "undefined" && date1 != "" && typeof(date2) != "undefined" && date2 != "")
		{
			if(rule == "1"){
				if(date1 > date2) return true;
			}
			if(rule == "2"){
				if(date1 >= date2) return true;
			}
			if(rule == "3"){
				if(date1 < date2) return true;
			}
			if(rule == "4"){
				if(date1 <= date2) return true;
			}
		}
		return false;
	}

	
	//判决金额由四项合计获得：其中，判决本息可能是外币，需要转换为人民币合计。其他均为人民币。
     function getConfirmSum(){
		fConfirmPI = getItemValue(0,getRow(),"ConfirmPI"); //判决本息
		sConfirmPICurrency = getItemValue(0,getRow(),"PICurrency");  //本息币种
		fConfirmFee = getItemValue(0,getRow(),"ConfirmFee"); //受理费和保全费
		fLawyerFee = getItemValue(0,getRow(),"LawyerFee"); //律师代理费
		fOtherFee = getItemValue(0,getRow(),"OtherFee");  //其他费用
     		
		if(typeof(fConfirmPI) == "undefined" || fConfirmPI.length == 0) fConfirmPI = 0; 
		if(typeof(fConfirmFee) == "undefined" || fConfirmFee.length == 0) fConfirmFee = 0; 
		if(typeof(fLawyerFee) == "undefined" || fLawyerFee.length == 0) fLawyerFee = 0; 
		if(typeof(fOtherFee) == "undefined" || fOtherFee.length == 0) fOtherFee = 0; 

		//获取币种sConfirmPICurrency对人民币的汇率
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAGetRMBExchangeRateDialogAjax.jsp?ReclaimCurrency="+sConfirmPICurrency,"","re				sizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sReturn = getSplitArray(sReturn);
		sRatio = sReturn[0];

		fConfirmPIRMB = fConfirmPI/sRatio;  //转换为人民币
     		
 		fConfirmSum = fConfirmPIRMB+fConfirmFee+fLawyerFee+fOtherFee;
        setItemValue(0,getRow(),"JudgeSum",fConfirmSum);
    }
		
	/*~[Describe=选择代理机构名称;InputParam=无;OutPutParam=无;]~*/
	function getAgencyName(){
		sParaString = "AgencyType"+",01";
		setObjectValue("SelectAgency",sParaString,"@AcceptedCourt@1",0,0,"");	
	}
	
	/*~[Describe=选择主承办法官;InputParam=无;OutPutParam=无;]~*/
	function getAgentName(){
		sParaString = "AgentType"+",01";
		var sReturn = setObjectValue("SelectAgent",sParaString,"",0,0,"");
		if (!(sReturn == '_CANCEL_' || typeof(sReturn) == "undefined" || sReturn.length == 0 || sReturn == '_CLEAR_')){
			sReturn = sReturn.split("@");
			//法官名称
			var sAgentName = sReturn[2];
			setItemValue(0,0,"WithdrawProposerName",sAgentName);			
		}else if (sReturn=='_CLEAR_'){
			setItemValue(0,0,"WithdrawProposerName","");
		}else{
			return;
		}
	}
	
	/*~[Describe=选择代理人;InputParam=无;OutPutParam=无;]~*/
	function getCurrentAgent(){
		sParaString = "AgentType"+",02";
		var sReturn = setObjectValue("SelectAgent",sParaString,"",0,0,"");
		if (!(sReturn == '_CANCEL_' || typeof(sReturn) == "undefined" || sReturn.length == 0 || sReturn == '_CLEAR_')){
			sReturn = sReturn.split("@");		
			//代理人名称、代理人所属机构
			var sAgentName = sReturn[1];
			var sBelongAgency = sReturn[3];
			
			setItemValue(0,0,"CurrentAgent",sAgentName);
			setItemValue(0,0,"WithdrawName",sBelongAgency);
		}else if (sReturn=='_CLEAR_'){
			setItemValue(0,0,"CurrentAgent","");
			setItemValue(0,0,"WithdrawProposerName","");
		}else{
			return;
		}
	}
	
	/*~[Describe=执行新增操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段		
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;	
			
			//台帐类型
			setItemValue(0,0,"BookType","<%=sBookType%>");					
			//对象类型、对象编号
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
						
			var sBookType = "<%=sBookType%>";			
			if(sBookType == "026" || sBookType == "030" || sBookType == "040" || sBookType == "050" || sBookType == "060"){
				//受理法院、受理日期、受理案号、申请日期
				setItemValue(0,0,"AcceptedCourt","<%=sAcceptedCourt%>");
				setItemValue(0,0,"AcceptedDate","<%=sAcceptedDate%>");
				setItemValue(0,0,"AcceptedNo","<%=sAcceptedNo%>");
				setItemValue(0,0,"AppDate","<%=smyAppDate%>");				
			}
			
			if(sBookType == "070"){
				//生效判决书、申请执行日期、币种
				setItemValue(0,0,"JudgementNo","<%=sJudgementNo%>");
				setItemValue(0,0,"AppDate","<%=sAppDate%>");
				setItemValue(0,0,"Currency","<%=sCurrency%>");
				
				//申请执行总标的(元)、其中：本金(元)、表内利息(元)、表外利息(元)
				setItemValue(0,0,"ApplySum","<%=DataConvert.toMoney(sApplySum)%>");
				setItemValue(0,0,"ApplyPrincipal","<%=DataConvert.toMoney(sApplyPrincipal)%>");
				setItemValue(0,0,"ApplyInInterest","<%=DataConvert.toMoney(sApplyInInterest)%>");
				setItemValue(0,0,"ApplyOutInterest","<%=DataConvert.toMoney(sApplyOutInterest)%>");
				
				//其他(元)、执行法院
				setItemValue(0,0,"ApplyOtherSum","<%=DataConvert.toMoney(sApplyOtherSum)%>");
				setItemValue(0,0,"AcceptedCourt","<%=sAcceptedCourt1%>");
			}
			
			if(sBookType == "080"){
				//破产人名称、破产申请人、宣告破产日
				setItemValue(0,0,"BankruptcyOrgName","<%=sLawCaseOrg%>");
				setItemValue(0,0,"ApplyRequest","<%=sClaim%>");
				setItemValue(0,0,"AppDate","<%=sApplyDate%>");
			}
						
			//登记人、登记人名称、登记机构、登记机构名称
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//登记日期						
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "LAWCASE_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}	

	//自动计算我行败诉未付金额(元)
	function getJudgeSum(){ 
		sJudgeSum = getItemValue(0,getRow(),"JudgeSum");
		sJudgePaySum = getItemValue(0,getRow(),"JudgePaySum");
		
		if(typeof(sJudgeSum)=="undefined" || sJudgeSum.length==0) sJudgeSum=0; 
		if(typeof(sJudgePaySum)=="undefined" || sJudgePaySum.length==0) sJudgePaySum=0;
		
		sJudgeNoPaySum = sJudgeSum-sJudgePaySum;
		
		setItemValue(0,getRow(),"JudgeNoPaySum",sJudgeNoPaySum);
 	}
	
	//根据输入的其中：本金，表内利息，表外利息，其它算出申请标的总额	
	function getAimSum(){ 
       	sApplyPrincipal = getItemValue(0,getRow(),"ApplyPrincipal");
       	sApplyInInterest = getItemValue(0,getRow(),"ApplyInInterest");
       	sApplyOutInterest = getItemValue(0,getRow(),"ApplyOutInterest");
       	sApplyOtherSum = getItemValue(0,getRow(),"ApplyOtherSum");

       	sCurrency = getItemValue(0,getRow(),"Currency");
   
       	if(typeof(sApplyPrincipal)=="undefined" || sApplyPrincipal.length==0) sApplyPrincipal=0; 
       	if(typeof(sApplyInInterest)=="undefined" || sApplyInInterest.length==0) sApplyInInterest=0;
       	if(typeof(sApplyOutInterest)=="undefined" || sApplyOutInterest.length==0) sApplyOutInterest=0; 
       	if(typeof(sApplyOtherSum)=="undefined" || sApplyOtherSum.length==0) sApplyOtherSum=0; 
      
		//获取币种sCurrency对人民币的汇率
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAGetRMBExchangeRateDialogAjax.jsp?ReclaimCurrency="+sCurrency,"","re				sizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sReturn = getSplitArray(sReturn);
		sRatio=sReturn[0];
		sApplyOtherSum=sApplyOtherSum*sRatio;  //转换为外币

		//alert(sApplyPrincipal+"=="+sApplyInInterest+"=="+sApplyOutInterest+"=="+sApplyOtherSum);
       	//诉讼总标的=其中：本金+表内利息+表外利息+其它
       	sApplySum = sApplyPrincipal+sApplyInInterest+sApplyOutInterest+sApplyOtherSum;

		setItemValue(0,getRow(),"ApplySum",sApplySum);
 	}
 	
 	//根据输入的其中：本金，表内利息，表外利息，其它算出落实偿还总金额	
	function getActualSum(){ 
		sActualPrincipal = getItemValue(0,getRow(),"ActualPrincipal");
		sActualInInterest = getItemValue(0,getRow(),"ActualInInterest");
		sActualOutInterest = getItemValue(0,getRow(),"ActualOutInterest");
		sActualOtherSum = getItemValue(0,getRow(),"ActualOtherSum");
		
		sCurrency = getItemValue(0,getRow(),"Currency");
		
		if(typeof(sActualPrincipal)=="undefined" || sActualPrincipal.length==0) sActualPrincipal=0; 
		if(typeof(sActualInInterest)=="undefined" || sActualInInterest.length==0) sActualInInterest=0;
		if(typeof(sActualOutInterest)=="undefined" || sActualOutInterest.length==0) sActualOutInterest=0; 
		if(typeof(sActualOtherSum)=="undefined" || sActualOtherSum.length==0) sActualOtherSum=0; 
    
		//获取币种sCurrency对人民币的汇率
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAGetRMBExchangeRateDialogAjax.jsp?ReclaimCurrency="+sCurrency,"","re				sizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sReturn = getSplitArray(sReturn);
		sRatio=sReturn[0];
		sActualOtherSum=sActualOtherSum*sRatio;  //转换为外币

		//诉讼总标的=其中：本金+表内利息+表外利息+其它
		sActualSum = sActualPrincipal+sActualInInterest+sActualOutInterest+sActualOtherSum;
	
     	setItemValue(0,getRow(),"ActualSum",sActualSum);
 	}
	</script>
	
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

