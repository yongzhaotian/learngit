<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: DataWindow数据过滤器示例页面
	 */
	String PG_TITLE = "DataWindow数据过滤器示例页面";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ExampleList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//生成查询框，这里除ApplySum，其他的查询条件(字段)在DW模型(显示模板)里勾选“可查询”
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","ApplySum","Operators=BetweenNumber;DOFilterHtmlTemplate=Number");//数字区间条件
	doTemp.setFilter(Sqlca,"2","InputUser","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";//初始化不显示列表数据,haveReceivedFilterCriteria()获取是否接收到filter过滤条件的状态
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*~[Describe=查询条件弹出对话框;]~*/%>
	function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.getElementById(sObjectID);
		oMyObj2 = document.getElementById(sObjectID2);
		if(sFilterID=="2"){
			sParaString = "SortNo,<%=CurOrg.getSortNo()%>";
			sReturn =setObjectValue("SelectUserInOrg",sParaString,"",0,0,"");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				//oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				//oMyObj2.value=sReturns[0];
			}
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		//hideFilterArea();//收缩查询区域,默认是收缩的
		showFilterArea();//展开查询区域
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>