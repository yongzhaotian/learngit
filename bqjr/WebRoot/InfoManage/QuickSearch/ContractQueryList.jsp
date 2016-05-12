<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>


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
	String PG_TITLE = "合同信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;合同信息快速查询&nbsp;&nbsp;";
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
	
	Map<String, String> roleClauseMap = new HashMap<String, String>();
	//门店表中城市经理不维护，从销售经理的上级取。 edit by Dahl 2015-3-20
	//roleClauseMap.put("1003", " stores in (SELECT SNO FROM STORE_INFO WHERE CITYMANAGER IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	roleClauseMap.put("1003", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid in (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	//roleClauseMap.put("1004", " stores in (select sno from store_info where citymanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1004", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1005", " stores in (select sno from store_info where salesmanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1006", " SALESEXECUTIVE='"+ CurUser.getUserID() +"' ");
	List roleList = CurUser.getRoleTable();
	String sRoleWhereClause = "";
	for (int i=0; i<roleList.size(); i++) {
		String sAndOr = "".equals(sRoleWhereClause)? " and ( ": " or ";
		if (roleClauseMap.containsKey(roleList.get(i))) {
			sRoleWhereClause += sAndOr + roleClauseMap.get(roleList.get(i));
		}
	}
	
	//设置申请时间为日历控件
	doTemp.setCheckFormat("InputTime", "3");
	//隐藏贷后资料上传状态
	doTemp.setVisible("uploadFlag", false);
		
	if (!"".equals(sRoleWhereClause)) {
		doTemp.WhereClause += sRoleWhereClause + ")";
	}
		
	//生成查询框
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0020", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0030", "CustomerName", "Operators=EqualsString,BeginsWith;");
	//CCS-1312:统计查询-合同快速查询：身份证号、手机号要改为只能用等于来查询
	//doTemp.setFilter(Sqlca, "0033", "CertID", "Operators=EqualsString,BeginsWith;");
	//doTemp.setFilter(Sqlca, "003310", "MobilePhone", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0033", "CertID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "003310", "MobilePhone", "Operators=EqualsString;");
	//End CCS-1312:统计查询-合同快速查询：身份证号、手机号要改为只能用等于来查询
	doTemp.setFilter(Sqlca, "003314", "InputTime", "Operators=BeginsWith;");
	doTemp.setFilter(Sqlca, "003315", "SignedDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "003320", "RegistrationDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0035", "SubProductType", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0040", "BusinessType", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0044", "ProductID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0045", "OperateModeName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0180", "ContractStatus", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "019001", "QualityGrade", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0200", "RetailID", "Operators=EqualsString,BeginsWith;");
// 	doTemp.setFilter(Sqlca, "0210", "Stores", "Operators=EqualsString,BeginsWith;");
// 	doTemp.setFilter(Sqlca, "0235", "Salesexecutive", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0241", "SalesManager", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0256", "StoreCityCode", "Operators=EqualsString;");
	//doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//判断符合该条件是否数据比较多，影响查询条件
	boolean flag = true;
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
		//输入的条件都不能含有%或_符号
		//if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){//commented by NQ, CCS-1312:统计查询-合同快速查询：身份证号、手机号要改为只能用等于来查询
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (doTemp.Filters.get(k).sFilterInputs[0][1].contains("%") || 
				doTemp.Filters.get(k).sFilterInputs[0][1].contains("_"))){//updated by NQ, CCS-1312:统计查询-合同快速查询：身份证号、手机号要改为只能用等于来查询
			%>
			<script type="text/javascript">
				alert("输入的条件不能含有\"%\"或者\"_\"符号!"); //updated by NQ, CCS-1312:统计查询-合同快速查询：身份证号、手机号要改为只能用等于来查询
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
	
	//CCS-857-程序中调用电子合同地址需保存到配置文件中使用
	String sAPPUrl4pdf = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String sAPPUrl4photo = CodeCache.getItem("PrintAppUrl","0011").getItemAttribute();
	String sAPPUrl4record = CodeCache.getItem("PrintAppUrl","0012").getItemAttribute();
	String sAPPUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0014").getItemAttribute();
	
	//借钱么代码被覆盖,现重新添加
	String sJQMUrl4pdf = CodeCache.getItem("PrintAppUrl","0013").getItemAttribute();
	String sFCUrl4pdf = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
	String sFCUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0016").getItemAttribute();

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
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","代扣账号变更","代扣账号变更","withholdChange()",sResourcesPath},
			{((CurUser.hasRole("1036") || CurUser.hasRole("1039")||CurUser.hasRole("1044") || CurUser.hasRole("1051")||CurUser.hasRole("1052") || CurUser.hasRole("1035"))?"true":"false"),"","Button","发起再次代扣","发起再次代扣","sponsorAgainWithhold()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","退款查询","查询退款查询信息","RefundFind()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","贷款结清证明申请","贷款结清证明申请","CreditSettle()",sResourcesPath},
			{"true","","Button","电子合同调阅","电子合同调阅","viewApplyReport()",sResourcesPath},
			{"true","","Button","第三方协议调阅","第三方协议调阅","creatThirdTable()",sResourcesPath},
			{"true","","Button","随心还服务申请书","随心还服务申请书","printSuiXinHuan()",sResourcesPath},
			{"true","","Button","打印佰保袋合同","打印佰保袋合同","printBaiBaoDai()",sResourcesPath},
			{"true","","Button","影像合同调阅","影像合同调阅","imageManage()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","提前还款查询","查询提前还款信息","SelectPrepayment()",sResourcesPath},
			{"true","","Button","退货申请","退货申请","returnApply()",sResourcesPath},
			{"true","","Button","退保申请","退保申请","cancellationInsurance()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","打印还款小贴士","打印还款小贴士","printRemind()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","打印批复函","打印批复函","printApprove()",sResourcesPath},
			{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},
			{(CurUser.getRoleTable().contains("1000")||CurUser.getRoleTable().contains("1038"))?"true":"false","","Button","电子合同","电子合同","createPDF()",sResourcesPath},
			{(CurUser.getRoleTable().contains("1000")||CurUser.getRoleTable().contains("1038"))?"true":"false","","Button","随心还电子合同","随心还电子合同","createSxhPDF()",sResourcesPath},
			{(CurUser.getRoleTable().contains("1000")||CurUser.getRoleTable().contains("1038"))?"true":"false","","Button","签名照片","签名照片","createPhoto()",sResourcesPath},
			{(CurUser.getRoleTable().contains("1000")||CurUser.getRoleTable().contains("1038"))?"true":"false","","Button","签名录音","签名录音","createAudio()",sResourcesPath},
			{"true","","Button","推荐奖励","推荐奖励","showWeChatResult()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	
	
	//  ==============================  打印格式化报告  公共方法  add by yzhang9    ============================================================
	
	//Excel导出功能呢	
	function exportExcel(){
		amarExport("myiframe0");
	}
	//end by pli2 20140417	
	
	function createPDF(){
        var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var ssuretype = RunMethod("公用方法", "GetColValue", "Business_Contract,SureType,SerialNo='"+sObjectNo+"'");
	    if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("该合同非电子合同!");
	        return;
	    }
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
		    window.open("<%=sAPPUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'JQM'){
		    window.open("<%=sJQMUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	window.open("<%=sFCUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }
	 }
		
	 function createSxhPDF(){
        var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
        var ssuretype = RunMethod("公用方法", "GetColValue", "Business_Contract,SureType,SerialNo='"+sObjectNo+"'");
	    if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("该合同非电子合同!");
	        return;
	    }
	    var bugpaypkgind = RunMethod("公用方法", "GetColValue", "business_contract,bugpaypkgind,serialno='"+sObjectNo+"'");
		if(typeof(bugpaypkgind)=="undefined" || bugpaypkgind.length==0 || bugpaypkgind == "0"){
	        alert("该合同没有购买随心还服务包!");
	        return;
		}
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
	    	window.open("<%=sAPPUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	window.open("<%=sFCUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }
	}
	 
	function createPhoto(){
   		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
	    var ssuretype = getItemValue(0,getRow(),"SureType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
	   	if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("该合同非电子合同!");
	        return;
	    }
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    window.open("<%=sAPPUrl4photo%>"+sObjectNo,"_blank",CurOpenStyle);
	}
	  
	function createAudio(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var ssuretype = getItemValue(0,getRow(),"SureType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("该合同非电子合同!");
	        return;
	    }
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    window.open("<%=sAPPUrl4record%>"+sObjectNo,"_blank",CurOpenStyle);
	}
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
			    if(sContractStatus == "060" || sContractStatus == "070"){   //新发生、审核中合同除了admin，其他人都不能打印合同
			    	//给管理员角色这个特权 
			    	if(!<%=CurUser.hasRole(new String[]{"000","099","1000"})%>){
			    		alert("只有管理员才能调阅该笔合同");
			    		return;
			    	}
		    }
			
			/* var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocID","serialNo="+sObjectNo+",type="+type);
			if (typeof(returnValue)=="undefined" || sObjectNo.returnValue==0){
				alert("请联系系统管理员检查合同模板配置");
				return;
			} */
			var sObjectType = type;
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}else{
				//检查出帐通知单是否已经生成
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if(sReturn == "move"){
					//alert("以前生成的文件已经被移动了，无法展示，也不可重新生成");
					return;
				}else if (sReturn == "false"){ //未生成出帐通知单
					var returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
					if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
						alert("请联系系统管理员检查合同模板配置和合同信息!");
						return;
					}
					var sDocID = 	returnValue.split("@")[0];
					var sUrl = returnValue.split("@")[1];
					var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
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
	
	/*~[Describe= 打印佰保袋服务;]~*/
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
	
	function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sContractStatus = getItemValue(0,getRow(),"ContractStatus");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if(sContractStatus!='160'){
			alert("该笔合同未结清！");
			return;
		} 
		sCompID = "CreditSettleApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/CreditSettleApplyInfo.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sObjectNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
	}
 
    //退款查询
    function RefundFind(){
    	//申请编号
    	sCustomerID =getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
    	var sReturn=RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
		if(sReturn<=0 || sReturn=="Null"){
			alert("该客户项下没预存款,不能退款");
			return;
		}		
		
		sCompID = "RefundApplyList";
		sCompURL = "/InfoManage/QuickSearch/RefundApplyList.jsp";
		popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

    }
    
    //代扣账号变更
    function withholdChange(){
    	//申请编号
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	//客户名称
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");//客户号
    	//身份证号
    	sCertID = getItemValue(0,getRow(),"CertID");
    	//手机号
    	sMobilePhone = getItemValue(0,getRow(),"MobilePhone");
    	//代扣账户户名
    	sReplaceName = getItemValue(0,getRow(),"ReplaceName");
    	//代扣账号
    	sReplaceAccount = getItemValue(0,getRow(),"ReplaceAccount");
    	//代扣账户开户行
    	sOpenBank = getItemValue(0,getRow(),"OpenBank");
    	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if (confirm("确认已经收到客户授权的更改或新增代扣账户授权书？"))
    	{			
			//add by huanghui ccs-789 withhold_charge_info表中只要count有记录，就可以反复变更。
		 	var count = RunMethod("BusinessManage","CheckChangeBusiness",sSerialNo);
			var sReturn;
			if(count == 0){
				//withhold_charge_info主键
				sReturn = RunMethod("BusinessManage","InsertChangeInfo4Dkzhbg",sSerialNo+","+sMobilePhone);
			}else{
				/* alert("当前客户合同已有在途的代扣账户变更审批，不能再次发起变更申请！");
				return; */
				sReturn = RunMethod("公用方法","GetColValue","withhold_charge_info,SerialNo,contractserialno='"+sSerialNo+"' and applicationtype = '01' and status = '01' " );//流水号
			}		 
			if( typeof(sReturn)!="undefined"&&sReturn != null){
				<%-- if(<%=CurUser.hasRole(new String[]{"000","099","1000","1036","1039"})%>){ --%>
					sCompID = "ChargeApplyInfo";
	                sCompURL = "/InfoManage/QuickSearch/ChargeApplyInfo.jsp";
	                sParamString = "SerialNo="+sReturn+"&ContractSerialNo="+sSerialNo;
					sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
				/* }else{
					alert("变更申请已发起，请到客户信息查询中进行代扣账户变更审批！");
				} */
			}
		} 
    }
    
    
    
    
    /*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        //验证合同产品是否已经在影响配置中配置
		var sBusinessType = RunMethod("公用方法", "GetColValue", "Business_Contract,BusinessType,SerialNo='"+sObjectNo+"'");
     	var sAmount = RunMethod("公用方法","GetColValueTables","product_ecm_type,product_type_ctype,count(1),product_ecm_type.PRODUCT_TYPE_ID = product_type_ctype.PRODUCT_TYPE_ID and product_type_ctype.PRODUCT_ID ='"+sBusinessType+"' ");
		if(sAmount == 0){
			alert("请先在商品影像配置中配置该产品对应的影像文件！");
			return false;
		}
   var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo+"&uploadPeriod=2";
   AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
    }
    
    /*~[Describe=提前还款查询;InputParam=无;OutPutParam=SerialNo;]~*/
	function SelectPrepayment()
	{
		//获取合同号，身份证号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCertID =getItemValue(0,getRow(),"CertID");	
		sCustomerID =getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			 var sReturn=RunMethod("BusinessManage","PrepaymentLoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同不能做提前还款");
				return;
			}
			
			 var sReturn=RunMethod("BusinessManage","PrepaymentLoanCount1",sCustomerID);
				if(sReturn>0){
					alert("该客户项下有逾期合同,不能做提前还款");
					return;
				}
			AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyList.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank","dialogWidth=200px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}

	}
    
	
	
	/*********************************退保申请************/
	function cancellationInsurance(){
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
				var status=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "selctMinanSerialNo","serialNo="+sSerialNo);
				//判断是否投保状态
				if(status =='F' ){
						alert("该合同不能做退保申请");
						return ;
				}
				//判断是否投保状态
				if(status =='F1' ){
						alert("该合同申请提前还款， 不能退保");
						return ;
				}
				//判断是否投保状态
				if(status =='F2' ){
						alert("申请退货中的合同，不能退保");
						return ;
				}			
				//判断是否投保状态
				if(status =='F3' ){
						alert("逾期超过90天并且系统已经汇总费用的合同，不能退保");
						return ;
				}	
				//判断是否投保状态
				if(status =='F4' ){
						alert("该合同已经结清，不能退保");
						return ;
				}
				//判断是否已经退保
				if(status =='F5' ){
						alert("该合同已经退保，不能再退保");
						return ;
				}
				//CCS-953 提前还款、退货、费用减免相互判断是否有交易进行中
				var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
				if(returnValue!="0"){
					alert(returnValue);
					return;
				}//CCS-953 end
			   var sCompID = "CancellationInsuranceInfo";
			    // 跳出一个页面  计算下月还款计划增值费
				var sCompURL = "/InfoManage/QuickSearch/CancellationInsurance.jsp";	 
				popComp(sCompID,sCompURL,"sSerialNo="+sSerialNo,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}
	}
	
	
	/*~[Describe= 退货流程;InputParam=无;OutPutParam=SerialNo;]~*/
	function returnApply()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			//是否消费贷
		   var sResult=RunMethod("BusinessManage","LoanProductType",sSerialNo);
			if(sResult==0){
				alert("该笔合同不是消费贷产品，不能做退货操作");
				return;
			} 
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("该笔合同不能做退货操作");
				return;
			}
			//是否在犹豫期内
			var sReturn=RunMethod("BusinessManage","HesitateDay",sSerialNo);
			if(sReturn==0){
				alert("该笔合同已超过犹豫期限,不能做退货操作");
				return;
			}  
			var sLoanSerialNo = RunMethod("PublicMethod","GetColValue","SerialNo,ACCT_LOAN,String@PutOutNo@"+sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			//CCS-953 提前还款、退货、费用减免相互判断是否有交易进行中
			var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
			if(returnValue!="0"){
				alert(returnValue);
				return;
			}//CCS-953 end
			
			sCompID = "BusinessRefundCargo";
			sCompURL = "/InfoManage/QuickSearch/BusinessRefundCargo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&BusinessSum="+sBusinessSum+"&";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}

	} 
	
	
	/*~[Describe= 发起再次代扣;InputParam=无;OutPutParam=SerialNo;]~*/
	function sponsorAgainWithhold()
	{
		//合同编号
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		var sparas = "sContractSerialNo="+sSerialNo;
		var sReturnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AgainWithholdCheck", "runTransaction",sparas);
		
		if(sReturnValue.split("@")[0]=="false"){
			alert(sReturnValue.split("@")[1]);
			return;
		}else{
			var payAmount = sReturnValue.split("@")[1];
			var sLoanSerialNo = sReturnValue.split("@")[2];
			var outsourcingCollection=sReturnValue.split("@")[3];
			
			sCompID = "SponsorAgainWithhold";
			sCompURL = "/InfoManage/QuickSearch/SponsorAgainWithhold.jsp";
    	 	sReturn = popComp(sCompID,sCompURL,"PayAmount="+payAmount+"&LoanSerialNo="+sLoanSerialNo+"&CustomerID="+sCustomerID+"&CustomerName="+sCustomerName+"&PutOutNo="+sSerialNo+"&OutsourcingCollection="+outsourcingCollection,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}
	}
	
	function ShowMessage1(str,showGb,clickHide){
		
		//可以通过对象检查来判断窗口是否已打开
		//采取替换或者取消的操作来避免重复打开
		//提示文字尽量别超过2行,因为背景iframe动态高度不知道怎么弄。
//		alert(1);
	 	if(document.getElementById("msgDiv"))
			return ;	 	

		var msgw=300;//信息提示窗口的宽度
		var msgh=125;//信息提示窗口的高度
		var scrollTop = document.body.scrollTop+document.body.clientHeight*0.4+"px";
		
		//**绘制背景层**/	
		var bgObj=document.createElement("div");
		bgObj.setAttribute('id','bgDiv');
		bgObj.className = "message_bg";

		//背景层动作 点击关闭
		if(clickHide)
			bgObj.onclick=hideMessage;
		if(showGb)
			document.body.appendChild(bgObj);
		
		//**绘制信息层**/
		var msgObj=document.createElement("div");
		msgObj.setAttribute("id","msgDiv");
		msgObj.setAttribute("align","center");
		msgObj.className = "message_div";
		
		msgObj.style.top= scrollTop; //"40%";
		msgObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
		msgObj.style.width = msgw + "px";
		msgObj.style.height =msgh + "px";
		
		document.body.appendChild(msgObj);
		
		//**绘制标题层**/ 点击关闭
		var title=document.createElement("h4");
		title.setAttribute("id","msgTitle");
		title.setAttribute("align","left");
		title.className = "message_title";
		
		title.innerHTML="系统处理中...";
		if(clickHide){
			title.innerHTML="关闭";
			title.style.cursor="pointer";			
			title.onclick = hideMessage;
		}	
		
		document.getElementById("msgDiv").appendChild(title);
		
		//**输出提示信息**/
		str = "<br>"+str.replace(/\n/g,"<br>");
		var txt=document.createElement("p");
		txt.style.margin="1em 0";
		txt.setAttribute("id","msgTxt");
		txt.innerHTML=str;
		document.getElementById("msgDiv").appendChild(txt);
	}	
	
	//微信奖励结果查询
    function showWeChatResult(){
    	//申请编号
    	sCustomerID =getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		sCompID = "WeChatResultList";
		sCompURL = "/InfoManage/QuickSearch/WeChatResultList.jsp";
		popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=1020px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

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


<%@ include file="/IncludeEnd.jsp"%>