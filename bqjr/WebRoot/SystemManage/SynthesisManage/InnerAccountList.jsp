<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "内部账户列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "InnerAccountList";
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

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		AsControl.PopView("/SystemManage/SynthesisManage/InnerAccountInfo.jsp","","dialogWidth="+(screen.availWidth*0.3)+"px;dialogHeight="+(screen.availHeight*0.4)+"px;resizable=yes;maximize:yes;help:no;status:no;"); 
		reloadSelf();            
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sAccountNo = getItemValue(0,getRow(),"CoreAccountNo");	//帐号
		var sOrgID = getItemValue(0,getRow(),"OrgID");	//机构
		var sCurrency = getItemValue(0,getRow(),"Currency");	//币种
		var sAccountType = getItemValue(0,getRow(),"AccountType");   //账户类型
        if(typeof(sOrgID)=="undefined" || sOrgID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}

        AsControl.PopView("/SystemManage/SynthesisManage/InnerAccountInfo.jsp",
                "CoreAccountNo="+sAccountNo+"&OrgID="+sOrgID+"&Currency="+sCurrency,+"&AccountType="+sAccountType,
                "dialogWidth="+(screen.availWidth*0.3)+"px;dialogHeight="+(screen.availHeight*0.4)+"px;resizable=yes;maximize:yes;help:no;status:no;"); 
        reloadSelf();       
	}
    
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID) == "undefined" || sOrgID.length == 0) {
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
