<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "SchoolAgentInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增一条记录","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/RetailManage/SchoolAgentApplyInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sUserID = getItemValue(0,getRow(),"USERID");
		if (typeof(sUserID)=="undefined" || sUserID.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var sUserID = getItemValue(0,getRow(),"USERID");
		if (typeof(sUserID)=="undefined" || sUserID.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/SchoolAgentApplyInfo.jsp","UserID="+sUserID,"_self","");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
