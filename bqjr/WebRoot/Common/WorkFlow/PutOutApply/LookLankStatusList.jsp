<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
 
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	
	//通过DW模型产生ASDataObject对象doTemp
	
		String sHeaders[][] = { 	
			{"contractNo","合同号"},
			{"customerName","客户名称"},
			{"inputuser","更改人"},
			{"eventtime","更改时间"},
			{"oldvalue","更改前地标"},
			{"newvalue","更改后地标"}
		   }; 

	 String sSql ="select contractNo,customerName, getusername(inputuser) as inputuser , eventtime,getItemName('LandMarkStatus',oldvalue) as oldvalue,getItemName('LandMarkStatus',newvalue) as newvalue from event_info  where type='050'";
	
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);//新增模型：2013-5-9
	 doTemp.setHeader(sHeaders);	
	 doTemp.setKey("serialNo", true);	 
	 doTemp.setColumnAttribute("contractNo,customerName","IsFilter","1");
	 doTemp.setColumnAttribute("eventtime","IsFilter","1");
	 doTemp.setCheckFormat("eventtime","3");
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

	String sButtons[][] = {
			{"true","","Button","返回","返回","back()",sResourcesPath},
			{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},

	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function back(){
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/ContrackRegistrationList.jsp","doWhere=<%=sDoWhere%>","right","");
		
	}
	
	//Excel导出功能呢	
	function exportExcel(){
		amarExport("myiframe0");
	}
	//end by pli2 20140417	
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
