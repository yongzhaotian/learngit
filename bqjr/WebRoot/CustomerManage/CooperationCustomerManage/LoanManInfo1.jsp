<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "贷款人详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sTemp==null) sTemp="";
	if(sSerialNo==null) sSerialNo="";
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "LoanManInfo1";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = null;
	if(sTemp.equals("modify")){
		vTemp=dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	}else{
		vTemp=dwTemp.genHTMLDataWindow("");
	}
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
	if(sTemp.equals("modify")){
		sButtons[2][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	 function getRegionCode(){
		 var sRetVal = setObjectValue("SelectCityCodeSingle", "", "", 0, 0, "");
			
			if (typeof(sRetVal)=='undefined' || sRetVal=='__CLEAR__' || sRetVal.length==0) {
				alert("请选择城市！");
				return;
			}
			setItemValue(0, 0, "city", sRetVal.split("@")[0]);
			setItemValue(0, 0, "cityName", sRetVal.split("@")[1]);
    }
	
	 function getRegionCode1()
		{
			var retVal = setObjectValue("SelectCityCodeMulti","","",0,0,"");
			if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
				alert("请选择所要选择的城市！");
				return;
			}
			var cityItems = retVal.split("~");
			var sCityNos = "";
			var sCityName = "";
			for (var i in cityItems) {
				sCityNos += cityItems[i].split("@")[0]+",";
				sCityName+=cityItems[i].split("@")[1]+",";
			}
			sCityNos = sCityNos.substring(0,sCityNos.length-1);
			setItemValue(0, 0, "province", sCityNos);
			setItemValue(0, 0, "provinceName", sCityName);
		}
	 
		function saveRecord(sPostEvents){
			if(bIsInsert){
				beforeInsert();
			}
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
		}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/CustomerManage/CooperationCustomerManage/LoanManList1.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var sSerialNo = getSerialNo("Service_Providers","serialNo");// 获取流水号
			setItemValue(0,getRow(),"serialNo",sSerialNo);
			setItemValue(0,getRow(),"CreditAttribute","0001");
			setItemValue(0,getRow(),"customerType1","06");
			setItemValue(0, 0, "inputOrgID", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputDate","<%=StringFunction.getToday()%>");

			setItemValue(0, 0, "updateOrgID", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"updateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"updateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
