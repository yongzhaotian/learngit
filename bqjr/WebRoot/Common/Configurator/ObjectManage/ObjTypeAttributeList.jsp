<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 对象类型属性列表
	 */
	String PG_TITLE = "对象类型属性列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
    //获得页面参数	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if (sObjectType == null) sObjectType = "";
	
	String sTempletNo = "ObjTypeAttributeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
			
    
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
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("ObjTypeAttributeInfo","/Common/Configurator/ObjectManage/ObjTypeAttributeInfo.jsp","ObjectType=<%=sObjectType%>","");
        //修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ObjectManage/ObjTypeAttributeList.jsp?ObjectType="+sReturnValues[0],"_self","");           
            }
        }
	}
	
	function viewAndEdit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sAttributeID = getItemValue(0,getRow(),"AttributeID");
		if(typeof(sAttributeID)=="undefined" || sAttributeID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		sReturn=popComp("ObjTypeAttributeInfo","/Common/Configurator/ObjectManage/ObjTypeAttributeInfo.jsp","ObjectType="+sObjectType+"&AttributeID="+sAttributeID,"");
        //修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ObjectManage/ObjTypeAttributeList.jsp?ObjectType="+sReturnValues[0],"_self","");           
            }
        }
	}

	function deleteRecord(){
		var sAttributeID = getItemValue(0,getRow(),"AttributeID");
		if(typeof(sAttributeID)=="undefined" || sAttributeID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ObjectType");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>