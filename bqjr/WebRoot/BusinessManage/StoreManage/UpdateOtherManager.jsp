<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "部分转移";

	// 获得页面参数
	String sCity =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("City"));
	String oldSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNO"));
	String oldSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("oldSalesManager"));
	if(oldSalesManager == null) oldSalesManager = "";
	if(sCity == null) sCity = "";
	if(oldSNO == null) oldSNO = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "UpdateOtherManagerInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确定","确定","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","取消","取消 ","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

/*~[Describe=弹出单选框选择销售人员;InputParam=无;OutPutParam=无;]~*/
	function selectSalesmanSingle1() {
		sCity="<%=sCity%>";
		var sRetVal = setObjectValue("SelectSalesmanSingleByCity", "City,"+ sCity, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "SALESMANAGER", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME", sRetVal.split("@")[1]);
		return;
	}
	
	function selectSNO(){
		var sSalesManager = getItemValue(0,getRow(),"SALESMANAGER");	
		if (typeof(sSalesManager)=="undefined" || sSalesManager.length==0) {
			alert("请先选择一个销售经理！");
			return;
		}
		var sRetVal = setObjectValue("SelectStoreManager", "salesmanager ,"+ sSalesManager, "@SNOName@2", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择一个门店！");
			return;
		}
		setItemValue(0, 0, "SNO", sRetVal.split("@")[1]);
	}
	
	function saveRecord(sPostEvents){
		var newSNO = getItemValue(0,getRow(),"SNO");
		var sSalesManager = getItemValue(0,getRow(),"SALESMANAGER");
		if (typeof(newSNO)=="undefined" || newSNO.length==0) {
			alert("请先选择一个门店！");
			return;
		}
		
		sCompID = "ShowOldSalesMan";
		sCompURL = "/BusinessManage/StoreManage/ShowOldSalesMan.jsp";
	    popComp(sCompID,sCompURL,"OldSNO=<%=oldSNO%>&NewSNO="+newSNO+"&oldSalesManager=<%=oldSalesManager%>&newSalesManager="+sSalesManager,"dialogWidth=800px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		self.close();
	}
	
	function saveAndGoBack(){
		self.close();
	}
	
	function goBack(){
		
		//AsControl.OpenView("/BusinessManage/StoreManage/StoreList.jsp", "", "_self","");
		top.close();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			bIsInsert = true;
		}
		
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
