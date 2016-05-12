<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "预审信息";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PretrialInfoList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    doTemp.WhereClause = " where State ='001' and inputuserid='"+CurUser.getUserID()+"'";
    
  	
    
	doTemp.generateFilters(Sqlca);
	//控制登记日期查询条件选项
  	doTemp.setFilter(Sqlca, "0350", "InputDate", "Operators=BetweenString,BeginsWith;");
	doTemp.parseFilterData(request,iPostChange);

	// 没有输入任何条件，只能查询查询当天数据
	if(!doTemp.haveReceivedFilterCriteria()) {
		doTemp.WhereClause += " and (to_date(to_char(SYSDATE,'YYYY/MM/DD'),'YYYY/MM/DD')-to_date(to_char(to_date(InputDate,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD'),'YYYY/MM/DD'))=0";
	} else {
		//有输入任何条件，只能查询3个月内的数据
	    doTemp.WhereClause += " and months_between(to_date(to_char(SYSDATE,'YYYY/MM/DD'),'YYYY/MM/DD'),to_date(to_char(to_date(InputDate,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD'),'YYYY/MM/DD'))<=3";
	}
	
	//控制特殊字符输入
	for(int k=0;k<doTemp.Filters.size();k++){
		
		//输入的条件都不能含有%或_符号
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null 
				&& (doTemp.Filters.get(k).sFilterInputs[0][1].contains("%") 
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("_")
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("#")
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("$"))){
			%>
			<script type="text/javascript">
				alert("输入的条件不能含有['%'、'_'、'#'、'$']符号!");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
			break;
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);//设置分页数量
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"false","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
	};
	
	//用于控制单行按钮显示的最大个数  
	String iButtonsLineMax = "5";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*~[Describe=新增 */%>
	function newRecord(){
		AsControl.OpenView("/Common/WorkFlow/PretrialInfo.jsp","","_self","");
	}
	<%/*~[Describe=查看修改  */%>
	function viewAndEdit(){

	}
	<%/*~[Describe=删除  */%>
	function deleteRecord(){
		var sNoticeId = getItemValue(0,getRow(),"NoticeId");
		if (typeof(sNoticeId)=="undefined" || sNoticeId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
		reloadSelf();
	}
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>