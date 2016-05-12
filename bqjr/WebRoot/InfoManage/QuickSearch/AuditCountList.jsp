<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "审核员统计";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
    String sInputUser =CurUser.getUserID();
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AuditCountList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//CCS-164 根据不同部门登录人员查询自个部门在线人数信息  20150615 huzp
    if(CurUser.getOrgID().equals("10")){
    	doTemp.WhereClause=" where begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and (endTime = '' or endTime is null) and u.userid in (select userid from USER_INFO where BelongOrg in (select OrgID from ORG_INFO where SortNo like '101%') and isCar = '02')";
    }else if(CurUser.getOrgID().equals("11")){
    	doTemp.WhereClause=" where begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and (endTime = '' or endTime is null) and u.userid in (select userid from USER_INFO where BelongOrg in (select OrgID from ORG_INFO where SortNo like '102%') and isCar = '02')";
    }else{
    	doTemp.WhereClause=" where begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and (endTime = '' or endTime is null) and u.userid in (select userid from USER_INFO where BelongOrg in (select OrgID from ORG_INFO where SortNo in ('101','102') and isCar = '02'))";
 	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//CCS-732 update huzp 20150507  分页每页显示15条记录
	dwTemp.setPageSize(15);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sInputUser);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","新增","新增","newRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    function initRow(){
    	setTimeout("reloadSelf()", "60000");
    }

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>