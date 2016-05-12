<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "退货申请信息";
	//定义变量
	String sSql="",sCustomerName="",sArtificialNo="";
	//定义变量：查询结果集
	ASResultSet rs = null;
	//获得页面参数：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));

	if(sSerialNo==null)  sSerialNo="";
	
    sSql="select CustomerName,ArtificialNo from Business_Contract where SerialNo =:serialno";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sSerialNo));
    if(rs.next()){
   	    sCustomerName = DataConvert.toString(rs.getString("CustomerName"));//客户编号
   	    sArtificialNo = DataConvert.toString(rs.getString("ArtificialNo"));//合同编号
		//将空值转化成空字符串
		if(sCustomerName == null) sCustomerName = "";
		if(sArtificialNo == null) sArtificialNo = "";
    }
    rs.getStatement().close();
	
	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ReturnApplyInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确认退货","确认退货","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------

	function saveRecord()
	{
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
			//申请类型（ApplicationType：退货申请:02）
			setItemValue(0,0,"ApplicationType","02");
			//处理状态
			setItemValue(0,0,"Status","01");
			//合同编号
			setItemValue(0,0,"ContractSerialNo","<%=sArtificialNo%>");
			//申请编号
			setItemValue(0,0,"ApplySerialNo","<%=sSerialNo%>");
			//客户名称
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");

            //登记人信息
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UpdateOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "WITHHOLD_CHARGE_INFO";//表名
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
