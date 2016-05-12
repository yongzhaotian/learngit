<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明：    
	 */
	String PG_TITLE = "角色详情";
	
	//获得页面参数
	String sRoleID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));
	if(sRoleID==null) sRoleID="";
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "RoleInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRoleID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{(CurUser.hasRole("099")?"true":"false"),"","Button","保存","保存修改","saveRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    var sCurRoleID=""; //记录当前所选择行的代码号

	function saveRecord(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if(sRoleID!="<%=sRoleID%>"){
			sReturn=RunMethod("PublicMethod","GetColValue","RoleID,ROLE_INFO,String@RoleID@"+sRoleID);
			if(typeof(sReturn) != "undefined" && sReturn != ""){
				alert("所输入的角色号已被使用！");
				return;
			}
		}
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","doReturn('Y');");
	}
    
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"RoleID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"RoleAttribute","2");
			bIsInsert = true;
		}
		sRoleAttribute = getItemValue(0,getRow(),"RoleAttribute");
		if(sRoleAttribute==""|| sRoleAttribute == null){
			setItemValue(0,0,"RoleAttribute","2");
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>