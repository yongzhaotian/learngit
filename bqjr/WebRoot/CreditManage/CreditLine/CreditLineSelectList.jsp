<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-18
		Tester:
		Content: 额度选择列表
		Input Param:
		Output param:
		History Log: xhgao 2005/09/05 重检页面

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "额度选择列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
	//获得组件参数	
	String sSerialNo    = DataConvert.toRealString(iPostChange,CurComp.getParameter("SerialNo"));
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
					{"LineID","额度ID"},
					{"CLTypeID","额度类型编号"},
					{"CLTypeName","额度类型"},
					{"LineContractNo","授信合同号"},
					{"CustomerID","客户编号"},
					{"CustomerName","客户名称"},
					{"LineSum1","额度金额"},
					{"Currency","币种"},
					};
	sSql =  " select LineID,CLTypeID,CLTypeName,LineContractNo,CustomerID,CustomerName,"+
			" LineSum1,getItemName('Currency',Currency) as Currency from CL_INFO Where 1=1";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CL_INFO";
	doTemp.setKey("LineID",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("LineID,CLTypeID,CustomerID",false);
	
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
		//{"true","","Button","确定","把所选业务转到此额度项下","TransRecord()",sResourcesPath},
		{"true","","Button","确定","确认使用此额度","UseConfirm()",sResourcesPath},
		{"true","","Button","取消","关闭窗口","my_close()",sResourcesPath}			
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
		
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function TransRecord(){
		var sLineID=getItemValue(0,getRow(),"LineID");
		if (typeof(sLineID)=="undefined" || sLineID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}		
		sReturn = PopPageAjax("/CreditManage/CreditLine/CreditLineTransActionAjax.jsp?LineID="+sLineID+"&SerialNo=<%=sSerialNo%>","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
		if(sReturn="true"){
			alert(getBusinessMessage('412'));//业务关联关系成功转移！
			parent.close();
		}
	}
	
	function UseConfirm(){
		var sLineID=getItemValue(0,getRow(),"LineID");
		if (typeof(sLineID)=="undefined" || sLineID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		top.returnValue = sLineID;
		top.close();
	}
	
	function my_close(){
		parent.close();
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
	setDialogTitle("授信额度选择列表");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
