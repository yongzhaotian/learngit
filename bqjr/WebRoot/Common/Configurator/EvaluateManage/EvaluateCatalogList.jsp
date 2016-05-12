<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 评估模型目录列表
	 */
	String PG_TITLE = "评估模型目录列表";

	//获得组件参数	
	String sType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	if(sType == null) sType = "";	 
	 
	String sTempletNo = "EvaluateCatalogList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//模型类型参见代码EvaluateModelType
		if(sType.equals("Classify")) //资产风险分类
			doTemp.WhereClause += " Where ModelType = '020' ";
		if(sType.equals("Risk")) //风险度评估
			doTemp.WhereClause += " Where ModelType = '030' ";	
		if(sType.equals("CreditLine")) //最高综合授信额度参考
			doTemp.WhereClause += " Where ModelType = '080' ";
		if(sType.equals("CreditLevel")) //信用等级评估	(公司客户和个人)
			doTemp.WhereClause += " Where (ModelType ='010' or ModelType = '015') ";	
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
	
	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelEvaluateModel(#ModelNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"false","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","模型列表","查看/修改模型列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    var sCurCodeNo=""; //记录当前所选择行的代码号

	function newRecord(){
		var sReturn=popComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
              if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
                    OpenPage("/Common/Configurator/EvaluateManage/EvaluateCatalogList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=查看及修改详情;]~*/
	function viewAndEdit(){
        var sModelNo = getItemValue(0,getRow(),"ModelNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        //openObject("EvaluateCatalogView",sModelNo,"001");
        popComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","ModelNo="+sModelNo);
	}
    
    /*~[Describe=查看/修改模型列表;]~*/
	function viewAndEdit2(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		popComp("EvaluateModelList","/Common/Configurator/EvaluateManage/EvaluateModelList.jsp","ModelNo="+sModelNo,"");
	}

	function deleteRecord(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
       if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('50'))){
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