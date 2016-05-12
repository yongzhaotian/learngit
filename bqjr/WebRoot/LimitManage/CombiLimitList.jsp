<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.web.config.check.ASConfigCheck"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:Thong 2005.8.29 15:20
		Tester:
		Content: 监管限额设置列表
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "监管限额设置列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;
	String sInputUser; //排序编号	
	String sKindCode; //组合限额编号
	//获得组件参数	
	sKindCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KindCode"));

	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	//获得页面参数	
	//sParameter =  DataConvert.toRealString(iPostChange,(String)request.getParameter("Parameter"));
%>
<%/*~END~*/%>
	<%/*~BEGIN~不可编辑区~[Describe=为检查限额是否在Code_Library中存在;]~*/%>	
	<%
		ASConfigCheck asc = new ASConfigCheck(Sqlca,sKindCode);
		if(!asc.getIsSucceed()){
			//在session中存储HASH
			session.setAttribute("equalsed",asc.getHashValue()); 
	%>
	<script type="text/javascript">
			if(confirm("本页面需要完全匹配CODE_LIBRARY中的<%=sKindCode%>代码内容，[确定]更新，[取消]返回"))
			{
				sTemp = PopPage("/Common/ToolsB/GetVerifyCode.jsp","KindCode=<%=sKindCode%>","");
			}
	</script>
	<%
		}
	%>
	<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆
	//通过Sql产生ASDataObject对象doTemp
	String sHeaders[][] = { 
				{"LimitType","限额类型"},
				{"KindCode","组合名称"},
				{"KindItem","组合类型"},
				{"TotalSum","限额总量(元)"},
				
				{"Limit","目标限额(元)"},
				{"Rate","目标占比(%)"},
				{"ActualLimit","实际限额(元)"},
				{"ActualRate","实际占比(%)"},
				
				{"AlertRate","警示比例(%)"},
				{"LimitLevel","限制级别"},
				{"BeginDate","生效日期"},
				{"EndDate","失效日期"},
				{"Useflg","是否使用"},
				{"UserName","输入人员"}
			       };   				   		
			       
	sSql = "select SerialNo,LimitType,KindCode,KindItem,TotalSum,Limit,Rate,ActualLimit"
			+",ActualRate,BeginDate,EndDate,AlertRate,getItemName('YesOrNo',Useflg) as Useflg"
			+",getUserName(UserID) as UserName  "
			+"from LIMIT_INFO where LimitType='基础限额' and KindCode='"+sKindCode+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);	
	
	doTemp.setColumnAttribute("KindItem","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.UpdateTable="LIMIT_INFO";
	doTemp.setKey("SerialNo",true);
	doTemp.setReadOnly("KindItem",true);
	doTemp.setUpdateable("UserName",false);
	doTemp.setVisible("SerialNo,LimitType,KindCode,ActualLimit,ActualRate",false);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(!sInputUser.equals("")) doTemp.WhereClause += " and InputUser = '"+sInputUser+"'";

	doTemp.setHTMLStyle("LimitType,BeginDate,EndDate,Useflg,UserName,Rate,AlertRate,"," style={width:70px}");
	doTemp.setHTMLStyle("TotalSum,Limit,ActualLimit"," style={width:130px}");

	doTemp.setDDDWCode("KindItem",sKindCode);
	
	doTemp.setAlign("TotalSum,Limit,ActualLimit,Rate,AlertRate","3");
	doTemp.setCheckFormat("TotalSum,Limit,ActualLimit","2");
	
	if(sKindCode.equals("Term"))
	doTemp.setDDDWCode("KindItem","Term");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
		{"true","","Button","保存设置","保存基础限额配置","saveRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		beforeUpdate();
		as_save("myiframe0");		
	}

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getTodayNow()%>");
	}
	function verifyCode(){
		PopPage("/Common/ToolsB/GetVerifyCode.jsp","","");
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

<%@ include file="/IncludeEnd.jsp"%>
