<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: ybwei  2009-06-18
*
*	Tester:
*	Describe: 每日校验结果查询
*	Input Param:
*	Output Param:     
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "校验结果"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%/*~END~*/%>         
                      
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"checkflow","层次号"},
							{"Occurdate","发生日期"},
							{"Loanaccount","帐号"},
							{"Subject","科目"},
							{"Orgname","机构名称"},
							{"errorcode","错误码"},
							{"ErrorDescribe","描述"}
						}; 


 	String sSql = "select Serialno,checkflow,Occurdate,Loanaccount,Subject,getOrgName(orgid) as Orgname,errorcode,ErrorDescribe from Check_log " +
 				  "where 1=1 and orgid in (select orgid from org_info where SortNo like '"+CurOrg.getSortNo()+"%') order by Occurdate desc";


	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);	
	doTemp.setKey("Serialno",true);
	doTemp.setVisible("Serialno",false);	
	doTemp.setHTMLStyle("Loanaccount,Subject,Orgname"," style={width:120px} ");
	doTemp.setHTMLStyle("ErrorDescribe"," style={width:350px} ");
	doTemp.setCheckFormat("Occurdate","3");
	//doTemp.setAlign("Loanaccount","3");  //数字靠右
	//设置可更新目标表
	doTemp.UpdateTable = "Check_log";   
	
	//生成查询条件
	doTemp.setColumnAttribute("checkflow,Subject,Loanaccount,ErrorDescribe,Orgname,Occurdate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	dwTemp.setPageSize(40); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	//String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
		{"true","","PlainText","由于本页面数据量过大，请通过查询条件查询","由于本页面数据量过大，请通过查询条件查询","style={color:red}",sResourcesPath}			
	};
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	//---------------------删除事件------------------------------------
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"Serialno");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}	
	
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
