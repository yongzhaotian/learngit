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
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if (!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause =  " where 1=2"; 
	
	doTemp.WhereClause += " and landmarkstatus='4' and  (IsArchive is null or IsArchive='02')";
	doTemp.setVisible("AccessType,ArchiveAddress,RenturnDate,ReturnName,InputUserID", false);
	doTemp.setVisible("InputUserIDName,AccessDate,RenturnDate,ReturnName,ArchiveDate,NowReturnDate", false);
	doTemp.setVisible("AccessUserName,ReturnUserName", false);
	
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
			{"true","","Button","影像","影像","imageView()",sResourcesPath},
			{"true","","Button","归档","归档","archiveContract()",sResourcesPath},
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
		//add 现金贷－申请表
		sObjectType = "ApplySettle";
		var sDocID = "7006";
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
			//生成出帐通知单	
			//var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
			//PopPage("/FormatDoc/Report17/03.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			alert("电子合同不存在！");
			return;
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
	     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
//	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
//	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
	}
	
	function archiveContract(){
		var sSerialNo = getItemValueArray(0,"SERIALNO");
		var sUserID = "<%=CurUser.getUserID()%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		if(confirm("您真的确定归档吗？")){
			for(var i=0;i<sSerialNo.length;i++){
//				var sReturn= RunMethod("ArchiveContract","GetArchiveContract",sSerialNo[i]); 
				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractFile", "updateFile","SerialNo="+sSerialNo[i]);
				if(sReturn=="归档成功！"){
					RunMethod("ModifyNumber","GetModifyNumber","business_contract,LandMarkStatus='7',serialNo='"+sSerialNo[i]+"'");//修改地标状态 
					//add CCS-212 记录归档人员编号
					RunMethod("ModifyNumber","GetModifyNumber","business_contract,ArchiveUserID='"+sUserID+"',serialNo='"+sSerialNo[i]+"'");
					//end
				}
			}
	    	alert(sReturn);
		}
	  reloadSelf();
	}
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//使用ObjectViewer以视图001打开Example，
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
