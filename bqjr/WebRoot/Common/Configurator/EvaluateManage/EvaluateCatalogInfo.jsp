<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    评估模型目录详情
	 */
	String PG_TITLE = "评估模型目录详情";
	
	//获得组件参数	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if(sModelNo==null) sModelNo="";
	
	String sTempletNo = "EvaluateCatalogInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if (!sModelNo.equals("")){
		doTemp.setReadOnly("ModelNo",true);
	}else{
		doTemp.setRequired("ModelNo",true);
	}
	
 	//filter过滤条件
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
		{"true","","Button","转换方法美化","转换方法美化","my_formatIF()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","self.close();");
	}
	function saveRecordAndBack(){
       as_save("myiframe0","doReturn('Y');");
	}

	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");
	}
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function newRecord(){
        OpenComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","","_self","");
	}

	function my_formatIF(){
		try{
			var sValue = getItemValue(0,getRow(),"TransformMethod");
			sValue = sValue.replace(/\r\nif/g,"if"); 
			sValue = sValue.replace(/if/g,"\r\nif"); 
			sValue = sValue.replace("\r\n",""); 
			setItemValue(0,getRow(),"TransformMethod",sValue);	
		} catch(e){}	
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
		    bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>