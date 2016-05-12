<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "商户预约"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CommecialConsultInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//交易定义详情模板
	
	doTemp.setUnit("CITYNAME", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.getRegionCode()>");	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","保存","保存记录","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表也面","goBack()",sResourcesPath},
		{"false","","Button","返回xxxx","返回列表也面","selectAreaInfo()",sResourcesPath},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	function getRegionCode() {
		alert("Caoni ma");
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	// 返回交易列表
	function goBack()
	{
		AsControl.OpenView("/BusinessManage/ChannelManage/CommecialAppoinmentList.jsp","","_self");
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			var sSerialNo = getSerialNo("Consult","SERIALNO");// 获取流水号
			setItemValue(0,getRow(),"SERIALNO",sSerialNo);
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }

	</script>

<script language=javascript>
	bFreeFormMultiCol = true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
