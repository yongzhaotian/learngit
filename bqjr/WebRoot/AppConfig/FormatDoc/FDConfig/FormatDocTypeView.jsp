<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"格式化报告大类","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	String sSqlTreeView = " FROM AWE_ERPT_TYPE WHERE IsInUse = '1' and attribute1='1'" ;
	tviTemp.initWithSql("TypeNo", "TypeTitle", "SortNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
	
	String[][] sButtons = {
		{"true","","Button","新增","新增树图类别","newFormatDocType()","","","",""},
		{"true","","Button","编辑","编辑树图类别","viewFormatDocType()","","","",""},
		{"true","","Button","删除","删除树图类别","deleteFormatDocType()","","","",""},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
</body><script type="text/javascript">
	<%/*[Describe=点击节点事件,查看及修改详情;]*/%>
	function TreeViewOnClick(){
		var sTypeNo = getCurTVItem().id;
		if(!sTypeNo){
			AsControl.OpenView("/AppMain/Blank.jsp?TextToShow=请选择左边树图节点!", "frameright");
		}else if(sTypeNo=="root"){
		}else{
			AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocSubTypeFrame.jsp", "TypeNo="+sTypeNo, "frameright"); 
		}
	}
	
	<%/*新增树图类别*/%>
	function newFormatDocType(){
		var sGroupID = AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeInfo.jsp","","dialogWidth=600px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
		if(!sGroupID) return;
		AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeView.jsp", "", "_self");
	}
	
	<%/* 编辑点击的树图类别 */%>
	function viewFormatDocType(){
		var sTypeNo = getCurTVItem().id;
		if(!sTypeNo){
			alert("请选择格式化报告类别！");
			return;
		}
		// 标记是否自由树图类别，树图类别下有子类别则不自由
		var sGroupID = AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeInfo.jsp","TypeNo=" + sTypeNo,"dialogWidth=600px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
		if(typeof sGroupID == "undefined" || sGroupID.length == 0) return;
		AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeView.jsp", "", "_self");
	}
	
	<%/* 删除点击的树图类别 */%>
	function deleteFormatDocType(){
		var sTypeNo = getCurTVItem().id;
		if(!sTypeNo){
			alert("请选择格式化报告类别！");
			return;
		}
		
		var sTypeTitle = getCurTVItem().name;
		if(!confirm("请确认删除“"+sTypeTitle+"”类别？")) return;
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.formatdoc.action.FormatDocTypeAction", "delete", "TypeNo="+sTypeNo);
		if(sReturn && sReturn == "SUCCESS"){
			AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeView.jsp", "", "_self");
		}else{
			alert("删除树图类别失败！");
		}
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
	}
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>