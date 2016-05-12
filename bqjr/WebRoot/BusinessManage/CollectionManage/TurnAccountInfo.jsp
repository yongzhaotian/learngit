<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "贷款人归集账户页面";

	// 获得页面参数
	String sSerialNoS =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNoS"));
	String sAreaCodes =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaCodes"));
	String sProductTypes =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductTypes"));
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
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "TurnAccountInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNoStr+","+sAreaCodeStr+","+sProductTypeStr);//传入参数,逗号分割
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
		var sTurnAccountNumber = getItemValue(0,getRow(),"turnAccountNumber");
		var sTurnAccountName = getItemValue(0,getRow(),"turnAccountName");
		var sTurnAccountBlank = getItemValue(0,getRow(),"turnAccountBlank");
		var sBackAccountPrefix = getItemValue(0,getRow(),"backAccountPrefix");
		var sSubBankName = getItemValue(0,getRow(),"SubBankName");
		
		var params = "serialNoS=" + sSerialNoS + ",areaCodes=" + sAreaCodes 
				+ ",productTypes=" + sProductTypes + ",turnAccountNumber=" + sTurnAccountNumber
				+ ",turnAccountName=" + sTurnAccountName + ",turnAccountBlank=" + sTurnAccountBlank
				+ ",backAccountPrefix=" + sBackAccountPrefix + ",subBankName=" + sSubBankName;
		
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.TurnAccountSave", 
				"saveBank", params);
		
		if(!vI_all("myiframe0")){
			return;
		}if (result.split("@")[0] != "true") {
			alert(result.split("@")[1]);
			return;
		} else {
			alert("保存成功！");
			reloadSelf();
			self.close();
			return;
		}
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		self.close();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");// 获取流水号
		setItemValue(0,getRow(),"ExampleID",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
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
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		//initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
