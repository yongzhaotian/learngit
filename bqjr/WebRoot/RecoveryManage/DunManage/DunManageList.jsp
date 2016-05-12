<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   	FSGong  2004.12.05
		Tester:
		Content:  	不良资产列表(List页面)
		Input Param:
				下列参数作为组件参数输入
				PropertyType	资产类型：不良资产/正常资产								
				ObjectType	对象类型：BUSINESS_CONTRACT
						上述两个参数的目的是保持扩展性,将来可能不仅仅用户不良资产的催收函管理.
			        
		Output param:
		                ContractID	资产编号
		History Log: 		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sSql ="";
	
	String sDBName = Sqlca.getConnection().getMetaData().getDatabaseProductName().toUpperCase();
	String sTempletNo = "DunManageList";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(sDBName.startsWith("INFORMIX"))
	{
			doTemp.FromClause = " from  BUSINESS_CONTRACT bc,outer Dun_Info di ";
			doTemp.WhereClause =" where bc.RecoveryUserID='"+CurUser.getUserID()+"' and bc.Balance >0 "+
						  							  " and (bc.FinishDate is NULL or bc.FinishDate =' ' or bc.FinishType='060') and bc.ShiftType='02' "+
													  " and bc.SerialNo=di.ObjectNo ";
	}else if(sDBName.startsWith("ORACLE")) 
	{
			doTemp.FromClause = " from  BUSINESS_CONTRACT bc,Dun_Info di ";
			doTemp.WhereClause = " where bc.RecoveryUserID='"+CurUser.getUserID()+"' and bc.Balance >0 "+
													   " and (bc.FinishDate is NULL or bc.FinishDate =' ' or bc.FinishType='060') and bc.ShiftType='02' "+
													   " and bc.SerialNo=di.ObjectNo(+) ";	
	}else if(sDBName.startsWith("DB2")) 
	{ 
		   doTemp.FromClause = " from BUSINESS_CONTRACT bc left outer join  Dun_Info di on (bc.SerialNo=di.ObjectNo) ";
		   doTemp.WhereClause = "where bc.RecoveryUserID='"+CurUser.getUserID()+"' and bc.Balance>0"+
		                                              " and (bc.FinishDate is NULL or bc.FinishDate =' ' or bc.FinishType='060') and bc.ShiftType='02' ";
	}

	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);//20条一分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入显示模板参数
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
		{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "AfterLoan";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sApproveType = getItemValue(0,getRow(),"ApproveType");
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApproveType="+sApproveType;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	/*~[Describe=选中某笔合同,自动显示相关的催收列表;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//合同编号
		sCurrency = getItemValue(0,getRow(),"Currency");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			//alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BusinessContract&ObjectNo="+sSerialNo+"&Currency="+sCurrency,"DetailFrame");
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
	OpenPage("/Blank.jsp?TextToShow=请先选择相应的合同信息!","DetailFrame","");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>