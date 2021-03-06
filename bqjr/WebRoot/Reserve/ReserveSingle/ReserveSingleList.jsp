<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
	/*
		Author: sjchuan 2009-10-20
		Tester:
		Content: 单项计提列表页面,根据客户类型、会计月份查询所有计提标志为“单项计提”的记录
		Input Param:
			CustomerType: 客户类型
				01 公司客户 
				03 个人客户
		Output param:
			会计月份：AccountMonth
			借据编号：DuebillNo
		History Log: 
	*/
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
<%
	// 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_TITLE = "单项计提列表"; 
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量:上一个月份,客户类型
	String sCustomerType; 		
	//获得组件参数
	//获得页面参数
	//CustomerType:客户类型
	sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	String sTempletNo = "ReserveSingleList";
   String sManagerUserID=CurUser.getUserID();
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca)); 
	
	if(!doTemp.haveReceivedFilterCriteria())
	{
		doTemp.WhereClause += " and AccountMonth = (select max(AccountMonth) from RESERVE_TOTAL where CalculateFlag = '20'  and CustomerType like '"+sCustomerType+"%')";
	}			
	
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1"; 
	//设置是否只读 1:只读 0:可写     
	dwTemp.ReadOnly = "1"; 
	dwTemp.setPageSize(10);	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerType+","+sManagerUserID);
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
		{"true","","Button","新增","组合计提转单项计提","newRecord()",sResourcesPath},
		{"true","","Button","数据详情","查看/修改详情","viewAndEdit()",sResourcesPath},
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
	function newRecord(){
		var sCustomerType= "<%=sCustomerType%>";
		var sCompID = "ReserveSingleNew";
		var sCompURL = "/Reserve/ReserveSingle/ReserveSingleNew.jsp";
		var sReturn = popComp(sCompID,sCompURL,"CustomerType="+sCustomerType,"dialogWidth=650px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn) == "undefined" || sReturn.length == 0){
			return;
		}

		if(sReturn == "_SUCCESSFUL_") {
			alert("新增组合计提转单项计提成功！");
			reloadSelf();
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        var sDueBillNo = getItemValue(0,getRow(),"DuebillNo");
        var sCustomerType = getItemValue(0,getRow(),"CustomerType");
        var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if((typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0) 
            || (typeof(sDueBillNo) == "undefined" || sDueBillNo.length == 0))
        {
            alert("请选择一条记录！");
            return;
        }
        var sCompID = "ReserveTab";
        var sURL = "/Reserve/ReserveTab.jsp";
        var sParameter = "AccountMonth=" + sAccountMonth +
                         "&DueBillNo=" + sDueBillNo +
                         "&CustomerType=" + sCustomerType +
                         "&ReserveFlag=20" +
                         "&CustomerID=" + sCustomerID;
        popComp(sCompID,sURL,sParameter,"");
	}
	
</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
