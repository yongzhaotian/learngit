<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "账务代码方案定义明细"; // 浏览器窗口标题 <title> PG_TITLE </title>
	

	//获取组件参数
	
	//获取页面参数
	String accountingNo  = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountingNo")));
	

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AccountingLibraryList";
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

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(accountingNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">
    var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{ 
		as_add("myiframe0");//新增记录       
		setItemValue(0,getRow(),"AccountingNo","<%=accountingNo%>");
	}

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);	
	}
    
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var accountCodeNo = getItemValue(0,getRow(),"AccountCodeNo");	//条款类别编号
        if(typeof(accountCodeNo) == "undefined" || accountCodeNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=选择银行科目信息;InputParam=无;OutPutParam=无;]~*/
	function selectSubjectInfo(){
		setObjectValue("SelectSubjectInfo","CodeNo,AccountCodeConfig,BankNo,B","@SubjectNo@0@SubjectName@1",0,0,"");
	}
	
</script>




<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	

<%@ include file="/IncludeEnd.jsp"%>
