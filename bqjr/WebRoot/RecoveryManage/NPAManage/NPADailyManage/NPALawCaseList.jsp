<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   XWu 2004.12.12
		Tester:
		Content: 合同涉诉案件信息列表
		Input Param:
			   ObjectNo：合同编号 不良资产调用    
			   ObjectType：对象类型     
			   CustomerID：客户ID 信贷客户信息调用    
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同涉诉案件信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sWhereCondition = "";
    String sInCondition = "";

	//获得组件参数	
	//获得页面参数
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //对象类型，这里就是Customer，所以这里没有用处，因为需要是BusinessContract
	
	if(sCustomerID == null) sCustomerID = "";
	if(sObjectType == null) sObjectType = "BusinessContract";
	if(sFinishType == null) sFinishType = "";

	if(sCustomerID.equals("")){
		//不良资产台帐管理涉诉信息页面里不传CustomerID参数，故出现这种情况；这里ObjectNo是合同号，ObjectType是BusinessContract
		String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		sWhereCondition	= " SerialNo in (Select SerialNo From LAWCASE_RELATIVE Where ObjectNo = '"+sObjectNo+"' And ObjectType = 'BusinessContract') ";
	}
	else{
		//大型和中小型企业在我行涉诉情况
		String sSql = "select SerialNo from BUSINESS_CONTRACT where CustomerID=:CustomerID";
		ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
		while(rs.next()){
			if(sInCondition != null && !sInCondition.equals(""))
				sInCondition = sInCondition+",";
			sInCondition = sInCondition+ "'"+rs.getString(1)+"'";
		}
		rs.getStatement().close();

		if(sInCondition == null) sInCondition = "";
		if(sInCondition.indexOf("'")<0) sInCondition = "'"+sInCondition+"'";
		sWhereCondition	= 	" SerialNo in (Select Distinct SerialNo From LAWCASE_RELATIVE Where ObjectNo in ("+sInCondition+")" + 
							" And ObjectType = 'BusinessContract') order by InputDate desc ";  	
	}
	
	//通过DW模型产生ASDataObject对象doTemp
		String sTempletNo = "NPALawCaseList";//模型编号
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

		doTemp.WhereClause += sWhereCondition;
		
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
		dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		dwTemp.setPageSize(10);

		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //查询区的页面代码
	
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
	
		//如果为诉前案件，则列表显示如下按钮
		String sButtons[][] = {
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
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得案件流水号、案件类型
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
		}
		else
		{		
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;
			sViewID = "002";
			openObject(sObjectType,sObjectNo,sViewID);		}
		
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
