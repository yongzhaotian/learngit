<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%
	String PG_TITLE = "费用减免信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得页面参数
	String SerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	if(SerialNo == null) SerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	//显示模版编号
	String sTempletNo = "AcctFeeWaiveInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(SerialNo);
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	

	String sButtons[][] = {
			{"true", "", "Button", "保存", "新增一条信息","saveRecord()",sResourcesPath},
			{"true", "", "Button", "返回", "费用详情","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>
	//保存
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();	
		as_save("myiframe0","goBack();");
	}
	//返回
	function goBack(){
		OpenPage("/Accounting/LoanDetail/LoanTerm/AcctFeeWaiveList.jsp","_self","");
	}
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateOrg","<%=CurOrg.getOrgName()%>");
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ACCT_FEE_WAIVE";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
	
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}else{
		    bIsInsert = false;
		}
	}
	//修改减免类型(0为金额1为比例)
	function changeWaiveType(){
		var sResult = getItemValue(0,getRow(),"WaiveType");
		if("0"==sResult){
			try{
				setItemDisabled(0,getRow(),"WaiveAmount",false);
				setItemDisabled(0,getRow(),"WaivePercent",true);
				setItemValue(0,getRow(),"WaivePercent","");
				setItemRequired(0,getRow(),"WaiveAmount",1);
				setItemRequired(0,getRow(),"WaivePercent",0);
			}catch(e){}
			
			return;
		}else{
			try{
				setItemDisabled(0,getRow(),"WaiveAmount",true);
				setItemDisabled(0,getRow(),"WaivePercent",false);
				setItemValue(0,getRow(),"WaiveAmount","");
				setItemRequired(0,getRow(),"WaiveAmount",0);
				setItemRequired(0,getRow(),"WaivePercent",1);
			}catch(e){}
			
			return;
		}
	}
</script>
<script language=javascript>
	//初始化
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>