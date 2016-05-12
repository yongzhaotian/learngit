<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	
// 获得页面参数
	String sCustomerID = DataConvert.toRealString(iPostChange,CurComp.getParameter("CustomerID"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	
    System.out.println("----"+sCustomerID+"----"+sObjectNo+"-----"+sObjectType);

	if(sCustomerID==null) sCustomerID="";
	if(sObjectNo==null) sObjectNo="";
	if(sObjectType==null) sObjectType="";

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "OldBusinessContractList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	// doTemp.WhereClause+=" and exists (select * from Formatdoc_Record where (objectType='ApplySettle' or objectType = 'CashLoanSettle') and objectno=BUSINESS_CONTRACT.Serialno) "+
	 //" and not exists(select objectno from flow_object where objectno = BUSINESS_CONTRACT.Serialno and phaseno = '9000' and (flowno = 'CreditFlow' or flowno = 'CashLoanFlow'))";
	doTemp.WhereClause+="and 1=1";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String AppUrl = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String JQMUrl = CodeCache.getItem("PrintAppUrl","0013").getItemAttribute();
	String FCUrl = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
		{"true","","Button","详情","详情记录","myDetail()",sResourcesPath},	
		{"false","","Button","查看电子合同","查看电子合同","",sResourcesPath},
		{"true","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//查询阶段信息
		var sPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		var sFlowNo=RunMethod("BusinessManage","GetFlowObjectInfo",sObjectType+","+sObjectNo);
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=详情;InputParam=无;OutPutParam=无;]~*/
	function myDetail(){
		sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sObjectType = "ApplySettle";	
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		var sAppFlag = RunMethod("公用方法", "GetColValue", "Business_Contract,SureType,SerialNo='<%=sObjectNo%>'");
		var url = "";
		if(sAppFlag=="APP"){//APP端提交数据
			url="<%=AppUrl%>"+<%=sObjectNo%>;
			window.open(url);
			return;
		}else if(sAppFlag=="JQM"){
			url="<%=JQMUrl%>"+<%=sObjectNo%>;
			window.open(url);
			return;
		}else if(sAppFlag=="FC"){
			url="<%=FCUrl%>"+<%=sObjectNo%>;
			window.open(url);
			return;
		}
		
/*		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		var sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>";
//		if (sFlowNo=="PutOutFlow" && sPhaseNo != "0035") {
//			sParamString += "&ViewID=002";
//		}
		//OpenComp(sCompID,sCompURL,sParamString,"","maximize:yes;help:no;minimize:yes");
		AsControl.PopComp(sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
//		popComp(sCompID,sCompURL,"","dialogWidth=100%;dialogHeight=;resizable=no;scrollbars=no;status:yes;maximize:yes;help:no;minimize:yes");
     */ 
		//获得加密后的出帐流水号
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sSerialNo);
		//通过　serverlet 打开页面
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
	}
	
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

