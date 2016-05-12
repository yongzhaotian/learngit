<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.accounting.tools.*" %>

<%
	String PG_TITLE = "功能组件列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>


<%
	//拿到主键参数
	String termType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermType"));
	if(termType == null)termType = "";
%>

<%	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "TermLibraryList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	//增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(termType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
%>



<%
	String sButtons[][] = {
		{"true","","Button","定义新组件","定义新组件","newRecord()",sResourcesPath},
		{"true","","Button","编辑组件","编辑组件","viewAndEdit()",sResourcesPath},		
		{"true","","Button","启用","启用","changeStatus(1)",sResourcesPath},
		{"true","","Button","停用","停用","changeStatus(2)",sResourcesPath},
		{"true","","Button","复制组件","复制组件","copyTerm()",sResourcesPath},
	};
%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>



<script language=javascript>

	function newRecord(){
		sReturn = AsControl.OpenView("/Accounting/Config/TermLibraryInfo.jsp","TermType=<%=termType%>&ObjectType=Term","_blank",OpenStyle);
		reloadSelf();
	}
	
	function changeStatus(status){
		sTermID = getItemValue(0,getRow(),"TermID");
		if(typeof(sTermID)=="undefined" || sTermID==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@Status@"+status+",PRODUCT_TERM_LIBRARY,String@ObjectType@Term@String@TermID@"+sTermID);
		reloadSelf();
	}
	
	function copyTerm(){
		var termID = getItemValue(0,getRow(),"TermID");
		var termName = getItemValue(0,getRow(),"TermName");
		if(typeof(termID)=="undefined" || termID==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var returnValue = PopPage("/Accounting/Config/CopyTermDialog.jsp","","resizable=yes;dialogWidth=20;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
			returnValue=returnValue.split("@");
			sReturn = RunMethod("ProductManage","CopyTerm","copyTerm,"+returnValue[0]+","+returnValue[1]+","+termID);
			reloadSelf();
		}
	}
	
	function viewAndEdit(){
		termID = getItemValue(0,getRow(),"TermID");
		SetFlag = getItemValue(0,getRow(),"SetFlag");
		if(typeof(termID)=="undefined" || termID==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(SetFlag=="BAS"||SetFlag=="SEG") {
			AsControl.OpenView("/Accounting/Config/TermLibraryInfo.jsp","ObjectNo="+termID+"&ObjectType=Term&TermID="+termID,"_blank",OpenStyle);
		}else{
			AsControl.OpenView("/Accounting/Config/TermLibraryInfo2.jsp","ObjectNo="+termID+"&ObjectType=Term&TermID="+termID,"_blank",OpenStyle);
		}
        reloadSelf();
	}
</script>



<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	

<%@ include file="/IncludeEnd.jsp"%>
