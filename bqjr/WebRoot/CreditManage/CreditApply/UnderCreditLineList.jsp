<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%> 
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: 额度项下业务
		Input Param:
			ObjectType: 阶段编号
			ObjectNo：业务流水号
		Output Param:

		HistoryLog: 
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "额度项下业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sCustomerID="",sBusinessType="";
	String sSql = ""; 
	String sWhereCondition="";
	ASResultSet rs=null;

	//获得页面参数

	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//得到业务品种和客户
	sSql="select CustomerID,BusinessType  from BUSINESS_CONTRACT where SerialNo=:SerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sCustomerID=DataConvert.toString(rs.getString("CustomerID"));
		sBusinessType=DataConvert.toString(rs.getString("BusinessType"));
	}
	rs.getStatement().close(); 
	
	sWhereCondition= " where BUSINESS_CONTRACT.BusinessType not in ('5010','5020') and (BUSINESS_CONTRACT.FinishDate = ' ' or BUSINESS_CONTRACT.FinishDate is null) and BUSINESS_CONTRACT.ContractFlag='010'";

	//通过显示模版产生ASDataObject对象doTemp
    String sTempletNo = "UnderCreditLineList";
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    if(sBusinessType.equals("5010")){
	    doTemp.WhereClause = doTemp.WhereClause+" and BUSINESS_CONTRACT.CustomerID = '"+sCustomerID+"' ";
    }
    else if(sBusinessType.equals("5020")){
	    doTemp.WhereClause = doTemp.WhereClause+" and BUSINESS_CONTRACT.CreditAggreement = '"+sObjectNo+"' ";
    }
    
    doTemp.WhereClause += sWhereCondition;

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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
	String sButtons[][] = {
		{"true","","Button","详情","查看额度项下业务详情","viewAndEdit()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function viewAndEdit(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			openObject("BusinessContract",sObjectNo,"001");
		}
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

<%@	include file="/IncludeEnd.jsp"%>
