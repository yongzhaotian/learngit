<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  zywei 2005/09/09
		Tester:
		Content: 
		Input Param:
			ObjectType：对象类型（按合同：BUSINESS_CONTRACT；按借据：BUSINESS_DUEBILL）
			ContractSerialNo：合同流水号
			ModelNo：模型编号			
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：SQL语句
	String sSql = "";
	
	//获得组件参数	：对象类型、合同流水号、模型号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	
	//将空值转化为空字符串	
	if(sObjectType == null) sObjectType = "";
	if(sContractSerialNo == null) sContractSerialNo = "";
	if(sModelNo == null) sModelNo = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	
	String[][] sHeaders1 = {
					{"AccountMonth","风险分类月份"},							
					{"ObjectNo","合同流水号"}							
			      };
	String[][] sHeaders2 = {
					{"AccountMonth","风险分类月份"},							
					{"ObjectNo","借据流水号"}							
			      };
	sSql = 	" select AccountMonth,ObjectNo "+	
			" from CLASSIFY_RECORD "+
			" where 1 = 2 ";	
	
	//通过SQL产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//设置按合同分类的标题
	if(sObjectType.equals("BusinessContract"))
		doTemp.setHeader(sHeaders1);
	if(sObjectType.equals("BusinessDueBill"))
		doTemp.setHeader(sHeaders2);
		
	doTemp.UpdateTable = "CLASSIFY_RECORD";
	//设置必输项
	doTemp.setRequired("AccountMonth,ObjectNo",true);
	
	//设置只读属性
	doTemp.setReadOnly("AccountMonth,ObjectNo",true);
	doTemp.setHTMLStyle("AccountMonth"," style={width:70px} ");
	//设置选择方式
	doTemp.setUnit("AccountMonth","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getMonth();\"> ");
	if(sObjectType.equals("BusinessDueBill")) //一个业务合同可能对应多个借据
		doTemp.setUnit("ObjectNo","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getObjectNo();\"> ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","确定","新增资产风险分类","doSubmit()",sResourcesPath},
		{"true","","Button","取消","取消资产风险分类","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=新增资产风险分类;InputParam=无;OutPutParam=无;]~*/	
	function doSubmit()
	{
		var sObjectType = "<%=sObjectType%>";
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//--风险分类月份	
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getBusinessMessage('671'));//请选择风险分类月份！
			return;
		}
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//--对象编号	
		
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			if(sObjectType == "BusinessContract")
				alert(getBusinessMessage('672'));//请选择需资产风险分类的合同流水号！
			if(sObjectType == "BusinessDueBill")
				alert(getBusinessMessage('673'));//请选择需资产风险分类的借据流水号！
			return;
		}
		
		//新增资产风险分类信息
	    sReturn = PopPageAjax("/CreditManage/CreditCheck/AddClassifyActionAjax.jsp?AccountMonth="+sAccountMonth+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&Type=Single&ModelNo=<%=sModelNo%>","","");
	    if(typeof(sReturn) == "undefined" || sReturn.length == 0)
	    {
	    	alert(getBusinessMessage('674'));//该期资产风险分类新增失败！
	    	return;
	    }else
	    {
			alert(getBusinessMessage('675'));//该期资产风险分类新增成功！
			top.returnValue = sReturn;
			top.close();	
		}	
    }
    
	/*~[Describe=取消新增资产风险分类;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>	
	<script type="text/javascript">
	
	/*~[Describe=选择会计月份;InputParam=无;OutPutParam=取消标志;]~*/
    function getMonth()
	{
		var sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp","","resizable=yes;dialogWidth=20;dialogHeight=15;center:no;status:no;statusbar:no");
		if (typeof(sMonth) != "undefined" && sMonth.length > 0)
			setItemValue(0,0,"AccountMonth",sMonth);		
	}
    
    /*~[Describe=弹出对象编号选择框;InputParam=无;OutPutParam=无;]~*/
	function getObjectNo()
	{
		var sReturnValue = "";
		var sObjectNo = "";
		var sObjectType = "<%=sObjectType%>";
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//--风险分类月份	
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getBusinessMessage('671'));//请选择风险分类月份！
			return;
		}
		
		//如果按照借据进行资产风险分类，那么选择借据流水号
		if(sObjectType == "BusinessDueBill")
		{				
			sParaString = "ObjectType,"+sObjectType+",AccountMonth"+","+sAccountMonth+",RelativeSerialNo2"+","+"<%=sContractSerialNo%>";
			sReturnValue = setObjectValue("SelectNPAClassifyDueBill",sParaString,"",0,0,"");			
		}
			
		if(sReturnValue != "_CANCEL_" && typeof(sReturnValue) != "undefined")
		{
			sReturnValue = sReturnValue.split('@');
			for(i = 0;i < sReturnValue.length;i++)
			{
				sObjectNo += sReturnValue[i];
			}
			setItemValue(0,getRow(),"ObjectNo",sObjectNo);
		}	
	}		
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			sObjectType = "<%=sObjectType%>";
			sContractSerialNo = "<%=sContractSerialNo%>";
			as_add("myiframe0");//新增一条空记录	
			if(sObjectType == "BusinessContract")
				setItemValue(0,getRow(),"ObjectNo",sContractSerialNo);		
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