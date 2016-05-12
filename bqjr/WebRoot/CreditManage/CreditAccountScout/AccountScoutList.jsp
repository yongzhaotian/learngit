<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   qfang 2011-06-03
		Tester:	  
		Content:  账户监控List页面
		Input Param:          
		Output param:                
		History Log:             
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "账户监控列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数：对象类型
	String sAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Account"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sAccount == null) sAccount = "";
	if(sCustomerID == null ) sCustomerID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AccountScoutList"; //模版编号
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混
	
	//担保信息项下的抵押物	
	PG_TITLE = "<font size='3px'><b>账户监控</b></font></br></br>["+sAccount+"]项下的流水信息列表@PageTitle";
	
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
  	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccount);
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
			{"true","","Button","账户台帐登记","新增一条记录","CheckInAccount()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},					
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
	function CheckInAccount(){
		popComp("AccountScoutInfo","/CreditManage/CreditAccountScout/AccountScoutInfo.jsp","Account=<%=sAccount%>&CustomerID=<%=sCustomerID%>","");
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
	    sAccount = getItemValue(0,getRow(),"Account");//
	    sSerialNo = getItemValue(0,getRow(),"SerialNo");//
	    if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    sReturn=popComp("AccountScoutInfo","/CreditManage/CreditAccountScout/AccountScoutInfo.jsp","SerialNo="+sSerialNo,"");
	    reloadSelf();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	hideFilterArea();;
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
