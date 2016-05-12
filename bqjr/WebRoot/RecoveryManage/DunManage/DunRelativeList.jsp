<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   	FSGong  2004.12.05
		Tester:
		Content:  	催收函列表
		Input Param:
				下列参数作为组件参数输入
				ObjectType	对象类型：BUSINESS_CONTRACT
				ObjectNo	对象编号：合同编号
						上述两个参数的目的是保持扩展性,将来可能不仅仅用户不良资产的催收函管理.
			        
		Output param:
		                	
		History Log: 
		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "催收函列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql 	="";
		
	
	String sObjectType; //对象类型
	String sObjectNo; //对象编号：合同编号。
	
	//获得组件参数	
	sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	sSql = 		" select SerialNo,"+
				" DunLetterNo,"+
				" DunDate,"+
				" getItemName('DunForm',DunForm) as DunForm, " +	
				" getItemName('DunMode',ServiceMode) as ServiceMode, " +	
				" DunObjectName,"+
				" getItemName('Currency',DunCurrency) as DunCurrency, " +	
				" DunSum,"+			
				" Corpus,"+			
				" InterestInSheet,"+			
				" InterestOutSheet,"+
				" ElseFee "+			
	       		" from DUN_INFO" +
	       		" where ObjectType='"+sObjectType+"' AND ObjectNo='"+sObjectNo+"' order by DunDate desc ";
	       			
   	String sHeaders[][] = {
				{"SerialNo","催收函流水号"},
				{"DunLetterNo","催收函编号"},
				{"DunDate","催收日期"},
				{"DunForm","催收形式"},
				{"ServiceMode","送达方式"},
				{"DunObjectName","催收对象名称"},
				{"DunCurrency","催收币种"},
				{"DunSum","催收金额(元)"},	
				{"Corpus","本金(元)"},	
				{"InterestInSheet","表内息(元)"},	
				{"InterestOutSheet","表外息(元)"},
				{"ElseFee","其他(元)"}	
			       };  
			       			       

    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "DUN_INFO";
	doTemp.setKey("SerialNo",true);	 
	//设置不可见项
	doTemp.setVisible("SerialNo,DunForm",false);	    
	//设置显示文本框的长度
	doTemp.setHTMLStyle("DunLetterNo"," style={width:70px} ");
	doTemp.setHTMLStyle("DunObjectName"," style={width:100px} ");
	doTemp.setHTMLStyle("DunDate,DunForm,ServiceMode,DunDate"," style={width:70px} ");
	doTemp.setHTMLStyle("DunCurrency"," style={width:60px} ");
	doTemp.setHTMLStyle("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee"," style={width:80px} ");
	//设置小数显示状态,
	doTemp.setAlign("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","3");
	doTemp.setType("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","2");
	
	
	//指定双击事件
	//doTemp.setHTMLStyle("DunLetterNo,DunObjectName,DunDate,DunForm,ServiceMode,DunCurrency,DunSum,Corpus,InterestInSheet,InterestOutSheet"," style={width:100px} ondblclick=\"javascript:parent.onDBLClick()\" ");  	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(16);  //服务器分页
	
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
//		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/DunManage/DunInfo.jsp?SerialNo="+sSerialNo,"_self","");
		}
	}
	
	//Doubleclick a certain item of list, calling this event.
	function onDBLClick()
    	{
    		viewAndEdit();
    	}	
    	
    	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>