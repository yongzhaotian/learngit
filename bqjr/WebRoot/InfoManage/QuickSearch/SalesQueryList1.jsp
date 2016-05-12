<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 销售数据查询
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "销售数据查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;销售数据查询&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String doWhere="";
    ASResultSet rs = null;
    ASResultSet rs1 = null;
    ASResultSet rs2 = null;
    String roleID="";
	//获得组件参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String userID=CurUser.getUserID();
	//String userID="200548";
	StringBuffer sb=new StringBuffer();
	StringBuffer snos=new StringBuffer();//门店 拼接 
	rs=Sqlca.getASResultSet(new SqlObject("select roleid from user_role where userid=:userid order by roleid").setParameter("userid", userID));
	while(rs.next()){
		roleID=rs.getString("roleid");
		//如果登陆人员为城市经理
		if("1004".equals(roleID)){
			//门店表中城市经理不维护，从销售经理的上级取。 edit by Dahl 2015-3-20
	 	    //doWhere =" and exists (select sno from store_info si where citymanager='"+userID+"' and si.sno=bc.stores)";
	 	    doWhere =" and exists (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+userID+"' and si.sno=bc.stores)  and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
	//		rs2=Sqlca.getASResultSet(new SqlObject("select sno from store_info where citymanager=:citymanager").setParameter("citymanager", userID));
	//		while(rs2.next()){
	//			snos.append("'"+rs2.getString("sno")+"',");
	//		}
	//		if(snos.toString().equals("")){
    //	        doWhere=" and 1=2 ";
	//       }else{
	//	      doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
	//       }
	//		rs2.getStatement().close();
		    break;
		}
		
		//如果登陆人员为销售经理 
		if("1005".equals(roleID)){
			doWhere =" and exists (select sno from store_info si where salesmanager='"+userID+"' and si.sno=bc.stores)    and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
//			rs1=Sqlca.getASResultSet(new SqlObject("select sno from store_info where salesmanager=:salesmanager").setParameter("salesmanager", userID));
//			while(rs1.next()){
//		    		snos.append("'"+rs1.getString("sno")+"',");
//		    	}
//		  	    if(snos.toString().equals("")){
//	    	        doWhere=" and 1=2 ";
//		        }else{
//		 	       doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
//		        }
//			    	rs1.getStatement().close();
		         break;
		}
	
		//如果登录人为销售代表 
	    if("1006".equals(roleID)){
	    	sb.append("'"+userID+"'");
	    	doWhere=" and inputuserid in ("+sb.toString()+")" + "   and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
	    	break;
	    }
		
	}
	rs.getStatement().close();

     
	//利用sSql生成数据对象

	String sTempletNo = "SalesQueryList"; //模版编号
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//设置申请日期格式
    doTemp.setCheckFormat("InputDate", "3");
	doTemp.setVisible("CityName", false);
	//doTemp.setKeyFilter("SerialNo");
	//生成查询框
	//doTemp.generateFilters(Sqlca);
	//增加门店代码、销售代表ID、合同编码、客户编码、客户名称、身份证号码查询条件，by huanghui 20151014
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0021", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0020", "CustomerName", "Operators=EqualsString;");// 紧急版本  CCS-1314_CCS-1312 V2_20160316   改为只能用"等于"  doTemp.setFilter(Sqlca, "0020", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0022", "CertID", "Operators=EqualsString;");// 紧急版本 CCS-1314_CCS-1312 V2_20160316  改为只能用"等于" doTemp.setFilter(Sqlca, "0022", "CertID", "Operators=EqualsString,BeginsWith;");
	
	doTemp.setFilter(Sqlca, "0030", "InputDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0146", "SalesManager", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0141", "Salesexecutive", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0110", "Stores", "Operators=EqualsString;");// 紧急版本  CCS-1314_CCS-1312 V2_20160316  改为只能用"等于" doTemp.setFilter(Sqlca, "0110", "Stores", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0200", "CityName", "Operators=Contains,EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0243", "ContractStatus", "Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.WhereClause +=doWhere;
	//判断符合该条件是否数据比较多，影响查询条件
	boolean flag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (("0110").equals(doTemp.getFilter(k).sFilterID)||("0141").equals(doTemp.getFilter(k).sFilterID)||("0010").equals(doTemp.getFilter(k).sFilterID)||("0021").equals(doTemp.getFilter(k).sFilterID)||("0020").equals(doTemp.getFilter(k).sFilterID)||("0022").equals(doTemp.getFilter(k).sFilterID)||("0030").equals(doTemp.getFilter(k).sFilterID)||("0146").equals(doTemp.getFilter(k).sFilterID)||("0200").equals(doTemp.getFilter(k).sFilterID)) ){
			flag = false;
			break;
		}
	}
	if(doTemp.haveReceivedFilterCriteria()&& flag)
	{
		%>
		<script type="text/javascript">
			alert("为了快速查询，合同状态需要与其他条件联合使用！");
		</script>
		<%
		doTemp.WhereClause+=" and 1=2";
	}
	for(int k=0; k<doTemp.Filters.size(); k++){
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
			if((("0200").equals(doTemp.getFilter(k).sFilterID)) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
				%>
				<script type="text/javascript">
					alert("输入的字符长度必须要大于等于2位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}
		} else if(k==doTemp.Filters.size()-1){
			
			if(!doTemp.haveReceivedFilterCriteria()){
				 doTemp.WhereClause+=" and 1=2";
			}else{
				doTemp.WhereClause+=doWhere;
			}
			
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
			{(CurUser.hasRole("1005") || CurUser.hasRole("1004") || CurUser.hasRole("1008"))?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
	    sObjectType = "QueryBusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/InfoManage/QuickSearch/QueryObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
    		
		}

	}
	
	//Excel导出功能
	function exportExcel(){
		<%
			//导出Excel时只导出相应的字段CSS-776
			doTemp.setVisible("CustomerID,CertID,RepaymentNo,MobilePhone,SignedDate,RegistrationDate,RejectedDate,ProductID,BusinessType,BusinessTypeName,BusinessTypeName1,OperateModeName,SubProductType,SubProductTypeName,ProductName,TotalPrice,MonthRepayment,ReplaceAccount,RepaymentWay,CreditAttribute,CreditAttributeName,QualityGrade,QualityGradeName,QualityTagging,RetailID,OrgName,PutoutFlag,SalesManager,CityName,uploadFlag,dayrange,SureType,Totalsum,BusinessSum,Periods,RetailName,BrandType,Area,OperateMode,RetailType", false);
			doTemp.setVisible("SerialNo,CustomerName,InputTime,InputDate,Stores,sStoreName,SalesexecutiveName,Salesexecutive,SaleManagerName,StoreCityName,ContractStatusName",true);
			dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
			dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
			dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
			dwTemp.setPageSize(16);  //服务器分页
			dwTemp.genHTMLDataWindow("");
		%>
		
		amarExport("myiframe0");
	}
	
	/* function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sExchangeType = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//检查出帐通知单是否已经生成
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //未生成出帐通知单
			//生成出帐通知单	
			PopPage("/FormatDoc/Report13/7001.jsp?DocID=7001&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//获得加密后的出帐流水号
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		
		//通过　serverlet 打开页面
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		
		
	} */

    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
	// 重写查询submit验证函数      -- 紧急版本   CCS-1314_CCS-1312  V2_20160316  ---------------- begin
	var default_checkDOFilterForm = checkDOFilterForm;
	checkDOFilterForm = function(v) {
		// 合同号0010/客户名称0020/客户编号0021/身份证号码0022/申请日期0030
		
		// 合同号:查询条件输入值
		var serialNoObj = document.getElementById("0010_1_INPUT");
		var serialNoVal = "";
		if (serialNoObj) {
			serialNoObj.value = $.trim(serialNoObj.value);
			serialNoVal = serialNoObj.value;
		}
		//客户名称:查询条件输入值
		var customerNameObj = document.getElementById("0020_1_INPUT");
		var customerNameVal = "";
		if (customerNameObj) {
			customerNameObj.value = $.trim(customerNameObj.value);
			customerNameVal = customerNameObj.value;
		}
		// 客户号:查询条件输入值
		var customerIdObj = document.getElementById("0021_1_INPUT");
		var customerIdVal = "";
		if (customerIdObj) {
			customerIdObj.value = $.trim(customerIdObj.value);
			customerIdVal = customerIdObj.value;
		}
		// 身份证号:查询条件输入值
		var certIDObj = document.getElementById("0022_1_INPUT");
		var certIDVal = "";
		if (certIDObj) {
			certIDObj.value = $.trim(certIDObj.value);
			certIDVal = certIDObj.value;
		}
		// 申请日期:查询条件输入值
		var inputdateObj = document.getElementById("0030_1_INPUT");
		var inputdateVal = "";
		if (inputdateObj) {
			inputdateObj.value = $.trim(inputdateObj.value);
			inputdateVal = inputdateObj.value;
		}

		// 合同号不允许输入下划线
		if (serialNoVal.indexOf("_") > -1) {
			alert("查询条件“合同号”不允许输入下划线！");
			return false;
		}
		// 合同号长度验证
		if (serialNoVal.length>0 && serialNoVal.length<8) {
			alert("输入的合同号长度必须要大于等于8位!");
			return false;
		}
		// 以下查询条件，必填其中一项: (合同号0010/客户名称0020/客户编号0021/身份证号码0022/申请日期0030)
		if (serialNoVal.length==0 && customerNameVal.length==0 && customerIdVal.length==0 && certIDVal.length==0 && inputdateVal.length==0) {
			alert("查询条件“合同号/客户名称/客户编号/身份证号码/申请日期”必须输入其中一项！");
			return false;
		}
		// 个性验证规则通过后，执行系统默认验证规则
		return default_checkDOFilterForm(v);
	}
	// 重写查询submit验证函数      -- 紧急版本   CCS-1314_CCS-1312  V2_20160316  ---------------- end
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
