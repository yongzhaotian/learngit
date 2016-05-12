<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "零售商准入申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	// 获得页面参数
	String sRetVal =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RetVal"));
	if (sRetVal == null) sRetVal = "";
	String[] retArry = sRetVal.split("@"); //0:零售商编号，1：准入类型，2：零售商名称，3：组织机构代码
	String sRNo = retArry[2];
	if (sRNo ==  null) sRNo = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RetailInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//交易定义详情模板
	
	// 设置默认值
	doTemp.setDefaultValue("PermitType", "02");

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sRNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","保存","保存记录","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
		{"false","","Button","返回xxxx","返回列表也面","selectAreaInfo()",sResourcesPath},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sAreaCode = getItemValue(0,getRow(),"RegionCode");
		//由于行政规划代码有几千项，分两步显示行政规划
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"RegionCode","");
			setItemValue(0,getRow(),"RegionName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"RegionCode",sAreaCodeValue);
					setItemValue(0,getRow(),"RegionName",sAreaCodeName);				
			}
		}
	}
	
	/*~[Describe=弹出身份-城市-区域选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/21~*/

	
	
	function saveRecord()
	{
		as_save("myiframe0");
	}
	
	// 返回交易列表
	function goBack()
	{
		//AsControl.OpenView("/BusinessManage/ChannelManage/RetailRetiveStoreList.jsp","RNo=<%=sRNo %>","_self");
		parent.reloadSelf();
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"RNo","<%=retArry[2] %>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.orgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.orgName%>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss") %>");
			setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UpdateOrgName","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss") %>");
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
