<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-28
		Tester:
		Describe: 担保合同所对应的拟引入的担保合同列表（一个保证合同对应一个保证人）;
		Input Param:
				ObjectType：对象类型（BusinessContract）
				ObjectNo: 对象编号（合同流水号）
		Output Param:
				
		HistoryLog:				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "拟引入担保合同列表"; // 浏览器窗口标题 
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
    String sWhereCond = "";
	//获得组件参数：对象类型、对象编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	//add by hwang 20090721.解决贷后管理中抵质押物详情显示不了问题。当对象类型为AfterLoan等其他类型时,GUARANTY_RELATIVE表中无数据。
	//现在修改逻辑,当对象类型为非申请、审批、合同时，默认为合同《
	//判断当ObjectType类型为ReinforceContract时，显示新增和删除按钮 2010/04/01
	if(sObjectType.equals("ReinforceContract")){
		sObjectType="ReinforceContract";
	}else if(!(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract"))){
		sObjectType="BusinessContract";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
   //通过DW模型产生ASDataObject对象doTemp
   String sTempletNo = "ContractAssureList2";//模型编号
   ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

    //where语句统一修改处，涉及业务不配在模板中				
    sWhereCond = " where  exists (Select CONTRACT_RELATIVE.ObjectNo from CONTRACT_RELATIVE  where "+
	                              " CONTRACT_RELATIVE.SerialNo = '"+sObjectNo+"' and CONTRACT_RELATIVE.ObjectType='GuarantyContract' "+
	                              " and CONTRACT_RELATIVE.RelationStatus = '010' and CONTRACT_RELATIVE.ObjectNo = GUARANTY_CONTRACT.SerialNo) and GUARANTY_CONTRACT.ContractType='020' "+
	                              " and (ContractStatus = '010' or ContractStatus = '020') "; 
    doTemp.WhereClause += sWhereCond;

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
	//获取业务申请人代码
	sSql = " select CustomerID from BUSINESS_CONTRACT where SerialNo =:SerialNo ";
	String sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sCustomerID == null) sCustomerID = "";
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
		{"false","All","Button","引入","引入担保合同信息","importRecord()",sResourcesPath},
		{"true","","Button","详情","查看担保合同信息详情","viewAndEdit()",sResourcesPath},
		{"false","All","Button","删除","删除担保合同信息","deleteRecord()",sResourcesPath},
		{"true","","Button","担保客户详情","查看担保合同相关的担保客户详情","viewCustomerInfo()",sResourcesPath},
	};
	if(sObjectType.equals("ReinforceContract")){
		sButtons[0][0]="true";
		sButtons[2][0]="true";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=引入记录;InputParam=无;OutPutParam=无;]~*/
	function importRecord(){
	    //传入当前的条件即可
	  sParaString = "RelativeTableName,CONTRACT_RELATIVE RT,ObjectNo,<%=sObjectNo%>,ContractStatus,020,ContractType,020,OrgID,<%=CurUser.getOrgID()%>";
		sReturn = selectObjectValue("SelectImportGuarantyContract",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sSerialNo = sReturn[0];
		sReturn=RunMethod("BusinessManage","ImportGauarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
		if(sReturn == "EXIST") alert(getBusinessMessage('415'));//该担保合同已经引入！
		if(sReturn == "SUCCEEDED") {
			alert(getBusinessMessage('416'));//引入担保合同成功！
			reloadSelf();
		}
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			sReturn=RunMethod("BusinessManage","DeleteGuarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED"){
				alert(getHtmlMessage('7'));//信息删除成功！
				reloadSelf();
			}else{
				alert(getHtmlMessage('8'));//对不起，删除信息失败！
				return;
			}	
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//--担保方式
			OpenPage("/CreditManage/CreditAssure/ContractAssureInfo2.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
		}
	}

	/*~[Describe=查看担保客户详情详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			var sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//系统中不存在担保人的客户基本信息，不能查看！
			else
				openObject("Customer",sCustomerID,"002");
		}
	}
	
	/*~[Describe=选中某笔担保合同,联动显示担保项下的抵质押物;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else{
			var sGuarantyType = getItemValue(0,getRow(),"GuarantyType");			
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=保证担保下无详细信息!","DetailFrame","");
			}else{
				if (sGuarantyType.substring(0,3) == "050") //抵押
					OpenPage("/CreditManage/GuarantyManage/ContractPawnList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
				else //质押
					OpenPage("/CreditManage/GuarantyManage/ContractImpawnList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
			}
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	OpenPage("/Blank.jsp?TextToShow=请先选择相应的担保信息!","DetailFrame","");
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>