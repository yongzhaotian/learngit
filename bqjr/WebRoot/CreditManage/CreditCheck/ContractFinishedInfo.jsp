<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --CChang 2003.8.25
		Tester:
		Content:    --合同终结 			
		Input Param:
        	SerialNo：    --合同流水号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同手工终结信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//-存放sql语句
		
	//获得组件参数	：合同流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sSerialNo == null) sSerialNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][]={
                        {"SerialNo","合同流水号"},
                        {"BusinessName","业务品种"},
                        {"Balance","合同余额"},
                        {"FinishTypeName","终结方式"},
                        {"FinishDate","终结日期"}
                        };                       

	sSql = " select SerialNo,BusinessType,getBusinessName(BusinessType) as BusinessName,Balance,"+
		   " FinishType,getItemName('FinishType',FinishType) as FinishTypeName,FinishDate "+
	  	   " from BUSINESS_CONTRACT " +
		   " where SerialNo = '"+sSerialNo+"' ";
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders); 
	//对表进行更新、插入、删除操作时需要定义表对象、主键   
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);	
	//设置只读属性
	doTemp.setReadOnly("SerialNo,BusinessName,Balance",true);
	//设置字段是否可更新
	doTemp.setUpdateable("BusinessName,FinishTypeName",false); 
	//设置字段是否可见  
	doTemp.setVisible("BusinessType,FinishType",false);
	//设置下拉框显示值
	doTemp.setDDDWCode("FinishType","FinishType");
	//设置对齐格式
	doTemp.setAlign("Balance","3");
	//设置检查格式
	doTemp.setCheckFormat("FinishDate","3");
	doTemp.setCheckFormat("Balance","2");
	//设置值类型  
	doTemp.setType("Balance","number");
	doTemp.setHTMLStyle("FinishDate"," style={width:80px}");
	//设置字段必输属性
	doTemp.setRequired("FinishTypeName,FinishDate",true);
	
	//设置终结类型选择框
	doTemp.setUnit("FinishTypeName"," <input type=button value=.. onclick=parent.selectFinishedType()>");
			
	//生成ASDataWindow对象		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform形式
	
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		as_save("myiframe0");				
	}
	
	/*~[Describe=选择终结类型;InputParam=无;OutPutParam=无;]~*/
	function selectFinishedType()
	{
		sParaString = "CodeNo"+",FinishType";		
		setObjectValue("SelectCode",sParaString,"@FinishType@0@FinishTypeName@1",0,0,"");
		
	}
	
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