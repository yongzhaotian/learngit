<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: 签署意见
	Input Param:
		TaskNo：任务流水号
		ObjectNo：对象编号
		ObjectType：对象类型
	Output param:
	History Log: zywei 2005/07/31 重检页面
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "签署意见";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	//定义变量
	String sSql = "";//--存放sql语句
	String sCustomerID = "";//--存放客户编号   
	ASResultSet rs = null;//-- 存放结果集

	//获取组件参数：任务流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sFlowNo == null) sFlowNo = "";
%>
<%/*~END~*/%>

	<%
		//取得客户编号
		sSql = "select CustomerID from Business_Contract where SerialNo= :serialno ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sObjectNo));
		if(rs.next()){
			sCustomerID = rs.getString("CustomerID");
		}
		rs.getStatement().close();
		if(sCustomerID == null) sCustomerID = ""; 

		
		sFlowNo = Sqlca.getString(new SqlObject("select FlowNo  from FLOW_TASK where SerialNo ='"+sSerialNo+"'"));

	   // 通过DW模型产生ASDataObject对象doTemp
		String sTempletNo = "SignTaskOpinionInfo";//模型编号
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		if(sObjectType.equals("TransactionApply")){
			doTemp.setRequired("SVRESULT",false);
			doTemp.setVisible("SVRESULT",false);
		}
		//汽车金融签署意见界面
		if(sFlowNo.startsWith("CarFlow")){
			doTemp.setVisible("SVRESULT", false);
			doTemp.setVisible("ISSCENE", false);
			
			doTemp.setRequired("SVRESULT",false);
			doTemp.setRequired("ISSCENE",false);
			
			doTemp.setHeader("PhaseOpinion", "签署意见");
		}
		
		
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
			{"true","","Button","电话仓库","电话仓库","getPhoneCode()",sResourcesPath},
		};
	
	if(sObjectType.equals("TransactionApply")){
		sButtons[2][0] ="false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=保存签署的意见;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		//不允许签署的意见为空白字符
		if(/^\s*$/.exec(getItemValue(0,0,"PhaseOpinion"))){
			alert("请签署意见！");
			setItemValue(0,0,"PhaseOpinion","");
			return;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0");
	}
	
	/*~[Describe=删除已删除意见;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    //未签署意见,点击删除给出提示信息后，不进行页面刷新操作
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0){
	   		alert("您还没有签署意见，不能做删除意见操作！");
	 	}else if(confirm("你确实要删除意见吗？"))	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1){
	    		alert("意见删除成功!");
	  		}else{
	    		alert("意见删除失败！");
	   		}
			reloadSelf();
		}
	} 
	
	/*~[Describe=电话录入;InputParam=无;OutPutParam=无;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		
	 }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initOpinionNo() 
	{
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		var sTableName = "FLOW_OPINION";//表名
		var sColumnName = "OpinionNo";//字段名
		var sPrefix = "";//无前缀
								
		//获取流水号
		var sOpinionNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sOpinionNo);*/
		
		//获取流水号
		var sOpinionNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
		//将流水号置入对应字段
		setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
		/** --end --*/
	}
	
	/*~[Describe=插入一条新记录;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//如果没有找到对应记录，则新增一条，并可以设置字段默认值
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");			
		}        
	}
	</script>
<%/*~END~*/%>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%@ include file="/IncludeEnd.jsp"%>