<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "法律诉讼页面";
	//获得页面参数
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));
	if(sPhaseType1==null) sPhaseType1="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ConsumeCollectionLawList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseType1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","查看合同","查看合同","OverDuelContractList()",sResourcesPath},
		{"true","","Button","行动代码录入","行动代码录入","viewAndEdit()",sResourcesPath},
		{"true","","Button","历史查询","历史查询","viewHistory()",sResourcesPath},
	};
	

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	//行动代码录入
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");//催收流水号
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");//客户编号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		sCompID = "ConsumeCollectionRegistInfo";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeCollectionRegistInfo.jsp";
	    popComp(sCompID,sCompURL,"CollectionSerialNo="+sSerialNo+"&CustomerID="+sCustomerID,"dialogWidth=400px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	
	//查看催收历史 
	function viewHistory(){
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ConsumeCollectionRegistList.jsp", "CustomerID="+sCustomerID+"&PhaseType1=<%=sPhaseType1%>", "_self","");
		
	}
	
	
	/*查看客户项下所有逾期合同*/
	function OverDuelContractList(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("该催收任务信息不完整，客户号为空！");
			return;
		}
	
		sCompID = "ConsumeOverDuelBCList";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeOverDuelBCList.jsp";
		sParamString = "CustomerID="+sCustomerID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		reloadSelf();
	}



	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
