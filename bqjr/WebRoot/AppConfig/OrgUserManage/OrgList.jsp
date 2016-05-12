<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 机构管理列表
	 */
	String PG_TITLE = "机构管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获取组件参数
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "";
	String sSortNo="";
	sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgID));
	if(sSortNo==null)sSortNo="";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "OrgList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    //增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo+"%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		//{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","停用","停用","deleteRecord()",sResourcesPath},
		{"true","","Button","启用","启用","enableRecord()",sResourcesPath},
		//{"true","","Button","初始化机构权限","初始化机构权限","initialOrgBelong()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
        OpenPage("/AppConfig/OrgUserManage/OrgInfo.jsp","_self","");            
	}
	
	function viewAndEdit(){
        var sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID)=="undefined" || sOrgID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		OpenPage("/AppConfig/OrgUserManage/OrgInfo.jsp?CurOrgID="+sOrgID,"_self","");        
	}
    
	function deleteRecord(){
		var sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID) == "undefined" || sOrgID.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		//if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
		/* if(confirm("您真的要停用该机构吗？")){ //您真的想删除该信息吗？
			//取消归档操作
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@15,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}else
			{
				reloadSelf();
				alert(getHtmlMessage('18'));//提交成功！
			}
		} */
	}
	
	
	/*~[Describe=初始化机构权限;InputParam=无;OutPutParam=无;]~*/
	function initialOrgBelong(){
		if(confirm("你确定初始化机构权限吗？")){
			var returnValue = PopPage("/AppConfig/OrgUserManage/InitialOrgBelongAction.jsp","","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			if("true"==returnValue)
			{
				alert("初始化机构权限成功！") ;
			}else{
				alert("初始化机构权限失败！") ;
			}
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>