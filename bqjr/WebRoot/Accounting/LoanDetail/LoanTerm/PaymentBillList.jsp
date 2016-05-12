<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "支付清单"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>

<%
	//获得组件参数
	String sPutoutSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String right=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("RightType")));
	if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sObjectType == null) sObjectType = "";
%>

<%//定义变量
	String sTempletNo = "";	 
%>

<%
	//显示模板		
	sTempletNo = "PutOutList";	
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	doTemp.WhereClause+=" and ObjectType='"+sObjectType+"' and ObjectNo='"+sPutoutSerialNo+"'";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPutoutSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>


<%
	String sButtons[][] = {
		{"true","","Button","新增","新增","newRecord()",sResourcesPath}, 
		{"true","","Button","详情","查看","viewRecord()",sResourcesPath},
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath}}; 
	if("ReadOnly".equals(right)){
		sButtons[0][1]="false";
		sButtons[2][1]="false";
	}
%>  

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		OpenPage("/Accounting/LoanDetail/LoanTerm/PaymentBillInfo.jsp","_self","");
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
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sAccountInFlag = getItemValue(0,getRow(),"AccountInFlag");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			OpenPage("/Accounting/LoanDetail/LoanTerm/PaymentBillInfo.jsp?SerialNo="+sSerialNo+"&AccountInFlag="+sAccountInFlag,"_self","");				
		}
	}
</script>


<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@	include file="/IncludeEnd.jsp"%>
