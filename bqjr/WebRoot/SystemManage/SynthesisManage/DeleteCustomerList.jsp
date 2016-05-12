<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	 /*
		Author:
		Tester:
		Describe: 删除无效客户
		Input Param:
		Output Param:
		HistoryLog: fbkang on 2005/08/14
					hwang on 2009/06/16 增加无效客户清理说明
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "清理无效客户信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "DeleteCustomerList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(100);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(CurOrg.getSortNo());
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
	//add by hwang 20090615,新增无效客户清理说明信息
	String sButtons[][] = {
		   {"true","","Button","清理","清理无效客户信息","clearCustomer()",sResourcesPath},
		   {"true","","PlainText","(清理：概况、关联、申请、合同、担保信息均无的客户)","(清理：概况、关联、申请、合同、担保信息均无的客户)","style={color:red}",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------	
	/*~[Describe=清理无效客户;InputParam=无;OutPutParam=无;]~*/
	function clearCustomer()
	{
		sCustomerID = getItemValue(0,getRow(),"CI.CustomerID");
		sCustomerType = getItemValue(0,getRow(),"CI.CustomerType"); 		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{			
			sReturn = PopPageAjax("/SystemManage/SynthesisManage/DeleteCustomerActionAjax.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType, "_self","");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
				return;  
			}else
			{
				alert(getBusinessMessage('947'));//无效客户被成功清理！
				reloadSelf();
			}
		}
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


<%@ include file="/IncludeEnd.jsp"%>
