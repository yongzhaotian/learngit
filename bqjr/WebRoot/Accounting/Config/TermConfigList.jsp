<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "业务组件类别列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "TermConfigList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("TermType");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
%> 


<%@include file="/Resources/CodeParts/List05.jsp"%>


<script type="text/javascript">
    var sCurCodeNo=""; //记录当前所选择行的代码号

	function newRecord()
	{ 
		AsControl.OpenView("/Accounting/Config/TermConfigInfo.jsp","","_self","");        
	}
	
	function viewAndEdit()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");	//条款类别编号
        if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        AsControl.OpenView("/Accounting/Config/TermConfigInfo.jsp","ItemNo="+sItemNo,"_self","");   
	}
    
	function deleteRecord()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");	//条款类别编号
        if(typeof(sItemNo) == "undefined" || sItemNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}	
</script>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	

<%@ include file="/IncludeEnd.jsp"%>
