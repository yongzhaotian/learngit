<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 财务报表模型列表
	 */
	String PG_TITLE = "财务报表模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if (sModelNo == null) 	sModelNo = "";
	
	String sTempletNo = "ReportModelList"; //模版编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    doTemp.appendHTMLStyle("Col1Def,Col2Def,Col3Def,Col4Def","style=\"cursor: pointer;\" onDBLClick=\"parent.myDBLClick(this)\"");
	//doTemp.appendHTMLStyle("RowSubjectName","style=\"cursor: pointer;\" onDBLClick=\"parent.SelectSubject()\"");
	
	//查询
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(50);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","生成/更新公式解释","公式的中文解释生成/更新到formulaexp字段中","genExplain()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("ReportModelInfo","/Common/Configurator/ReportManage/ReportModelInfo.jsp","ModelNo=<%=sModelNo%>","");
        //修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ReportManage/ReportModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}
    
	function saveRecord(){
		as_save("myiframe0","");
	}

	function myDBLClick(myobj){
        editObjectValueWithScriptEditorForAFS(myobj,'<%=sModelNo%>');
    }

	function viewAndEdit(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		var sRowNo = getItemValue(0,getRow(),"RowNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		sReturn=popComp("ReportModelInfo","/Common/Configurator/ReportManage/ReportModelInfo.jsp","ModelNo="+sModelNo+"&RowNo="+sRowNo,"");
        //修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ReportManage/ReportModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	function deleteRecord(){
		var sRowNo = getItemValue(0,getRow(),"RowNo");
		if(typeof(sRowNo)=="undefined" || sRowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	function genExplain(){
		var sReturn = RunMethod("Configurator","GenFinStmtExplain","<%=sModelNo%>");
		if(typeof(sReturn)!="undefined" && sReturn=="succeeded"){
			alert("已将公式的中文解释生成/更新到formulaexp1、formulaexp2字段中。");
		}else{
			alert(sReturn);
		}
	}

	function SelectSubject(){
		setObjectValue("SelectAllSubject","","@RowSubject@0@RowSubjectName@1",0,0,"");			
	}
	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>