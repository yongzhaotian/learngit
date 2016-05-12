<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "销售人员";

	// 获得页面参数
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo")); //门店编号
	String sMobilePoseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MobilePoseNo")); //POS编号
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));

	if (sSerialNo == null) sSerialNo = "";
	if (sSNo == null) sSNo="";
	if (sMobilePoseNo == null) sMobilePoseNo="";
	if(sPhaseNo == null) sPhaseNo = "";
	
	String starttime = ""; //开始时间
	String endtime = ""; //结束时间
	
	ASResultSet rs = null;//-- 存放结果集
	String sql = "SELECT t.STARTTIME,t.ENDTIME FROM mobilepos_info t WHERE moblieposno = :mobileposeno";
	rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("mobileposeno",sMobilePoseNo));
	if(rs.next()){
		starttime = rs.getString("STARTTIME");
		endtime = rs.getString("ENDTIME");
	}
	rs.getStatement().close();
	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "MobilePosSalesmanInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	// 获取该门店所在城市
	
	// 设置字段可见属性
	
	/* if ("Detail".equals(sActionType)) {
		doTemp.setUnit("SALESMANNO", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectSalesmanSingle()>");
	} */
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{CurUser.hasRole("1005")&&"0010".equals(sPhaseNo)?"true":"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	function selectSalesman() {
		var args = "sSNo,<%=sSNo%>,sPOSNO,<%=sMobilePoseNo%>,starttime,<%=starttime%>,endtime,<%=endtime%>";
		
		var sSalManForPos = setObjectValue("SelectSalesmanByCityForMobilePos", args, "@SALESMANNO@0@USERNAME@1",0,0,"");
		
		if (typeof(sSalManForPos)=='undefined' || sSalManForPos.length==0) {
			alert("请选择销售人员！");
			return;
			
		}
		sSalManForPos = sSalManForPos.substring(0, sSalManForPos.length-1);
		var retArry = sSalManForPos.split("@");
		var salNo = "";
		var salName = "";
		for (var i in retArry) {
			if (i%2==0) {
				salNo += retArry[i] + "@";
			} else if (i%2==1) {
				salName += retArry[i] + "@";
			}
		}
		salNo = salNo.substring(0,salNo.length-1)
		setItemValue(0, 0, "SALESMANNO",salNo );
//		setItemValue(0, 0, "SALESMANNAME", salName.substring(0,salName.length-1));

	}
	
<%-- 	function selectSalesman() {
		//CCS-541     //  AduEduRoleId    StuEduRoleId     add by yzhang9 CCS-571 UserId@Username
		alert("<%=sSNo%>");
		
		var sSalManForPos = setObjectValue("SelectSalesmanByCityForMobilePos", "sSNo,<%=sSNo%>", "");
		if (typeof(sSalManForPos)=='undefined' || sSalManForPos.length==0) {
			//alert("请选择销售人员！");
			return;
		}
		sSalManForPos=sSalManForPos.substring(0,(sSalManForPos.length-1));
		var sSalManForPosArr = sSalManForPos.split("@");
		var salNo = "";
		var salName = "";
		for (var i=0;i<sSalManForPosArr.length;i++){
			if((i%2)==0){
				if(i==0){
					salNo = sSalManForPosArr[i];
				}else{
				salNo= salNo+","+ sSalManForPosArr[i];
				}
			}else{
				if(i==1){
					salName = sSalManForPosArr[i];
				}else{
					salName= salName+","+ sSalManForPosArr[i];
				}
			}
		}
		setItemValue(0, 0, "SALESMANNO", salNo);
		setItemValue(0, 0, "SALESMANNAME", salName);
		
		
		
	} --%>
	
function saveRecord(sPostEvents){
		
		var sSalesmanNos = getItemValue(0, 0, "SALESMANNO");
		
		if (typeof(sSalesmanNos)=="undefined" || sSalesmanNos=="") {
			alert("请选择销售代表！");
			return;
		}
		<%-- var sParam = "sNo=<%=sSNo%>"+",PosNo="+getItemValue(0, 0, "POSNO")+",salesmanNos="+getItemValue(0, 0, "SALESMANNO")+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
		var retResult= RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "MobilePosRelativeSalesman", sParam); --%>
		/* as_save("myiframe0",sPostEvents);  */
		<%-- var sPosNo = "<%=sMobilePoseNo%>"; --%>
		var sSerialno = getItemValue(0, 0, "SERIALNO");
		 var sPosNo = getItemValue(0, 0, "POSNO");
		var sInputOrg = "<%=CurUser.getOrgID()%>";
		var sInputUser = "<%=CurUser.getUserID()%>";
		var sInputDate = "<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";
		var sSno = "<%=sSNo%>";
		var salesmanager = RunMethod("公用方法","GetColValue", "Store_info,SALESMANAGER,sno='"+sSno+"'");
		
		var sParam = "PosNo="+sPosNo+",InputOrg="+sInputOrg+",InputUser="+sInputUser+",InputDate="+sInputDate+",SalManForPos="+sSalesmanNos+",Serialno="+sSerialno+",Salesmanager="+salesmanager;
		var retResult= RunJavaMethodSqlca("com.amarsoft.app.billions.PosRelativeSalman", "sRelativeSalMan", sParam);
		if(retResult=="TRUE"){
			alert("关联成功！");
		}else if(retResult=="NoSal"){
			alert("未关联销售，请选择销售！");
			return;
		}else{
			alert("关联失败！");
			return;
		}
		var sSALESMANNO = RunMethod("公用方法","GetColValue", "Store_info,SALESMANNO,sno='"+sSno+"'");
		var sSALESMANNO = RunMethod("公用方法","GetColValue", "MOBLIEPOSRELATIVESALMAN,SALESMANNO,SerialNo='"+sSerialno+"'");
		setItemValue(0, 0, "SALESMANNO",sSALESMANNO );
		/* reloadSelf(); */
	}
	
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/SalesManListForMobilePos.jsp", "SNo=<%=sSNo %>&MOBLIEPOSNO=<%=sMobilePoseNo%>", "_self","");

	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var sSerialNo = getSerialNo("MOBLIEPOSRELATIVESALMAN","SerialNo");// 获取流水号
			setItemValue(0,0,"SERIALNO",sSerialNo);
			setItemValue(0, 0, "POSNO", "<%=sMobilePoseNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			<%-- setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>"); --%>
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
