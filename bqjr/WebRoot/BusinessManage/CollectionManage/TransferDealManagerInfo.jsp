<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "资产转让协议详情页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得页面参数	：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//协议编号
	if(sSerialNo==null) sSerialNo="";
	
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));//首次转让或再转让判断标识
	if(sTransferType==null) sTransferType="";
	
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));//首次转让或再转让判断标识
	if(sApplyType==null) sApplyType="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("TransferDealManagerInfo",Sqlca);//交易定义详情模板
	if(sSerialNo.equals(""))
	{
		doTemp.setVisible("UpdateUserName,UpdateUserID,UpdateOrgName,UpdateOrgID,UpdateDate", false);
	}
	doTemp.setReadOnly("IsTransfer", true);
	
	doTemp.setReadOnly("RivalSerialNo,AccountNo,RivalOpenBank,TrustCompaniesSerialNo,InputUserID,InputUserName,InputOrgID,InputOrgName,InputDate,UpdateUserID,UpdateUserName,UpdateOrgID,UpdateOrgName,UpdateDate", true);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);

	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	
	if(!"0010".equals(sTransferType)){
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	}else{
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	}

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		{"true","","Button","保存并返回","保存并返回","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","返回","返回","goBack()",sResourcesPath},
	};
	if(!"0010".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------
	/*选择资产转让方*/
	function selectOpponentName()
	{
		sRec = AsControl.OpenComp("/BusinessManage/CollectionManage/AssetTransferList.jsp", "","_blank", "");//资产转让方选择列表界面
		if (typeof(sRec)=="undefined" || sRec.length==0){
			return;
		}
		var array = sRec.split("@");
		if(array.length!=2){
			alert("受让方信息不完整!");return;
		}
		setItemValue(0,getRow(),"TrustCompaniesSerialNo",array[0]);
		setItemValue(0,getRow(),"CreditMan",array[1]);
		
	}
	
	/*选择信托公司*/
	function selectTrustCompanies(){
		sRec = AsControl.OpenComp("/BusinessManage/CollectionManage/TrustCompaniesList.jsp", "", "_blank", "");//资产转让信托公司选择列表界面
		if (typeof(sRec)=="undefined" || sRec.length==0){
			return;
		}
		var array = sRec.split("@");
		if(array.length!=2){
			alert("出让方信息不完整!");return;
		}
		setItemValue(0,getRow(),"RivalSerialNo",array[0]);//出让方编号
		setItemValue(0,getRow(),"RivalName",array[1]);//出让方名称
	}
	
	function saveRecord()
	{
		if(!validCheck())return;
		as_save("myiframe0");
	}
	function saveRecordAndReturn()
	{
		if(!validCheck())return;
		as_save("myiframe0");
		AsControl.OpenPage("/BusinessManage/CollectionManage/TransferDealList.jsp","TransferType=<%=sTransferType%>","_self","");
	}
	
	function validCheck(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		var RivalSerialNo = getItemValue(0,getRow(),"RivalSerialNo");
		var TrustCompaniesSerialNo = getItemValue(0,getRow(),"TrustCompaniesSerialNo");
		var EffectiveDate = getItemValue(0,getRow(),"EffectiveDate");
		var MaturityDate = getItemValue(0,getRow(),"MaturityDate");
		var RivalNo = getItemValue(0,getRow(),"RivalNo");
		if(typeof(RivalSerialNo)=="undefined"||RivalSerialNo==""){
			alert("出让方编号不能为空");
			return false;
		}
		if(typeof(TrustCompaniesSerialNo)=="undefined"||TrustCompaniesSerialNo==""){
			alert("受让方编号不能为空");
			return false;
		}
		if(RivalSerialNo==TrustCompaniesSerialNo){
			alert("出让方与受让方不得为同一机构!");
			return false;
		}
		
		if(typeof(EffectiveDate)!="undefined"&&EffectiveDate!=""&&EffectiveDate.length==10){
			if(typeof(MaturityDate)!="undefined"&&MaturityDate!=""&&MaturityDate.length==10){
				if(EffectiveDate>MaturityDate){
					alert("协议到期日不得小于协议生效日!");
					return false;
				}
			}
		}
		
		var sReturn = RunMethod("公用方法","GetColValue","Transfer_Deal,SerialNo,RivalNo='"+RivalNo+"' and serialNo<>'"+SerialNo+"'");
		if(typeof(sReturn)!="undefined"&&sReturn.toLowerCase()!="null"&&sReturn.length>0){
			alert("协议文本编号重复,已被协议号【"+sReturn+"】占用");
			return false;
		}

		return true;
	}
	
	// 返回交易列表
	function goBack()
	
	{
		AsControl.OpenPage("/BusinessManage/CollectionManage/TransferDealList.jsp","TransferType=<%=sTransferType%>","_self","");
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			initSerialNo();
			setItemValue(0,getRow(),"DealStatus","01");//01：未生效 02：已生效 03:已终止
			setItemValue(0,getRow(),"ApplyType","<%=sApplyType%>");//申请类型
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"InputUserName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
		else{
			setItemValue(0,0,"UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateOrgID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"UpdateUserName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate", "<%=StringFunction.getToday()%>");
		}
		
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "Transfer_Deal";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);//获取流水号
		
		setItemValue(0,getRow(),sColumnName,sSerialNo);//将流水号置入对应字段
	}

	</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
