<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "还款日变更";
	//定义变量
		String sSql="",sCustomerID="",sCarNumber="",sRepaymentWay="",sCustomerName="",sRepaymentNo="";
		//定义变量：查询结果集
		ASResultSet rs = null;
		//获得页面参数：
		String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
		if(sSerialNo==null)  sSerialNo="";
		
	    sSql="select CustomerID,CustomerName,CarNumber,RepaymentWay,RepaymentNo from business_contract  where serialno =:serialno";
	    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sSerialNo));
	    if(rs.next()){
	    		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));//客户编号
	    		sCarNumber = DataConvert.toString(rs.getString("CarNumber"));//车牌号码
	    		sRepaymentWay = DataConvert.toString(rs.getString("RepaymentWay"));//还款方式
	    		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
	    		sRepaymentNo = DataConvert.toString(rs.getString("RepaymentNo"));

	   	 
				//将空值转化成空字符串
				if(sCustomerID == null) sCustomerID = "";
				if(sCarNumber == null) sCarNumber = "";
				if(sRepaymentWay == null) sRepaymentWay = "";
				if(sCustomerName == null) sCustomerName = "";
				if(sRepaymentNo == null) sRepaymentNo = "";
	    }
	    rs.getStatement().close();
		
	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RepaymentChangeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确认变更","确认变更","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------

	function saveRecord()
	{
		if(!vI_all("myiframe0")) return;
		as_save("myiframe0","");
	}
	
	function initRow()
	{	
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			//流水号
			initSerialNo();
			setItemValue(0,0,"PutoutNo","<%=sSerialNo%>");
			
			setItemValue(0,0,"RepaymentFlag","<%=sRepaymentNo%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"CarNumber","<%=sCarNumber%>");
			setItemValue(0,0,"OldRepaymentWay","<%=sRepaymentWay%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "CONTRACT_REPAYMENT_CHANGE";//表名
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
