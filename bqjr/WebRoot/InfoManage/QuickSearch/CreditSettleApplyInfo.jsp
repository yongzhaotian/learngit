<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "贷款结清证明申请信息";
	//定义变量
	String sSql="",sCustomerName="",sContractStatus="",sContractStatusName="",sMobileTelephone="",sReplaceName="",sReplaceAccount="",sOpenBank="",sArtificialNo="";
	//定义变量：查询结果集
	ASResultSet rs = null;
	//获得页面参数：
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null)  sSerialNo="";
	
    sSql="select getItemName('ContractStatus',ContractStatus) as ContractStatusName from Business_Contract bc where bc.serialno =:serialno";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sSerialNo));
    if(rs.next()){
   	       
		   	sContractStatusName = DataConvert.toString(rs.getString("ContractStatusName"));//合同状态
   	 
			//将空值转化成空字符串
			if(sContractStatusName == null) sContractStatusName = "";		
			
    }
    rs.getStatement().close();
	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CreditSettleApplyInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确认提交","确认提交","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------

	function saveRecord()
	{
		//合同申请编号
		ContractSerialno = "<%=sSerialNo%>";
		//流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sCotractStatus = getItemValue(0,getRow(),"ContractStatus");
		sIsScan = getItemValue(0,getRow(),"IsScan");
	
	 	if (!(typeof(sIsScan) == "undefined" || sIsScan != ""))
		{
			alert("请输入是否扫描！");
			return;
		} 

		as_save("myiframe0");
	}
	
	function initRow()
	{	
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			//流水号
			initSerialNo();
 			//合同申请编号
			setItemValue(0,0,"ApplySerialNo","<%=sSerialNo%>");
			setItemValue(0,0,"ContractStatus","<%=sContractStatusName%>");

		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "WITHHOLD_SETTLE_INFO";//表名
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
	//showFilterArea();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
