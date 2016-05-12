<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   pwang  20091021
		Tester:
		Content:  预测现金流
		Input Param:
			SerialNo:现金流流水号
			AccountMonth:会计月份
			DuebillNo：借据编号
			
		Output param:
		History Log:

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预测现金流信息"; // 浏览器窗口标题 
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得组件参数
	String sSql = "";
	double dContractRate = 0.0,dAuditRate=0.0;
	String sCustomerName= "",sAccountMonth="",sDuebillNo="";
	String sCustomerType= "";
	String sCurrency="";

	//获得页面参数
	//现金流流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	//申请流水号
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";

	//如果为新增时
	if(sSerialNo.equals("")){
		sSql = "select AccountMonth,DuebillNo,CustomerName,CustomerType,Currency,ContractRate,AuditRate from  RESERVE_APPLY where SerialNo= :SerialNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));		
	 	if(rs.next()){
	 		//会计月份
	 		sAccountMonth = rs.getString("AccountMonth");
	 		//借据号
	 		sDuebillNo = rs.getString("DuebillNo");
	 		sCustomerName = rs.getString("CustomerName");
	 		sCustomerType = rs.getString("CustomerType");
	 		sCurrency = rs.getString("Currency");
	 		//合同利率
	 		dContractRate = rs.getDouble("ContractRate");	
	 		//实际利率
			dAuditRate = rs.getDouble("AuditRate");
		}
		rs.getStatement().close();
	}
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReservePredictInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform	
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//执行插入或者更新操作后需更新Reserve_Total,Reserve_Apply字段
	dwTemp.setEvent("AfterInsert","!ReserveManage.FinishPredictData(#AccountMonth,#DuebillNo,#ObjectNo)");
	dwTemp.setEvent("AfterUpdate","!ReserveManage.FinishPredictData(#AccountMonth,#DuebillNo,#ObjectNo)");
		
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
		//6.资源图片路径(sAbleToSee.equals("true"))?"true":"false"
	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
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
	function saveRecord(sPostEvents){
		if(!vI_all("myiframe0")) return;
	

		if(bIsInsert){
			initSerialNo();
			bIsInsert = false;
		}
		//计算折现值	
		if(!calDiscountValue()) return;
		as_save("myiframe0",sPostEvents);		
	}


	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "RESERVE_PREDICTDATA";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	/*~[Describe=计算现金流总额;InputParam=无;OutPutParam=无;]~*/
	function calDueSum(){
	    if(allowCalDueSum() == false){
	       return;
	    }
	    var dPredictValue = getItemValue(0,getRow(),"PredictValue");				
	    var dGuarantyValue = getItemValue(0,getRow(),"GuarantyValue");			
	    var dEnsureValue = getItemValue(0,getRow(),"EnsureValue");
	    var dSubstituteValue = getItemValue(0,getRow(),"SubstituteValue");
	    var dOtherWayValue = getItemValue(0,getRow(),"OtherWayValue");
	    var dDueSum = dPredictValue + dGuarantyValue + dEnsureValue + dSubstituteValue + dOtherWayValue;
	    setItemValue(0,getRow(),"PredictSum",dDueSum);	
	}
	/*~[Describe=现金流总额计算校验;InputParam=无;OutPutParam=无;]~*/
	function allowCalDueSum(){
		var dPredictValue = getItemValue(0,getRow(),"PredictValue");			
      	if (typeof(dPredictValue) == "undefined" || dPredictValue.length == 0){
			return false;
		}			
      	var dGuarantyValue = getItemValue(0,getRow(),"GuarantyValue");
      	if (typeof(dGuarantyValue) == "undefined" || dGuarantyValue.length == 0){
			return false;
		}
      	var dEnsureValue = getItemValue(0,getRow(),"EnsureValue");
      	if (typeof(dEnsureValue) == "undefined" || dEnsureValue.length == 0){
			return false;
		}
      	var dSubstituteValue = getItemValue(0,getRow(),"SubstituteValue");
      	if (typeof(dSubstituteValue) == "undefined" || dSubstituteValue.length == 0){
			return false;
		}
      	var dOtherWayValue = getItemValue(0,getRow(),"OtherWayValue");
      	if (typeof(dOtherWayValue) == "undefined" || dOtherWayValue.length == 0){
			return false;
		}
		return true;	   
	}
	/*~[Describe=折现值计算;InputParam=无;OutPutParam=无;]~*/
	function calDiscountValue(){
		var dDiscountRate = getItemValue(0,getRow(),"DiscountRate");
	   	//显示的利率为带单位的利率，需要转换为小数形式的实际值 //如果是月利率，则除以1000，如果是日利率，则除以10000	  
	   	var dDiscountRate = dDiscountRate/1000;
	   	var sBaseDate = getItemValue(0,getRow(),"BaseDate");
	   	if(typeof(sBaseDate)=="undefined" || sBaseDate.length ==0){
	   		alert("本笔业务的基础数据基准日期不存在，请检查本月份的基础数据！");
	   		return false;
	   	}
	   	var sReturnDate = getItemValue(0,getRow(),"ReturnDate");
	   	if(typeof(sReturnDate)=="undefined" || sReturnDate.length ==0){
	   		alert("本笔业务的基础数据预测日期不存在，请检查本月份的基础数据！");
	   		return false;
	   	}
	   	var dPredictSum = getItemValue(0,getRow(),"PredictSum");	
	   	if(typeof(dPredictSum)=="undefined" || dPredictSum.length ==0){
	   		alert("本笔业务的基础数据现金流总计不存在，请检查本月份的基础数据！");
	   		return false;
	   	}
		//计算预测未来现金流折现值。
		var sReturn = RunMethod("ReserveManage","ReservePredictCF",dDiscountRate+","+dPredictSum+",<%=sObjectNo%>,"+sReturnDate+","+sBaseDate);
		if(sReturn==null ||sReturn=="undefined"){
			alert("未来现金流预测计算没有结果！");
		}else{
			dDiscountValue =sReturn;
		}
		if(isNaN(dDiscountValue)){
			setItemValue(0,getRow(),"DiscountSum","");	
		}else{	   		
		  	setItemValue(0,getRow(),"DiscountSum",dDiscountValue);
	    }
	   return true;
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	function initRow(){
		var sReturn ="";
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,getRow(),"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,getRow(),"DuebillNo","<%=sDuebillNo%>");
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
			setItemValue(0,getRow(),"CustomerType","<%=sCustomerType%>");
			setItemValue(0,getRow(),"Currency","<%=sCurrency%>");
			setItemValue(0,getRow(),"PredictValue","<%=0.00%>");
			setItemValue(0,getRow(),"GuarantyValue","<%=0.00%>");
			setItemValue(0,getRow(),"EnsureValue","<%=0.00%>");
			setItemValue(0,getRow(),"SubstituteValue","<%=0.00%>");
			setItemValue(0,getRow(),"OtherWayValue","<%=0.00%>");
			setItemValue(0,getRow(),"PredictSum","<%=0.00%>");
			setItemValue(0,getRow(),"DiscountSum","<%=0.00%>");
			//根据不同的项目要求，配置不同的折现率:实际利率或者合同利率
			//目前默认为合同利率
			setItemValue(0,getRow(),"DiscountRate","<%=dContractRate%>");
			sReturn = RunMethod("ReserveManage","GetReserveBaseDate","<%=sObjectNo%>");
			if(sReturn==null ||sReturn=="undefined"){
				alert("获得基准日期错误");
				sReturn ="";
			}			
			setItemValue(0,getRow(),"BaseDate",sReturn);			
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
