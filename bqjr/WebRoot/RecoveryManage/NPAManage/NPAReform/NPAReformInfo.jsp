<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   SLLIUA  2005.02.02
		Tester:
		Content: 重组方案执行台帐
		Input Param:
			sSerialNo 重组方案流水号
		Output param:

		History Log: 

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "重组方案执行台帐"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	
	//获得页面参数(重组方案流水号)	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));	
	
	if(sSerialNo == null) sSerialNo = "";
	
	String sSql="";
	String sSql1="";
	
	ASResultSet rs;
	ASResultSet rs1;
	
	String sFlag3="";
	String sOtherCondition="";
	String sFlag2="";
	String sImmediacyPaySource="";
	String sPaySource="";
	String sArtificialNo="";
	String sCustomerName="";
	String sVouchType="";
	String sContractNo="";
	
	double sReformSum=0.00;
	double sBusinessSum=0.00;
	double sDayCount=0.00;
	
	sSql1 =   " select BC.SerialNo as SerialNo,BC.ArtificialNo as ArtificialNo,BC.OverdueDays as OverdueDays, "+
	          " BC.CustomerName as CustomerName," + 
	          " isnull(BC.BusinessSum,0) as BusinessSum," +
	          " BC.VouchType " + 
	          " from BUSINESS_CONTRACT BC ,CONTRACT_RELATIVE CR " +
			  " where BC.SerialNo = CR.SerialNo "+
			  " and  CR.ObjectType = 'RelativeReform' " +
			  " and CR.ObjectNo = :ObjectNo  order by SerialNo" ;
	rs1 = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("ObjectNo",sSerialNo)); 
   	while(rs1.next()){
		//合同编号、新借款人、重组发放金额、主要担保方式
		sContractNo = DataConvert.toString(rs1.getString("SerialNo"));
		sArtificialNo = DataConvert.toString(rs1.getString("ArtificialNo"));
		sCustomerName = DataConvert.toString(rs1.getString("CustomerName"));
		sVouchType = DataConvert.toString(rs1.getString("VouchType"));
		sBusinessSum = rs1.getDouble("BusinessSum");
		sDayCount = rs1.getDouble("OverdueDays");
		sReformSum = sReformSum+sBusinessSum;
	}
	rs1.getStatement().close();
	
	sSql =  "  select Flag3,ImmediacyPaySource,PaySource,OtherCondition,Flag2 from BUSINESS_APPLY "+
            "  where SerialNo =:SerialNo ";
   	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo)); 
   	if(rs.next()){
		//重组条件1、重组条件2、重组条件3
		sFlag3 = DataConvert.toString(rs.getString("Flag3"));
		sImmediacyPaySource = DataConvert.toString(rs.getString("ImmediacyPaySource"));
		sPaySource = DataConvert.toString(rs.getString("PaySource"));
		
		//贷款收回本金情况
		sOtherCondition = DataConvert.toString(rs.getString("OtherCondition"));
		
		//是否按期收回贷款利息
		sFlag2 = DataConvert.toString(rs.getString("Flag2"));
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReformBook";        

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		//{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
	
			//合同编号、新借款人、主要担保方式
			setItemValue(0,0,"ContractNo","<%=sArtificialNo%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"VouchID","<%=sVouchType%>");
			
			//重组方案流水号、重组条件1、重组条件2、重组条件3
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");
			setItemValue(0,0,"ReformCond1","<%=sFlag3%>");
			setItemValue(0,0,"ReformCond2","<%=sImmediacyPaySource%>");
			setItemValue(0,0,"ReformCond3","<%=sPaySource%>");
			
			//贷款收回本金情况、是否按期收回贷款利息
			setItemValue(0,0,"TakeBack","<%=sOtherCondition%>");
			setItemValue(0,0,"InterestFlag","<%=sFlag2%>");
			
			setItemValue(0,0,"ReformSum","<%=DataConvert.toMoney(sReformSum)%>");
			setItemValue(0,0,"DayCount","<%=sDayCount%>");
			
			//登记人、登记机构
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
		}
   	}
	
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
