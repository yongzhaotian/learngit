<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	//首次转让或再转让判断标识
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	out.println("流水号："+sSerialNo+"转让类型："+sTransferType);
	
	// 通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("TransferDealManagerInfo2",Sqlca);
	doTemp.setReadOnly("ISTRANSFER,TRANSFERTYPE,SERIALNO,RIVALSERIALNO,RIVALNAME,INPUTUSERID,INPUTUSERNAME,INPUTORGID,INPUTORGNAME,UPDATEUSERID,UPDATEUSERNAME,UPDATEORGID,UPDATEORGNAME,UPDATEDATE,INPUTDATE,CREDITMAN", true);
	if(sSerialNo.equals("")){
		doTemp.setVisible("UpdateDate,UpdateUserID,UpdateUserName,UpdateOrgID,UpdateOrgName", false);
	}
	doTemp.setRequired("RELATIVESERIALNO,TRUSTCOMPANIESSERIALNO,MATURITYDATE,SERIALNO", true);
	doTemp.setDDDWSql("IsTransfer", "select itemno,itemname from code_library where codeno='YesNo'");
	doTemp.setDDDWSql("TransferType", "select itemno,itemname from code_library where codeno='TransferType'");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	/*~~再次转让协议关联首次转让协议~~*/
	function selectTransferDealManager()
	{
		var sRec = AsControl.PopPage("/BusinessManage/CollectionManage/TransferDealManagerList.jsp", "Selected=true", "");
		var arr = sRec.split("@");
		if(arr.length!=3){
			alert("您关联的协议信息不完整!");
			return;
		}
		var sTransferSerialNo = arr[0];//协议编号
		var sTransactionMan = arr[1];//协议信息录入的对手编号
		var sTransactionManName = arr[2];//协议信息中录入的对手名称
		//RELATIVESERIALNO\RIVALSERIALNO\RIVALNAME
		if(typeof(sTransferSerialNo) == "undefined" || sTransferSerialNo == "")
		{
			alert("请在列表界面关联相应的资产转让协议!");
			return;
		}
		
		setItemValue(0,getRow(),"RELATIVESERIALNO",sTransferSerialNo);
		setItemValue(0,getRow(),"RIVALSERIALNO",sTransactionMan);
		setItemValue(0,getRow(),"RIVALNAME",sTransactionManName);
	}
	
	
	
	/*选择信托公司*/
	function selectTrustCompanies(){
		sRec = AsControl.PopPage("/BusinessManage/CollectionManage/TrustCompaniesList.jsp", "", "");//资产转让信托公司选择列表界面
		if (typeof(sRec)=="undefined" || sRec.length==0){
			alert("您未选择信托公司，请选择后点【确定】按钮！");
			return;
		}
		var array = sRec.split("@");
		if(array.length!=2){
			alert("信托公司信息不完整!");return;
		}
		setItemValue(0,getRow(),"TRUSTCOMPANIESSERIALNO",array[0]);//信托公司编号
		setItemValue(0,getRow(),"CREDITMAN",array[1]);//信托公司名称
	}
	</script>
	
	
	
	<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}else{
			beforeUpdate();
		}
		as_save("myiframe0",sPostEvents);
	}
	
	
	/*~~保存并返回~~*/
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	/*~~返回协议列表界面~~*/
	function goBack(){
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerList2.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSERID", "<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"UPDATEORGID","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEDATE", "<%=StringFunction.getToday()%>");
		//setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			initSerialNo();
			setItemValue(0,0,"ISTRANSFER","1");//设置是否己转让
			setItemValue(0,0,"TRANSFERTYPE","<%=sTransferType%>");//设置转让类型（0010首次转让、0020再转让）
			setItemValue(0,0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"InputUserName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTUSERID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "Transfer_Deal";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);//获取流水号
		setItemValue(0,getRow(),sColumnName,sSerialNo);//将流水号置入对应字段
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
