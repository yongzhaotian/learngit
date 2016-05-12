<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
 <%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "实时代扣发送查询"; 
	ASDataObject doTemp = new ASDataObject("QuerySendKFTList",Sqlca);
	
	//设置查询条件
	doTemp.setFilter(Sqlca, "0081", "businessdate", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0010", "serialno", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0060", "customerid", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0070", "contranctno", "Operators=EqualsString,BeginsWith;");
	
	//doTemp.generateFilters(Sqlca);
	
	doTemp.parseFilterData(request,iPostChange);

	if(!doTemp.haveReceivedFilterCriteria()){
		String sBusinessDate=SystemConfig.getBusinessDate();
		doTemp.Filters.get(0).sFilterInputs[0][1] = sBusinessDate;
		doTemp.WhereClause+=" and businessdate='"+sBusinessDate+"'";
	}else if(doTemp.Filters.get(0).sFilterInputs[0][1]==null){
			%>
				<script type="text/javascript">
					alert("发送时间不能为空！");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	
	//生成HTMLDataWindow 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			//{"true","","Button","代扣结果查询","代扣结果查询","affirmWithhold()",sResourcesPath},
		    };
%>

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


<%/*~[Describe=再次代扣申请确认;InputParam=无;OutPutParam=无;]~*/%>
function affirmWithhold(){
	var sSerialNo = getItemValue(0,getRow(),"outid");
	
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
	{
		alert(getHtmlMessage(1));  //请选择一条记录！
		return;
	}
	
	
	var returlVale = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.WithholdSimpleQuery","sendPayMentSimple","serialNo="+sSerialNo);
	if(returlVale == 'true'){
		alert("查询成功!");
	}else{
		alert('调用接口失败!');
	}
	reloadSelf();
}
	


	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//查询条件展开设置
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>