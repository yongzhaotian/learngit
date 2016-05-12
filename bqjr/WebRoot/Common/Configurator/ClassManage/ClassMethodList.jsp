<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:类及方法列表
	 */
	String PG_TITLE = "类及方法列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
    //获得组件参数	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassName"));
    if (sClassName == null) sClassName = "";
 
//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ClassMethodList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//查询
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(sClassName!=null && !sClassName.equals("")){
		doTemp.WhereClause  += " And ClassName='"+sClassName+"'";
	}
	/*
	else{
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause  += " And 1=2";
	}*/
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelClassMethod(#ClassName)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(sClassName.equals("")?"false":"true"),"","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var sCurCodeNo=""; //记录当前所选择行的代码号

	function newRecord(){
		sReturn=popComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","","");
		reloadSelf();
	}
	
	function viewAndEdit(){
       var sClassName = getItemValue(0,getRow(),"ClassName");
       var sMethodName = getItemValue(0,getRow(),"MethodName");
       if(typeof(sClassName)=="undefined" || sClassName.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
    	popComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","ClassName="+sClassName+"&MethodName="+sMethodName,"");
		reloadSelf();
	}
    
	function saveRecord(){
		as_save("myiframe0","");
	}

    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2(){
       var sClassName = getItemValue(0,getRow(),"ClassName");
       var sClassDescribe = getItemValue(0,getRow(),"ClassDescribe");
       if(typeof(sClassName)=="undefined" || sClassName.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
	    popComp("ClassMethodList","/Common/Configurator/ClassManage/ClassMethodList.jsp","ClassName="+sClassName+"&ClassDescribe="+sClassDescribe,"");        
	}

	function deleteRecord(){
		var sClassName = getItemValue(0,getRow(),"ClassName");
       if(typeof(sClassName)=="undefined" || sClassName.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('54'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>