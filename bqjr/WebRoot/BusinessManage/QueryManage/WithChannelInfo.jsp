<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNO"));
	if(sExampleId==null) sExampleId="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "WithChannelInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleId);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

    //add by ybpanCCS-608   --更改代扣渠道配置时报错    20150413
    var sWithCity ="";//代扣省市
    
	function ClearProvice(){
		var sWithLevel = getItemValue(0,getRow(),"WITHLEVEL");//代扣级别
		//若代扣级别为全行的话把代扣省市设为空
		if(sWithLevel=="010"){
			setItemValue(0,getRow(),"CITYNAME","");
		}else if(sWithLevel=="020"){
			setItemValue(0,getRow(),"CITYNAME",sWithCity);
		}
	}
	//end by ybpanCCS-608   --更改代扣渠道配置时报错    20150413

	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		var sWithLevel = getItemValue(0,getRow(),"WITHLEVEL");//代扣级别
		var sWithRange = getItemValue(0,getRow(),"WITHRANGE");//代扣范围
		var sWithCity = getItemValue(0,getRow(),"WITHCITY");//代扣省市
		var sWithChannel = getItemValue(0,getRow(),"WITHCHANNEL");//代扣渠道
		var sBankNo = getItemValue(0,getRow(),"BANKNO");//银行编号

		//注释 by ybpan at 20150323  CCS-608  --更改代扣渠道配置时报错
		/* var count = RunMethod("BusinessManage","CheckWithLevel",sBankNo);
		if(count > 0){
			alert("当前银行已存在代扣级别，不允许新增全行或非全行的渠道信息！");
			return;
		} */
	 
		if(sWithLevel == "020" && (typeof(sWithRange) == "undefined" || sWithRange.length==0)){
			alert("代扣级别选择非全行，请选择代扣范围！");
			return;
		}
		if(sWithLevel == "020" && (typeof(sWithCity) == "undefined" || sWithCity.length==0)){
			alert("代扣级别选择非全行，请选择代扣省市！");
			return;
		}
		if(sWithLevel == "010" && (typeof(sWithRange) != "undefined" && sWithRange.length!=0 && sWithRange!= null)){
			alert("代扣级别为全行，不需要选择代扣范围！");
			return;
		}  	
		
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/BusinessManage/QueryManage/WithChannelList.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("WITHCHANNEL_INFO","SERIALNO");// 获取流水号
		setItemValue(0,getRow(),"SERIALNO",serialNo);
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
	}
	
	function initRow(){
		sWithCity = getItemValue(0,getRow(),"CITYNAME");//代扣省市  add by ybpan CCS-608
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"USERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"ORGNAME","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getCellRegionCode()
	{
		var sSelName = "";
		var sWithRange = getItemValue(0,getRow(),"WITHRANGE");
		if(sWithRange == "020"){
			sSelName = "SelectCityCodeSingle";
		}else if(sWithRange == "010"){
			sSelName = "SelectProvinceCodeSingle";
		}
		//判断代扣级别
		var sWithRange = getItemValue(0,getRow(),"WITHLEVEL");
		if(sWithRange == "010"){
			alert("代扣级别为全行，不需要选择省市！");
			return;
		}
		
		var sAreaCode = getItemValue(0,getRow(),"WITHCITY");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = setObjectValue(sSelName,"","",0,0,"");
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"WITHCITY","");
			setItemValue(0,getRow(),"CITYNAME","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"WITHCITY",sAreaCodeValue);
					setItemValue(0,getRow(),"CITYNAME",sAreaCodeName);				
			}
		}
	}
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
