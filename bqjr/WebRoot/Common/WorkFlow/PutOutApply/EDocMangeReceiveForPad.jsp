<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "合同包裹接收管理";
    //定义变量
    String sTempletNoType="EDocMangeReceiveForPad";
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = sTempletNoType;//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//doTemp.multiSelectionEnabled=true;//设置可多选
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);
	
//	doTemp.WhereClause+=" and mi.status in ('3','4','5') ) ";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
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
			{"true","","Button","接收与退回","合同接收与退回","mangeReceiveAdd()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
  function mangeReceiveAdd(){
	   var sCompID = "EDocMangeReceiveAdd";
	    // 跳出一个页面  
		var sCompURL = "/Common/WorkFlow/PutOutApply/EDocMangeReceiveAdd.jsp";	 
		popComp(sCompID,sCompURL,"ser=kkk","dialogWidth=690px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
  }
  
  
	function exportAll(){
		amarExport("myiframe0");
	}

</script>	
	<script type="text/javascript">	
		AsOne.AsInit();
		init();
		showFilterArea();//查询条件展开设置
		my_load(2,0,'myiframe0');
	</script>	
<%@ include file="/IncludeEnd.jsp"%>