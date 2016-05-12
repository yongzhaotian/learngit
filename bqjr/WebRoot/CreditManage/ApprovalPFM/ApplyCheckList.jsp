<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:Thong 2005.9.01 8:50
		Tester:
		Content: 审批绩效列表
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "审批绩效列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sInputUser; //排序编号
	ASResultSet rs = null;   
	int iTemp = 0; 

	//获得组件参数	
	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	//获得页面参数	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过Sql产生ASDataObject对象doTemp
	String sHeaders[][] = {
								{"applyname","流程名称"},
								{"appsum","总金额[万元]"},
                               	{"BusinessStatus1","业务形态"},
                               	{"count1","笔数"},
                               	{"avg","所占百分比%"}
                          };
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆
	
	sSql = " select count(*) as allcount from apply_info a,apply_relative b,business_info c"+
           " where a.applyno=b.applyno and c.businessno=b.businessno";	
	rs = Sqlca.getASResultSet(sSql); 
	while(rs.next()){
	   iTemp = rs.getInt(1);
	}
	rs.getStatement().close();
	
	sSql = "select getFlowName(a.ApplyFlow) as applyname,ApplyFlow,c.BusinessStatus,"+
	       "getItemName('BusinessStatus',BusinessStatus) as BusinessStatus1,count(*) as count1,"+
	       "sum(c.applysum)/10000 as appsum,count(*)*100/"+iTemp+
	       "as avg from apply_info a,apply_relative b,business_info c"+
	       "where a.applyno=b.applyno and c.businessno=b.businessno and c.businessstatus in ('1','4','5','6') "+
	       "group by getFlowName(a.ApplyFlow),ApplyFlow,c.BusinessStatus";
       	               
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setCheckFormat("avg,appsum","2");
	doTemp.setAlign("avg,count1,appsum","3");
	doTemp.setHTMLStyle("BusinessStatus,count1","style={width:80px}");
	doTemp.setHTMLStyle("appsum","style={width:100px}");
	doTemp.setVisible("ApplyFlow,BusinessStatus",false);
	
	doTemp.setColumnAttribute("applyname","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(!sInputUser.equals("")) doTemp.WhereClause += " and InputUser = '"+sInputUser+"'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/Frame/CodeExamples/ExampleInfo.jsp","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sExampleID = getItemValue(0,getRow(),"ExampleID");
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sExampleID=getItemValue(0,getRow(),"ExampleID");
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		OpenPage("/Frame/CodeExamples/ExampleInfo.jsp?ExampleID="+sExampleID,"_self","");
	}
	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		sExampleID=getItemValue(0,getRow(),"ExampleID");
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		openObject("Example",sExampleID,"001");//使用ObjectViewer以视图001打开Example，
		/*
		 * [参考]
		 * 等同于这一句：
		 * OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ComponentName=对象查看器&ObjectType=Example&ObjectNo="+sExampleID+"&ViewID=001","_blank",OpenStyle);
		 */
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
