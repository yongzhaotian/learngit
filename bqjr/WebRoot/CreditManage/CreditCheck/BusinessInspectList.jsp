<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 贷后检查列表
		Input Param:
			InspectType：  报告类型 
				010     贷款用途检查报告
	            010010  未完成
	            010020  已完成
	            020     贷后检查报告
	            020010  未完成
	            020020  已完成
		Output Param:
			SerialNo:流水号
			ObjectType:对象类型
			ObjectNo：对象编号
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后检查列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得组件参数
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InspectType"));
    if(sInspectType == null) sInspectType="020010";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
 	 
   
    String sWhereCond="";
  	ASDataObject doTemp = null;
  	if(sInspectType.equals("010010") || sInspectType.equals("010020")){ 
  		 String sTempletNo = "BusinessInspectList1";
  		 doTemp = new ASDataObject(sTempletNo,Sqlca);	
  		 sWhereCond=" where  INSPECT_INFO.ObjectType='BusinessContract' "+
	                " and  INSPECT_INFO.InspectType like '010%' "+
	                " and  INSPECT_INFO.ObjectNo=BUSINESS_CONTRACT.SerialNo "+
	                " and  INSPECT_INFO.InputUserID='"+CurUser.getUserID()+"'";
  		if(sInspectType.equals("010010")){
			doTemp.WhereClause=doTemp.WhereClause+sWhereCond+" and ( INSPECT_INFO.FinishDate = ' ' or  INSPECT_INFO.FinishDate is null)";
			doTemp.OrderClause += " order by INSPECT_INFO.UpDateDate desc";
		}
  		else{
			doTemp.WhereClause=doTemp.WhereClause+sWhereCond+" and  INSPECT_INFO.FinishDate <> ' ' and  INSPECT_INFO.FinishDate is not null";
			doTemp.OrderClause += " order by INSPECT_INFO.FinishDate desc";
		}
  		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request, iPostChange);
		CurPage.setAttribute("FilterHTML",
				doTemp.getFilterHtml(Sqlca));
  	}
  	else if(sInspectType.equals("020010") || sInspectType.equals("020020")){
  		 String sTempletNo = "BusinessInspectList2";
  		doTemp = new ASDataObject(sTempletNo,Sqlca);	
  		sWhereCond="where ObjectType='Customer' "+
                " and InspectType  like '020%' "+
                " and InputUserID='"+CurUser.getUserID()+"'";
  		if(sInspectType.equals("020010")){
  			doTemp.WhereClause=doTemp.WhereClause+sWhereCond+" and (FinishDate = ' ' or FinishDate is null)";
  			doTemp.OrderClause += "Order by UpDateDate desc";
		}
  		else{
			doTemp.WhereClause=doTemp.WhereClause+sWhereCond+" and FinishDate is not null";
			doTemp.OrderClause += "Order by FinishDate desc";
		}
  		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request, iPostChange);
		CurPage.setAttribute("FilterHTML",
				doTemp.getFilterHtml(Sqlca));
	} //新增模型：2013-5-9

  	
  	  	
  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
  	dwTemp.Style="1";      //设置为Grid风格
  	dwTemp.ReadOnly = "1"; //设置为只读
  	
    //定义后续事件，同时删除附表信息
	dwTemp.setEvent("BeforeDelete","!InfoManage.DeleteInspectData(#SerialNo)");
  
  	Vector vTemp = dwTemp.genHTMLDataWindow("");
  	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		{"true","","Button","新增","新增报告","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看报告详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除该报告","deleteRecord()",sResourcesPath},
		{"true","","Button","客户基本信息","查看客户基本信息","viewCustomer()",sResourcesPath},
		{"true","","Button","业务清单","查看业务清单","viewBusiness()",sResourcesPath},
		{"false","","Button","完成","完成报告","finished()",sResourcesPath},
		{"false","","Button","撤回","重新填写报告","ReEdit()",sResourcesPath}
		};
		
		if(sInspectType.equals("010010") || sInspectType.equals("020010")){
			sButtons[5][0] = "true";
		}
		
		if(sInspectType.equals("010020") || sInspectType.equals("020020")){
		    sButtons[0][0] = "false";
		    sButtons[2][0] = "false";
		    sButtons[6][0] = "true";
		}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		sInspectType = "<%=sInspectType%>";
		if(sInspectType == '010010'){
			//选择贷后的合同信息
			var sParaString = "ManageUserID" + "," + "<%=CurUser.getUserID()%>";
			sReturn = selectObjectValue("SelectInspectContract",sParaString,"",0,0);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") 
				return;
			sReturn = sReturn.split("@");
			//得到合同编号
			sContractNo=sReturn[0];
			sSerialNo = PopPageAjax("/CreditManage/CreditCheck/AddInspectActionAjax.jsp?ObjectNo="+sContractNo+"&InspectType="+sInspectType+"&ObjectType=BusinessContract","","");
			sCompID = "PurposeInspectTab";
			sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sContractNo+"&ObjectType=BusinessContract";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}else if(sInspectType == '020010'){
			sParaString = "UserID" + "," + "<%=CurUser.getUserID()%>";
			sReturn = selectObjectValue("SelectInspectCustomer",sParaString,"",0,0);
			//alert(sReturn);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
			sReturn = sReturn.split("@");			
			//得到客户输入信息
			sCustomerID=sReturn[0];
			//向检查表中插记录
			sSerialNo = PopPageAjax("/CreditManage/CreditCheck/AddInspectActionAjax.jsp?ObjectNo="+sCustomerID+"&InspectType="+sInspectType+"&ObjectType=Customer","","");
			sCompID = "InspectTab";
			sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sCustomerID+"&ObjectType=Customer";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sInspectType = "<%=sInspectType%>";
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			if(sInspectType == '010010' || sInspectType == '010020'){
				sCompID = "PurposeInspectTab";
				sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;

				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else if(sInspectType == '020010' || sInspectType == '020020'){
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
		}
	}

  	/*~[Describe=完成;InputParam=无;OutPutParam=无;]~*/
	function finished(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getBusinessMessage('650')))//你真的想完成该报告吗？
		{
			sReturn=PopPageAjax("/CreditManage/CreditCheck/FinishInspectActionAjax.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if(sReturn=="Inspectunfinish"){
				alert(getBusinessMessage('651'));//该贷后检查报告无法完成，请先完成风险分类！
				return;
			}
			if(sReturn=="Purposeunfinish"){
				alert(getBusinessMessage('652'));//该贷款用途报告无法完成，请先输入提款记录和用款纪录！
				return;
			}
			if(sReturn=="finished"){
				alert(getBusinessMessage('653'));//该报告已完成！
				reloadSelf();
			}
		}
	}
	 
    /*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer(){
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020"){
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020"){
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			openObject("Customer",sCustomerID,"001");
		}
    		
    }
    /*~[Describe=查看业务清单;InputParam=无;OutPutParam=无;]~*/
	function viewBusiness(){
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020"){
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020"){
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			popComp("CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,"","","");
		}
	}
	
	function ReEdit(){
	    var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getBusinessMessage('654')))//你确定要撤回该报告吗？
		{
			sReturn=PopPageAjax("/CreditManage/CreditCheck/ReEditInspectActionAjax.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if(sReturn=="succeed")
				alert(getBusinessMessage('655'));//报告撤回完成！
			reloadSelf();
		}
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