<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --股东情况;
		Input Param:
			CustomerID：--当前客户编号
			RelativeID：--关联客户组织机构代码
			Relationship：--关联关系	
			EditRight:--权限代码（01：查看权；02：维护权）		
		Output Param:

		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	参数、格式			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "资本构成情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
     String sSql = "";
     
	//获得组件参数,客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//获得页面参数，关联客户代码、关联关系、编辑权限
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	if(sCustomerScale == null) sCustomerScale = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
 
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "EntOwnerInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sRelativeID == null || sRelativeID.equals("")){
		doTemp.setUnit("CustomerName"," <input type=button class=inputdate value=.. onclick=parent.selectCustomer()><font color=red>(可输可选)</font><font class=ecrmpt9>&nbsp;(征信 M)&nbsp;</font>");
		doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setUnit("CustomerName"," <font class=ecrmpt9>&nbsp;(征信 M)&nbsp;</font>");
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip,CustomerType",true);
	}
	//doTemp.appendHTMLStyle("CertType","onchange=parent.setCustomerType()");
	//设置实际投资金额(元)范围
	//doTemp.appendHTMLStyle("InvestmentSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"实际投资金额(元)必须大于等于0！\" ");
	//设置出资比例(%)范围
  	//doTemp.appendHTMLStyle("InvestmentProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"出资比例(%)的范围为[0,100]\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";		// 设置DW风格 1:Grid 2:Freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	/* dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写 */
	
	//设置插入和更新事件，反方向插入和更新
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,#LoanCardNo,#InputUserID,#CustomerType)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRelativeID+","+sRelationShip);//传入参数,逗号分割
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
			{"false","","Button","新增","新增资本构成","newRecord()",sResourcesPath},
			{(sEditRight.equals("02")?"true":"false"),"All","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","股东信息详情","查看股东信息详情","viewOwnerInfo()",sResourcesPath},
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
	var selectCustMode = false;//客户选择方式：false表示填入客户，true表示引入客户。用于贷款卡唯一性校验做控制。
	var sLoanCard ="";//记录贷款卡号
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	//add by wlu 2009-02-19
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?EditRight=02","_self","");
	}	

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		//录入数据有效性检查
		if (!ValidityCheck()) return;	
		//if(!chkCustomerType()) return;
		if(bIsInsert){
			//保存前进行检查,检查通过后继续保存,否则给出提示
		    if (!RelativeCheck()) return;
			beforeInsert();
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=返回股东信息详情页面;InputParam=无;OutPutParam=无;]~*/
	//add by wlu 2009-02-19
	function viewOwnerInfo()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		if(typeof(sRelativeID) == "undefined" || sRelativeID == "")
		{
			alert("请先保存！");
			return;
		}
		sReturn = RunMethod("CustomerManage","CheckRolesAction",sRelativeID+",<%=CurUser.getUserID()%>");
	    if (typeof(sReturn) == "undefined" || sReturn.length == 0){
	    	return;
	    }

	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];
	    sReturnValue2 = sReturnValue[1];
	    sReturnValue3 = sReturnValue[2];
	                        
	    if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2"){    		
	    		openObject("Customer",sRelativeID+"&<%=sCustomerScale%>","001");
	    		//reloadSelf();
		}else{
		    alert(getBusinessMessage('115'));//对不起，你没有查看该客户的权限！
		}
	}
		
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntOwnerList.jsp?","_self","");
	}


	
	/*~[Describe=证件类型为个人证件时，客户类型设置为个人客户;InputParam=无;OutPutParam=无;]~*/
	function setCustomerType(){
		sCertType = getItemValue(0,getRow(),"CertType");
		if(sCertType.length >= 3){
			if(sCertType.substr(0,3) == "Ind"){
				setItemValue(0,getRow(),"CustomerType","0310");
			}else{
				setItemValue(0,getRow(),"CustomerType","0110");
			}
		}
	}
	/*~[Describe=检查客户类型;InputParam=无;OutPutParam=无;]~*/
	/* function chkCustomerType(){
			sCertType = getItemValue(0,getRow(),"CertType");
			sCustomerType = getItemValue(0,getRow(),"CustomerType");

			if(sCustomerType == "" || sCustomerType.length == 0){
				alert("客户类型不能为空");
				try{setItemFocus(0,0,"CustomerType");}catch(e){}
				return false;
			}
			if(sCertType.length >= 3){
				//个人证件时，不能选择企业类客户
				if(sCertType.substr(0,3) == "Ind"){
					if(sCustomerType.substr(0,2) != "03"){
						alert("证件类型为个人类证件时，客户类型必需为个人类客户");
						try{setItemFocus(0,0,"CustomerType");}catch(e){}
						return false;
					}
				//企业客户，需要检查客户类型是否录入
				}else if(sCertType.substr(0,3) == "Ent"){
					if(sCustomerType.substr(0,2) != "01"){
						alert("证件类型为企业类证件时，客户类型必需为公司类客户");
						try{setItemFocus(0,0,"CustomerType");}catch(e){}
						return false;
					}
				}
			}
			return true;
	} */
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		var sRelationShip   = getItemValue(0,getRow(),"RelationShip");//--关联关系
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
	    //返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号	
	    var sReturn = "";
	    if(sCertType!=""&&typeof(sCertType)!="undefined"){
	    	sParaString = "CertType,"+sCertType;
	    	sReturn = setObjectValue("SelectOwner",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");	    
	    }else{
	    	sParaString = "CertType, ";
			sReturn = setObjectValue("SelectOwner",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");	    
	    }
		if(sReturn == "_CLEAR_"){
			setItemDisabled(0,0,"CertType",false);
			setItemDisabled(0,0,"CertID",false);
			setItemDisabled(0,0,"CustomerName",false);
			selectCustMode = false;
			sLoanCard = "";
		}else{
			//防止用户点开后，什么也不选择，直接取消，而锁住这几个区域
			sCertID = getItemValue(0,0,"CertID");
			if(typeof(sCertID) != "undefined" && sCertID != ""){
				setItemDisabled(0,0,"CertType",true);
				setItemDisabled(0,0,"CertID",true);
				setItemDisabled(0,0,"CustomerName",true);
				setItemDisabled(0,0,"CustomerType",true);  //added by yzheng
				selectCustMode = true;
				var certType = getItemValue(0,0,"CertType");
				var temp = certType.substring(0,3); 
				  if(temp=='Ent'){
					  sLoanCard = getItemValue(0,0,"LoanCardNo");//贷款卡号
					  setItemRequired(0,0,"LoanCardNo",true);
					  setItemDisabled(0,0,"LoanCardNo",true);
				  }  else{
					    sLoanCard = "";
		            	setItemRequired(0,0,"LoanCardNo",false);
		            	setItemDisabled(0,0,"LoanCardNo",false);
		            }
				  sCertType="";
			}else{
				setItemDisabled(0,0,"CertType",false);
				setItemDisabled(0,0,"CertID",false);
				setItemDisabled(0,0,"CustomerName",false);
				setItemDisabled(0,0,"LoanCardNo",false);
				selectCustMode = false;
				sLoanCard = "";
			}
		}
	}
	
	/*~[Describe=根据证件类型和证件编号获得客户编号和客户名称;InputParam=无;OutPutParam=无;]~*/
	var sCertType="";
	function getCustomerName()
	{
		sCertType   = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID   = getItemValue(0,getRow(),"CertID");//--证件号码
        
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
	        //获得客户名称
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
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
						//设置客户编号
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"RelativeID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
						//设置贷款卡编号
						if(my_array2[n] == "loancardno") 
						{
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			}  
		}
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

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"CurrencyType","01");
		}
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{		
	    sCertID = getItemValue(0,0,"CertID");//证件代码
		//校验股东贷款卡编号
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//股东贷款卡编号	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			if(sLoanCard != sLoanCardNo || selectCustMode == false)
			{
				//检验股东贷款卡编号唯一性
				sCustomerName = getItemValue(0,getRow(),"CustomerName");//客户名称	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerName+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('231'));//该股东贷款卡编号已被其他客户占用！							
					return false;
				}	
			}					
		}

		//校验股东是否被修改
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//客户名称
		sReturn=RunMethod("CustomerManage","CheckCustomerName",sCustomerName+","+sCertID);
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
		{
			alert(getBusinessMessage('257'));//该股东已经存在，请不要修改用户名！							
			return false;
		}						
		//校验股东的出资比例(%)之和是否超过100%
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--主体客户代码
		sInvestmentProp = getItemValue(0,getRow(),"InvestmentProp");//--出资比例(%)
		if(typeof(sInvestmentProp) != "undefined" && sInvestmentProp != "" )
		{
			sStockSum = RunMethod("CustomerManage","CalculateStock",sCustomerID+","+sRelativeID);
			sTotalStockSum = parseFloat(sStockSum) + parseFloat(sInvestmentProp);
			if(sTotalStockSum > 100)
			{
				alert(getBusinessMessage('138'));//所有股东的出资比例(%)之和不能超过100%！
				return false;
			}
		}
		return true;
	}

	/*~[Describe=关联关系插入前检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function RelativeCheck()
	{			
		sCustomerID   = getItemValue(0,0,"CustomerID");//--客户代码		
		sCertType = getItemValue(0,0,"CertType");//--证件类型		
		sCertID = getItemValue(0,0,"CertID");//证件代码		
		sRelationShip = getItemValue(0,0,"RelationShip");//--关联关系
		if (typeof(sRelationShip) != "undefined" && sRelationShip != '')
		{			
			var sMessage = PopPageAjax("/CustomerManage/EntManage/RelativeCheckActionAjax.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			var messageArray = sMessage.split("@");
			var isRelationExist = messageArray[0];
			var info = messageArray[1];
			if (typeof(sMessage)=="undefined" || sMessage.length==0) {
				return false;	
			}	
			else if(isRelationExist == "false"){
				alert(info);
				return false;
			}
			else if(isRelationExist == "true"){
				setItemValue(0,0,"RelativeID",info);
			}
		}
		return true;
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


<%@	include file="/IncludeEnd.jsp"%>
