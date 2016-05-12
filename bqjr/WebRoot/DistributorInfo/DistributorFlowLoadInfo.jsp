<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --新增经销商流动资金借款
			未用到的属性字段暂时隐藏，如果需要请展示出来。
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增经销商流动资金借款"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("DistributorFlowLoadInfo",Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
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
			{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","saveRecordAndBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //记录当前所选择行的代码号
    var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		bIsInsert = false;
	    as_save("myiframe0");
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
        window.close();
	}
    
    function getRegionCode(){
    	var sEntInfoValue=setObjectValue("SelectServiceProvidersInfo","","@customerName@2",0,0,"");
    	if(typeof(sEntInfoValue)=="undefined" || sEntInfoValue.length==0){
			alert("请选择一个经销商！");  
			return;
		}
    	sEntInfoValue=sEntInfoValue.split('@');
    	sCustomerID=sEntInfoValue[0];             // 经销商编号
    	sServiceProvidersType=sEntInfoValue[1];   //经销商类型 
    	entErpriseName=sEntInfoValue[2];          //经销商名称
    	 if(sServiceProvidersType=="经销商"){
 	    	sServiceProvidersType="2";
 	    }else if(sServiceProvidersType=="经销商集团"){
 	    	sServiceProvidersType="1";
 	    }
    	setItemValue(0, 0, "customerID", sCustomerID);
    	setItemValue(0, 0, "serviceProvidersType", sServiceProvidersType);
    	setItemValue(0, 0, "customerName", entErpriseName);
//    	var fBankName= RunMethod("GetElement","GetElementValue","bankName,account_Information,relativeSerialno='"+sCustomerID+"' and accountType=01"); //流动资金放款开户支行名称
//    	var sBankName =RunMethod("GetElement","GetElementValue","bankName,account_Information,relativeSerialno='"+sCustomerID+"' and accountType=02");//流动资金收款开户支行名称
//    	var fAccountNo =RunMethod("GetElement","GetElementValue","accountNo,account_Information,relativeSerialno='"+sCustomerID+"' and accountType=01");//流动资金放款开户帐号
//    	var sAccountNo =RunMethod("GetElement","GetElementValue","accountNo,account_Information,relativeSerialno='"+sCustomerID+"' and accountType=02");//流动资金放款 开户帐号
//    	setItemValue(0, 0, "loanBranchName", fBankName);
//    	setItemValue(0, 0, "repaymentBranchName", sBankName);
//    	setItemValue(0, 0, "loanBankAccount", fAccountNo);
//    	setItemValue(0, 0, "repaymentBankAccount", sAccountNo);
    }
    
    function getRegionCode1(){
    	var sCustomerID=getItemValue(0,getRow(),"customerID");
    	if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请先选择相应的经销商！");  
			return;
		}
    	var sEntInfoValue1=setObjectValue("SelectDistributorLoadInfo2", "customerID,"+sCustomerID, "@bondSum@4", 0, 0, "");
    	if(typeof(sEntInfoValue1)=="undefined" || sEntInfoValue1.length==0){
			alert("请选择一个额度！");  
			return;
		}
    	sEntInfoValue1=sEntInfoValue1.split('@');
    	sQuotaID=sEntInfoValue1[0];       //经销商额度的额度协议编号
    	sBondSum=sEntInfoValue1[4];      //关联额度（启用额度）
    	sQuotaMoney=sEntInfoValue1[5];   //额度金额
    	setItemValue(0, 0, "quotaID", sQuotaID);
//    	setItemValue(0, 0, "bondSum", sBondSum);
//    	setItemValue(0, 0, "quotaMoney", sQuotaMoney);
    }
    
    function getRegionCode2(){
    	var sEntInfoValue2=setObjectValue("SelectDistributorLoadInfo3","","@productName@1",0,0,"");
    	if(typeof(sEntInfoValue2)=="undefined" || sEntInfoValue2.length==0){
			alert("请选择一个产品！");  
			return;
		}
    	sEntInfoValue2=sEntInfoValue2.split('@');
    	sBusinessType=sEntInfoValue2[0];        //经销商关联的产品代码
    	sProductName=sEntInfoValue2[1];      //产品名称
    	sFloatingManner=sEntInfoValue2[2];   //浮动方式
    	sInterestRate=sEntInfoValue2[3];     //利率类型
    	sFloatingRange=sEntInfoValue2[4];    //浮动幅度
    	setItemValue(0, 0, "BusinessType", sBusinessType);
//    	setItemValue(0, 0, "floatingManner", sFloatingManner);
//    	setItemValue(0, 0, "interestRate", sInterestRate);
//    	setItemValue(0, 0, "floatingRange", sFloatingRange);
    }
   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0, 0, "creditAttribute", "0003");
			setItemValue(0, 0, "productID", "060");
			setItemValue(0, 0, "quotaStatus", "01");
			//初始化版本
			setItemValue(0,0,"productVersion","V1.0");
			setItemValue(0,0,"serialNo",getSerialNo("business_contract", "serialNo", " "));
			setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputOrgID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"inputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputDate", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"updateOrgName", "<%=CurOrg.orgName%>");
			setItemValue(0,0,"updateUserID", "<%=CurUser.getUserID() %>");
			setItemValue(0,0,"updateOrgID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"updateDate", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
