<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 格式化报告定义列表
	 */
	String PG_TITLE = "格式化报告定义列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数	
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocID"));
	if(sDocID == null) sDocID = "";
	
	String[][] sHeaders={
			{"DocID","报告编号"},
			{"DirID","节点编号"},
			{"DirName","节点名称"},
			{"JspFileName","JSP文件"},
		};

	String sSql =  " select DocID,DirID,DirName,JspFileName from FormatDoc_Def where 1=1";
	if (!sDocID.equals("")){
		sSql += " and DocID='"+sDocID+"'";
	}
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Def";
	doTemp.setKey("DocID,DirID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DocID,DirID"," style={width:50px} ");
	doTemp.setHTMLStyle("DirName,JspFileName"," style={width:180px} ");

	//查询
 	doTemp.setColumnAttribute("DocID,DirID,DirName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	doTemp.OrderClause = "Order by DocID,DirID asc";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("FormatdocDefInfo","/Common/Configurator/FormatDocManage/FormatdocDefInfo.jsp","DocID=<%=sDocID%>","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/FormatDocManage/FormatdocDefList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		var sDirID = getItemValue(0,getRow(),"DirID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       //openObject("FlowCatalogView",sFlowNo,"001");
       popComp("FormatdocDefInfo","/Common/Configurator/FormatDocManage/FormatdocDefInfo.jsp","DocID="+sDocID+"&DirID="+sDirID,"");
	}

	function deleteRecord(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('68'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>