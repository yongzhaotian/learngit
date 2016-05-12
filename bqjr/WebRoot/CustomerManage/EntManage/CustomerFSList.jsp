<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: jbye  2004-12-16 20:15
		Tester:
		Describe: 显示客户相关的财务报表
		Input Param:
			CustomerID： 当前客户编号
		Output Param:
			CustomerID： 当前客户编号
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	页面调整
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户财务报表信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
     String sCustomerID = "";//--客户代码
     String sSql = "";//--存放sql语句
	//获得页面参数

	//获得组件参数，客户代码
	sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CustomerFSList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);

	//删除相关财务报表信息
	dwTemp.setEvent("AfterDelete","!BusinessManage.InitFinanceReport(CustomerFS,#CustomerID,#ReportDate,#ReportScope,#RecordNo,,,Delete,,)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
		{"true","All","Button","新增报表","新增客户一期财务报表","AddNewFS()",sResourcesPath},
		{"false","All","Button","报表说明","修改客户一期财务报表基本信息","FSDescribe()",sResourcesPath},
		{"true","","Button","报表详情","查看该期报表的详细信息","FSDetail()",sResourcesPath},
		{"true","All","Button","修改报表日期","修改报表日期","ModifyReportDate()",sResourcesPath},
		{"true","All","Button","删除报表","删除该期财务报表","DeleteFS()",sResourcesPath},
		{"true","All","Button","完成","设置报表为完成状态","FinishFS()",sResourcesPath},//采用标志位来控制报表权限，新增完成按钮，实现财务报表由新增状态转换为完成状态。
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var ObjectType = "CustomerFS";
	//新增一期财务报表
	function AddNewFS()
	{
		var stmp = CheckRole();
		if("true" == stmp)
		{
    		//判断该客户信息中财务报表的类型是否选择
    		sModelClass = PopPageAjax("/CustomerManage/EntManage/FindFSTypeAjax.jsp?CustomerID=<%=sCustomerID%>&rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
    		if(sModelClass == "false")
    		{
    			alert(getBusinessMessage('162'));//客户概况信息输入不完整，请先输入客户概况信息！
    		}else
    		{
    			//打开 /CustomerManage/EntManage/AddFSPre.jsp 页面进行新增操作
    			sReturn = PopComp("CustomerFS","/CustomerManage/EntManage/AddFSPre.jsp","CustomerID=<%=sCustomerID%>&ModelClass="+sModelClass,"dialogWidth=40;dialogHeight=50;resizable:yes;scrollbars:no;");
    			if(sReturn=="ok")
    			{
    				reloadSelf();	
    			}
    		}
		}else
	    {
	        alert(getHtmlMessage('16'));//对不起，你没有信息维护的权限！
	        return;
	    }
	}
	
	//修改报表基本信息
	function FSDescribe()
	{
	    var stmp = CheckRole();
	    var srole = "";
		if("true" == stmp)
		    srole="has";
		else
		    srole="no";
		var sEditable="true";
		sUserID = getItemValue(0,getRow(),"UserID");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		if (typeof(sRecordNo) != "undefined" && sRecordNo != "" )
		{
			if(FSLockStatus())
				sEditable="false";
			if(sUserID!="<%=CurUser.getUserID()%>")
				sEditable="false";
			OpenComp("FinanceStatementInfo","/CustomerManage/EntManage/FinanceStatementInfo.jsp","Role="+srole+"&RecordNo="+sRecordNo+"&Editable="+sEditable,"_self",OpenStyle);
		}else
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
	}
	
	//报表详细信息
	function FSDetail()
	{
	    var stmp = CheckRole();
	    var srole = "";
		if("true" == stmp)
		{
		    srole="has";
		}
		else
		{
		    srole="no";
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sUserID = getItemValue(0,getRow(),"UserID");

		if (typeof(sCustomerID) != "undefined" && sCustomerID != "" )
		{
			var sEditable="true";
			if(FSLockStatus())
				sEditable="false";
			if(sUserID!="<%=CurUser.getUserID()%>")
				sEditable="false";
			OpenComp("FinanceReportTab","/Common/FinanceReport/FinanceReportTab.jsp","Role="+srole+"&RecordNo="+sRecordNo+"&ObjectType="+ObjectType+"&CustomerID="+sCustomerID+"&ReportDate="+sReportDate+"&ReportScope="+sReportScope+"&Editable="+sEditable,"_blank",OpenStyle);
		    reloadSelf();
		}else
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
	}
	
	//修改报表日期
	function ModifyReportDate()
	{
		var stmp = CheckRole();
		if("true" != stmp)
		{
		    alert(getHtmlMessage('16'));//对不起，你没有信息维护的权限！
		    return;
		}
		if(FSLockStatus()){
			alert("本期财务报表已锁定，不能修改!");
			return;
		}
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		if(typeof(sReportDate)!="undefined"&& sReportDate != "" )
		{
			//取得对应的报表月份
			sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
			if(typeof(sReturnMonth) != "undefined" && sReturnMonth != "")
			{
				sToday = "<%=StringFunction.getToday()%>";//当前日期
				sToday = sToday.substring(0,7);//当前日期的年月
				if(sReturnMonth >= sToday)
				{		    
					alert(getBusinessMessage('163'));//报表截止日期必须早于当前日期！
					return;		    
				}
				
				if(confirm("你确认要将 "+sReportDate+"财务报表 更改为"+sReturnMonth+"吗？"))
				{
					//如果需要可以进行保存前的权限判断
					sPassRight = PopPageAjax("/CustomerManage/EntManage/FinanceCanPassAjax.jsp?ReportDate="+sReturnMonth+"&ReportScope="+sReportScope,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
					if(sPassRight == "pass")
					{
						//更改相关的财务报表
						sReturn = RunMethod("BusinessManage","InitFinanceReport","CustomerFS,<%=sCustomerID%>,"+sReportDate+","+sReportScope+","+sRecordNo+","+""+","+sReturnMonth+",ModifyReportDate,<%=CurOrg.getOrgID()%>,<%=CurUser.getUserID()%>");
						if(sReturn == "ok")
						{
							alert("该期财务报表已经更改为"+sReturnMonth);	
							reloadSelf();	
						}
					}else
					{
						alert(sReturnMonth +" 的财务报表已存在！");
					}
				}
			}
		}else
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
	}
	
	//删除一期财务报表
	function DeleteFS() 
	{
	    var stmp = CheckRole();
		if("true" != stmp)
		{
		    alert(getHtmlMessage('16'));//对不起，你没有信息维护的权限！
		    return;
		}
		if(FSLockStatus()){
			alert("本期财务报表已锁定，不能删除!");//处于锁定状态的报表，不能删除！
			return;
		}
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sUserID = getItemValue(0,getRow(),"UserID");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		if (typeof(sReportDate) != "undefined" && sReportDate != "" )
		{
			if(sUserID=='<%=CurUser.getUserID()%>')
			{
    			if(confirm(getHtmlMessage('2')))
    		    {			
	    			as_del('myiframe0');
	      			as_save('myiframe0');  //如果单个删除，则要调用此语句			
	      			reloadSelf();	  //added by yzheng 2013-06-17
    			}
			}else alert(getHtmlMessage('3'));
		}else
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}	
	}

	//设置测算后的财务报表为完成状态
	function FinishFS()
	{
		var stmp = CheckRole();
		if("true" != stmp)
		{
		    alert(getHtmlMessage('16'));//对不起，你没有信息维护的权限！
		    return;
		}
		if(FSLockStatus()){
			alert("本期财务报表已锁定，不能修改!");
			return;
		}
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		if (typeof(sReportDate) != "undefined" && sReportDate != "" )
		{
			sReportStatus = '02';//01表示新增状态，02表示完成状态，03表示锁定状态
			sReturn = RunMethod("CustomerManage","UpdateFSStatus","<%=sCustomerID%>,"+sReportStatus+","+sReportDate+","+sReportScope);
			if(sReturn == "SUCCESS")
			{
				alert("财务报表已置为完成状态！");	
			}else{
				alert("操作失败！");	
			}
		}else
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		reloadSelf();
	}
	
	//判断时候有信息维护权，
	function CheckRole()
	{
	    var sCustomerID="<%=sCustomerID%>";
		var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
  
        if (typeof(sReturn)=="undefined" || sReturn.length==0){
        	return n;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];        //客户主办权
        sReturnValue2 = sReturnValue[1];        //信息查看权
        sReturnValue3 = sReturnValue[2];        //信息维护权
        sReturnValue4 = sReturnValue[3];        //业务申办权

        if(sReturnValue3 =="Y2")
            return "true";
        else
            return "n";
	}
	
	//检测财务报表是否已用于信用等级评估
	/*采用状态标志位后，本方法已无效。
		function CheckFSinEvaluateRecord(){
			sCustomerID = getItemValue(0,getRow(),"CustomerID");
			sReportDate = getItemValue(0,getRow(),"ReportDate");
			sReturn=RunMethod("CustomerManage","CheckFSinEvaluateRecord",sCustomerID+","+sReportDate);
			if(sReturn>0)return true;
			return false;
			
		}
	*/
	
	//检测财务报表是否为锁定状态，如：查询结果为03即锁定状态，返回true，否则返回false
	//此方法就完全可以替代CheckFSinEvaluateRecord方法，因为所有处于03状态的报表都已用于信用等级评估了。
	function FSLockStatus()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sReturn=RunMethod("CustomerManage","CheckFSStatus",sCustomerID+","+sReportDate+","+sReportScope);
		return sReturn == '03';
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>