<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 决策流模型列表
	 */
	String PG_TITLE = "决策流模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
    //获得组件参数	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
    if (sModelNo == null)	sModelNo = "";

 	
 	//通过DW模型产生ASDataObject对象doTemp
 	String sTempletNo = "ClassifyModelList";//模型编号
 	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
 		
	//查询
 //	doTemp.setColumnAttribute("ModelNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("ClassifyModelInfo","/Common/Configurator/ClassifyManage/ClassifyModelInfo.jsp","ModelNo=<%=sModelNo%>","");
        //修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ClassifyManage/ClassifyModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
	function viewAndEdit(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		var sGroupNo = getItemValue(0,getRow(),"GroupNo");
		var sConditionNo = getItemValue(0,getRow(),"ConditionNo");
		var sStatus = getItemValue(0,getRow(),"Status");
       if(typeof(sGroupNo)=="undefined" || sGroupNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		sReturn=popComp("ClassifyModelInfo","/Common/Configurator/ClassifyManage/ClassifyModelInfo.jsp","ModelNo="+sModelNo+"~GroupNo="+sGroupNo+"~ConditionNo="+sConditionNo+"~Status="+sStatus,"");
        //修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ClassifyManage/ClassifyModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	function deleteRecord(){
		var sGroupNo = getItemValue(0,getRow(),"GroupNo");
		if(typeof(sGroupNo)=="undefined" || sGroupNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>