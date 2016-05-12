<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "核算交易定义列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	ASDataObject doTemp = new ASDataObject("TransactionConfigList", "",Sqlca);	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","删除","删除一条记录","delRecord()",sResourcesPath},
		{"true","","Button","详情","详细信息","myDetail()",sResourcesPath},
		{"true","","Button","分录模板","会计分录模板定义","viewTransEntry()",sResourcesPath,"btn_icon_detail"},
		{"true","","Button","交易参数列表","交易参数列表","viewDoNo()",sResourcesPath,"btn_icon_detail"},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>

	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	function newRecord(){
		AsControl.OpenView("/Accounting/Config/TransactionConfigInfo.jsp","","right","");
	}

	function viewDoNo(){
		//【过滤未选择记录可以弹出空记录的界面。By ghshi 2013-07-30】
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if (typeof(sItemNo) == "undefined" || sItemNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息
			return;
		}
		
		var attribute1 = getItemValue(0,getRow(),"attribute1");
		if(typeof(attribute1) == "undefined" || attribute1=="")
			alert("没有配置相应的显示模板。");
		else
			AsControl.OpenView("/Accounting/Config/TransactionParameterList.jsp","attribute1="+attribute1,"_blank","");
	}
	
	function myDetail(){
		var sitemno = getItemValue(0,getRow(),"ItemNo");
		var scodeno = getItemValue(0,getRow(),"CodeNo");
		if (typeof(sitemno) == "undefined" || sitemno.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		AsControl.OpenView("/Accounting/Config/TransactionConfigInfo.jsp","ItemNo="+sitemno+"&CodeNo="+scodeno,"right","");
	}
	
	function viewTransEntry(){
		var sitemno = getItemValue(0,getRow(),"ItemNo");
		var status = getItemValue(0,getRow(),"Status");
		var attribute1 = getItemValue(0,getRow(),"attribute1");
		if (typeof(sitemno) == "undefined" || sitemno.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		AsControl.OpenView("/Accounting/Config/TransEntryConfigList.jsp","ItemNo="+sitemno+"&attribute1="+attribute1,"_blank","");
	}
	
	
	function delRecord()
	{
		var sCodeno = getItemValue(0,getRow(),"CodeNo");
		var sItemNo=getItemValue(0,getRow(),"ItemNo");
		
		if (typeof(sItemNo) == "undefined" || sItemNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息
			return;
		}
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	</script>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>