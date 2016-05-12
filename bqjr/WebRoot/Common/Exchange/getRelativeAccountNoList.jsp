<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2005-03-25
		Tester:
		Describe: 展期原帐号选择
		Input Param:
			
		Output Param:

		 	

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷款类型选择"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";

	//获得组件参数	
	String sContractSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo"));
	
%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
    String sHeaders[][] = { 							
            				{"SerialNo","帐号"},
            				{"RelativeSerialNo1","借据号"},
            				{"CustomerName","客户名称"},
            				{"BusinessSum","金额"}
			              }; 
	
	sSql =	"select ba.serialno as SerialNo,ba.RelativeSerialNo1 as RelativeSerialNo1, "+
	        " ba.CustomerName as CustomerName,ba.BusinessSum as BusinessSum"+
	        " from business_duebill bd ,business_account ba "+
            " where bd.serialno=ba.relativeserialno1 "+
            " and bd.relativeserialno2 in (select objectno from contract_relative where objecttype = 'BUSINESSCONTRACT'"+
            " and serialno = '"+sContractSerialNo+"')";
	
	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    //doTemp.setHTMLStyle("SerialNo"," style={width:200px}");
    doTemp.setHTMLStyle("CustomerName"," style={width:200px}");
    doTemp.setCheckFormat("BusinessSum","2");
    doTemp.setType("BusinessSum","number"); 
	doTemp.setColumnAttribute("RelativeSerialNo1,CustomerName,BusinessSum","IsFilter","1");
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(13);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


%> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script>
	function doSearch()
	{
		document.forms["form1"].submit();
	}
	function mySelectRow()
	{      
		try{
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
		}catch(e){
			return;
		}
		parent.sObjectInfo = sSerialNo;
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>