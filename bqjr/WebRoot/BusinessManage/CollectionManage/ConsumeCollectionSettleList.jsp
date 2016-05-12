<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "已结清催收列表";
 
	//获得页面参数
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));
	if(sPhaseType1==null) sPhaseType1="";
	

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ConsumeCollectionSettleList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setKeyFilter("CCI.SerialNO");
    
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	if(!doTemp.haveReceivedFilterCriteria()){
		   doTemp.WhereClause+=" and 1=2 ";
		}
	if(!sPhaseType1.equals("")){
		doTemp.WhereClause=sPhaseType1;
	}
     
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseType1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","历史查询","历史查询","viewHistory()",sResourcesPath},
	};
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//查看催收历史 
	function viewHistory(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ConsumeCollectionRegistList.jsp", "CustomerID="+sCustomerID+"&PhaseType1=<%=doTemp.WhereClause%>", "_self","");
		
	}
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		showFilterArea();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
