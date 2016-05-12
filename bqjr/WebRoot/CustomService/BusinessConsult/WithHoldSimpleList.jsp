<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
 <%
	/*
		页面说明: 示例列表页面  
	 */
	String PG_TITLE = "实时代扣结果查询";
	ASDataObject doTemp = new ASDataObject("WithHoldSimpleList",Sqlca);
	
	doTemp.setRequired("businessdate", false);
	//设置查询条件
	doTemp.setFilter(Sqlca, "0101", "businessdate", "Operators=EqualsString,IsNotNull;");
	
	doTemp.setFilter(Sqlca, "0050", "contractno", "Operators=EqualsString,BeginsWith;");
	
	//doTemp.setFilter(Sqlca, "0100", "sendflag1", "Operators=EqualsString;");
	
	//doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()){
		String sBusinessDate=SystemConfig.getBusinessDate();
		doTemp.Filters.get(0).sFilterInputs[0][1] = sBusinessDate;
		doTemp.WhereClause+=" and 1=2";
	}else if(doTemp.Filters.get(0).sFilterInputs[0][1]==null||doTemp.Filters.get(1).sFilterInputs[0][1]==null){
		   %>
			<script type="text/javascript">
				alert("录入日期、合同号不能为空！");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
	}
	
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	//使用new ASDataWindow(CurPage,doTemp,Sqlca)将造成查询条件重复，改成dwTemp
	 Vector vTemp =  dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			//{"true","","Button","代扣结果查询","代扣结果查询","affirmWithhold()",sResourcesPath},
		    };
%>

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


<%/*~[Describe=再次代扣申请确认;InputParam=无;OutPutParam=无;]~*/%>

	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//查询条件展开设置
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>