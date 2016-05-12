<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS"%>

<%
	String PG_TITLE = "约定还本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>

<%
	//获得组件参数
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String objectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	
	if(objectNo == null) objectNo = ""; 
    if(objectType == null) objectType = "";
    
    BusinessObject businessObject= AbstractBusinessObjectManager.getBusinessObject(objectType,objectNo,Sqlca);
	if(businessObject==null){
		throw new Exception("未取到业务主对象ObjectType="+objectType+",ObjectNo="+objectNo+"，请检查！");
	}
	objectType = businessObject.getObjectType();
%>

<%//定义变量
	String sTempletNo = "";	 
%>

<%
	//显示模板		
	sTempletNo = "DRPTList";	
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType+",4");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>


<%
	String sButtons[][] = {
		{"true","","Button","快速新增","快速新增","newRecord()",sResourcesPath}, 
		{"true","","Button","快速保存","快速保存当前页面","afterSave()",sResourcesPath},
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath}}; 
%>  

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">

	/*~[Describe=保存记录;InputParam=无;OutPutParam=无;]~*/
	function afterSave(){
		var sWaivePrincipalamt = "";
		for(var i=0;i<getRowCount(0);i++){
			sWaivePrincipalamt = getItemValue(0,i,"WaivePrincipalamt");
			setItemValue(0,i,"PayPrinciPalamt",sWaivePrincipalamt);
		}
		as_save("myiframe0");
	}
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		as_add("myiframe0");
		initSerialNo();
		//快速新增时候给定默认值
		setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(),"PayType","<%=ACCOUNT_CONSTANTS.PS_PAY_TYPE_DRPT%>");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2'))){//您真的想删除该信息吗？
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "ACCT_PAYMENT_SCHEDULE";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
</script>


<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@	include file="/IncludeEnd.jsp"%>
