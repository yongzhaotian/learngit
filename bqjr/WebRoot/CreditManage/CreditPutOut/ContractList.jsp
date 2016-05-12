<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 授信台账列表信息;
		Input Param:
			ContractType：
				010010表内未终结业务
				010020表外未终结业务
				020010表内终结业务
				020020表外终结业务	
				030010010表内未终结业务(已移交保全)
				030010020表外未终结业务(已移交保全)
				030020010表内终结业务(已移交保全)
				030020020表外终结业务(已移交保全)						
		Output Param:
			
		HistoryLog:
					2005.7.28 hxli  sql重写，界面改写
					2005.08.09 王业罡 修改担保管理按钮
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%

	//定义变量
	String sSql = "";
	//获得页面参数
	//获得组件参数
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//	010010表内未终结业务
	//	010020表外未终结业务
	//	020010表内终结业务
	//	020020表外终结业务
	//  030010010表内未终结业务(已移交保全)
	//  030010020表外未终结业务(已移交保全)
	//  030020010表内终结业务(已移交保全)
	//  030020020表外终结业务(已移交保全)
	
	String sTempletNo = "ContractList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	
	if(sContractType.equals("010010") || sContractType.equals("030010010")){
		if(sContractType.equals("010010"))
			doTemp.WhereClause += " and Balance >= 0 and OffSheetFlag in ('EntOn','IndOn') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
			/* sSql += " and Balance >= 0 and OffSheetFlag in ('EntOn','IndOn') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')"; */
		else
			doTemp.WhereClause += " and Balance >= 0 and OffSheetFlag in ('EntOn','IndOn') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID <> ' ' and RecoveryOrgID is not null)"+
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
	}
	else if(sContractType.equals("010020") || sContractType.equals("030010020")){
		if(sContractType.equals("010020"))
			doTemp.WhereClause += " and Balance >= 0 and OffSheetFlag in ('EntOff','IndOff') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
		else
			doTemp.WhereClause += " and Balance >= 0 and OffSheetFlag in ('EntOff','IndOff') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID <> ' ' and RecoveryOrgID is not null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
	}	
	else if(sContractType.equals("020010") || sContractType.equals("030020010")){
		if(sContractType.equals("020010"))
			doTemp.WhereClause += " and (FinishDate <> ' ' and FinishDate is not null) and OffSheetFlag in ('EntOn','IndOn') and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
		else
			doTemp.WhereClause += " and (FinishDate <> ' ' and FinishDate is not null) and OffSheetFlag in ('EntOn','IndOn') and (RecoveryOrgID <> ' ' and RecoveryOrgID is not null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
	}
	else if(sContractType.equals("020020") || sContractType.equals("030020020")){
		if(sContractType.equals("020020"))
			doTemp.WhereClause += " and (FinishDate <> ' ' and FinishDate is not null) and OffSheetFlag in ('EntOff','IndOff') and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
		else
			doTemp.WhereClause += " and (FinishDate <> ' ' and FinishDate is not null) and OffSheetFlag in ('EntOff','IndOff') and (RecoveryOrgID <> ' ' and RecoveryOrgID is not null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
	}
		
	//具有支行客户经理、分行客户经理、总行客户经理的用户只能查看自己管户的合同
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")){
		doTemp.WhereClause += " and ManageUserID = '"+CurUser.getUserID()+"'";
	}else{
		//不是客户经理不能查看
		doTemp.WhereClause += " and 1=2";
	}
	doTemp.OrderClause = " order by CustomerName";
	
	/* doTemp.setHeader(sHeaders); */
	if(sContractType.equals("010010") || sContractType.equals("020010"))
	{
		doTemp.setVisible("BailAccount,BailSum,ClearSum,PdgRatio",false);	
	}
	if(sContractType.equals("010020") || sContractType.equals("020020"))
	{
		doTemp.setVisible("OverdueBalance,FineBalance1,FineBalance2,OccurTypeName,BusinessRate",false);	
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页
	dwTemp.ShowSummary = "1";

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
	/* add by hwang 20090611 增加授信台帐中借还款记录手工维护功能,增加按钮“借还款记录”  */
	String sButtons[][] = {
			{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
			{"true","","Button","担保合同信息","担保合同管理","AssureManage()",sResourcesPath},			
			{"false","","Button","借还款记录","借还款记录管理","WasteBookManage()",sResourcesPath},		
			{"true","","Button","工作笔记","贷后工作笔记","WorkRecord()",sResourcesPath},
			{"true","","Button","移交保全","将不良资产移交保全部管理","ShiftRMDepart()",sResourcesPath},
			{"true","","Button","加入重点链接","加入重点链接","AddUserDefine()",sResourcesPath},
			{"true","","Button","催收函管理","催收函管理","my_DunManage()",sResourcesPath},
			{"true","","Button","合同终结","终结类型补登","my_Finish()",sResourcesPath},
			{"true","","Button","还款方式补登","还款方式补登","my_ReturnWay()",sResourcesPath},
			{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
		};
		
	if(sContractType.equals("010020"))//未终结表外业务
	{
		sButtons[getBtnIdxByName(sButtons,"还款方式补登")][0]="false";
	}
	
	if(sContractType.equals("020010") ||sContractType.equals("020020"))//已终结业务
	{
		sButtons[getBtnIdxByName(sButtons,"担保合同信息")][0]="false";
		/* add by hwang 20090611 增加授信台帐中借还款记录手工维护功能  */
		sButtons[getBtnIdxByName(sButtons,"借还款记录")][0]="false";		
		sButtons[getBtnIdxByName(sButtons,"移交保全")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"加入重点链接")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"催收函管理")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"工作笔记")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"合同终结")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"还款方式补登")][0]="false";
	}
	
	if(sContractType.indexOf("030") >= 0) //已移交保全
	{		
		sButtons[getBtnIdxByName(sButtons,"担保合同信息")][0]="false";
		/* add by hwang 20090611 增加授信台帐中借还款记录手工维护功能  */
		sButtons[getBtnIdxByName(sButtons,"借还款记录")][0]="false";	
		sButtons[getBtnIdxByName(sButtons,"移交保全")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"加入重点链接")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"催收函管理")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"工作笔记")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"合同终结")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"还款方式补登")][0]="false";		
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "AfterLoan";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sApproveType = getItemValue(0,getRow(),"ApproveType");
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApproveType="+sApproveType;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}

	/*~[Describe=担保合同管理;InputParam=无;OutPutParam=无;]~*/
	function AssureManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("AssureView","/CreditManage/CreditPutOut/AssureView.jsp","ComponentName=担保合同管理&ObjectType=AfterLoan&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/********** add by hwang 20090611 增加授信台帐中借还款记录手工维护功能***************/
	/*~[Describe=借还款记录管理;InputParam=无;OutPutParam=无;]~*/
	function WasteBookManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			//OpenPage("/CreditManage/CreditPutOut/AccountWasteBookList.jsp?AccountType=ALL&ObjectNo="+sSerialNo,"_self","");
			OpenComp("WasteBookManage","/CreditManage/CreditPutOut/AccountWasteBookList1.jsp","ComponentName=借还款记录&AccountType=ALL&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=贷后工作笔记;InputParam=无;OutPutParam=无;]~*/
	function WorkRecord()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","ComponentName=贷后工作笔记&NoteType=BusinessContract&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=清偿归档;InputParam=无;OutPutParam=无;]~*/
	function my_Finish()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{
			//获取合同余额、表内欠息、表外欠息
			sBalance = getItemValue(0,getRow(),"Balance");
			sInterestBalance1 = getItemValue(0,getRow(),"InterestBalance1");
			sInterestBalance2 = getItemValue(0,getRow(),"InterestBalance2");
			if((parseFloat(sBalance)+parseFloat(sInterestBalance1)+parseFloat(sInterestBalance2)) > 0)
			{
				alert(getBusinessMessage('649'));//该合同【余额＋表内欠息金额＋表外欠息金额>0】不能进行终结操作！
				return;
			}else
			{			
				//弹出对话选择框
				sReturn = PopPage("/RecoveryManage/NPAManage/NPADailyManage/NPAFinishedTypeDialog.jsp","","dialogWidth:22;dialogHeight:10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
				if(typeof(sReturn) != "undefined" && sReturn.length != 0)
				{
					ss = sReturn.split('@');
					sFinishedType = ss[0];
					sFinishedDate = ss[1];
					//终结操作
					sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishType@"+sFinishedType+"@String@FinishDate@"+sFinishedDate+",BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
					if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
						alert(getHtmlMessage('62'));//终结失败！
						return;			
					}else
					{
						reloadSelf();	
						alert(getHtmlMessage('43'));//终结成功！
					}	
				}
			}
		}
	}

	/*~[Describe=加入重点合同链接;InputParam=无;OutPutParam=无;]~*/
	function AddUserDefine()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getBusinessMessage('420'))) //要把这个合同信息加入重点合同链接中吗？
		{
			var sRvalue=PopPageAjax("/Common/ToolsB/AddUserDefineActionAjax.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
			alert(getBusinessMessage(sRvalue));
		}
	}
	
	/*~[Describe=催收函管理;InputParam=无;OutPutParam=无;]~*/
	function my_DunManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		sCurrency  = getItemValue(0,getRow(),"BusinessCurrency");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/DunManage/DunList.jsp?ObjectType=BusinessContract"+"&Currency="+sCurrency+"&ObjectNo="+sSerialNo+"&flag=page","_self");
		}
	}
	
	/*~[Describe=不良资产还款方式补登;InputParam=无;OutPutParam=无;]~*/
	function my_ReturnWay()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenComp("NPAReturnWayMain","/RecoveryManage/NPAManage/NPADailyManage/NPAReturnWayView.jsp","ComponentName=不良资产还款方式&ComponentType=MainWindow&DefaultTVItemName=待补登工作&SerialNo="+sSerialNo,"_blank",OpenStyle)
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//合同台帐信息
	function my_ManageView()
	{ 
		//合同流水号、合同编号、客户名称,币种
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sItemMenuNo = "<%=sContractType%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //请选择一条信息！
		}else
		{
			sObjectType = "NPABook";
			sObjectNo = sSerialNo;
			
			if(sItemMenuNo=="010050") 
				sViewID = "001";
			else
				sViewID = "002";

			openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
	
	/*~[Describe=移交保全部门;InputParam=无;OutPutParam=无;]~*/
	function ShiftRMDepart()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{       
			sReturnValue = RunMethod("BusinessManage","CheckContractShift",sSerialNo);
			if(parseInt(sReturnValue) == 0) 
			{
				var sTraceInfo = PopPage("/RecoveryManage/Public/NPAShiftDialog.jsp","","dialogWidth=25;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if(typeof(sTraceInfo)!="undefined" && sTraceInfo.length!=0)
				{
					var sTraceInfo = sTraceInfo.split("@");				
					//获得移交类型、保全机构
					var sShiftType = sTraceInfo[0];
					var sTraceOrgID = sTraceInfo[1];
					var sTraceOrgName = sTraceInfo[2];
					if(typeof(sTraceOrgID)!="undefined" && sTraceOrgID.length!=0)
					{
						var sReturn = PopPageAjax("/RecoveryManage/Public/NPAShiftActionAjax.jsp?SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"&TraceOrgID="+sTraceOrgID+"&Type=1","","");
						if(sReturn == "true") //刷新页面
						{
							alert("该不良资产成功移交到『"+sTraceOrgName+"』"); 
							self.location.reload();
						}
					}
				}
			}else
			{
				alert(getBusinessMessage("495")); //该业务已经移交给保全部，不能再次移交！
				return;
			}	
		}
	}

	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init_show();
	my_load_show(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>