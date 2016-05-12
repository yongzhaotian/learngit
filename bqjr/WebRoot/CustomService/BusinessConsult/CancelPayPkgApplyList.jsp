<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CancelPayPkgApplyQueryList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//生成查询框
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0020", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0030", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0040", "CertID", "Operators=EqualsString;");
	//doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause = " where 1=2";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","申请取消","申请取消","cancelApply()",sResourcesPath},
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	/*~[Describe=取消申请;InputParam=无;OutPutParam=无;]~*/
	function cancelApply(){
		//手动取得审核中1020的FT表的字段
		//获得合同流水号、申请类型、流程编号、阶段编号
		var sObjectNo = getItemValue(0, getRow(), "SerialNo");//合同流水号
		var sCUSTOMERID = getItemValue(0, getRow(), "CUSTOMERID");
		var sCustomerName = getItemValue(0, getRow(), "CustomerName");
		var sBUGPAYPKGIND = getItemValue(0, getRow(), "BUGPAYPKGIND");
		
		var sStartDate = '';
		var sEndDate = '';
		var sCREATEOR = "<%=CurUser.getUserID()%>";
		var sUPDATEOR = "<%=CurUser.getUserID()%>";
		<%-- var sCREATETIME = "<%=StringFunction.getTodayNow()%>";
		var sUPDATETIME = "<%=StringFunction.getTodayNow()%>";
		var sCANCELSYSDATE = "<%=StringFunction.getTodayNow()%>"; --%>
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(sBUGPAYPKGIND!="是"){
			var sTemp="没有购买随心还服务包不能取消！";
			alert(sTemp);
			return;
		}
		
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckContractInfo", "checkContractStatus","contractNO="+sObjectNo);
		if("TRUE" != sReturn.split("@")[0]){
			alert(sReturn.split("@")[1]);
			return;
		}
		
		if (confirm("你确定要取消该笔随心还服务包吗？")) {
			var sPkgStatus =getItemValue(0,getRow(),"PkgStatus");
			if(sPkgStatus!="启用中"){
				var sTemp="只有启用中的随心还服务包才能取消！";
				alert(sTemp);
				return;
			}
			
			sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CancelPayPkgApply","cancelApply","serialNo="+sObjectNo+",CUSTOMERID="+sCUSTOMERID+",CustomerName="+sCustomerName+",StartDate="+sStartDate+",EndDate="+sEndDate+",CREATEOR="+sCREATEOR+",UPDATEOR="+sUPDATEOR);
			sPhaseInfo = sReturn.split("@")[0];
			if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
			else if (sPhaseInfo == "Success"){
				alert("取消随心还服务包成功！");
			}else if (sPhaseInfo == "Failure"){
				alert(sReturn.split("@")[1]);//提交失败！
				return;
			}
			reloadSelf();
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>