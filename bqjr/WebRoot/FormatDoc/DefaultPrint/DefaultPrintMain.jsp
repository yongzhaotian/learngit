<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: jbye  2004-12-16 20:15
		Tester:
		Describe: 显示客户相关的财务报表
		Input Param:
			
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%!
	//获得机构所在的分行
	String getBranchOrgID(String sOrgID,Transaction Sqlca) throws Exception {
		String sUpperOrgID = sOrgID;
		int sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		while (sLevel > 3) {
			sUpperOrgID = Sqlca.getString("select RelativeOrgID from Org_Info where OrgID='"+sOrgID+"'");
			if (sUpperOrgID == null) break;
			sOrgID = sUpperOrgID;
			sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		}
		return sOrgID;
	}
	
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "尽职调查报告模板列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"DocID","模板编号"},
							{"DocName","模板名称"},
							{"InputDate","登记日期"},
							{"OrgName","登记机构"},
							{"UserName","登记人"},
							{"UpdateDate","修改日期"}
						  };
	String sOrgID = getBranchOrgID(CurOrg.getOrgID(),Sqlca);
	String sSql = "";
	sSql =  " select DocID,DocName,DefaultValue,"+
			" getUserName(UpdateUser) as UserName,"+
			" getOrgName(OrgID) as OrgName,"+
			" UpdateDate "+
			" from FORMATDOC_PARA "+
			" where OrgID = '"+sOrgID+"'";
	//out.println(sSql);
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "FORMATDOC_PARA";
	doTemp.setKey("DocID",true);	
	//设置不可见项
	doTemp.setVisible("DefaultValue,InputDate,OrgName,UserName,UpdateDate",false);
	//设置界面宽度
	doTemp.appendHTMLStyle("DocID,InputDate,OrgName,UserName,UpdateDate"," style={width=60px} ");
	doTemp.appendHTMLStyle("DocName"," style={width=220px} ");

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","定制打印设置","定制打印设置","structureInfo()",sResourcesPath},
		//{"true","","Button","初始化数据","初始化数据","initInfo()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function structureInfo()
	{
		sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sDirID = PopPage("/FormatDoc/DefaultPrint/DefaultPrintSelect.jsp?DocID="+sDocID+"&rand="+randomNumber(),"","dialogWidth=36;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
		
		if(typeof(sDirID)=="undefined" || sDirID=="_none_")
			return;
		
		PopPage("/FormatDoc/DefaultPrint/GetDefaultPrintAction.jsp?DirID="+sDirID+"&DocID="+sDocID,"","");
		alert("设置成功");
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
