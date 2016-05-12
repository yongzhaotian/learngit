<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hwang 2009-06-15
		Tester:
		Describe: 流水台帐列表;
		Input Param:
			ObjectNo	合同流水号
			ObjectType：010发放流水
				    	020回收流水
				    	增加ALL 全部
		Output Param:
			
		HistoryLog:
	
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "流水台帐列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";

	//获得页面参数
	
	//获得组件参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//AccountType 01 发放 02 回收
	String sAccountType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AccountType"));
	
	if(sObjectNo == null) sObjectNo = "";
	if(sAccountType == null) sAccountType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//列表表头
	String sHeaders[][] = { {"SerialNo","交易流水号"},
							{"OccurDirectionName","台帐类型"},
							{"RelativeContractNo","合同流水号"},
							{"RelativeSerialNo","借据流水号"},							
							{"OccurDate","发生日期"},
							{"BusinessCCYName","币种"},
							{"BackType","回收方式"},
							{"ActualDebitSum","发放金额(元)"},
							{"ActualCreditSum","回收金额(元)"}
					  };

	if(sAccountType.equals("ALL")){
		sSql =	" select SerialNo,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,"+
				" RelativeContractNo,OccurDate,ActualDebitSum,ActualCreditSum "+
				" from BUSINESS_WASTEBOOK  "+
				" where RelativeContractNo='"+sObjectNo+"' "+
				" and OccurSubject='0'"+
				" order by OccurDate ";
	}else if(sAccountType.equals("01")){
		sSql =	" select SerialNo,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,"+
				" RelativeContractNo,OccurDate,ActualDebitSum "+
				" from BUSINESS_WASTEBOOK  "+
				" where RelativeContractNo='"+sObjectNo+"' "+
				" and OccurDirection='0'  "+
				" and OccurSubject='0' "+
				" order by OccurDate ";
	}else if(sAccountType.equals("02")){
		sSql =	" select SerialNo,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,"+
				" RelativeContractNo,OccurDate,getItemName('ReclaimType',BackType) as BackType,ActualCreditSum "+
				" from BUSINESS_WASTEBOOK  "+
				" where RelativeContractNo='"+sObjectNo+"' "+
				" and OccurDirection='1' "+
				" and OccurSubject='0' "+
				" and (BackType <> ' ' and BackType is not null) "+
				" order by  OccurDate ";
	}
	//out.println(sSql);

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("OccurDirection,BusinessCurrency,OccurType",false);

    //设置金额为数字形式
    doTemp.setType("ActualCreditSum,ActualDebitSum","Number");
    doTemp.setCheckFormat("ActualCreditSum,ActualDebitSum","2");
	doTemp.setAlign("ActualCreditSum,ActualDebitSum","3");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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
		{"true","","Button","新增流水","新增流水","newRecord()",sResourcesPath},
		{"true","","Button","查看详情","查看详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除流水","删除流水","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增流水信息;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		var sReturn = PopPage("/CreditManage/CreditPutOut/AccountWasteBookDialog.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(sReturn == "_RePay_"){
			OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo1.jsp?OccurDirection=1", "_self","");
		}else if(sReturn == "_Credit_"){
			OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo1.jsp?OccurDirection=0", "_self","");
		}else{
			alert("您没有选择新增流水的发生方向");
			return;
		}
		
		//OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo.jsp?OccurDirection=1", "_self","");
	}
	
	/*~[Describe=删除流水信息;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
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
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sOccurDirection = getItemValue(0,getRow(),"OccurDirection");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo.jsp?SerialNo="+sSerialNo, "_self","");
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
