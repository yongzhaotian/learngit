<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "已阅公告";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ReadNoticeList";//公告模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//设置申请时间为日历控件	add by byang CCS-1252公告栏  
	doTemp.setCheckFormat("NoticeDate", "3");
	
	//add by byang CCS-1252	控制查看已阅公告栏为本部门的发出的公告
    doTemp.WhereClause = " where noticeid  in (select t.noticeid from USER_NOTICE t where t.isflag = '1' and t.UserID = '"+CurUser.getUserID()+"') and InputOrg='"+CurUser.getOrgID()+"'";

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);//设置分页数量
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
	};
	
	//用于控制单行按钮显示的最大个数  
	String iButtonsLineMax = "5";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*~[Describe=新增 */%>
	function newRecord(){
		AsControl.OpenView("/Common/WorkFlow/ReadNoticeInfo.jsp","","_self","");
	}
	<%/*~[Describe=查看修改  */%>
	function viewAndEdit(){
		var sNoticeId = getItemValue(0,getRow(),"NoticeId");
		if (typeof(sNoticeId)=="undefined" || sNoticeId.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/Common/WorkFlow/ReadNoticeInfo.jsp","NoticeId="+sNoticeId,"_self","");
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