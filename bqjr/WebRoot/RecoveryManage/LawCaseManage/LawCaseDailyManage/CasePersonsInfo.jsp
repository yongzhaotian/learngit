<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 案件相关人员信息
		Input Param:
			        SerialNo:记录流水号
			        ObjectNo:案件编号
			        PersonsType ：案件相关人员类别
		Output param:
		               
		History Log: zywei 2005/09/06 重检代码
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "案件相关人员信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String sOrgNo = "";
	String sOrgName = "";
	String sDepartType = "";
	String sTakePartPhase = "";
	String sTakePartRole = "";
		
	//获得页面参数(案件编号、记录流水号、人员类别)
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sPersonType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PersonType"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sPersonType == null) sPersonType = "";

	String sObjectType = "LawcaseInfo";
	//获得案件最近受理机关人员的相关信息，以作为下次信息输入的默认值
	if(sPersonType.equals("02")){
		sSql =  " select OrgNo,OrgName,DepartType,TakePartPhase,TakePartRole "+
		        " from LAWCASE_PERSONS "+
		        " where ObjectNo = :ObjectNo1 "+ 
		    	" and ObjectType = :ObjectType1 "+ 
		    	" and SerialNo=(select max(SerialNo) from LAWCASE_PERSONS "+
		    	" where ObjectNo = :ObjectNo2 "+
		    	" and ObjectType = :ObjectType2) ";
		so = new SqlObject(sSql).setParameter("ObjectNo1",sObjectNo).setParameter("ObjectType1",sObjectType)
		.setParameter("ObjectNo2",sObjectNo).setParameter("ObjectType2",sObjectType);
	   	rs = Sqlca.getASResultSet(so); 	   	
	   	if(rs.next()){
			//受理机关编号、所属受理机关、受理机关类型、参与阶段、参与角色
			sOrgNo = DataConvert.toString(rs.getString("OrgNo"));
			sOrgName = DataConvert.toString(rs.getString("OrgName"));
			sDepartType = DataConvert.toString(rs.getString("DepartType"));			
			sTakePartPhase = DataConvert.toString(rs.getString("TakePartPhase"));
			sTakePartRole = DataConvert.toString(rs.getString("TakePartRole"));
		 }		 
		 rs.getStatement().close();
	}
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//根据不同的案件相关人员类型，显示不同的详细信息模板
	if (sPersonType.equals("01"))
		sTempletNo="CasePartyInfo";	//案件当事人信息
	else if (sPersonType.equals("02"))
		sTempletNo="CaseCourtInfo";	 //案件法院信息
	else if (sPersonType.equals("03"))
		sTempletNo="CaseAgentInfo";	//案件代理人信息
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
				
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql);
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
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}		
		beforeUpdate();
		as_save("myiframe0",sPostEvents);					
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		sPersonType = "<%=sPersonType%>";			
		if (sPersonType == "01")	//案件当事人信息
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/CasePartyList.jsp","_self","");
		else if (sPersonType == "02")	//案件法院方人员信息
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/CaseCourtList.jsp","_self","");
		else if (sPersonType == "03")	//案件代理人信息
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/CaseAgentList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=选择代理机构名称;InputParam=无;OutPutParam=无;]~*/
	function getPersonName()
	{				
		sPersonType = "<%=sPersonType%>";			
		
		if (sPersonType == "01")	//案件当事人信息
		{
			setObjectValue("SelectAgent","","@OtherAttorneyName@1",0,0,"");	
		}else if (sPersonType == "02")	//案件法院方人员信息
		{
			setObjectValue("SelectAcceptor","","@PersonNo@0@PersonName@1@OrgNo@2@OrgName@3@DepartType@4",0,0,"");	
		}else if (sPersonType == "03")	//案件代理人信息
		{	
			setObjectValue("SelectAgent","","@PersonNo@0@PersonName@1@OrgNo@2@OrgName@3@AgentType@4",0,0,"");	
		}
	}
		
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		sParaString = "RecoveryOrgID"+","+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectImportCustomer",sParaString,"@PersonID@0@PersonNo@3@PersonName@1@LegalPerson@4@ContactTel@5@OrgAddress@6@PostalCode@7",0,0,"");	
	}
	
	/*~[Describe=执行新增操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段		
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");		
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;	
								
			setItemValue(0,0,"PersonType","<%=sPersonType%>");			
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");			
			if("<%=sPersonType%>"=="02")
			{
				//受理机关编号、所属受理机关、受理机关类型、参与阶段、参与角色
				setItemValue(0,0,"OrgNo","<%=sOrgNo%>");
				setItemValue(0,0,"OrgName","<%=sOrgName%>");
				setItemValue(0,0,"DepartType","<%=sDepartType%>");			
				setItemValue(0,0,"TakePartPhase","<%=sTakePartPhase%>");
				setItemValue(0,0,"TakePartRole","<%=sTakePartRole%>");
			}								
			//登记人、登记人名称、登记机构、登记机构名称
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");			
			//登记日期						
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{		
		var sTableName = "LAWCASE_PERSONS";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);

		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	</script>
		
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

