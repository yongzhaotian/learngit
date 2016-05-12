<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jbye 2004-12-16 20:40
		Tester:
		Describe: 修改报表信息
		Input Param:
			--sRecordNo:	报表流水号
			
		Output Param:

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "报表说明"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sRecordNo = "";//--报表流水号
	boolean isEditable=true;
	String sSql = "";//--存放sql语句
	//获得组件参数,报表流水号
	sRecordNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sEditable =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable"));
	if("false".equals(sEditable))isEditable=false;
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sHeaders[][] = {
							{"CustomerID","客户号"},
							{"RecordNo","记录号"},
							{"ReportDate","报表日期"},
							{"ReportScope","报表口径"},
							{"ReportPeriod","报表周期"},
							{"ReportCurrency","报表币种"},
							{"ReportUnit","报表单位"},
							{"ReportStatus","报表状态"},
							{"ReportFlag","报表检查标志"},
							{"ReportOpinion","报表注释"},
							{"AuditFlag","是否审计"},
							{"AuditOffice","审计单位"},
							{"AuditOpinion","审计意见"},
							{"InputDate","登记日期"},
							{"OrgName","登记机构"},
							{"UserName","登记人"},
							{"UpdateDate","修改日期"},
							{"Remark","备注"}

						  };

	sSql = 	" select CustomerID,RecordNo,ReportDate,ReportScope,ReportPeriod,ReportCurrency,"+
			" ReportUnit,ReportStatus,ReportFlag,ReportOpinion,AuditFlag,AuditOffice,AuditOpinion,"+
			" getUserName(UserID) as UserName,"+
			" getOrgName(OrgID) as OrgName,"+
			" InputDate,OrgID,UserID,UpdateDate,Remark "+
			" from CUSTOMER_FSRECORD "+
			" where RecordNo='"+sRecordNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_FSRECORD";
	doTemp.setKey("RecordNo",true);	
	doTemp.setUpdateable("UserName,OrgName",false);
	
	doTemp.setRequired("ReportScope,ReportPeriod,ReportUnit,ReportCurrency",true);
	doTemp.setVisible("CustomerID,RecordNo,OrgID,UserID,Remark,ReportStatus,ReportFlag",false);
	//下拉列表
	doTemp.setDDDWCode("ReportPeriod","ReportPeriod");
	doTemp.setDDDWCode("ReportCurrency","Currency");
	doTemp.setDDDWCode("ReportStatus","ReportStatus");
	doTemp.setDDDWCode("ReportScope","ReportScope");
	doTemp.setDDDWCode("ReportUnit","ReportUnit");
	doTemp.setDDDWCode("AuditFlag","YesNo");
	
	doTemp.setEditStyle("ReportOpinion,AuditOpinion","3");
	doTemp.setReadOnly("ReportDate,UserName,OrgName,InputDate,UpdateDate",true);
	doTemp.appendHTMLStyle("ReportDate"," style={width=55px} ");
	doTemp.appendHTMLStyle("ReportOpinion,AuditOpinion","  style={height:100px;width:400px;overflow:auto} ");
    doTemp.setLimit("ReportOpinion,AuditOpinion",200);
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.setEvent ("AfterUpdate","!CustomerManage.SaveFinanceReport(#CustomerID,#RecordNo,#ReportScope,#ReportDate)");
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{isEditable?"true":"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件-----------------------//
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		//当前月份财务报表已存在
		if(checkFSMonth()){
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		alert(sReportDate +" 的财务报表已存在！");
		return;
		}
		setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"OrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		as_save("myiframe0");
	}
	
	/*~[Describe=返回;InputParam=后续事件;OutPutParam=无;]~*/
	function goBack()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		OpenComp("CustomerFSList","/CustomerManage/EntManage/CustomerFSList.jsp","CustomerID="+sCustomerID,"_self",OpenStyle);
	}
	
	/*~[Describe=获取月份;InputParam=后续事件;OutPutParam=无;]~*/
	function getMonth(sObject)
	{
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined")
		{
			setItemValue(0,0,sObject,sReturnMonth);
		}
	}
	/*~[Describe=检测报表月份是否已存在;InputParam=后续事件;OutPutParam=无;]~*/
	function checkFSMonth(){
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReturn=RunMethod("CustomerManage","CheckFSRecord",sCustomerID+","+sRecordNo+","+sReportDate);
		if(sReturn>0)return true;
		return false;
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
