<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "账务代码方案定义信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","180");

	//获取组件参数
	
	//获取页面参数
	String sBookType  = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType")));
	

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AccountingCatalogList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","配置方案条件","配置方案具体条件","edit()",sResourcesPath}
		};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">
    var oldAccountingNo=""; //记录当前所选

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{ 
		as_add("myiframe0");//新增记录
		initSerialNo();
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);	
	}
    
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var accountingNo = getItemValue(0,getRow(),"AccountingNo");	//条款类别编号
        if(typeof(accountingNo) == "undefined" || accountingNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=配置变化;InputParam=无;OutPutParam=无;]~*/
	function edit()
	{
		var accountingNo = getItemValue(0,getRow(),"AccountingNo");	//条款类别编号
        if(typeof(accountingNo) == "undefined" || accountingNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
        AsControl.OpenView("/Accounting/Config/ConditionRuleDef.jsp","ObjectNo="+accountingNo+"&ObjectType=jbo.app.ACCOUNTING_CATALOG","_blank",OpenStyle);
	}


	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ACCOUNTING_CATALOG";//表名
		var sColumnName = "AccountingNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=选择变化;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow()
	{
		var accountingNo = getItemValue(0,getRow(),"AccountingNo");
       	if(typeof(accountingNo)=="undefined" || accountingNo.length==0) {
			OpenPage("/Blank.jsp?TextToShow=请选择一条记录","DetailFrame","");
			return;
		}
		if(oldAccountingNo!=accountingNo)
		{
       		OpenComp("AccountingLibraryList","/Accounting/Config/AccountingLibraryList.jsp","AccountingNo="+accountingNo,"DetailFrame","");
       		oldAccountingNo = accountingNo;
		}
	}

	
	
</script>




<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	

<%@ include file="/IncludeEnd.jsp"%>
