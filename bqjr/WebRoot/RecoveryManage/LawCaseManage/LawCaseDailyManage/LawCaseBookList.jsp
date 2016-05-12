<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 过程台帐信息列表
		Input Param:
				SerialNo：案件流水号
				BookType：台帐类型 
				LawCaseType：案件类型
		Output param:
				ObjectNo:案件流水号
				ObjectType:对象类型LAWCASE_INFO
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "过程台帐信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
		
	//获得组件参数（案件流水号、台帐类型、案件类型）		
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sBookType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BookType"));
	String sLawCaseType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("LawCaseType"));
	//获取合同终结类型
    String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
    //获取归档日期
    String sPigeonholeDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PigeonholeDate"));   

	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sBookType == null) sBookType = "";
	if(sLawCaseType == null) sLawCaseType = "";
    if(sFinishType == null) sFinishType = "";
    if( sPigeonholeDate == null) sPigeonholeDate = "";
	
	String sObjectType = "LawcaseInfo";
		
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//根据不同的booktype（台帐类型）显示不同的模板	
 	if (sBookType.equals("010"))	//支付令台帐
		sTempletNo="PaymentList";
	if (sBookType.equals("020"))	//诉前保全台帐
		sTempletNo="DamageList";
	if (sBookType.equals("026"))	//诉讼保全台帐
		sTempletNo="DamageList";
	if (sBookType.equals("030"))	//立案台帐
		sTempletNo="BeforeLawsuitList";
	if (sBookType.equals("040"))	//一审台帐
		sTempletNo="FirstLawsuitList";
	if (sBookType.equals("050"))	//二审台帐
		sTempletNo="SecondLawsuitList";
	if (sBookType.equals("060"))	//再审台帐
		sTempletNo="LastLawsuitList";
	if (sBookType.equals("070"))	//执行台帐
		sTempletNo="EnforceLawsuitList";
	if (sBookType.equals("080"))	//破产台帐
		sTempletNo="BankruptcyList";
	if (sBookType.equals("065"))	//公证台帐
		sTempletNo="ArbitrateList";
	if (sBookType.equals("068"))	//仲裁台帐
		sTempletNo="NotarizationList";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
	
	//定义后续事件中要保存的表
	String sTableName = "LAWCASE_INFO";
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sSerialNo+","+sBookType);

	//Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
	//out.println("----"+doTemp.SourceSql);
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
			{sFinishType.equals("")?(sPigeonholeDate.equals("")?"true":"false"):"false","All","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{sFinishType.equals("")?(sPigeonholeDate.equals("")?"true":"false"):"false","All","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseBookInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sSerialNo%>&LawCaseType=<%=sLawCaseType%>&BookType=<%=sBookType%>&SerialNo=","right","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得台帐编号、对象编号或案件编号、对象类型、台帐类型
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		var sBookType=getItemValue(0,getRow(),"BookType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseBookInfo.jsp?SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&LawCaseType=<%=sLawCaseType%>&BookType="+sBookType+"","right","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
