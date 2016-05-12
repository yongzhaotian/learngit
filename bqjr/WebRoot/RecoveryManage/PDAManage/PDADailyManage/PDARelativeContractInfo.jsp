<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong  2004.12.09
		Tester:
		Content: 抵债资产关联合同详细信息_info
		Input Param:
		Content: 抵债资产关联合同详细信息PDABasicInfo.jsp
		Input Param:
			        SerialNo:抵债资产流水号
			        ContractSerialNo：合同流水号						
		Output param:
		
		History Log: 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产关联合同详细信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";		
	String sCustomerName = "";//客户名称
	String sBusinessCurrency = "";//币种
	String sBusinessSum = "";//合同金额
	String sBalance = "";//合同余额
	String sBusinessType = "";//业务品种
	ASResultSet rs = null;
	
	//获得组件参数
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo"));			
	if(sSerialNo == null ) sSerialNo = "";
	if(sContractSerialNo == null ) sContractSerialNo = "";
	if(sAssetStatus == null ) sAssetStatus = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	
	//获得合同相关信息	
	sSql = 	" select CustomerName,BusinessSum,getBusinessName(BusinessType) as BusinessTypeName, "+
			" Balance,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName "+
			" from BUSINESS_CONTRACT "+
			" where SerialNo=:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sContractSerialNo));
	if (rs.next()){
		sBusinessType = rs.getString("BusinessTypeName");	
		sCustomerName = rs.getString("CustomerName");	
		sBusinessCurrency = rs.getString("BusinessCurrencyname");			
		sBusinessSum = rs.getString("BusinessSum");		
	  	sBalance=rs.getString("Balance");			
	  	if (sBusinessType == null)  sBusinessType = "";	
	  	if (sCustomerName == null)  sCustomerName = "";	
	  	if (sBusinessCurrency == null)  sBusinessCurrency = "";	
	  	if ((sBusinessSum == null) || (sBusinessSum.equals(""))) sBusinessSum="0.00";	
		if ((sBalance == null) || (sBalance.equals(""))) sBalance="0.00";
	}
	rs.getStatement().close(); 
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo ="PDAAssetContract";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+','+sContractSerialNo);
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
			{sAssetStatus.equals("04")?"false":"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回到调用页面","goBack()",sResourcesPath}
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
	function saveRecord()
	{
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0");		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function goBack()
	{
		top.close();
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			
			sSerialNo="<%=sSerialNo%>";
			sContractSerialNo="<%=sContractSerialNo%>";
			setItemValue(0,0,"ContractSerialNo",sContractSerialNo);
			setItemValue(0,0,"SerialNo",sSerialNo);
			//setItemValue(0,0,"ContractNo",sContractSerialNo);
			setItemValue(0,0,"IndebtSum","0.00");
			setItemValue(0,0,"Principal","0.00");
			setItemValue(0,0,"IndebtInterest","0.00");
			setItemValue(0,0,"OutdebtInterest","0.00");
			setItemValue(0,0,"OtherInterest","0.00");
			setItemValue(0,0,"UnDisposalSum","0.00");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");		
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		};
		setItemValue(0,0,"BusinessType","<%=sBusinessType%>");
		setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
		setItemValue(0,0,"BusinessCurrency","<%=sBusinessCurrency%>");
		setItemValue(0,0,"BusinessSum","<%=sBusinessSum%>");
		setItemValue(0,0,"Balance","<%=sBalance%>");
		
		var sColName = "AssetName"+"~";
		var sTableName = "ASSET_INFO"+"~";
		var sWhereClause = "String@SerialNo@"+<%=sSerialNo%>+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array1[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array1.length;j++)
			{
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(m = 0;m < sReturnInfo.length;m++)
				{
					my_array2[m] = sReturnInfo[m];
				}
				
				for(n = 0;n < my_array2.length;n++)
				{									
					//设置资产名称
					if(my_array2[n] == "assetname")
						setItemValue(0,getRow(),"AssetName",sReturnInfo[n+1]);					
				}
			}			
		}		
    }

	/*~[Describe=抵入合同金额由四项合计获得;InputParam=无;OutPutParam=无;]~*/
    function getSum()
    {
 		fPrincipal = getItemValue(0,getRow(),"Principal");
 		fIndebtInterest = getItemValue(0,getRow(),"IndebtInterest");
 		fOutdebtInterest = getItemValue(0,getRow(),"OutdebtInterest");
 		fOtherInterest = getItemValue(0,getRow(),"OtherInterest");
     		
 		if(typeof(fPrincipal)=="undefined" || fPrincipal.length==0) fPrincipal=0; 
 		if(typeof(fIndebtInterest)=="undefined" || fIndebtInterest.length==0) fIndebtInterest=0; 
 		if(typeof(fOutdebtInterest)=="undefined" || fOutdebtInterest.length==0) fOutdebtInterest=0; 
 		if(typeof(fOtherInterest)=="undefined" || fOtherInterest.length==0) fOtherInterest=0; 
     		
 		fSum = fPrincipal+fIndebtInterest+fOutdebtInterest+fOtherInterest;
        setItemValue(0,getRow(),"IndebtSum",fSum);
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

