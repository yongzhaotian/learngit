<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: �û������б�
	 */
	String PG_TITLE = "�û������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//��ȡ�������
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "";
	String sSortNo = Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgID));
	if(sSortNo==null)sSortNo="";
	
	String sIsCar = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isCar"));
	if(sIsCar == null) sIsCar = "";
	ARE.getLog().debug("�Ƿ񳵴��û�����isCar="+sIsCar);
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "UserList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    //filter��������
	doTemp.generateFilters(Sqlca);
	//CCS-1209 �������룺���۲�ͬ����Ϣ��ѯ�����У����Ӳ�ѯ�ֶΣ����֤����
	if("15".equals(sOrgID)){
		doTemp.setFilter(Sqlca, "0225", "CertId", "Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}
	//filter��������
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = true;//���ÿɶ�ѡ
	if(!doTemp.haveReceivedFilterCriteria()){
		doTemp.WhereClause =  " where 1=2";
	}else{
		//doTemp.WhereClause +=" and isCar='"+sIsCar+"'";
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","����","�ڵ�ǰ������������Ա","my_add()",sResourcesPath},			
			{"false","","Button","����","������Ա����ǰ����","my_import()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000") || CurUser.hasRole("1047"))?"true":"false"),"","Button","����","�ӵ�ǰ���������ø���Ա","my_enable()",sResourcesPath},
            {"true","","Button","����","�鿴�û�����","viewAndEdit()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000") || CurUser.hasRole("1047"))?"true":"false"),"","Button","����","�ӵ�ǰ������ɾ������Ա","my_disable()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","�û���Դ","�鿴�û���Ȩ��Դ","viewResources()",sResourcesPath},
            //{((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000"))?"true":"false"),"","Button","�û���ɫ","�鿴�����޸���Ա��ɫ","viewAndEditRole()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","��ɫά��","��ɫά��","viewAndEditRole()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","�������½�ɫ","�������½�ɫ","my_Addrole()",sResourcesPath},
			{((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","���û����½�ɫ","���û����½�ɫ","MuchAddrole()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","ת��","ת����Ա����������","UserChange()",sResourcesPath},    
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","�û�excel����","�û�excel����","importRecords()",sResourcesPath},   
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000"))?"true":"false"),"","Button","��ɫexcel����","��ɫexcel����","importUserRoleRecords()",sResourcesPath},   
            //{((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000"))?"true":"false"),"","Button","��ʼ����","��ʼ�����û�����","ClearPassword()",sResourcesPath}
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000") || CurUser.hasRole("1036") || CurUser.hasRole("1035"))?"true":"false"),"","Button","��������","��ʼ�����û�����","ClearPassword()",sResourcesPath},
            {((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000") || CurUser.hasRole("1000") || CurUser.hasRole("1036") || CurUser.hasRole("1035"))?"true":"false"),"","Button","�����û�","���ô������û�","enableUser()",sResourcesPath},
            //{((CurUser.hasRole("099") || CurUser.hasRole("3000") || CurUser.hasRole("2000"))?"true":"false"),"","Button","�û���������","�û���������","batchImport()",sResourcesPath},
    		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},

        };
	sButtons[8][0]="false";
	
	//���ڿ��Ƶ��а�ť��ʾ��������  add by Dahl 20150403
	String iButtonsLineMax = "15";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
	//end
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//Excel����������	
	function exportExcel(){
		amarExport("myiframe0");
	}

	function batchImport() {
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportUser", "filePath="+sFilePath);
	}
	//�����û�
	function importRecords(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportUserInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		
		//RunMethod("BlackListModel","delAddressMulti","");
		reloadSelf();
	}
	
	//�����û���Ӧrole
	function importUserRoleRecords(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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
	
	/*~[Describe=�鿴�û���Ȩ��Դ;InputParam=��;OutPutParam=��;]~*/
	function viewResources(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID)=="undefined" || sUserID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			AsControl.PopView("/AppConfig/OrgUserManage/ViewUserResources.jsp","UserID="+sUserID,"");
		}
	}

	<%/*~[Describe=�鿴�����޸���Ա��ɫ;]~*/%>
	function viewAndEditRole(){
        var sUserID=getItemValue(0,getRow(),"UserID");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }else{
        	var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"�������û����޷��鿴�û���ɫ��");
        	else
            	sReturn=popComp("UserRoleList","/AppConfig/OrgUserManage/UserRoleList.jsp","UserID="+sUserID+"&isCar="+'<%=sIsCar%>'+"","");
        }    
    }
    
    <%/*~[Describe=�������½�ɫ;]~*/%>    
    function my_Addrole(){
	    var sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    	}else{
        	var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"�������û����޷��������½�ɫ��");
        	else
        		PopPage("/AppConfig/OrgUserManage/AddUserRole.jsp?UserID="+sUserID,"","dialogWidth=550px;dialogHeight=350px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
    	}
	}
	
	<%/*~[Describe=���û����½�ɫ;]~*/%>
	function MuchAddrole(){
		var sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0){ 
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    	}else{
    		var sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"�������û����޷����û����½�ɫ��");
        	else
        		PopPage("/AppConfig/OrgUserManage/AddMuchUserRole.jsp?UserID="+sUserID,"","dialogWidth=550px;dialogHeight=600px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
		}
	}

	<%/*~[Describe=ת����Ա����������;]~*/%>
	function UserChange(){
        var sUserID = getItemValue(0,getRow(),"UserID");
        var sFromOrgID = getItemValue(0,getRow(),"BelongOrg");
        var sFromOrgName = getItemValue(0,getRow(),"BelongOrgName");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }else{
            //��ȡ��ǰ�û�
			sOrgID = "<%=CurOrg.getOrgID()%>";			
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined"){
			    if( typeof(sOrgInfo) != "undefined"&&sOrgInfo != "_CLEAR_")alert(getBusinessMessage('953'));//��ѡ��ת�ƺ�Ļ�����
			    return;
		    }else{
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];
			    
			    if(sFromOrgID == sToOrgID){
					alert(getBusinessMessage('954'));//��������Աת����ͬһ�����н��У�������ѡ��ת�ƺ������
					return;
				}
				//����ҳ�����
				sReturn = PopPageAjax("/SystemManage/SynthesisManage/UserShiftActionAjax.jsp?UserID="+sUserID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
				if(sReturn == "TRUE"){
	                alert(getBusinessMessage("914"));//��Աת�Ƴɹ���
	                reloadSelf();           	
	            }else if(sReturn == "FALSE"){
	                alert(getBusinessMessage("915"));//��Աת��ʧ�ܣ�
	            }
			}
		}
	}
	
	<%/*~[Describe=���ô������û�;]~*/%>
	function enableUser() {
	
		var userid = getItemValueArray(0,"UserID");	// ��ѡ
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
			alert("���óɹ���");
			reloadSelf();
		}
	}
	
	<%/*~[Describe=������Ա����ǰ����;]~*/%>
	function my_import(){
       sParaString = "BelongOrg"+","+"<%=sOrgID%>";		
		sUserInfo = setObjectValue("SelectImportUser",sParaString,"",0,0,"");
		if(typeof(sUserInfo) != "undefined" && sUserInfo != "" && sUserInfo != "_NONE_" && sUserInfo != "_CANCEL_" && sUserInfo != "_CLEAR_"){
       		sInfo = sUserInfo.split("@");
	        sUserID = sInfo[0];
	        sUserName = sInfo[1];
	        if(typeof(sUserID) != "undefined" && sUserID != ""){
	        	if(confirm(getBusinessMessage("912"))){ //��ȷ������ѡ��Ա���뵽����������
        			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction","addUser","UserID="+sUserID+",OrgID=<%=sOrgID%>");
					if(sReturn == "SUCCESS"){
		        		alert(getBusinessMessage("913"));//��Ա����ɹ���
		        		reloadSelf();
	        		}
	        	}else{
	        		alert("��Աת��ʧ��!");
	        	}
	        }
       	}
	}

	<%/*~[Describe=�ӵ�ǰ������ɾ������Ա;]~*/%>
	function my_disable(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID) == "undefined" || sUserID.length == 0){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
		}else if(confirm("��������������û���")){
            var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction","suoUser","UserID="+sUserID);
            if(sReturn == "SUCCESS"){
			    alert("��Ϣ�����ɹ���");
			    reloadSelf();
			}
		}
	}

	<%/*~[Describe=�����û�;]~*/%>
	function my_enable(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID) == "undefined" || sUserID.length == 0){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
		}else if(confirm("����������ø��û���")){
            var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction","enableUser","UserID="+sUserID);
            if(sReturn == "SUCCESS"){
			    alert("��Ϣ���óɹ���");
			    reloadSelf();
			}
		}
	}
	
	<%/*~[Describe=��ʼ���û�����;]~*/%>
	function ClearPassword(){
        var sUserID = getItemValue(0,getRow(),"UserID");
        var sInitPwd = "welcome!bqjr88";
        if (typeof(sUserID)=="undefined" || sUserID.length==0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getBusinessMessage("916"))){ //��ȷ��Ҫ��ʼ�����û���������
		    var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.ClearPasswordAction","initPWD","UserID="+sUserID+",InitPwd="+sInitPwd);
			if(sReturn == "SUCCESS"){
			    alert(getBusinessMessage("917"));//�û������ʼ���ɹ���
			    reloadSelf();
			}else{
				alert("�û������ʼ���ɹ���");
			}
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>