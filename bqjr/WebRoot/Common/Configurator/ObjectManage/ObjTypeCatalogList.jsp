<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 对象类型目录列表
	 */
	String PG_TITLE = "对象类型目录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
 	
	String sTempletNo = "ObjTypeCatalogList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","1+!Configurator.DelObjTypeRelative(#ObjectType)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"false","","Button","保存","查看/修改详情","as_save('myiframe0')",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","对象类型层级列表","查看/修改对象类型层级列表","viewAndEdit2()",sResourcesPath},
		{"false","","Button","对象属性列表","查看/修改对象属性列表","viewAndEdit3()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("ObjTypeCatalogInfo","/Common/Configurator/ObjectManage/ObjTypeCatalogInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/ObjectManage/ObjTypeCatalogList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       popComp("ObjectTypeView","/Common/Configurator/ObjectManage/ObjTypeCatalogView.jsp","ObjectNo="+sObjectType,"");
	}
    
    /*~[Describe=查看及修改对象类型层级列表;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       popComp("ObjTypeLevelList","/Common/Configurator/ObjectManage/ObjTypeLevelList.jsp","ObjectType="+sObjectType,"");
	}

    /*~[Describe=查看及修改对象属性列表;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit3(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		popComp("ObjTypeAttributeList","/Common/Configurator/ObjectManage/ObjTypeAttributeList.jsp","ObjectType="+sObjectType,"");
	}
	
	function deleteRecord(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>