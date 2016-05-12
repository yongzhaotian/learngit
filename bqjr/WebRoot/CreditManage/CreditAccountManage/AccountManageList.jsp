<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   qfang 2011-06-02
		Tester:	  
		Content:  账户管理List页面
		Input Param:
                  
		Output param:
		    
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "账户管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AccountManageList"; //模版编号
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//过滤查询
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//设置页面显示的列数
	dwTemp.setPageSize(20);
	//删除账户所对应的流水表(account_wastebook)的相关信息
	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteAccountData(#Account)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","账户关联合同","查看该账户关联的合同","viewRelaContract()",sResourcesPath},					
			{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{		
		OpenComp("AccountManageInfo","/CreditManage/CreditAccountManage/AccountManageInfo.jsp","ReadOnly=y","_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	    sAccount = getItemValue(0,getRow(),"Account");//--永久类型编号
	    if(typeof(sAccount)=="undefined" || sAccount.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    sReturn=popComp("AccountManageInfo","/CreditManage/CreditAccountManage/AccountManageInfo.jsp","ReadOnly=n&Account="+sAccount,"");
	    reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sAccount = getItemValue(0,getRow(),"Account");//--永久类型编号
		if (typeof(sAccount)=="undefined" || sAccount.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		if(confirm(getHtmlMessage('70')))//您真的想取消该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
    
	/*~[Describe=查看账户相关合同;InputParam=无;OutPutParam=无;]~*/
	function viewRelaContract()
	{
		sAccount = getItemValue(0,getRow(),"Account");//--永久类型编号
		if( typeof(sAccount)=="undefined" || sAccount.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		openComp("RelaContractOfAccountList","/CreditManage/CreditAccountManage/RelaContractOfAccountList.jsp","Account="+sAccount,"_blank","");
	}

	/*~[Describe=选中某条记录,联动显示对应的账户监控信息;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow()
	{
		sAccount = getItemValue(0,getRow(),"Account");//--流水号码
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--客户ID
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//--客户名称
		if(typeof(sAccount)=="undefined" || sAccount.length==0) {
			
		}else{
			OpenPage("/CreditManage/CreditAccountScout/AccountScoutList.jsp?Account="+sAccount+"&CustomerID="+sCustomerID+"&CustomerName="+sCustomerName,"DetailFrame","");
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	OpenPage("/Blank.jsp?TextToShow=<font size='3px'><b>账户监控</b></font></br></br>请先选择一个账户!","DetailFrame","");
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
