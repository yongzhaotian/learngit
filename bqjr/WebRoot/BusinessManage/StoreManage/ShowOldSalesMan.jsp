<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "原销售代表展示 ";

	// 获得页面参数
	String oldSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldSNO"));
	String newSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NewSNO"));
	String oldSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("oldSalesManager"));
	String newSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("newSalesManager"));
	if(oldSalesManager == null) oldSalesManager = "";
	if(newSalesManager == null) newSalesManager = "";
	if(oldSNO == null) oldSNO = "";
	if(newSNO == null) newSNO = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreSalesmanList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause+=" and SType is null";
	doTemp.multiSelectionEnabled=true;
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(oldSNO);//传入参数,逗号分割
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
	
	function saveRecord(sPostEvents){
		var sSalesNos = getItemValueArray(0, "SALESMANNO");
		if (typeof(sSalesNos)=="undefined" || sSalesNos.length==0 || sSalesNos=="") {
			alert("请至少选择一条记录！");
			return;
		}
		sSalesNo=sSalesNos.toString();
		var re=/,/g;
		sSalesNo=sSalesNo.replace(re, "@");
		var count=RunMethod("GetElement","GetElementValue","count(serialno),storerelativesalesman,SNo='<%=oldSNO%>' and SType is null");
		if(parseInt(count)==sSalesNos.length){
			if(confirm("你确定转移该门店下所有的销售代表吗？")){
				//新门店、原销售代表、新销售经理 
				var sParam = "sNo=<%=oldSNO%>,ewNo=<%=newSNO%>,salesmanNos="+sSalesNo+",salesManager=<%=oldSalesManager%>,newSalesManager=<%=newSalesManager%>,userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
				var reValue=RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","updateUserInfo",sParam);
				if(reValue=="SUCESS"){
					alert("转移成功！");
				}
				self.close();
			}
		}else {
			//新门店、原销售代表、新销售经理 
			var sParam = "sNo=<%=oldSNO%>,ewNo=<%=newSNO%>,salesmanNos="+sSalesNo+",salesManager=<%=oldSalesManager%>,newSalesManager=<%=newSalesManager%>,userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
			var reValue=RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","updateUserInfo",sParam);
			if(reValue=="SUCESS"){
				alert("转移成功！");
			}
			self.close();
		}

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
