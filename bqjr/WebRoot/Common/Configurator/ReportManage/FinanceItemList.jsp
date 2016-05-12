<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 财务科目列表
	 */
	String PG_TITLE = "财务科目列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sTempletNo = "FinanceItemList"; //模版编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//查询
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(50);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	/*
	String sCriteriaAreaHTML = "<table><form action=''><tr>"
		+"<input type=hidden name=CompClientID value='"+sCompClientID+"'>"
		+"<td>CodeNo:</td><td><input type=text name=CodeNo value='"+sCodeNo+"'></td> "
		+"<td>CodeName:</td><td><input type=text name=CodeName value='"+sCodeName+"'></td> "
		+"<td><input type=submit value=查询></td>"
		+"</tr></form></table>"; 
	*/

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("FinanceItemInfo","/Common/Configurator/ReportManage/FinanceItemInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/ReportManage/FinanceItemList.jsp","_self","");    
                }
            }
        }
	}
	
	function viewAndEdit(){
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		sReturn=popComp("FinanceItemInfo","/Common/Configurator/ReportManage/FinanceItemInfo.jsp","ItemNo="+sItemNo,"");
	}

	function deleteRecord(){
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>