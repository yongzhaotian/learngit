<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 数据对象列表
	 */
	String PG_TITLE = "数据对象列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获得组件参数	：代码表编号、编辑权限
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
   	String sEditRight =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if (sDoNo == null) sDoNo = "";
	if (sEditRight == null) sEditRight = "";
	
	String sTempletNo="DOLibraryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
	if(!sDoNo.equals("")){
		doTemp.WhereClause += " and DoNo = '"+sDoNo+"' ";
	} 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(22);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
   	//产品管理联接过来的就屏蔽这些功能
   	if(sEditRight.equals("01")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
    }
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("DOLibraryInfo","/Common/Configurator/DataObject/DOLibraryInfo.jsp","DoNo=<%=sDoNo%>","");
		reloadSelf();
        //新增数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/DataObject/DOLibraryList.jsp?DoNo="+sReturnValues[0],"_self","");    
            }
         }
	}
	
	function viewAndEdit(){
		var sDoNo = getItemValue(0,getRow(),"DoNo");
		var sColIndex = getItemValue(0,getRow(),"ColIndex");
       if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
        
       sReturn=popComp("DOLibraryInfo","/Common/Configurator/DataObject/DOLibraryInfo.jsp","DoNo="+sDoNo+"~ColIndex="+sColIndex,"");
       reloadSelf();
        //修改数据后刷新列表
       if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
                OpenPage("/Common/Configurator/DataObject/DOLibraryList.jsp?DoNo="+sReturnValues[0],"_self","");    
            }
        }
	}
	
	function deleteRecord(){
		var sDoNo = getItemValue(0,getRow(),"DoNo");
       if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
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
</script>	
<%@ include file="/IncludeEnd.jsp"%>