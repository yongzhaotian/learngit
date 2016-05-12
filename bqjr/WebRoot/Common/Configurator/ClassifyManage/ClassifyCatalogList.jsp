<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 决策流模型目录列表
	 */
	String PG_TITLE = "决策流模型目录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	

 	//通过DW模型产生ASDataObject对象doTemp
 	String sTempletNo = "ClassifyCatalogList";//模型编号
 	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
 	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
   	dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelClassifyModel(#ModelNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","模型列表","查看/修改模型列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("ClassifyCatalogInfo","/Common/Configurator/ClassifyManage/ClassifyCatalogInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
  	    	//新增数据后刷新列表
  	    	if (typeof(sReturn)!='undefined' && sReturn.length!=0){
    	    	sReturnValues = sReturn.split("@");
    	    	if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
    	    	    OpenPage("/Common/Configurator/ClassifyManage/ClassifyCatalogList.jsp","_self","");    
    	    	}
  	    	}
       	}
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       //openObject("ClassifyCatalogView",sModelNo,"001");
       popComp("ClassifyCatalogView","/Common/Configurator/ClassifyManage/ClassifyCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0010","");
	}
    
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
          	return ;
		}
       //popComp("ClassifyModelList","/Common/Configurator/ClassifyManage/ClassifyModelList.jsp","ModelNo="+sModelNo,"");
       popComp("ClassifyCatalogView","/Common/Configurator/ClassifyManage/ClassifyCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0020","");
	}

	function deleteRecord(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('51'))){
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