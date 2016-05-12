<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 用户查询列表
	 */
	String PG_TITLE = "用户查询列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sUsersSelected =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UsersSelected",1));
	String sAlertID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlertID",10));
	if(sAlertID==null) sAlertID="";

	String sHeaders[][] = {	{"UserID","用户号"},
							{"UserName","用户名"},
							{"BelongOrg","所属机构号"},
							{"BelongOrgName","所属机构名"}
						  };

	String sSql =	" select UserID,UserName,getOrgName(BelongOrg) as BelongOrgName,BelongOrg " +
					" from USER_INFO " +
					" where 1 = 1 and (BelongOrg != ' ' or BelongOrg is not null) ";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.multiSelectionEnabled=true;
	doTemp.setHeader(sHeaders);
	//doTemp.setVisible("",false);
	//doTemp.setDDDWCode("BelongAttribute","BelongAttribute");
	//生成查询
	doTemp.setFilter(Sqlca,"1","UserID","");
	doTemp.setFilter(Sqlca,"2","UserName","");
	doTemp.setFilter(Sqlca,"3","BelongOrg","");
	doTemp.setFilter(Sqlca,"4","BelongOrgName","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","加入列表","将选中的人员加入分发目标用户列表","distribute()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function distribute(){
		var sUsers = getItemValueArray(0,"UserID");
		var sUserString="";
		for(i=0;i<sUsers.length;i++){
			sUserString += "@" + sUsers[i];
		}
		if (typeof(sUserString)==""){
			alert("请双击多选区，选择一条以上记录！");
			return;
		}

		parent.saveParaToComp("UsersSelected=<%=DataConvert.toString(sUsersSelected)%>"+sUserString,"reloadLeftAndRight()");
	}
	
    function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.getElementById(sObjectID);
		oMyObj2 = document.getElementById(sObjectID2);
		if(sFilterID=="1"){
			sReturn = setObjectInfo("User","@UserID@0@UserName@1",0,0);
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_"){
				return;
			}else if(sReturn=="_CLEAR_"){
				oMyObj.value="";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				//oMyObj2.value=sReturns[1];
			}
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%@ include file="/IncludeEnd.jsp"%>