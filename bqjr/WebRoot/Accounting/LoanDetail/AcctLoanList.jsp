<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "台帐信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ContractSerialNo"));
	if(sObjectNo == null) sObjectNo = "";
	
	//显示模版编号
	String sTempletNo = "AcctLoanList";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	
	String sButtons[][] = {
			{"true", "", "Button", "详情", "详情","viewRecord()",sResourcesPath},
	};
	
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else 
		{
			OpenComp("AcctLoanView","/Accounting/LoanDetail/AcctLoanView.jsp","ObjectNo="+sSerialNo+"&ObjectType=<%=BUSINESSOBJECT_CONSTATNTS.loan%>"+"&RightType=ReadOnly","_blank","");				
		}
	}
</script>


<script language=javascript>
	//初始化
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
/*~END~*/
%>

<%@ include file="/IncludeEnd.jsp"%>
