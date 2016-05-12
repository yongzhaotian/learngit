<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "MobilePosList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause = " where MP.Status not in ('01','02','04')";

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  详情  激活  关闭  暂时关闭  取消关闭
		{"true","","Button","详情查看","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","激活","激活","activeStore()",sResourcesPath},
		{"true","","Button","关闭","关闭","closeStore()",sResourcesPath},
		{"true","","Button","暂时关闭","暂时关闭","amomentCloseStore()",sResourcesPath},
		{"true","","Button","取消关闭","取消关闭","cancelCloseStore()",sResourcesPath},
		
	};
	
	//用于控制单行按钮显示的最大个数  add by Dahl 20150318
	String iButtonsLineMax = "12";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	/* 解除该门店绑定的销售 */
	function unbandSalesman() {
		
		var vWhereClause = "<%=doTemp.WhereClause%>";
		var vSalesNo = document.getElementById("DF7_1_INPUT").value;
		var vSalesName = document.getElementById("DF8_1_INPUT").value;
		var vSerialNo = getItemValue(0,getRow(),"SNO");
		var vSname = getItemValue(0,getRow(),"SNAME");
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreUserUnbandList.jsp","","_self","");
		
		return;

		var vQuery = vSalesNo;
		if (vSalesName!="" && vSalesNo=="") {
			vQuery = vSalesName;
			var icnt = RunMethod("公用方法", "GetColValue", "user_info,count(userid),username='"+vQuery+"'");
			if (icnt > 1) {
				alert("请在门店详情，门店关联销售中解绑！");
				return;
			}

		}
		
		if (vQuery ==  "") {
			alert("请输入销售编号或名称查询绑定门店！");
			return;
		}
		
		if (vWhereClause.indexOf(vQuery)<0) {
			alert("请先查询！");
			return;
		}
		
		if (typeof(vSerialNo)=="undefined" || vSerialNo.length==0){
			alert("请选择一个门店进行解绑！");
			return;
		}
		
		if (vSalesName!="" && vSalesNo=="") {
			vQuery = RunMethod("公用方法", "GetColValue", "user_info,userid,username='"+vQuery+"'"); 
		}
		
		if (confirm("确定要解除绑定，门店："+vSname+"，销售编号："+RunMethod("公用方法", "GetColValue", "user_info,username,userid='"+vQuery+"'"))){
			RunMethod("公用方法", "DelByWhereClause", "storerelativesalesman,sno='"+vSerialNo+"' and salesmanno='"+vQuery+"'");
			RunMethod("公用方法", "UpdateColValue", "user_info,superid,,userid='"+vQuery+"'");
		}

		reloadSelf();
	}


	<%/*~[Describe=关联产品;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function relativeProduct() {
		
		var sRetVal = AsControl.PopView("/BusinessManage/StoreManage/StoreProductDoubleSelect.jsp", "", "dialogWidth:1080px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
		var sProductCategorys = sRetVal.split("~")[0];
		var sStores = sRetVal.split("~")[1];
		
		if (typeof(sRetVal)=='undefined' || (sProductCategorys.length==0 || sStores.length==0)) {
			alert("请选择门店和产品范畴！");
			return;
		}
		sProductCategorys = sProductCategorys.substring(0, sProductCategorys.length-1);
		sStores = sStores.substring(0, sStores.length-1);
		/* alert(sStores);
		alert(sProductCategorys);
		return; */
		// 执行java方法进行操作
		RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getStoreRelativeProductMulti", "serialNo="+sProductCategorys+",objectNo="+sStores+",retailNo=<%=CurUser.getUserID()%>");
		reloadSelf();
	}

	<%/*~[Describe=取消关闭零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function cancelCloseStore() {
		var sRETATIVESTORENO = getItemValue(0, getRow(), "RETATIVESTORENO");//门店编码
		var sMOBLIEPOSNO = getItemValue(0,getRow(),"MOBLIEPOSNO");//pos点编号
		if (typeof(sMOBLIEPOSNO)=="undefined" || sMOBLIEPOSNO.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if(sStatus=="07"){
			var sReturn = RunMethod("公用方法","UpdateColValue","MOBILEPOS_INFO,Status,05,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
				alert("取消关闭移动POS点失败！");
				return;	
			}
			alert("取消关闭移动POS点成功！");
			reloadSelf();
		} else {
			alert("暂时关闭状态门店才允许取消关闭！");
			return;
		}
	}

	<%/*~[Describe=暂时关闭零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function amomentCloseStore() {
		var sRETATIVESTORENO = getItemValue(0, getRow(), "RETATIVESTORENO");//门店编码
		var sMOBLIEPOSNO = getItemValue(0,getRow(),"MOBLIEPOSNO");//pos点编号
		if (typeof(sMOBLIEPOSNO)=="undefined" || sMOBLIEPOSNO.length==0){
			alert("请选择一条记录！");
			return;
		}

		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "05") {
			var tipVal = "确定要暂时关闭\n移动POS点：" + getItemValue(0, getRow(), "MOBLIEPOSNO");
			if (confirm(tipVal)) {
				var sReturn = RunMethod("公用方法","UpdateColValue","MOBILEPOS_INFO,Status,07,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("移动POS点暂时关闭失败！");
					return;			
				}else if(sStatus == "07"){
                  alert("移动POS点暂时关闭成功！");
				}
				reloadSelf();
			}
		} else {
			alert("激活状态门店才允许暂时关闭！");
			return;
		}
	}

	<%/*~[Describe=关闭零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function closeStore() {
		var sMobliePosNo = getItemValue(0,getRow(),"MOBLIEPOSNO");  //移动POS点编码
		var sRetativeStoreNO = getItemValue(0,getRow(),"RETATIVESTORENO");  //门店代码
		
		if (typeof(sMobliePosNo)=="undefined" || sMobliePosNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		//对于状态为激活或暂时关闭的零售商，可将其关闭。其他状态不允许;
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus=="07" || sStatus=="05" || sStatus=="03") {
			
			var tipVal = "您确定要关闭移动POS点：" + getItemValue(0, getRow(), "RETATIVESTORENO");
			if (confirm(tipVal)) {
	        	var sReturn = RunMethod("公用方法","UpdateColValue","MOBILEPOS_INFO,STATUS,06,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");
				if(sReturn == "Fail") {				
					alert("移动POS点关闭失败！");
					return;			
				}else if(sStatus=="06" ){
					alert("移动POS点关闭成功！");
				}
				reloadSelf();
			}
		} else {
			alert("只有门店为准入、激活和暂时关闭状态才允许进行关闭操作！");
			return;
		}
	}

	<%/*~[Describe=激活零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function activeStore() {
		var sMobliePosNo = getItemValue(0,getRow(),"MOBLIEPOSNO");  //移动POS点编码
		var sRetativeStoreNO = getItemValue(0,getRow(),"RETATIVESTORENO");  //门店代码
		
		if (typeof(sMobliePosNo)=="undefined" || sMobliePosNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		var sStatus = getItemValue(0, getRow(), "STATUS");
		var sPosStatus = RunMethod("公用方法","GetColValue","MOBILEPOS_INFO,STATUS,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");
          if(sStatus == "03"){
		        var sStoreStatus = RunMethod("公用方法","GetColValue","STORE_INFO,STATUS,SNO='"+getItemValue(0, getRow(), "RETATIVESTORENO")+"'");
		        if(sStoreStatus !="05"){
		        	alert("请先 激活门店！");
		        }else{
		        	var sReturn = RunMethod("公用方法","UpdateColValue","MOBILEPOS_INFO,STATUS,05,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");		        	
		        }
		        alert("激活成功！");
		       reloadSelf(); 
		   }else if(sStatus == "05"){
			   alert("移动POS点已激活");
			   return;
		   }else{
			   alert("准入状态的移动POS点才允许激活！");
			   return;
		   }

		
		
<%-- 		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sRetailStatus = RunMethod("公用方法", "GetColValue", "RETAIL_INFO,STATUS, SERIALNO=(SELECT RSERIALNO FROM STORE_INFO WHERE SERIALNO='"+sSerialNo+"')");
		if (sRetailStatus !== "05") {
			alert("请先激活商户！");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		//alert(sStatus);
		if (sStatus == "03") {
			var tipVal = "确定要激活门店：" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				sReturn = RunMethod("公用方法","UpdateColValue","Store_Info,Status,05,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("激活门店失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
			}
			reloadSelf();
		} else if (sStatus == "05") {
			alert("门店已经被激活！");
			return;
		}else {
			alert("准入状态门店才允许激活！");
			return;
		} --%>
	}

	<%/*~[Describe=门店信息查看;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/20~*/%>
	function viewReservCustomerInfo(){
		
		AsControl.OpenView("/CustomService/BusinessConsult/ReservConsultInfo.jsp","CustomerType=Customer","_blank","");
	}
	
	<%/*~[Describe=客户预约;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/20~*/%>
	function viewReservCommercialInfo(){
		
		AsControl.OpenView("/CustomService/BusinessConsult/ReservConsultInfo.jsp","CustomerType=Commercial","_blank","");
	}
	
	<%/*~[Describe=商户预约;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/20~*/%>
	function viewStoreInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SERILNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//alert(1);
		AsControl.OpenView("/BusinessManage/StoreManage/StoreInfo.jsp","SNo="+sSNo,"_self","");
	}

	
	//查看历史记录 
	function history(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNO = getItemValue(0,getRow(),"SNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/StoreManage/StoreUserHistoryList.jsp","SNO="+sSNO,"_self","");
	}
	
	function viewAndEdit(){
		var sApplySerialNo= getItemValue(0,getRow(),"APPLYSERIALNO");
		var sSNo = getItemValue(0, getRow(), "RETATIVESTORENO");
		var sStatus= getItemValue(0, getRow(), "STATUS");
		var sMobilePosNo=getItemValue(0,getRow(),"MOBLIEPOSNO")
		if (typeof(sApplySerialNo)=="undefined" || sApplySerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosInfoTab.jsp","ApplySerialNo="+sApplySerialNo+"&SNo="+sSNo+"&Status="+sStatus+"&MOBLIEPOSNO="+sMobilePosNo,"_blank","");
		reloadSelf();
	}
	
	

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>