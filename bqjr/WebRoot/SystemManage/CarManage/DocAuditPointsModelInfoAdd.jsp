<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: 文件质量检查审核要点功能维护
		Input Param:
		Output param:
		History Log: //CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "审核要点信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;审核要点信息&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	//获得组件参数
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if (null == sTypeNo) sTypeNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
										{"TypeNo","类型编号"},
										{"TypeName","类型名称"},
										{"SerialNo","序列号"},
										{"Time","创建时间"},
						   }; 
	
	sSql = 	" select eit.TypeNo,eit.TypeName,eit.addtime as Time "+
			" from ecm_image_type eit "+
			" where eit.TypeNo='"+sTypeNo+"' "+
			" order by AddTime desc ";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置关键字
	doTemp.setKeyFilter("TypeNo");
	doTemp.setKey("TypeNo",true);	
	//隐藏字段
	//doTemp.setVisible("AuditPoints",false);//CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
	
	//doTemp.multiSelectionEnabled=true;// 分配多选
	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","Time","");
	doTemp.parseFilterData(request,iPostChange);
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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
		{"true","","Button","更新","更新审核要点","AddAuditPoints()",sResourcesPath},
		{"true","","Button","删除","删除审核要点","DeleteAuditPoints()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------//
	
	function AddAuditPoints()
	{//CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
		//OpenPage("/SystemManage/CarManage/DocAuditPointsModelInfo.jsp","_self","");
		  AsControl.OpenView("/SystemManage/CarManage/DocAuditPointsModelInfo.jsp","TypeNo=<%=sTypeNo%>","_self","");
	} 

	function DeleteAuditPoints()
	{
		var sTime =getItemValue(0,getRow(),"Time");
		if (typeof(sTime)=="undefined" || sTime.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("确实删除该记录吗？")){
			RunMethod("公用方法","DelByWhereClause","ecm_image_type,AddTime='"+sTime+"'");
			as_del("myiframe0");
			reloadSelf();
		}
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
