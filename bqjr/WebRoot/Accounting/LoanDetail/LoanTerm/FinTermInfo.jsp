<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "罚息组件"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sObjectType = "";
	String sObjectNo = "";
	String productID = "";
	String productVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo"));
	sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectType == null) sObjectType = "";
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject rateSegmentBusinessObject = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, sSerialNo);
	if(rateSegmentBusinessObject != null)
	{
		sObjectType = rateSegmentBusinessObject.getString("ObjectType");
		sObjectNo = rateSegmentBusinessObject.getString("ObjectNo");
	}else
	{
		throw new Exception("对象【"+BUSINESSOBJECT_CONSTATNTS.loan_rate_segment+"."+sSerialNo+"】不存在！");
	}
	BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(sObjectType, sObjectNo,Sqlca);
	if(businessObject != null)
	{
		productID = businessObject.getString("BusinessType");
		productVersion = businessObject.getString("ProductVersion");
	}else
	{
		throw new Exception("对象【"+sObjectType+".+"+sObjectNo+"】不存在！");
	}
	
	//显示模版编号
	String sTempletNo = "FinRateSegmentInfo";
	String sTempletFilter = "1=1";
	String sIsSegEdit = "1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	
	doTemp.setHTMLStyle("RateFloat","onChange=parent.calcBaseRate()");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	
	ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, rateSegmentBusinessObject.getString("RateTermID"));
	String dwControl = DWExtendedFunctions.genDataWindowControlScript(term,dwTemp);
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//依次为：
	//0.是否显示
	//1.注册目标组件号(为空则自动取当前组件)
	//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.按钮文字
	//4.说明文字
	//5.事件
	//6.资源图片路径
	String sButtons[][] = 
	{
			{"true", "All", "Button", "保存", "保存","saveRecord()",sResourcesPath},
	};
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>	
	function saveRecord()
	{
		if(!calcBaseRate())
		{
			return;
		}
		as_save("myiframe0","reloadSelf()");
	}
	
	function calcBaseRate()
	{
		var rateMode = getItemValue(0,getRow(),"RateMode");
		var baseRateType = getItemValue(0,getRow(),"BaseRateType");
		var baseRate = getItemValue(0,getRow(),"BaseRate");
		var rateFloatType = getItemValue(0,getRow(),"RateFloatType");
		var rateFloat = getItemValue(0,getRow(),"RateFloat");
		//add by bhxiao 20120913 
		//修改原因，当rateFloat为空时，parseInt()调用后rateFloat=NaN,执行Method时报错，故为空时设置为0
		if(typeof(rateFloat)=="undefined" || rateFloat==null ||rateFloat.length==0){
			rateFloat = 0.0;
		}
		if(rateMode != "2")
		{
			if(baseRate == "")
			{
				alert("基准年利率不能为空！确认贷款基本信息中的利率信息是否录入。");
				return false;
			}
			if(rateFloatType == "")
			{
				alert("浮动利率类型不能为空！");
				return false;
			}
			rateFloat = parseInt(rateFloat);
			if(rateFloat == 0)
			{
				setItemValue(0,0,"RateFloat",0);
			}
			
			var rateTermID = getItemValue(0,0,"RateTermID");
    		var flag = RunMethod("BusinessManage","FinFloatRateCheck","<%=productID+"-"+productVersion%>,"+rateTermID+","+rateFloat);
    		if(flag != "true")
    		{
    			alert(flag);
    			return false;
    		}
    		
			if(rateFloatType == "0")
			{
				setItemValue(0,0,"BusinessRate",parseFloat(baseRate)*(1+parseFloat(rateFloat)/100));
			}else
			{
				setItemValue(0,0,"BusinessRate",parseFloat(baseRate)+parseFloat(rateFloat));
			}
		}else{
			var businessRate = getItemValue(0,getRow(),"BusinessRate");
			if(typeof(businessRate)=="undefined"||businessRate.length==0){
				alert("执行利率不能为空！");
				return false;
			}
		}
    	
    	return true;
    }
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
		}
		//如果是固定利率
		var rateMode = getItemValue(0,getRow(),"RateMode");
    	if(rateMode == "2")
    	{
			calcBaseRate();
		}else{//modify begin add by bhxiao 20120827 优化，当第一次打开详情页面时，如果基准利率类型只读，并基准利率为空时，需要加载相应基准利率值
			var baseRateType = getItemValue(0,getRow(),"BaseRateType");
			var rateUnit = getItemValue(0,getRow(),"RateUnit");
			var sBaseRate = getItemValue(0,getRow(),"BaseRate");
			if(typeof(sBaseRate)!="undefined"&&sBaseRate>0.0){
				return;
			}
			var baseRate = RunMethod("BusinessManage","GetBaseRateByTerm","<%=sObjectType%>,<%=sObjectNo%>,"+baseRateType+","+rateUnit+",,<%=businessObject.getString("Currency")%>");
	    	if(baseRate.length == 0)
	    	{
	    		if(baseRateType == "100")
	    		{
	    			alert("请检查是否已经录入利率信息！");
	    		}else
	    		{
	    			if(baseRateType != "060")
	    			{
	    				alert("请检查是否已经维护基准利率！");
	    				setItemValue(0,0,"BaseRate","");
	    			}	
	    		}
	    	}
	    	setItemValue(0,getRow(),"BaseRate",baseRate);
		}//modify end 
	}
	
	
	
</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	<%=dwControl%>
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>