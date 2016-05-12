<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "筹建中项目"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得页面参数	：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//项目编号
	String sProtocolNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProtocolNo"));//项目所关联的协议编号
	String sflag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));//转让类型
	String sStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));//项目编号
	
	if(sTransferType==null) sTransferType="";
	if(sSerialNo==null) sSerialNo="";
	if(sProtocolNo==null)sProtocolNo="";
	if(sStatus==null) sStatus="";
	if(sflag==null) sflag="";
	//out.println("项目编号："+sSerialNo+"协议编号："+sProtocolNo);
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "BuildProjectInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//交易定义详情模板
	if(sSerialNo.equals("")){
		doTemp.setVisible("UpdateUserID,UpdateUserName,UpdateOrgID,UpdateOrgName,UpdateDate", false);
		doTemp.setReadOnly("TransactionMan,TransactionManName,Status,InputUserID,InputOrgID,InputDate,UpdateUserID,UpdateOrgID,UpdateDate,InputUserName,InputOrgName,UpdateUserName,UpdateOrgName", true);
	}
	
	doTemp.setDDDWSql("ProjectType", "select itemno,itemname from code_library where codeno='ProjectType'");
	doTemp.setDDDWSql("status","select itemno,itemname from code_library where codeno='ProjectPhaseType' and itemno='0010'");//项目状态0010：筹建中; 0020：动作中；0030：己终结;
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		//{"true","","Button","返回","返回","goBack()",sResourcesPath},
	};
	
	//筹建阶段可以保存项目信息，非筹建阶段不能保存项目信息
	//if(!sStatus.equals("0010")){
	//	sButtons[0][0]="false";
	//}
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------
	/*~~项目关联协议~~*/
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
		if(typeof(sTransferSerialNo) == "undefined" || sTransferSerialNo == "")
		{
			alert("请在列表界面关联相应的资产转让协议!");
			return;
		}
		
		setItemValue(0,getRow(),"ProtocolNo",sTransferSerialNo);
		setItemValue(0,getRow(),"TransactionMan",sTransactionMan);
		setItemValue(0,getRow(),"TransactionManName",sTransactionManName);
	}
	
	
	
	function saveRecord()
	{
		as_save("myiframe0");
	}
	
	// 返回交易列表
	function goBack()
	{
		var sflag="<%=sflag%>";
		//alert("==================="+sflag);
		if(sflag=="Y"){
			OpenPage("/BusinessManage/CollectionManage/BuildProjectList.jsp","_self","");
		}
		if(sflag=="S"){
			OpenPage("/BusinessManage/CollectionManage/WorkProjectList.jsp","_self","");
		}
		if(sflag=="N"){
			OpenPage("/BusinessManage/CollectionManage/FinalProjectList.jsp","_self","");
		}
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			initSerialNo();
			bIsInsert = true;
			setItemValue(0,getRow(),"Status","0010");//设置项目状态为筹建中
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
		}else{
			setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"UpdateOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"UpdateOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "Transfer_Project_Info";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	</script>

<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
