<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 合同信息快速查询
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "RPM合同信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;RPM合同信息快速查询&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	//获得组件参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//利用sSql生成数据对象

	String sTempletNo = "ContractQueryList1"; //模版编号
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setKeyFilter("BC.SerialNo");
	/**
	Map<String, String> roleClauseMap = new HashMap<String, String>();
	//门店表中城市经理不维护，从销售经理的上级取。 edit by Dahl 2015-3-20
	roleClauseMap.put("1003", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	//roleClauseMap.put("1004", " stores in (select sno from store_info where citymanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1004", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1005", " stores in (select sno from store_info where salesmanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1006", " SALESEXECUTIVE='"+ CurUser.getUserID() +"' ");
	List roleList = CurUser.getRoleTable();
	String sRoleWhereClause = "";
	boolean isBaimingdan = false;
	for (int i=0; i<roleList.size(); i++) {
		String sAndOr = "".equals(sRoleWhereClause)? " and ( ": " or ";
		if (roleClauseMap.containsKey(roleList.get(i))) {
			sRoleWhereClause += sAndOr + roleClauseMap.get(roleList.get(i));
		}
		if("1005".equals(roleList.get(i))||"1006".equals(roleList.get(i))){
			isBaimingdan = true;
		}
	}
	if(isBaimingdan){
		doTemp.WhereClause +=   " and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
	}
	**/
	//设置申请时间为日历控件
	doTemp.setCheckFormat("InputTime", "3");
	//设置提单时间为日历控件
	doTemp.setCheckFormat("SALESUBMITTIME", "3");
	//隐藏贷后资料上传状态
	doTemp.setVisible("uploadFlag", false);
	/**
	if (!"".equals(sRoleWhereClause)) {
		doTemp.WhereClause += sRoleWhereClause + ")";
	}
	**/
	doTemp.WhereClause +=  " and  bc.OperatorMode = '02'";
	
	//生成查询框
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0020", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0030", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0033", "CertID", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "003310", "MobilePhone", "Operators=EqualsString,BeginsWith;");
	//添加提单时间作为查询条件CCS-776
	doTemp.setFilter(Sqlca, "003313", "SALESUBMITTIME", "Operators=BeginsWith;");
	//doTemp.setFilter(Sqlca, "003314", "InputTime", "Operators=BetweenString,BeginsWith;");
	doTemp.setFilter(Sqlca, "003315", "SignedDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "003320", "RegistrationDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0035", "SubProductType", "Operators=EqualsString;");
	//doTemp.setFilter(Sqlca, "0040", "BusinessType", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0044", "ProductID", "Operators=EqualsString;");
	//doTemp.setFilter(Sqlca, "0045", "OperateModeName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0180", "ContractStatus", "Operators=EqualsString;");
	//doTemp.setFilter(Sqlca, "019001", "QualityGrade", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0200", "RetailID", "Operators=EqualsString,BeginsWith;");
 	//doTemp.setFilter(Sqlca, "0210", "Stores", "Operators=EqualsString,BeginsWith;");
 	//doTemp.setFilter(Sqlca, "0235", "Salesexecutive", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0241", "SalesManager", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0256", "StoreCityCode", "Operators=EqualsString;");
	//doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//判断符合该条件是否数据比较多，影响查询条件
		boolean flag = false;
		for(int k=0;k<doTemp.Filters.size();k++){
			if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (("0010").equals(doTemp.getFilter(k).sFilterID)||("0020").equals(doTemp.getFilter(k).sFilterID)||("0030").equals(doTemp.getFilter(k).sFilterID)||("0033").equals(doTemp.getFilter(k).sFilterID)||("003310").equals(doTemp.getFilter(k).sFilterID)) ){
				flag = false;
				break;
			}
		}
		if(doTemp.haveReceivedFilterCriteria()&& flag)
		{
			%>
			<script type="text/javascript">
				alert("为了快速查询，合同编号,客户编号,客户名称,身份证号码,手机号码至少输入一项！");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
		}	
	for(int k=0;k<doTemp.Filters.size();k++){
		//输入的条件都不能含有%符号
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){
			%>
			<script type="text/javascript">
				alert("输入的条件不能含有\"%\"符号!");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
			break;
		}
		
		
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null  && "BeginsWith".equals(doTemp.Filters.get(k).sOperator)){
			if(("0030").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
				%>
				<script type="text/javascript">
					alert("输入的字符长度必须要大于等于2位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			} else if(("0033").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("输入的身份证长度必须要大于等于8位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}else if(("0010").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("输入的合同号长度必须要大于等于8位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break; 
			}else if(("003310").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("输入的手机号长度必须要大于等于8位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}
			
		} else if(k==doTemp.Filters.size()-1){
		
			if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
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
	String sButtons[][] = {
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","打印电子合同","打印电子合同调阅","viewApplyReport()",sResourcesPath},
			{"true","","Button","打印第三方协议","打印第三方协议","creatThirdTable()",sResourcesPath},
			{"true","","Button","打印还款小贴士","打印还款小贴士","printRemind()",sResourcesPath},
			{"true","","Button","打印批复函","打印批复函","printApprove()",sResourcesPath},
			{"true","","Button","打印反欺诈提示","打印反欺诈提示","printRishTip()",sResourcesPath},
			{"true","","Button","随心还服务申请书","随心还服务申请书","printSuiXinHuan()",sResourcesPath},
			{"true","","Button","打印佰保袋合同","打印佰保袋合同","printBaiBaoDai()",sResourcesPath},
			{"true","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},

	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	
	//Excel导出功能呢	
	function exportExcel(){
		<%
			//导出Excel时只导出相应的字段CSS-776
			doTemp.setVisible("CustomerID,CertID,RepaymentNo,MobilePhone,SignedDate,RegistrationDate,RejectedDate,ProductID,BusinessType,BusinessTypeName,BusinessTypeName1,OperateModeName,SubProductType,SubProductTypeName,ProductName,TotalPrice,MonthRepayment,ReplaceAccount,RepaymentWay,CreditAttribute,CreditAttributeName,QualityGrade,QualityGradeName,QualityTagging,RetailID,OrgName,PutoutFlag,SalesManager,CityName,uploadFlag,dayrange,SureType", false);
			doTemp.setVisible("SerialNo,CustomerName,InputTime,InputDate,TotalSum,BusinessSum,Periods,Stores,sStoreName,SalesexecutiveName,Salesexecutive,SaleManagerName,StoreCityName,ContractStatusName",true);
			dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
			dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
			dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
			dwTemp.setPageSize(16);  //服务器分页
			dwTemp.genHTMLDataWindow("");
		%>
		
		amarExport("myiframe0");
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	
    /*~[Describe= 查看电子合同;]~*/
    function viewApplyReport(){
		    printTable("ApplySettle");
    }
    
	/*~[Describe=打印第三方协议;]~*/
	function creatThirdTable(){
			printTable("ThirdSettle");
	}
	
	/*~[Describe=打印审批意见书;]~*/
	function printApprove(){
			printTable("ApproveSettle");
	}
	
	/*~[Describe= 打印还款小贴士;]~*/
	function printRemind(){
			printTable("CreditSettle");
	}
	
	/*~[Describe= 打印佰保袋合同;]~*/
	function printBaiBaoDai(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sBusinessType2 = RunMethod("公用方法", "GetColValue", "business_contract,BusinessType2,serialno='"+sObjectNo+"'");
		if (typeof(sBusinessType2)=="undefined" || sBusinessType2.length==0 || sBusinessType2!="2015061500000017"){
			alert("该合同未购买佰保袋!");
			return; 
		}
		printTable("BaiBaoDai");
	}
	
	/*~[Describe=打印还风险函;InputParam=无;OutPutParam=无;]~*/
	function printRishTip(){

		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type=RishSettle");
		if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
			alert("请联系系统管理员检查合同模板配置和合同信息!");
			return;
		}
		var sDocID = returnValue.split("@")[0];
		var sUrl = returnValue.split("@")[1];
		//add by daihuafeng 20150708 ----begin 多传一个参数，控制当业务来源是APP时客户签名是URL签名
		sUrl = sUrl+"?ObjectNo="+sObjectNo;
		//add by daihuafeng 20150708 ----end
		
		OpenPage(sUrl,"_blank02",CurOpenStyle); 

	}
	
//  ==============================  打印格式化报告  公共方法  add by yzhang9    ============================================================
	
	/*~[Describe=打印格式化报告;InputParam=无;OutPutParam=无;]~*/
	function printTable(type){
			var sObjectNo = getItemValue(0,getRow(),"SerialNo");
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			//CCS-316 需要根据合同状态控制快速查询里的按钮     add by Roger 2015/03/09
			var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
			 
		    if(!(sContractStatus == "020" || sContractStatus == "050" || sContractStatus == "080")){ 
		    	alert("只有审批通过、已签署和已注册的合同才能调阅！");
	    		return;
		    }
			
			var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
				if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
					alert("请联系系统管理员检查合同模板配置和合同信息!");
					return;
				}
				var sDocID = returnValue.split("@")[0];
				var sUrl = returnValue.split("@")[1];
				var sObjectType = type;
			var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}else{
				//检查出帐通知单是否已经生成
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if (sReturn == "false"){ //未生成出帐通知单
					//生成出帐通知单	
						PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
					//记录生成动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
				}else{
					//记录查看动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
				}
				//获得加密后的出帐流水号
				var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
				//通过　serverlet 打开页面
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
				//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
				OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
	}
	
	/*~[Describe=打印随心还服务申请书;InputParam=无;OutPutParam=无;]~*/
	function printSuiXinHuan(){

		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
	    if(!(sContractStatus == "020" || sContractStatus == "050" || sContractStatus == "080")){ 
	    	alert("只有审批通过、已签署和已注册的合同才能调阅！");
    		return;
	    }
	    
	    var sBugPayPkgind = RunMethod("公用方法", "GetColValue", "business_contract,BugPayPkgind,serialno='"+sObjectNo+"'");
		if (typeof(sBugPayPkgind)=="undefined" || sBugPayPkgind.length==0 || (sBugPayPkgind!="1" && sBugPayPkgind!="2")){
			alert("该合同未购买随心还服务包!");
			return;
		}
		
		var sUrl = "/FormatDoc/Report17/ApplySuiXinHuan.jsp?ObjectNo="+sObjectNo;
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		OpenPage(sUrl,"_blank02",CurOpenStyle); 

	}
	//   ============================== end  打印格式化报告 ============================================================
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>