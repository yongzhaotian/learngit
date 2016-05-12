<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*
		Author: zq 2016-01-12
		Tester:
		Describe: 新增债权转让查询列表
		Jira:PRM-658
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		Output Param:
		HistoryLog:
	 */
	%>

<%String PG_TITLE = "债权转让查询列表"; // 浏览器窗口标题 <title> PG_TITLE </title>%>
<%
	String sTempletNo = "AssignmentClaimsQueryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()){
	doTemp.WhereClause =" where 1=2 ";
    }
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10);  //服务器分页
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
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
		{"false","","Button","新增","新增数据","newRecord()",sResourcesPath},
		{"false","","Button","详情","详情记录","myDetail()",sResourcesPath},	
		{"false","","Button","删除","删除所选中的数据","deleteRecord()",sResourcesPath},
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">
	/**
	 * 打开详情
	 */
	function myDetail(){
		var serialno = getItemValue(0,getRow(),"serialno");	
		if(typeof(serialno)=="undefined" || serialno.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			sCompID = "NoBespeakCashLoanParaDetail";
			sCompURL = "/BusinessManage/BusinessType/NoBespeakCashLoanParaInfo.jsp";
			sCompParam = "serialno="+serialno; //赋值参数
			var left = (window.screen.availWidth-800)/2;
			var top = (window.screen.availHeight-400)/2;
			var features ='left='+left+',top='+top+',width='+800+',height='+400;
			var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll:no;status=no,menubar=no,'+features;
			popComp(sCompID, sCompURL, sCompParam , style);
		}
		reloadSelf();
	}
	
	/**
	 * 关闭页面
	 */
	function doCancel(){		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@	include file="/IncludeEnd.jsp"%>

