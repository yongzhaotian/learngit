<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "家访要求信息";
	//定义变量
	String sSql="",sCustomerName="",sCustomerID="",sArtificialNo="";
	//定义变量：查询结果集
	ASResultSet rs = null;
	//获得页面参数：
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null)  sSerialNo="";
	
    sSql="select CustomerID,CustomerName,ArtificialNo from business_contract where serialno =:serialno";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sSerialNo));
    
    if(rs.next()){
   	        sCustomerName = DataConvert.toString(rs.getString("CustomerName"));//客户编号
     	    sCustomerID = DataConvert.toString(rs.getString("CustomerID"));//客户编号
		   	sArtificialNo = DataConvert.toString(rs.getString("ArtificialNo"));//合同号
   	 
			//将空值转化成空字符串
			if(sCustomerName == null) sCustomerName = "";
			if(sCustomerID == null) sCustomerID = "";
			if(sArtificialNo == null) sArtificialNo = "";

    }
    rs.getStatement().close();
	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "HomeVisitInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确认","确认","saveRecord()",sResourcesPath}
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
	
	/*~[Describe=地址选择;InputParam=无;OutPutParam=无;]~*/
	function getAddCode(){
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"Address",sAddress);//现居住地址
		setItemValue(0,0,"AddressName",sAddressName);
		setItemValue(0,0,"TownShip",sTownShip);//乡/镇
		setItemValue(0,0,"Street",sStreet);//街道
		setItemValue(0,0,"Cell",sCell);//小区/楼盘
		setItemValue(0,0,"Room",sRoom);//栋/单元/房间号
		
	}
	
	/*~[Describe=手机号码选择;InputParam=无;OutPutParam=无;]~*/
	function getTelPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		setItemValue(0,0,"PhoneCode",sPhoneCode);//手机号码
		
	}
	
	
	function initRow()
	{	
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			//流水号
			initSerialNo();

			//合同编号
			setItemValue(0,0,"ContractSerialNo","<%=sArtificialNo%>");
			//申请编号
			setItemValue(0,0,"ApplySerialNo","<%=sSerialNo%>");

			//客户信息
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");

			
            //登记人信息
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "home_visit_info";//表名
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
