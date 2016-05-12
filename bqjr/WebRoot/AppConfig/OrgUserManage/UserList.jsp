<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 用户管理列表
	 */
	String PG_TITLE = "用户管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获取组件参数
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "";
	String sSortNo = Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgID));
	if(sSortNo==null)sSortNo="";
	
	String sIsCar = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isCar"));
	if(sIsCar == null) sIsCar = "";
	ARE.getLog().debug("是否车贷用户管理isCar="+sIsCar);
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "UserList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    //filter过滤条件
	doTemp.generateFilters(Sqlca);
	//CCS-1209 需求申请：销售部同事信息查询界面中，增加查询字段：身份证号码
	if("15".equals(sOrgID)){
		doTemp.setFilter(Sqlca, "0225", "CertId", "Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}
	//filter过滤条件
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = true;//设置可多选
	if(!doTemp.haveReceivedFilterCriteria()){
		doTemp.WhereClause =  " where 1=2";
	}else{
		//doTemp.WhereClause +=" and isCar='"+sIsCar+"'";
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","新增","在当前机构中新增人员","my_add()",sResourcesPath},			
			{"false","","Button","引入","引入人员至当前机构","my_import()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000") || CurUser.hasRole("1047"))?"true":"false"),"","Button","解锁","从当前机构中启用该人员","my_enable()",sResourcesPath},
            {"true","","Button","详情","查看用户详情","viewAndEdit()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000") || CurUser.hasRole("1047"))?"true":"false"),"","Button","锁定","从当前机构中删除该人员","my_disable()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","用户资源","查看用户授权资源","viewResources()",sResourcesPath},
            //{((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000"))?"true":"false"),"","Button","用户角色","查看并可修改人员角色","viewAndEditRole()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","角色维护","角色维护","viewAndEditRole()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","批量更新角色","批量更新角色","my_Addrole()",sResourcesPath},
			{((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","多用户更新角色","多用户更新角色","MuchAddrole()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","转移","转移人员至其他机构","UserChange()",sResourcesPath},    
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","用户excel导入","用户excel导入","importRecords()",sResourcesPath},   
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","角色excel导入","角色excel导入","importUserRoleRecords()",sResourcesPath},   
            //{((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000"))?"true":"false"),"","Button","初始密码","初始化该用户密码","ClearPassword()",sResourcesPath}
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000") || CurUser.hasRole("1036") || CurUser.hasRole("1035"))?"true":"false"),"","Button","密码重置","初始化该用户密码","ClearPassword()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000") || CurUser.hasRole("1036") || CurUser.hasRole("1035"))?"true":"false"),"","Button","启用用户","启用待启用用户","enableUser()",sResourcesPath},
            //{((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000"))?"true":"false"),"","Button","用户批量导入","用户批量导入","batchImport()",sResourcesPath},
    		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},

        };
	sButtons[8][0]="false";
	
	//用于控制单行按钮显示的最大个数  add by Dahl 20150403
	String iButtonsLineMax = "15";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
	//end
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//Excel导出功能呢	
	function exportExcel(){
		amarExport("myiframe0");
	}

	function batchImport() {
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportUser", "filePath="+sFilePath);
	}
	//导入用户
	function importRecords(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportUserInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		
		//RunMethod("BlackListModel","delAddressMulti","");
		reloadSelf();
	}
	
	//导入用户对应role
	function importUserRoleRecords(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportUserRoleInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		
		//RunMethod("BlackListModel","delAddressMulti","");
		reloadSelf();
	}
	function my_add(){
		//OpenPage("/AppConfig/OrgUserManage/UserInfo.jsp","_self","");
		
		sCompID = "UserInfo";
		sCompURL = "/AppConfig/OrgUserManage/UserInfo.jsp";
		sParamString = "isCar=02";
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=600px;dialogHeight=620px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sUserID)=="undefined" || sUserID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else{
			//OpenPage("/AppConfig/OrgUserManage/UserInfo.jsp?UserID="+sUserID,"_self","");
			
			sCompID = "UserInfo";
			sCompURL = "/AppConfig/OrgUserManage/UserInfo.jsp";
			sParamString = "UserID="+sUserID;
			sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=550px;dialogHeight=620px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			reloadSelf();
		}
	}
	
	/*~[Describe=查看用户授权资源;InputParam=无;OutPutParam=无;]~*/
	function viewResources(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID)=="undefined" || sUserID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			AsControl.PopView("/AppConfig/OrgUserManage/ViewUserResources.jsp","UserID="+sUserID,"");
		}
	}

	<%/*~[Describe=查看并可修改人员角色;]~*/%>
	function viewAndEditRole(){
        var sUserID=getItemValue(0,getRow(),"UserID");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
        }else{
        	var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"非正常用户，无法查看用户角色！");
        	else
            	sReturn=popComp("UserRoleList","/AppConfig/OrgUserManage/UserRoleList.jsp","UserID="+sUserID+"&isCar="+'<%=sIsCar%>'+"","");
        }    
    }
    
    <%/*~[Describe=批量更新角色;]~*/%>    
    function my_Addrole(){
	    var sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
    	}else{
        	var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"非正常用户，无法批量更新角色！");
        	else
        		PopPage("/AppConfig/OrgUserManage/AddUserRole.jsp?UserID="+sUserID,"","dialogWidth=550px;dialogHeight=350px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
    	}
	}
	
	<%/*~[Describe=多用户更新角色;]~*/%>
	function MuchAddrole(){
		var sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0){ 
		    alert(getHtmlMessage('1'));//请选择一条信息！
    	}else{
    		var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"非正常用户，无法多用户更新角色！");
        	else
        		PopPage("/AppConfig/OrgUserManage/AddMuchUserRole.jsp?UserID="+sUserID,"","dialogWidth=550px;dialogHeight=600px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
		}
	}

	<%/*~[Describe=转移人员至其他机构;]~*/%>
	function UserChange(){
        var sUserID = getItemValue(0,getRow(),"UserID");
        var sFromOrgID = getItemValue(0,getRow(),"BelongOrg");
        var sFromOrgName = getItemValue(0,getRow(),"BelongOrgName");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
        }else{
            //获取当前用户
			sOrgID = "<%=CurOrg.getOrgID()%>";			
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined"){
			    if( typeof(sOrgInfo) != "undefined"&&sOrgInfo != "_CLEAR_")alert(getBusinessMessage('953'));//请选择转移后的机构！
			    return;
		    }else{
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];
			    
			    if(sFromOrgID == sToOrgID){
					alert(getBusinessMessage('954'));//不允许人员转移在同一机构中进行，请重新选择转移后机构！
					return;
				}
				//调用页面更新
				sReturn = PopPageAjax("/SystemManage/SynthesisManage/UserShiftActionAjax.jsp?UserID="+sUserID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
				if(sReturn == "TRUE"){
	                alert(getBusinessMessage("914"));//人员转移成功！
	                reloadSelf();           	
	            }else if(sReturn == "FALSE"){
	                alert(getBusinessMessage("915"));//人员转移失败！
	            }
			}
		}
	}
	
	<%/*~[Describe=启用待启用用户;]~*/%>
	function enableUser() {
	
		var userid = getItemValueArray(0,"UserID");	// 多选
		var str = "";
		for (var i = 0; i < userid.length; i++) {
			str += userid[i] + "|";
		}
		if (str != null && str != "") {
			str = str.substr(0, str.length - 1);
		}
		
		var res = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction", "enableUserList", "userIdList=" + str);
		if (res != "SUCCESS") {
			alert(res);
			return;
		} else {
			alert("启用成功！");
			reloadSelf();
		}
	}
	
	<%/*~[Describe=引入人员至当前机构;]~*/%>
	function my_import(){
       sParaString = "BelongOrg"+","+"<%=sOrgID%>";		
		sUserInfo = setObjectValue("SelectImportUser",sParaString,"",0,0,"");
		if(typeof(sUserInfo) != "undefined" && sUserInfo != "" && sUserInfo != "_NONE_" && sUserInfo != "_CANCEL_" && sUserInfo != "_CLEAR_"){
       		sInfo = sUserInfo.split("@");
	        sUserID = sInfo[0];
	        sUserName = sInfo[1];
	        if(typeof(sUserID) != "undefined" && sUserID != ""){
	        	if(confirm(getBusinessMessage("912"))){ //您确定将所选人员引入到本机构中吗？
        			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction","addUser","UserID="+sUserID+",OrgID=<%=sOrgID%>");
					if(sReturn == "SUCCESS"){
		        		alert(getBusinessMessage("913"));//人员引入成功！
		        		reloadSelf();
	        		}
	        	}else{
	        		alert("人员转移失败!");
	        	}
	        }
       	}
	}

	<%/*~[Describe=从当前机构中删除该人员;]~*/%>
	function my_disable(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID) == "undefined" || sUserID.length == 0){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
		}else if(confirm("您真的想锁定该用户吗？")){
            var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction","suoUser","UserID="+sUserID);
            if(sReturn == "SUCCESS"){
			    alert("信息锁定成功！");
			    reloadSelf();
			}
		}
	}

	<%/*~[Describe=启用用户;]~*/%>
	function my_enable(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID) == "undefined" || sUserID.length == 0){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
		}else if(confirm("您真的想启用该用户吗？")){
            var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction","enableUser","UserID="+sUserID);
            if(sReturn == "SUCCESS"){
			    alert("信息启用成功！");
			    reloadSelf();
			}
		}
	}
	
	<%/*~[Describe=初始化用户密码;]~*/%>
	function ClearPassword(){
        var sUserID = getItemValue(0,getRow(),"UserID");
        var sInitPwd = "welcome!bqjr88";
        if (typeof(sUserID)=="undefined" || sUserID.length==0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getBusinessMessage("916"))){ //您确定要初始化该用户的密码吗？
		    var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.ClearPasswordAction","initPWD","UserID="+sUserID+",InitPwd="+sInitPwd);
			if(sReturn == "SUCCESS"){
			    alert(getBusinessMessage("917"));//用户密码初始化成功！
			    reloadSelf();
			}else{
				alert("用户密码初始化成功！");
			}
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>