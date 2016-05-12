<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "分配服务商"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得页面参数	：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AssignServiceInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//交易定义详情模板
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存记录","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表也面","goBack()",sResourcesPath},
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
	
	// 返回交易列表
	function goBack()
	{
		//OpenPage("/BusinessManage/CollectionManage/UntreatedOutsouceCollectionList.jsp","_self","");
		window.close();
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			initSerialNo();
			setItemValue(0,0,"CodeNo","<%=sSerialNo%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIdName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "Service_Info";//表名
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
