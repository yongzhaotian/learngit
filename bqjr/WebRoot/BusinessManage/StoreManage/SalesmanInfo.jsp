<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "销售人员";

	// 获得页面参数
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sVIWEFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("VIWEFLAG"));//从详情按钮打开的标记  add by ybpan  CCS-588

	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	
	if (sSerialNo == null) sSerialNo = "";
	if (sSNo == null) sSNo="";
	if (sVIWEFlag == null) sVIWEFlag="";
	
	String sPrevUrl =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrevUrl"));
	String flag = CurPage.getParameter("flag");
	if(sPrevUrl==null) sPrevUrl="";
	if(flag==null) flag = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreSalesmanInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	// 获取该门店所在城市
	String values = Sqlca.getString(new SqlObject("Select City||'@'||company from Store_Info si where si.SNo=:SNo").setParameter("SNo", sSNo));
	String salesNo = Sqlca.getString(new SqlObject("SELECT SALESMANNO FROM STORERELATIVESALESMAN WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sSerialNo));
	String sCity = values.split("@")[0];
	String company = "";
	if(values.split("@").length >1){
		company = values.split("@")[1];
	}
	if (salesNo == null) salesNo = "";
	// 设置字段可见属性
	
	/* if ("Detail".equals(sActionType)) {
		doTemp.setUnit("SALESMANNO", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectSalesmanSingle()>");
	} */
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform

	//关闭状态不允许编辑 update CCS-884 关闭状态隐藏保存按钮 tangyb 20150720
	if(!"06".equals(sStatus)){
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	}else{
		dwTemp.ReadOnly = "1"; // 设置是否只读 1:只读 0:可写
	}
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};

	//add CCS-884 关闭状态隐藏保存按钮 tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
    var sSaleTypeold="";  //点击详情页面修改时销售类型的原值  add by ybpan  CCS-588

	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	function selectSalesman() {
		var company = '<%=company%>';
		if(company == "")
		{
		  alert("门店业务所属于公司为空");
		  return;
		}
		//CCS-541     //  AduEduRoleId    StuEduRoleId     add by yzhang9 CCS-571     add by ybpan CCS-588,设置返回参数
		var sSNos = setObjectValue("SelectSalesmanByAuthor", "City,<%=sCity%>,company,<%=company%>", "@SALESMANNO@0@USERTYPE@1",0,0,"");
		//end by jshu 20150310
		if (typeof(sSNos)=='undefined' || sSNos.length==0) {
			//alert("请选择销售人员！");
			return;
			
		}
		//之前不能批量选择是因为没进行处理 add by huzp 20150428
		sSNos = sSNos.substring(0, sSNos.length-1);
		var retArry = sSNos.split("@");
		var sPNo = "";
		var sPName = "";
		for (var i in retArry) {
			if (i%2==0) {
				sPNo += retArry[i] + "@";
			} else if (i%2==1) {
				sPName += retArry[i] + "@";
			}
		}
		setItemValue(0, 0, "SALESMANNO", sPNo.substring(0, sPNo.length-1));
	}
	function selectSalesmanSingle() {
		
		var sSNo = setObjectValue("SelectSalesmanSingle", "", "");

		if (typeof(sSNo)=='undefined' || sSNo.length==0) {
			alert("请选择销售人员！");
			return;
		}
		//【配合上面function功能屏蔽此处了  update by huzp 20150428
		//setItemValue(0, 0, "SALESMANNO", sSNo.split("@")[0]);

	}
	
	function saveRecord(sPostEvents){
		
		/* if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents); */
		var sSalesmanNos = getItemValue(0, 0, "SALESMANNO");
		var sSaleTypeNew = getItemValue(0, 0, "SALETYPE");  //点击详情页面修改时销售类型的新值  add by ybpan  CCS-588
		var sUserType=getItemValue(0, 0, "USERTYPE");//用户类型:01-内部员工02-外部员工  add by ybpan CCS-588

		if (typeof(sSalesmanNos)=="undefined" || sSalesmanNos=="") {
			alert("请选择销售代表！");
			return;
		}
		
		//add by ybpan  CCS-588  at 20150409  系统中增加中域ALDI模式的客户主管
		//当为新增或者点击详情修改销售类型不是客户主管且要改为客户主管时要校验该门店是否已经存在客户主管
		if(("<%=sVIWEFlag%>" != "2" &&sSaleTypeNew=="02")||(sSaleTypeold!="02"&&sSaleTypeNew=="02") ){         
			
			var sSaleManager =  RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "checkSaleManager", "sNo=<%=sSNo%>");
			if(sSaleManager=="true"){
					alert("该门店已经关联客户主管");
					return ;
				}
		}
		//若是外部员工选择销售类型为主管，则提示错误信息    
		if(sUserType=='02'&&sSaleTypeNew=="02"){
			alert("只有内部人员才能作为客户主管");
			return;
		}
		//end by ybpan   CCS-588  at 20150409  系统中增加中域ALDI模式的客户主管
		 
		var sParam = "type=01,sNo="+getItemValue(0, 0, "SNO")+",salesmanNos="+getItemValue(0, 0, "SALESMANNO")+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>,saleType="+getItemValue(0, getRow(), "SALETYPE")+",VIWEFlag=<%=sVIWEFlag%>";
		var retResult= RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "storeRelativeSalesman", sParam);
		if (false && "FAIL"==retResult) {
			 RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "checkStoreRelativeSalesman", "serialNo=<%=sSNo%>");
			return;
		} else if ("SUCCESS") {
			var sExitManagers = retResult.split("@")[1];
			if (typeof(sExitManagers)=='undefined' || sExitManagers.length==0) {
				if("<%=sVIWEFlag%>" == "2"){
					as_save("myiframe0");
				}
				reloadSelf();
				return;
			}
			alert(sExitManagers.replace(/@/g,", ")+"\n上述销售人员已经关联到其他销售经理，如要关联到该门店，请先解绑！");
		}
		reloadSelf();
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/StoreManage/SalesManList.jsp", "SNo=<%=sSNo %>", "_self","");

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
		sSaleTypeold = getItemValue(0, 0, "SALETYPE"); //点击详情页面修改时销售类型的原值  add by ybpan  CCS-588 原值需要在外边定义，initRow中赋值
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var sSerialNo = getSerialNo("StoreRelativeSalesman","SerialNo");// 获取流水号
			setItemValue(0,0,"SERIALNO",sSerialNo);
			setItemValue(0, 0, "SNO", "<%=sSNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			setItemValue(0, 0, "SALESMANNO", "<%=salesNo %>");
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
