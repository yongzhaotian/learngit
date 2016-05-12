<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29  ndeng 2004-11-30
		Tester:
		Describe: 相关票据信息
		Input Param:
			ObjectType: 对象类型
			ObjectNo:   对象编号
			SerialNo:	流水号
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
	String sBusinessType ="";  //业务品种
	ASResultSet rs =null ;
	
	//获得组件参数
	String sObjectType    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType.equals("AfterLoan")) sObjectType = "BusinessContract";
	
	//获得页面参数	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
	String sSql = "";

	//************************changed by slliu 2005/03/04*******************************	
	if(sObjectType.equals("CreditApply")){
		sSql = "select BusinessType from BUSINESS_APPLY where SerialNo =:SerialNo";
	}else if(sObjectType.equals("ApproveApply")){
		sSql = "select BusinessType from BUSINESS_APPROVE where SerialNo =:SerialNo";
	}else if(sObjectType.equals("BusinessContract")){
		sSql = "select BusinessType from BUSINESS_CONTRACT where SerialNo =:SerialNo";
	}
	
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if (rs.next()){
		sBusinessType = rs.getString("BusinessType");  
	}  
	rs.getStatement().close();
	
	//************************changed by slliu 2005/03/04*******************************	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "";
	String sTempletFilter = "";
	
	if(sBusinessType.equals("1020010")) //银行承兑汇票贴现
	{
		sTempletNo = "BillInfo";
	}
	else if(sBusinessType.equals("1020020")) //商业承兑汇票贴现
	{
		sTempletNo = "BillInfo";
		sTempletFilter = " colattribute like '%2%'";
	}
	else if(sBusinessType.equals("1020030")) //协议付息票据贴现
	{
		sTempletNo = "BillInfo";
	}
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//if(!sBusinessType.equals("1020020")) //银行承兑汇票/协议付息票据贴现
	//{
		//计算实付金额、实收利息
	//	doTemp.appendHTMLStyle("BillSum,Maturity,FinishDate,EndorseTimes,Rate"," onChange=\"javascript:parent.getSum()\" ");
	//	doTemp.setReadOnly("actualSum,actualint",true);
	//}
	//else
	//{
	//    doTemp.appendHTMLStyle("BillSum,Maturity,FinishDate"," onChange=\"javascript:parent.getSum()\" ");
	//}
	
	//设置金额为三位一逗数字
//	doTemp.setType("actualSum,actualint","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	//doTemp.setCheckFormat("actualSum,actualint","2");
//	doTemp.setCheckFormat("Rate","16"); /*表示小数点后6位*/
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
//	doTemp.setAlign("actualSum,actualint","3");
	   
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
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
		
	    //获得业务品种
		sBusinessType = "<%=sBusinessType%>";

        //当新增业务品种为承兑汇票贴现的票据信息时，对输入的票据号进行唯一性检查。add by cbsu 2009-11-10
        //1020010：银行承兑汇票贴现 1020020：商业承兑汇票贴现 1020030：协议付息票据贴现 1020040：商业承兑汇票保贴
        if (bIsInsert) {
			if (sBusinessType == "1020010" || sBusinessType == "1020020" || sBusinessType == "1020030" || sBusinessType == "1020040") {
				if (!validateCheck()) {
				    return;
				} 
			}
        }
		getSum();
		if(bIsInsert)
		{
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditApply/RelativeBillList.jsp","_self","");
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
		
		if(typeof(sRate)=="undefined" || sRate.length==0) sRate=0; 
		if(typeof(sEndorseTimes)=="undefined" || sEndorseTimes.length==0) sEndorseTimes=0;
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

	/*~[Describe=用与检查输入的票据号是否已经存在;InputParam=无;OutPutParam=无;]~*/
	//add by cbsu 2009-11-10
    function validateCheck() {
        var sBillNo = getItemValue(0,getRow(),"BillNo");
        var sContractSerialNo = "<%=sObjectNo%>";
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if (typeof(sBillNo) != "undefined" && sBillNo.length != 0) {
            var sParaString = sObjectType + "," + sContractSerialNo + "," + sBillNo;
            sReturn = RunMethod("BusinessManage","CheckApplyDupilicateBill",sParaString);
            //如果输入的票据号已经存在，则不允许进行新增操作。
            if (sReturn != 0) {
                 alert("票据号:" + sBillNo + "已存在！请重新检查输入的票据号是否正确。");
                 return false;
            } else {
                return true;
            }
        }
        else{
        	alert("请输入票据编号！")
        	return false;
        }
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
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
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