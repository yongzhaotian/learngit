<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:thong 2005
		Tester:
		Content: 交叉组合限额
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "交叉组合限额"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;
	String sInputUser; 
	String sLimitSerialNo; 
	String sCombiType1 = "",sCombiType2 = "",sCombiType3 = "";
	//获得组件参数	
	sLimitSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LimitSerialNo"));

	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	//获得页面参数	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆
	//通过显示模版产生ASDataObject对象doTemp
	String sHeaders[][] = { 
				{"KindCode1","组合类型一"},
				{"KindCode2","组合类型二"},
				{"KindCode3","组合类型三"},
				{"TotalSum","限额总量(元)"},
				
				{"Limit","目标限额(元)"},
				{"Rate","目标占比(%)"},
				{"ECLimit","经济资本分配金额(元)"},
				{"ECRate","分配金额占比(%)"},
				
				{"AlertRate","警示比例(%)"},
				{"LimitLevel","限制级别"},
				{"BeginDate","生效日期"},
				{"EndDate","失效日期"},
				{"Useflg","是否使用"},
				{"UserName","输入人员"}
			       };   				   		
	
	sSql = "select getItemDescribe('CombiType',CombiType1) as CombiType1,"+
		   "getItemDescribe('CombiType',CombiType2) as CombiType2,"+
		   "getItemDescribe('CombiType',CombiType3) as CombiType3 "+
		   "from XLIMIT_DEF where SerialNo = '"+sLimitSerialNo+"'";
	ASResultSet rs = SqlcaRepository.getResultSet(sSql);
	if(rs.next()){
		sCombiType1 = DataConvert.toRealString(rs.getString(1));
		sCombiType2 = DataConvert.toRealString(rs.getString(2));
		sCombiType3 = DataConvert.toRealString(rs.getString(3));
	}
	rs.getStatement().close();

	sSql = "select XL.SerialNo,XL.LimitType,XL.KindCode1,XL.KindCode2";
	if(sCombiType3!=null&&!sCombiType3.equals("null")&&!"".equals(sCombiType3)){
		sSql = sSql + ",XL.KindCode3";
	}
	sSql = sSql + "	,XL.TotalSum,XL.Limit,XL.Rate,XL.ECLimit"
			+",XL.ECRate,XL.BeginDate,XL.EndDate,XL.AlertRate,getItemName('YesOrNo2',XL.Useflg) as Useflg"
			+",getUserName(XL.UserID) as UserName  "
			+" from XLIMIT_INFO XL,XLIMIT_DEF XD "
			+" where XL.LimitType = '"+sLimitSerialNo+"' and XD.SerialNo = XL.LimitType "
			+" order by XL.SerialNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.UpdateTable = "XLIMIT_INFO";           //for delete        		
	doTemp.setKey("SerialNo",true);
					
	doTemp.setColumnAttribute("KindCode1","IsFilter","1");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.setReadOnly("SerialNo",true);
	doTemp.setVisible("SerialNo,LimitType,",false);

	doTemp.setDDDWCode("KindCode1","CombiType");
	doTemp.setDDDWSql("KindCode2","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='VouchTyped'");
	//doTemp.setDDDWSql("KindCode1",sCombiType1);
	//doTemp.setDDDWSql("KindCode2",sCombiType2);	
	
	if(sCombiType3!=null&&!sCombiType3.equals("null"))
	doTemp.setDDDWCode("KindCode3","CombiType");	
	//doTemp.setDDDWSql("KindCode3",sCombiType3);

	doTemp.setAlign("TotalSum,Limit,ECLimit,Rate,AlertRate,ECRate","3");
	doTemp.setCheckFormat("TotalSum,Limit,ECLimit","2");
	
	doTemp.setHTMLStyle("LimitType,BeginDate,EndDate,Useflg,UserName,Rate,AlertRate,"," style={width:70px}");
	doTemp.setHTMLStyle("TotalSum,Limit,ECRate,ECLimit"," style={width:130px}");	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(!sInputUser.equals("")) doTemp.WhereClause += " and InputUser = '"+sInputUser+"'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
		{"true","","Button","保存并返回","保存所有修改,并返回列表页面","saveAndGoBack()",sResourcesPath},
		{"true","","Button","保存并新增","保存并新增一条记录","saveAndNew()",sResourcesPath},
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
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=保存所有修改,并返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/LimitManage/XCombiDef.jsp","_self","");
	}

	/*~[Describe=保存并新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function saveAndNew(){
		saveRecord("newRecord()");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		OpenPage("/LimitManage/XCombiDef.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "XLIMIT_DEF";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),"SerialNo",sSerialNo);
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
