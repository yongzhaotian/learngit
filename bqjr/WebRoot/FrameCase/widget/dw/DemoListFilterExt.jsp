<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.setPageSize(5);
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	var sDateAreaHtml = "<input type='radio' onclick='setDateArea(6,0)' name='monthsetting'>半年内<input type='radio' onclick='setDateArea(3,1)' name='monthsetting'>三个月内<input type='radio' onclick='setDateArea(1,2)' name='monthsetting'>一个月内";
	var iDateAreaSelectedIndex = -1;
	var sSerialNoHtml = "<input type='radio' onclick='setSerialNo(0,0)' name='serialnosetting'>201206以前数据<input type='radio' onclick='setSerialNo(1,1)' name='serialnosetting'>201206以后数据";
	var iSerialNoSelectedIndex = -1;
	
	function validFilter(){
		return true;
	}
	//提交以后的处理。当替换原始控件时需要进行额外设置
	function afterSubmitFilter(){
		//隐藏测试日期原始控件
		hideFilterforSelection(0,"ADDRESS");
		//替换要显示的控件
		setFilterExtHtml(0,"ADDRESS",sDateAreaHtml);
		//设置选中项目
		var objs = document.getElementsByName("monthsetting");
		for(var i=0;i<objs.length;i++){
			if(i==iDateAreaSelectedIndex){
				objs[i].checked = true;
			}
		}
		if(iSerialNoSelectedIndex==1)
			resetSerialNo('BigEqualsThan');
		else
			resetSerialNo('LessEqualsThan');
	}
	function setDateArea(month,selectedIndex){
		var day0 = new Date();
		day0.setMonth(day0.getMonth()-month); 
		setFilterAreaValue(0,"ADDRESS",getFormatedDateString(day0,"/"),0);
		setFilterAreaValue(0,"ADDRESS",getFormatedDateString(new Date(),"/"),1);
		iDateAreaSelectedIndex= selectedIndex;
	}
	function setSerialNo(value,selectedIndex){
		if(value==1){
			setFilterAreaOption(0,"SERIALNO","BigEqualsThan");
			setFilterAreaValue(0,"SERIALNO","201206");
		}
		else{
			setFilterAreaOption(0,"SERIALNO","LessEqualsThan");
			setFilterAreaValue(0,"SERIALNO","201206");
		}
		iSerialNoSelectedIndex= selectedIndex;
	}
	function initFilter(){
		//设置测试日期 操作符为 “在。。。之间”
		setFilterAreaOption(0,"ADDRESS","Area");
		//隐藏测试日期原始操作控件
		hideFilterforSelection(0,"ADDRESS");
		//替换要显示的控件
		setFilterExtHtml(0,"ADDRESS",sDateAreaHtml);
		//重新定义是否使用过滤框
		resetSerialNo("BigEqualsThan");
		//显示高级查询框
		showFilterArea();
		//提交查询
		//submitFilterArea();
	}
	function resetSerialNo(option){
		//设置测试日期 操作符为 “在。。。之间”
		setFilterAreaOption(0,"SERIALNO",option);
		//隐藏测试日期原始操作控件
		hideFilterforSelection(0,"SERIALNO");
		//替换要显示的控件
		setFilterExtHtml(0,"SERIALNO",sSerialNoHtml);
		//设置选中项目
		var objs = document.getElementsByName("serialnosetting");
		for(var i=0;i<objs.length;i++){
			if(i==iSerialNoSelectedIndex){
				objs[i].checked = true;
			}
		}
	}
	window.onload= initFilter;
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
