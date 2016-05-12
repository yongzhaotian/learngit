<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "配置格式化报告文档页面";

	// 获得页面参数
	String sSerialNoS =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNoS"));
	String sAreaCodes =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaCodes"));
	String sProductTypes =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductTypes"));
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeNo"));

	String sSerialNoStr = "";
	String sAreaCodeStr = "";
	String sProductTypeStr = "";
	if(sSerialNoS==null){
		sSerialNoS="";
	}else{
		sSerialNoStr = sSerialNoS.split(",")[0];
	}
	if(sAreaCodes==null){
		sAreaCodes="";
	}else{
		sAreaCodeStr = sAreaCodes.split(",")[0];
	}
	if(sProductTypes==null){
		sProductTypes="";
	}else{
		sProductTypeStr = sProductTypes.split(",")[0];
	}
	
	String sSerialNo = sSerialNoStr+sAreaCodeStr+sProductTypeStr;
	ARE.getLog().info("流水号：===============sSerialNo： "+sSerialNo);
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "LoanManEDocInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sTypeNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		var sSerialNoS = "<%=sSerialNoS%>";
		var sAreaCodes = "<%=sAreaCodes%>";
		var sProductTypes = "<%=sProductTypes%>";
		if(sSerialNoS=="" || sAreaCodes=="" || sProductTypes==""){
			return;
		}
		var sSerialNoArr = sSerialNoS.split(",");
		var sAreaCodeArr = sAreaCodes.split(",");
		var sProductTypeArr = sProductTypes.split(",");
		var sSpSerialNo = "";
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sDocID = getItemValue(0,getRow(),"DocID");
		var sBeginTime = getItemValue(0,getRow(),"BeginTime");
		var sEndTime = getItemValue(0,getRow(),"EndTime");
		var sinputUser = getItemValue(0,getRow(),"inputUser");
		var sinputDate = getItemValue(0,getRow(),"inputDate");
		
		if(!dateCompare()){
			return;
		}
		if(!vI_all("myiframe0")){
			return;
		}

		for(var i=0;i<sAreaCodeArr.length;i++){
			sSpSerialNo = sSerialNoArr[i]+sAreaCodeArr[i]+sProductTypeArr[i];
			RunMethod( "LoanAccount", "deleteFormatdoc", "SpSerialNo='"+sSpSerialNo+"' and BusinessType='"+sBusinessType+"'");
			RunMethod( "LoanAccount", "insertFormatDocVersion", sSpSerialNo+","+sBusinessType+","+sDocID+","+sBeginTime+","+sEndTime+","+sinputUser+","+sinputDate);
			RunMethod( "公用方法", "UpdateColValue", "ProvidersCity,SpSerialNo,"+sSpSerialNo+",SerialNo='"+sSerialNoArr[i]+"' and AreaCode='"+sAreaCodeArr[i]+"' and ProductType='"+sProductTypeArr[i]+"'");//更新贷款人城市中间表的模版关联编号
		}
		
		alert("保存成功！");
		window.close();
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	//获取模板编号
	 function getDocID(){
		var sTypeNo = getItemValue(0,getRow(),"BusinessType");
		var sRetVal = setObjectValue("selectFormatdocCatalog", "TypeNo,"+sTypeNo, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("请选择关联模版！");
			return;
		}
		setItemValue(0,0,"DocID",sRetVal.split("@")[0]);
		setItemValue(0,0,"DocName",sRetVal.split("@")[1]);
	} 
	
	 function dateCompare() {
			
			var sStartTime = getItemValue(0, 0, "BeginTime");
			var sEndTime = getItemValue(0, 0, "EndTime");
			if(typeof(sStartTime)=="undefined" || sStartTime.length==0){
				alert("请先选择生效时间！");
				return false;
			}
			if ((sEndTime.localeCompare(sStartTime)<=0)&&!(typeof(sEndTime)=="undefined" || sEndTime.length==0)) {
				alert("失效时间必须大于生效时间！");
				return false;
			}
			return true;
		}
	 
	function goBack(){}


	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"SpSerialNo","<%=sSerialNo%>");
		setItemValue(0,0,"BusinessType","<%=sTypeNo%>");
		var sBusinessType = getItemValue(0, 0, "BusinessType");
		var sDOCName = RunMethod("公用方法", "GetColValue", "Formatdoc_Type,typetitle,TypeNo='"+sBusinessType+"'");
		setItemValue(0,0,"BusinessTypeName",sDOCName);
		setItemValue(0,0,"inputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"inputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			beforeInsert();
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
