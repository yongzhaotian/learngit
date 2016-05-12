<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 对查询条件进行处理，并且显示数据窗口
		Input Param:
	           --StatResult:结果类型
	                        1--汇总查询
	                        2--明细查询
	           --querySql：  查询语句
	 */
	String PG_TITLE = "查询结果显示"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	String argumentString="";//--合计字段的列
	String sumString2="";//--各个计算列
	String sumString1="";//--汇总列
	String argumentValue="100";//--汇总参数的值

	//获得组件参数	，传入要执行的sql语句、表头、查询类型
	String querySql   =DataConvert.toRealString(iPostChange,(String)session.getAttribute("querySql"));
	String[][] header = (String[][])session.getAttribute("header");
	String sStatResult = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("StatResult")).trim();

	String sNumberString="",sSumString="",sUnVisibleString=""; 
	XQuery xQuery = (XQuery)session.getAttribute("XQuery");
	Vector vColumn=xQuery.getAllColumnsList();
	for(int ii=0;ii<vColumn.size();ii++){
		String[] sColumn=(String[])vColumn.get(ii);
		if(sColumn[6].equals("NUMBER")||sColumn[6].equals("NUMBERSCOPE")){
			//sNumberString+=sColumn[3]+",";
			
			if(sColumn[4]!=null && sColumn[4].length()>0){
				sNumberString+=sColumn[4]+",";		//有别名则取别名,与header保持一致
			}else{
				sNumberString+=sColumn[3]+",";
			}
		}
		if(sColumn[9].length()>0){
			if(sColumn[4].length()==0)
				sUnVisibleString+=sColumn[3]+",";
			else
				sUnVisibleString+=sColumn[4]+",";
		}
		if(xQuery.availableSummaryColumns.indexOf("."+sColumn[3])>=0){
			sSumString+=sColumn[3]+",";
		}
	}

	if(sNumberString.length()>=2) sNumberString=sNumberString.substring(0,sNumberString.length()-1);
	if(sSumString.length()>=2) sSumString=sSumString.substring(0,sSumString.length()-1);
	if(sUnVisibleString.length()>=2) sUnVisibleString=sUnVisibleString.substring(0,sUnVisibleString.length()-1);
  // out.print(querySql);
	ASDataObject doTemp = new ASDataObject(querySql);
	doTemp.setHeader(header);
	
	if(sStatResult.equals("1")){//汇总查询
		argumentString = (String)session.getAttribute("Arguments");
		sumString2     = (String)session.getAttribute("sumString2");
		sumString1     = (String)session.getAttribute("sumString1");
		argumentValue  = (String)session.getAttribute("argumentValue");
		doTemp.Arguments= argumentString;
		doTemp.setAlign(sumString2,"3");
		doTemp.setColumnType("Sum0,"+sumString1,"2");
		doTemp.setType("Sum0,"+sumString2,"Number");
		doTemp.setCheckFormat(sumString2,"2");
	}
	//设number类型的内容
	if(!sNumberString.equals("")){
		doTemp.setAlign(sNumberString,"3");
		doTemp.setType(sNumberString,"Number");
		doTemp.setCheckFormat(sNumberString,"2");
	}
	//doTemp.setColumnType(sSumString,"2");
	doTemp.setCheckFormat("ERate","14");
	doTemp.setVisible(sUnVisibleString,false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";
	dwTemp.ShowSummary="1";//设置合计列
	dwTemp.setPageSize(40);
	Vector vTemp = dwTemp.genHTMLDataWindow(argumentValue);
	for(int i = 0;i < vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql);

	String sButtons[][] = {
			{"false","","Button","查看客户详情","查看客户详情","my_CustomerInfo()",sResourcesPath},
			{"false","","Button","查看业务详情","查看合同的详细信息","my_ContractInfo()",sResourcesPath},
			{"true","","Button","转出至电子表格","转出至电子表格","saveResult()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=查看客户详情;]~*/
	function my_CustomerInfo(){
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
		}else{
			openObject("Customer",sCustomerID,"002");
		}
	}
   /*~[Describe=查看业务详情;]~*/
	function my_ContractInfo(){

	}
   /*~[Describe=转出电子表格;]~*/
	function saveResult(){
		amarExport("myiframe0");
	}

	AsOne.AsInit();
	init();
	//init_show();
	my_load(1,0,'myiframe0');
	//my_load_show(1,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>