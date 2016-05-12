<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-21  
		Tester:
		Describe: 票据信息出账申请时的票据信息
		Input Param:
			ObjectType: 对象类型
			ObjectNo:   对象编号
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "相关票据信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	ASResultSet rs =null ;
	
	//获得组件参数
	String sContractSerialNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo"));
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sBusinessType    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	if(sSerialNo == null ) sSerialNo = ""; 
    if(sObjectNo == null) sObjectNo = ""; 
    if(sContractSerialNo == null) sContractSerialNo = ""; 
    if(sBusinessType == null) sBusinessType = ""; 

    String sObjectType = "BusinessContract";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	if(sBusinessType.equals("2010")) //银行承兑汇票
	{
		sTempletNo = "BillInfo1";
	}
	else
	{
		sTempletNo = "BillInfo2";
	}

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//add by sjchuan 建立一次出账申请可以出多张票据的关联
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertPutoutRelative("+sObjectNo+",#SerialNo,"+StringFunction.getToday()+","+CurUser.getUserID()+","+sBusinessType+")");	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
	    //获得业务品种
		sBusinessType = "<%=sBusinessType%>";
		//在新增票据信息时，如果业务品种为"银行承兑汇票贴现"则执行验证检查。add by cbsu 2009-11-03
		//因为"银行承兑汇票"的票据号也是唯一的，因此增加了对票据号的检查。add by cbsu 2009-11-09
		//2010：银行承兑汇票 1020010：银行承兑汇票贴现 1020020：商业承兑汇票贴现 1020030：协议付息票据贴现 1020040：商业承兑汇票保贴
		if (bIsInsert) {
            if (sBusinessType == "2010" || sBusinessType == "1020010" || sBusinessType == "1020020"
                || sBusinessType == "1020030" || sBusinessType == "1020040") {
                if (!validateCheck()) {
                    return;
                }
            }
        }
		
	
		getSum();
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();		
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditApply/BillList.jsp","_self","");
	}
	//计算实付金额和实收利息
	function getSum()
	{
		//票据金额、票据到期日、票据贴现日期
		sBillSum = getItemValue(0,getRow(),"BillSum");
		sMaturity = getItemValue(0,getRow(),"Maturity");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");
				
		//调整天数、月利率
		sEndorseTimes = getItemValue(0,getRow(),"EndorseTimes");
		sRate = getItemValue(0,getRow(),"Rate");
				
		//初始化实付金额、实收利息
		setItemValue(0,0,"actualSum",sBillSum);
		setItemValue(0,0,"actualint",0.00);
		
		if(typeof(sRate)=="undefined" || sRate == null || sRate.length==0) sRate=0; 
		if(typeof(sEndorseTimes)=="undefined" || sEndorseTimes == null || sEndorseTimes.length==0) sEndorseTimes=0;
		if(typeof(sMaturity)=="undefined" || sMaturity.length==0) return;
		if(typeof(sFinishDate)=="undefined" || sFinishDate.length==0) return;
		
		sTerms = PopPageAjax("/CreditManage/CreditApply/getDayActionAjax.jsp?Maturity="+sMaturity+"&FinishDate="+sFinishDate,"","");
				
		if(typeof(sTerms)=="undefined" || sTerms.length==0) sTerms=0; 
				
		//计算实收利息=(到期日 - 贴现日期+调整天数)*月利率/30*票据金额
		sActualint = sTerms*sRate*sBillSum/30000+sEndorseTimes*sRate*sBillSum/30000;
				
		//计算实付金额=票据金额 - 实收利息
		sActualSum =  sBillSum - sActualint;
	
		//更新实付金额、实收利息
		setItemValue(0,0,"actualSum",roundOff(sActualSum,2));
		setItemValue(0,0,"actualint",roundOff(sActualint,2));
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
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
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sContractSerialNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BILL_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=在新增前验证输入的票据号是否已经存在或引入;InputParam=无;OutPutParam=无;]~*/
	//add by cbsu 2009-11-03
	function validateCheck() {
		var sBillNo = getItemValue(0,getRow(),"BillNo");
		var sContractSerialNo = "<%=sContractSerialNo%>";
		var sPutOutNo = "<%=sObjectNo%>";
		if (typeof(sBillNo) != "undefined" && sBillNo.length != 0) {
			var sParaString = sBillNo + "," + sContractSerialNo + "," + sPutOutNo;
		    sReturn = RunMethod("BusinessManage","CheckDuplicateBill",sParaString);
		    //如果输入的票据号已经存在，则不允许进行新增操作。
	        if (sReturn == "Failed") {
	             alert("票据号:" + sBillNo + "已存在！");
	             return false;
	         }
	         //如果输入的票据号可以引入，则引入。
	         else if (sReturn == "Import") {
	             var sBillSerialNo = RunMethod("BusinessManage","GetBillSerialNo",sBillNo);
	             sParaString = sPutOutNo + "," + sBillSerialNo + "," + 
	                           "<%=StringFunction.getToday()%>" + "," + "<%=CurUser.getUserID()%>" + "," + "<%=sBusinessType%>";
	             RunMethod("BusinessManage","InsertPutoutRelative",sParaString);            
	             alert("票据号:" + sBillNo + "引入成功！");
	             return false;
	         } else {
	             return true;
	         }
		} else {
			return true;
		}
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