<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNO"));
	String sObjectNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNO"));
	if(sSerialNO==null) sSerialNO="";
	if(sObjectNO==null) sObjectNO="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "DelegateCompanyCityInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNO);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		var sExistNo = RunMethod("公用方法", "GetColValue", "DELEGATECOMPANY_RELATIVE,SerialNo,objectno='<%=sObjectNO%>' and cityno='"+getItemValue(0, 0, "CITYNO")+"' and rownum=1");
		//alert(sExistNo+"|"+typeof(sExistNo));
		if (sExistNo!="Null") {
			alert("该城市已经存在，请重新选择！");
			return;
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyCityList.jsp","ObjectNO=<%=sObjectNO%>","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("DELEGATECOMPANY_RELATIVE","SERIALNO");// 获取流水号
		setItemValue(0,getRow(),"SERIALNO",serialNo);
		bIsInsert = false;
	}
	
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0,0,"OBJECTTYPE","DelegateCompany");
			setItemValue(0,0,"OBJECTNO","<%=sObjectNO%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTORGNAME", "<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getCellRegionCode()
	{
		var sAreaCode = getItemValue(0,getRow(),"CITYNO");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"CITYNO","");
			setItemValue(0,getRow(),"CITYNONAME","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"CITYNO",sAreaCodeValue);
					setItemValue(0,getRow(),"CITYNONAME",sAreaCodeName);				
			}
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>
