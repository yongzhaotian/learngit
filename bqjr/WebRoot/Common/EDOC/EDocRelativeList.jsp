<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cyyu 2009-02-09
		Tester:
		Describe: 添加电子合同模板时，关联对应的业务类型;
		Input Param:
			ObjectType：对象类型
			ObjectNo: 对象编号
			ContractNo：担保信息编号
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联业务类型信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";

	//获得页面参数：对象类型、对象编号、担保信息编号
	String sEDocNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EDocNo"));
	String sEDocType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EDocType"));
	
	//将空值转化为空字符串
	if(sEDocNo == null) sEDocNo = "";
	if(sEDocType == null) sEDocType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
			{"EDocNo","电子合同模板编号"},
			{"TypeNo","业务类型编号"},
			{"TypeName","业务类型"}
		  };
	sSql =  " select TypeNo,TypeName,EDocNo from EDOC_RELATIVE where EDocNo='" + sEDocNo + "' ";
	
	//电子合同模板对应的业务类型	
	PG_TITLE = "电子合同模板["+sEDocNo+"]对应的业务类型@PageTitle";
	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EDOC_RELATIVE";
	doTemp.setKey("TypeNo",true);
	doTemp.setVisible("EDocNo,TypeNo",false);
	//设置格式
	doTemp.setHTMLStyle("TypeName"," style={width:180px} ");
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);//调试datawindow的Sql语句

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
		{"true","","Button","更改关联类型","修改模板对应的业务类型","changeRecord()",sResourcesPath},
	};
		
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
			
	/*~[Describe=引入新的业务类型;InputParam=无;OutPutParam=无;]~*/
	function changeRecord()
	{
		sEDocNo = "<%=sEDocNo%>";
		sEDocType = "<%=sEDocType%>";
		if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) 
		{
			alert(getHtmlMessage("不存在的模板编号，请先定义模板编号"));
		}else 
		{
			sReturnValue = PopPage("/Common/EDOC/EDocTerm.jsp?EDocNo="+sEDocNo+"&EDocType"+sEDocType,"","width=160,height=20,left=20,top=20,status=yes,center=yes");
			if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
			{
				return;
			}
			sReturn = RunMethod("Configurator","SaveEDoc",sReturnValue+","+sEDocNo+","+sEDocType);
			if(sReturn == '0' || typeof(sReturn)=="undefined" || sReturn=="_none_")
			{
				alert("数据保存失败");
			}
		}
		reloadSelf();
	}
		
	</script>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	</script>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>