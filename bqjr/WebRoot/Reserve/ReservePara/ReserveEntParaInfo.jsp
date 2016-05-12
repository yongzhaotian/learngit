<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.biz.reserve.business.DateTools" %>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author:zwang 2008.11.12
		Tester:
		Content: 减值计提参数调整页面
		Input Param:
			会计月份：AccountMonth
			客户类型：CustomerType
				01 公司客户 
				03 个人客户
			损失率计算类型: LossRateCalType
		Output param:
			会计月份：AccountMonth
			客户类型：CustomerType
				01 公司客户 
				03 个人客户
		History Log: 
			zytan 20090108 页面只读控制
	*/
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
<%
	// 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_TITLE = "减值计提参数调整"; 
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	
	//获得组件参数
	
	//获得页面参数			
	String sAssetsType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetsType"));
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	//如果是新增的参数信息页面，则自动取得会计月份值，目前默认为按照季度来取值
	if(sAccountMonth == null) sAccountMonth = DateTools.getAccountMonth("yyyy/MM/dd",3);
	if(sAssetsType == null) sAssetsType = "01";
	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReserveEntPara";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "0";
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sAssetsType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
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
	//标记DW是否处于"新增状态"
	var bIsInsert = false; 
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){			
			//进行新增验证：数据库中已经存在的改客户类型对应月份已经存在时，给出提示，重新选择
			sAccountMonth = getItemValue(0,0,"AccountMonth");//取得会计月份
			sAssetsType = getItemValue(0,0,"AssetsType");//取得客户类型
			//调用页面验证 "01"表示客户类型为公司客户
		    sParaString = sAccountMonth + "," + "01" + "," + sAssetsType;
		    sPassRight = RunMethod("ReserveManage","ReserveCheckAccountMonth",sParaString);
			if(sPassRight=="Pass"){
				beforeInsert();	
			}else{
				alert(" 所选资产组的会计月份参数已经存在，请重新选择！");
				return;
			}				
		}else{
			beforeUpdate();			
		}
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
   		OpenPage("/Reserve/ReservePara/ReserveEntParaList.jsp","_self","");
   	}
	
	/*~[Describe=日期选择;InputParam=无;OutPutParam=无;]~*/
	function getMonth(sObject)
	{
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined")
		{
			setItemValue(0,0,sObject,sReturnMonth);
		}
	}
</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script type="text/javascript">
		
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{			
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/	
	function beforeUpdate()
	{
		//设置更新时需要自动填充的字段
	}
		
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//如果没有找到对应记录，则新增一条，并设置字段默认值
		if (getRowCount(0)==0) 
		{
			//新增记录
			as_add("myiframe0");
			bIsInsert = true;
			setItemValue(0,0,"AssetsType","<%=sAssetsType%>");
			setItemValue(0,0,"AccountMonth","<%=sAccountMonth%>");
		}
	}
</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	//页面装载时，对DW当前记录进行初始化
	initRow(); 
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
