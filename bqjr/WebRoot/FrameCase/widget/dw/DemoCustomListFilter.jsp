<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.awe.framecase.dw.*"%>
<%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	doTemp.setFilterCustomWhereClauses(new DemoFilterCustomWhereClauses());;
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.setPageSize(5);
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","","Button","导出Txt","导出Txt","exportPage('"+sWebRootPath+"',0,'txt','"+dwTemp.getArgsValue()+"',getExtendParams())","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	var sFilterCustomWhereClauses = undefined;
	function validFilter(){//在提交之前先保存查询信息
		sFilterCustomWhereClauses = getFilterCustomWhereClauses(0);
		return true;
	}
	function afterSubmitFilter(){//提交查询之后恢复查询信息
		setFilterCustomWhereClauses(0,sFilterCustomWhereClauses);
	}
	function tableSearchFromInput(obj,from,params,clearSort){//重新设置查询
		params += "&" + getExtendParams();
		return  tableSearchFromInput0(obj,from,params,clearSort);
	}
	function getExtendParams(){
		return  "f_serialno=" + encodeURI(document.getElementById("f_serialno").value);//必须使用encodeURI转码，否则会出现中文乱码问题
	}
	function afterOpenFilterArea(){//每次打开查询框之后执行操作
		if(sFilterCustomWhereClauses==undefined)
			sFilterCustomWhereClauses = "客户编号 like <input type='text' name='f_serialno' id='f_serialno' value=''>"; 
		setFilterCustomWhereClauses(0,sFilterCustomWhereClauses);
		TableFactory.hideAllSearchIcon();
		TableFactory.showSearchIcon("SERIALNO");
	}
	TableFactory.clearFilter = function(tableIndex){//重新设置清空方法
		sFilterCustomWhereClauses = undefined;
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
