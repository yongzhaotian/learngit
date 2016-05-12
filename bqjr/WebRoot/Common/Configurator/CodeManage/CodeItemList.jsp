<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 代码表列表
		Input Param:
                    CodeNo：    代码表编号
	 */
	String PG_TITLE = "代码表列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));   
	if(sCodeNo==null) sCodeNo="";
	String sCodeName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeName"));   
	if(sCodeName==null) sCodeName="";
	String sDiaLogTitle = "【"+sCodeName+"】代码：『"+sCodeNo+"』配置";

	
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CodeItemList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(sCodeNo!=null && !sCodeNo.equals("")){
		doTemp.WhereClause+=" And CodeNo='"+sCodeNo+"'";
	}
	/*
	else{
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause  += " And 1=2";
	}
	*/
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateCodeCatalogUpdateTime("+StringFunction.getTodayNow()+","+CurUser.getUserID()+",#CodeNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql);

	String sButtons[][] = {
		{(sCodeNo.equals("")?"false":"true"),"","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},		
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
       sReturn=popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","");
       if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //新增数据后刷新列表
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				reloadSelf();
            }
        }
	}
	
	function viewAndEdit(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
        
       popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeName=<%=sCodeName%>&CodeNo="+sCodeNo+"~ItemNo="+sItemNo,"");
		reloadSelf();
	}
	
	function deleteRecord(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
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
	my_load(2,0,'myiframe0');
	ssCodeNo = "<%=sCodeNo%>"
	if(typeof(ssCodeNo)=="undefined" || ssCodeNo.length==0){
    //因sCodeNo 空时，页面未调用模态窗口 Remark by wuxiong 2005-02-23
	}else{
     	setDialogTitle("<%=sDiaLogTitle%>");
    }
//add by byhu 默认显示filter区，查询后不显示
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>
</script>
<%@ include file="/IncludeEnd.jsp"%>
