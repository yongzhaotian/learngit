<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ArchiveContractList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;
	doTemp.setColumnAttribute("CERTID,SALESMANAGER,AccessUserName,ReturnUserName,InputUserID,ArchiveDate,NowReturnDate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.WhereClause+=" and ISARCHIVE='01' and (RENTURNDATE>=ACCESSDATE or ACCESSDATE is null )  ";
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","合同详情","合同详情","viewtab()",sResourcesPath},
		{"true","","Button","电子合同","电子合同","elecContractView()",sResourcesPath},
		{"true","","Button","查阅第三方协议","查阅第三方协议","creatThirdTable()",sResourcesPath},
		{"true","","Button","影像","影像","imageView()",sResourcesPath},
		{"true","","Button","合同调阅","合同调阅","contractView()",sResourcesPath},
		{"true","","Button","归还","归还","tackbackContract()",sResourcesPath},
		{"false","","Button","销毁","销毁","destroyContract()",sResourcesPath},
		{"true","","Button","查看历史调阅信息","查看历史调阅信息","lookHistory()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

		//Excel导出功能呢	
		function exportExcel(){
			amarExport("myiframe0");
		}
		//end by pli2 20140417	
	
	function viewtab(){
		//获得申请类型、申请流水号
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function elecContractView(){
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		sObjectType = "ApplySettle";
		var sDocID = "7006";
		//add 现金贷－申请表
		var ssProductID = RunMethod("PublicMethod","GetColValue","productid,business_contract,String@SerialNo@"+sObjectNo);
		var sProductID=ssProductID.split("@")[1];
		if(null == sProductID) sProductID = "";
		if("020" == sProductID)
		{
			sObjectType = "CashLoanSettle";
			sDocID = "L001";
		}
		//end
		
		sExchangeType = "";
		//检查出帐通知单是否已经生成
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //未生成出帐通知单
			alert("电子合同不存在！");
			return;
			//生成出帐通知单	
// 			var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
// 			PopPage("/FormatDoc/Report17/03.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");	
		}else{
			//记录查看动作
			RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=view");
			//获得加密后的出帐流水号
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//通过　serverlet 打开页面
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}					
	}
	
	function lookHistory(){
		var sCount=RunMethod("Unique","uniques","EVENT_INFO,SERIALNO,type='030' or type='040'");
		if(sCount=="Null"){
			alert("没有历史调阅信息记录！");
			return;
		}
		AsControl.OpenView("/AppConfig/Document/LookAccessList.jsp","","right","");
	}

	/* function imageView(){
		 var sObjectNo   = getItemValue(0,getRow(),"SERIALNO");
	        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
	            alert(getHtmlMessage('1'));//请选择一条信息！
	            return;
	        }
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
	} */
	function imageView(){
	    var sObjectNo   = getItemValue(0,getRow(),"SERIALNO");
	    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
	        alert(getHtmlMessage('1'));//请选择一条信息！
	        return;
	    }
//	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
//	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
	     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
	}
	
	/*~[Describe=打印第三方;InputParam=无;OutPutParam=无;]~*/
	function creatThirdTable(){
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sCustomerID=getItemValue(0,getRow(),"CUSTOMERID");
		//alert("sObjectNo"+sObjectNo+"==sCustomerID"+sCustomerID);
		var sObjectType = "ThirdSettle";
		//var sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		var xx = RunMethod("PublicMethod","GetColValue","TempSaveFlag,business_contract,String@SerialNo@"+sObjectNo);
		var sTempSaveFlag = xx.split("@")[1];
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
		var sCTempSaveFlag = RunMethod("BusinessManage","TempSaveFlag",sCustomerID);
		 if (typeof(sTempSaveFlag)=="undefined" || sTempSaveFlag.length==0 || sTempSaveFlag == "1" || typeof(sCTempSaveFlag)=="undefined" || sCTempSaveFlag.length==0 || sCTempSaveFlag == "1"){
			alert("客户或申请信息未保存，请保存信息后再打印申请表！");
			return;
		}else{ 
			//检查出帐通知单是否已经生成
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //未生成出帐通知单
				var sUrl = "/FormatDoc/Report17/04.jsp";
				//add 现金贷－申请表
				var ssProductID = RunMethod("PublicMethod","GetColValue","productid,business_contract,String@SerialNo@"+sObjectNo);
				var sProductID=ssProductID.split("@")[1];
				if(null == sProductID) sProductID = "";
				if("020" == sProductID)
				{
					sUrl = "/FormatDoc/CashLoanReport/04.jsp";
				}
				//end
				//生成出帐通知单	
 				PopPage(sUrl+"?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
 				//记录生成动作
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=produce");
				
			}else{
				//记录查看动作
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=view");
				
			}
			
			//获得加密后的出帐流水号
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//通过　serverlet 打开页面
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}
	}
	
	function contractView() {
		var sSerialNo=getItemValueArray(0, "SERIALNO");
		var sCustomerID=getItemValueArray(0, "CUSTOMERID");
//		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
//		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
//		var sAccessType = getItemValue(0,getRow(),"AccessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	         alert("请至少选中一条信息！ ");//请选择一条信息！
	         return;
	     }
		for(var i=0; i<sSerialNo.length;i++){
			var sValue=RunMethod("GetElement","GetElementValue","AccessType,business_contract,serialNo='"+sSerialNo[i]+"'");
			if(sValue=="01"){
				alert("你选中中的合同已存在被调阅！");
				return;
			}
		}
		
		sCompID = "AccessTypeInfo";
		sCompURL = "/AppConfig/Document/AccessTypeInfo.jsp";
	    var returnValue=popComp(sCompID,sCompURL,"serialNo="+sSerialNo+"&Type=Access&ssCustomerID="+sCustomerID+"&ssSerialNo="+sSerialNo,"dialogWidth=350px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(returnValue=="Success"){
	    	for(var i=0;i<sSerialNo.length;i++){
	    		 RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='01',serialNo='"+sSerialNo[i]+"'");
	    	}
	   	 alert("调阅成功！");
	    }
	    reloadSelf();
	}
	
	function tackbackContract() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sAccessType = getItemValue(0,getRow(),"AccessType");
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		 if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	           alert(getHtmlMessage('1'));//请选择一条信息！
	           return;
	     }
		 if (typeof(sAccessType)=="undefined" || sAccessType.length==0 || sAccessType=="正常(已归还)"){
	           alert("该合同没有被调阅,不需要归还！");//请选择一条信息！
	           return;
	     }
		sCompID = "AccessTypeInfo";
		sCompURL = "/AppConfig/Document/AccessTypeInfo.jsp";
		var returnValue=popComp(sCompID,sCompURL,"serialNo="+sSerialNo+"&Type=Return&customerID="+sCustomerID,"dialogWidth=350px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		 if(returnValue=="Success"){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='02',serialNo='"+sSerialNo+"'");
			alert("归还成功！");
		 }
		reloadSelf();
	}
	
	function destroyContract() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	           alert(getHtmlMessage('1'));//请选择一条信息！
	           return;
	    }
		if(confirm("您真的要销毁吗？")){
		    RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='03',serialNo='"+sSerialNo+"'");
			reloadSelf();
		}
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
