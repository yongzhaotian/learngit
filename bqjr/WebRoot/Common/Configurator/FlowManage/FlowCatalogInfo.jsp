<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    流程模型信息详情
	 */
	String PG_TITLE = "流程模型信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	FlowNo：流程编号
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	if(sFlowNo==null) sFlowNo="";
   	
   	String sTempletNo = "FlowCatalogInfo";
   	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	function saveRecord(){
       var sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1"){ //是否进行授权设置
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0){
				alert("请选择授权方案！"); 
				return;
			}
		}else{
			//将所填写的授权方案置为空字符串
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
		
		if(beforeSave() == false && bIsInsert){
			alert("该流程编号已经被占用,请输入新的编号");
			return;
		}
		bIsInsert = false;
       as_save("myiframe0","");
	}
    
	function saveRecordAndAdd(){
       var sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1"){ //是否进行授权设置
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0){
				alert("请选择授权方案！"); 
				return;
			}
		}else{
			//将所填写的授权方案置为空字符串
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
       as_save("myiframe0","newRecord()");        
	}
	
	/*~[Describe=检验插入数据唯一性;InputParam=;OutPutParam=是否有记录;]~*/
    function beforeSave()
    {
    	var flowNo  = getItemValue(0,getRow(),"FlowNo");
    	
		var sPara = "FlowNo=" + flowNo + ", TableName=FLOW_CATALOG";
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.process.action.FlowNoUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }
    
	function newRecord(){
        OpenComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","_self","");
	}

	function goBack(){
		AsControl.OpenView("/Common/Configurator/FlowManage/FlowCatalogList.jsp","","_self");
	}
	
	/*~[Describe=弹出授权方案选择窗口;InputParam=无;OutPutParam=无;]~*/
	function getPolicyID(){
		var sParaString = "Today"+",<%=StringFunction.getToday()%>";
		setObjectValue("SelectPolicy",sParaString,"@AAPolicy@0@AAPolicyName@1",0,0,"");
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