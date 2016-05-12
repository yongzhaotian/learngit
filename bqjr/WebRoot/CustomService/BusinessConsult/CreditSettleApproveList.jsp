<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "贷款结清证明审批页面";
  
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CreditSettleApprove";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause = " where 1=2";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","确认并打印结清证明","确认并打印结清证明","InsureApprove()",sResourcesPath},
		
	};
    
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	

	function InsureApprove()
	{
		var sSerialNo = getItemValue(0,getRow(),"ApplySerialNo");//合同申请编号
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		
	//	var sContractStatus = getItemValue(0,getRow(),"ContractStatus");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
	   	RunMethod("BusinessManage","updateIsScan",sObjectNo);
	 	
	   	//检查出帐通知单是否已经生成
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //未生成出帐通知单
			//生成出帐通知单	
			PopPage("/FormatDoc/Report13/7001.jsp?DocID=7001&ObjectNo="+sSerialNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//获得加密后的出帐流水号
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sSerialNo);
		
		//通过　serverlet 打开页面
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		 
	}
	
	


	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//查询条件展开设置
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>