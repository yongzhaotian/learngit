<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "催收城市修改"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得页面参数	：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";

	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CollectionCityInfo";//模型编号
	
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
	   OpenPage("/BusinessManage/CollectionManage/TaskCollectionList.jsp","_self","");
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getCellRegionCode()
	{
		var sAreaCode = getItemValue(0,getRow(),"Collectioncity");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");

		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"Collectioncity","");
			setItemValue(0,getRow(),"CollectioncityName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"Collectioncity",sAreaCodeValue);
					setItemValue(0,getRow(),"CollectioncityName",sAreaCodeName);				
			}
		}
	}	
	</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	

<%@ include file="/IncludeEnd.jsp"%>
