<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "注册部包裹页面";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	  
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PackagePostList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增包裹","新增包裹","newRecord()",sResourcesPath},
		{"true","","Button","关联合同","关联合同","relativeContract()",sResourcesPath},
		{"true","","Button","打印邮寄清单","打印邮寄清单","printPostList()",sResourcesPath},
		{"true","","Button","确定邮寄","确定邮寄","confirmPost()",sResourcesPath},
		{"false","","Button","删除","删除","deleteRecord()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},

	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

		//Excel导出功能呢	
		function exportExcel(){
			amarExport("myiframe0");
		}
		//end by pli2 20140417	

	<%/*~[Describe=确定邮寄;InputParam=无;OutPutParam=无;] ~*/%>
	function confirmPost() {
		var sPackNo = getItemValue(0,getRow(),"PackNo");
		var sCreateUser = getItemValue(0,getRow(),"CreateUser");//包裹创建人
		var userid="<%=CurUser.getUserID()%>";

		if (typeof(sPackNo)=="undefined" || sPackNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if(sCreateUser == userid){
			//更新包裹状态为"已邮寄"
			RunMethod("BusinessManage","updatePackStatus",sPackNo);
			
			//更新包裹关联的合同地标状态由门店变更为"送往贷款人"(1:门店；2：送往总部；3：送往贷款人；4：贷款人)
			RunMethod("BusinessManage","updatePackContractStatus","3,"+sPackNo);
			reloadSelf();
		}else{
			alert("当前用户无法操作此包裹！");
		}
	}
	
	<%/*~[Describe=打印邮寄清单;InputParam=无;OutPutParam=无;] ~*/%>
	function printPostList() {
		var sObjectNo = getItemValue(0,getRow(),"PackNo");
		var sCreateUser = getItemValue(0,getRow(),"CreateUser");//包裹创建人
		var userid="<%=CurUser.getUserID()%>";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(sCreateUser == userid){
			sObjectType = "CreditSettle";
			sExchangeType = "";
			//edit by phe 2015/03/10 (把生成的包裹清单可以重新生存   CCS-181)
			//检查出帐通知单是否已经生成
			//var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7004&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			
			/* if (sReturn == "false"){ //未生成出帐通知单
				//生成出帐通知单	
				PopPage("/FormatDoc/Report17/00.jsp?DocID=7004&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			} */
			//添加一个删除原来过去的邮寄清单的方法
			RunMethod("BusinessManage", "DeleteFormatdocRecord", sObjectType+","+sObjectNo);
			//生成出帐通知单	
			PopPage("/FormatDoc/Report17/00.jsp?DocID=7004&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			//end by phe 2015/03/10
			//获得加密后的出帐流水号
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//通过　serverlet 打开页面
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}else{
			alert("当前用户无法操作此包裹！");
		}
	}

	<%/*~[Describe=关联合同;InputParam=无;OutPutParam=无;] ~*/%>
	function relativeContract(){
		var sPackNo = getItemValue(0,getRow(),"PackNo");
		var sCreditID = getItemValue(0,getRow(),"CreditID");
		var sCreateUser = getItemValue(0,getRow(),"CreateUser");//包裹创建人
		
		if (typeof(sPackNo)=="undefined" || sPackNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		sCompID = "PackRelativeContractList";
		sCompURL = "/BusinessManage/ContractManage/PackRelativeContractList.jsp";
		sString="PackNo="+sPackNo+"&Flag="+"Y"+"&CreditID="+sCreditID+"&CreateUser="+sCreateUser;
		sReturn = popComp(sCompID,sCompURL,sString,"dialogWidth=850px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:yes;help:no;");
	    reloadSelf();
	}

	<%/*~[Describe=新增包裹;InputParam=无;OutPutParam=无;] ~*/%>
	function newRecord(){
		sCompID = "PackageInfo";
		sCompURL = "/BusinessManage/ContractManage/PackageInfo.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=500px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	<%/*~[Describe=删除包裹信息;InputParam=无;OutPutParam=无;] ~*/%>
	function deleteRecord(){
		var sPackNo = getItemValue(0,getRow(),"PackNo");
		var sCreateUser = getItemValue(0,getRow(),"CreateUser");//包裹创建人
		var userid="<%=CurUser.getUserID()%>";
		
		if (typeof(sPackNo)=="undefined" || sPackNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//如果登陆人与包裹创建人相同，可以操作
		if(sCreateUser == userid){
			if(confirm("您真的想删除该信息吗？")){
				RunMethod("BusinessManage","delRelContract",sPackNo);//先删除包裹中的合同
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
			
		}else{
			alert("当前用户无法操作此包裹！");
		}
	}


	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>