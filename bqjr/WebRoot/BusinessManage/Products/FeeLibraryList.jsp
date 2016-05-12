<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.accounting.web.*" %>

<%
	String PG_TITLE = "费用维护列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>

<%
	//获取参数
	
	String ObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(ObjectType == null) ObjectType = "";
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("typeNo"));
	if(sTypeNo == null) sTypeNo = "";
%>

<%	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "FeeLibraryList";
	String sTempletFilter = "1=1";
	String znjcount = "";
	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	if(sTypeNo.length() != 0 ){
		ObjectType = "Product";
		doTemp.WhereClause += " and objectno='"+sTypeNo+"-V1.0' and TermId not in('N100','N200') ";
		doTemp.setColumnAttribute("SubTermType,Status1","IsFilter","0");
		//获取产品关联的滞纳金
		 znjcount = Sqlca.getString(new SqlObject("SELECT count(*) FROM product_term_library where subtermtype = 'A10' and objectno='"+sTypeNo+"-V1.0' "));
	}
	//增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(ObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	String userid = CurUser.getUserID();
	String OperateUserID = CurOrg.getOrgID();
%>

<%
	String sButtons[][] = {
		//{"true","","Button","复制费用","复制组件复制","copyTerm()",sResourcesPath},
		{"true","","Button","新增费用","新增费用","newRecord()",sResourcesPath},
		{"true","","Button","费用详情","费用详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","移除费用","移除费用","",sResourcesPath},
		{"true","","Button","启用","启用","changeStatus(1)",sResourcesPath},
		{"true","","Button","停用","停用","changeStatus(2)",sResourcesPath},
		{"false","","Button","导入费用","导入费用","impFeeByProduct()",sResourcesPath},
		{"false","","Button","导入滞纳金","移除费用","impFeeByCPD()",sResourcesPath},
		{"false","","Button","移除费用","移除费用","deleteRecord()",sResourcesPath},

	};

		if(!sTypeNo.equals("")){
			sButtons[0][0]="false";
			//sButtons[1][0]="false";
			sButtons[2][0]="false";
			sButtons[3][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="true";
			sButtons[6][0]="true";
			sButtons[7][0]="true";
		}
%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>
	 //引入费用
	function impFeeByProduct(){
		sParaString = "ObjectNo"+","+"<%=sTypeNo%>";
		sReturn = setObjectValue("SelectFeeTermLibray",sParaString,"",0,0,"");
		
		if(typeof(sReturn) != "undefined" && sReturn.length != 0)
		{
			var feeList = sReturn.split("@");
			for(var i = 0;i < feeList.length-1;i++){
				var termID = feeList[i];
				<%-- RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+termID); --%>
				RunMethod("ProductManage","CDPFeeManage","<%=sTypeNo%>,V1.0,"+termID);
			}
		}
	    reloadSelf();
	}
	
	//导入滞纳金
	function impFeeByCPD(){
		var znjcount = "<%=znjcount%>";
		if(parseInt(znjcount, 10)>0){
			alert("已经有滞纳金配置，要引入新的滞纳金请先移除现有的滞纳金！！");
			return;
		}
		//sReturn = setObjectValue("SelectFeeTermLibray","","",0,0,"");
		sReturn = setObjectValue("SelectFeeCPDlibrary","","",0,0,"");
		
		if(typeof(sReturn) != "undefined" && sReturn.length != 0){
			//termid@subtermtype@activedate@closedate
			var sTypeArry = sReturn.substring(0, sReturn.length-1).split("@");
			
			var x = parseInt(sTypeArry.length, 10)/4;
			var i = 0;
			for (var j = 0; j < x ; j++) {
				var sFeeTermID = sTypeArry[i];
				var sSubTermType = sTypeArry[i+1];
				var sActivedate = sTypeArry[i+2];
				var sClosedate = sTypeArry[i+3];
				//alert(sFeeTermID+","+sSubtermtype+","+sActivedate+","+sClosedate);
				i = i+4;
				
			 	var returnvalue = RunMethod("ProductManage","CDPFeeManage","<%=sTypeNo%>,V1.0,"+sFeeTermID+","+sSubTermType+",<%=userid%>,<%=OperateUserID%>");
				if(!returnvalue=="true"){
					alert("滞纳金导入错误！");
				}
			}
		}
	 reloadSelf();
	}
	
	//移除费用
	function deleteRecord(){
		var termID = getItemValue(0, getRow(), "TermID");
		var sSubtermtype = getItemValue(0, getRow(), "FeeType");
		if (typeof(termID)=="undefined" || termID.length==0){
			alert("请选择一条记录！");
			return;
		}
		RunMethod("ProductManage","UpdateProductTerm","deleteTermFromProduct,<%=sTypeNo%>,V1.0,"+termID);
		if("A10"==sSubtermtype){
			RunMethod("PublicMethod","UpdateColValue","String@isinuse@2,CODE_LIBRARY,String@CODENO@DelayFine@String@ITEMNO@"+"<%=sTypeNo%>"+"@String@attribute1@"+termID);//更新为不可用
		}
		
		 reloadSelf();
	}

	//新增费用
	function newRecord(){
		sCompID = "CostType";
		sCompURL = "/BusinessManage/Products/CostTypeInfo.jsp";
	    popComp(sCompID,sCompURL," ","dialogWidth=350px;dialogHeight=430px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	//定义费用
	function viewAndEdit(){
		termID = getItemValue(0,getRow(),"TermID");
		sFeeType = getItemValue(0,getRow(),"FeeType");
		sTypeNo = "<%=sTypeNo%>";
		if(typeof(termID)=="undefined" || termID==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsControl.OpenView("/BusinessManage/Products/FeeLibraryInfo.jsp","typeNo="+sTypeNo+"&ObjectNo="+termID+"&ObjectType=Term&TermID="+termID+"&FeeType="+sFeeType,"_blank",OpenStyle);
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
	
/* 	function copyTerm(){
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
	} */

</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	if("<%=sTypeNo%>"==""){
		showFilterArea();
	}
	
</script>	

<%@ include file="/IncludeEnd.jsp"%>
