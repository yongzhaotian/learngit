<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author:   ttshao 2012-12-21
        Tester: 
        Content: ���ſͻ���Ϣ�б�
        Input Param:   
        Output Param:  
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "���ż���ά��"   ; // ��������ڱ��� <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sCurBranchOrg=""; //��ǰ�û����ڷ���
	String sUserID =CurUser.getUserID();
	String sOrgID=CurUser.getOrgID();
	String sCurBranchSortNo = ""; //��ǰ�û����ڷ��е�SortNo
	String sTempletNo = "";//ģ��
	String sRight="All";
	String sRoleID="";

	//����������    ���ͻ�����
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%    
	String hasRole016 ="false";  //added by yzheng 2013/05/29
	String hasRole216 ="false";
    //016 ���м��ż���ά����,216 ���м��ż���ά����
    if(CurUser.hasRole("016") || CurUser.hasRole("216")|| CurUser.hasRole("000")){
    	sTempletNo = "GroupCustomerList";
    	hasRole016 = "true";
    	hasRole216 = "true";
    }
    else{
    	out.println("û�м���ά��Ȩ��");
    	return;
    }

    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    //���ӹ����� 
   // doTemp.setColumnAttribute("CustomerName,CustomerID,CertID","IsFilter","1");ģ��û����Ӧ�ֶ�nyzhang
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //����DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //������datawindows����ʾ������
    dwTemp.Style="1"; //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
    //����HTMLDataWindow
    Vector vTemp = null;
    if(CurUser.hasRole("016") || CurUser.hasRole("216")|| CurUser.hasRole("000"))
        vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sOrgID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));    
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>  
<% 
    //����Ϊ��
        //0.�Ƿ���ʾ
        //1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
        //2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
        //3.��ť����
        //4.˵������
        //5.�¼� 
        //6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
    String sButtons[][] = {
    		 {"true","","Button","��������","����һ����¼","newRecord()",sResourcesPath}, 
             {"true","","Button","��������","��������","viewGroupInfo()",sResourcesPath},
             {"true","","Button","ɾ������","ɾ������","deletePhyRecord()","btn_icon_delete"},//(sRightType.equals("ReadOnly")?"false":"true")
             {CurUser.hasRole("016")?"false":"true","","Button","�������й�������","�������й�������","changeGroupType2()",sResourcesPath},
            //{"true","","Button","�������й�������","�������й�������","changeGroupType2()",sResourcesPath},
             {"true","","Button","���ż��׸������","�鿴���ż��׸������","viewOpinions()",sResourcesPath},
             {"true","","Button","���ż��׸ſ�","�鿴���ż��׸ſ�","viewGroupFamily()","btn_icon_detail"},
             {"true","","Button","���ż����������϶��汾","�鿴���ż����������϶��汾","viewGroupFamilyList()","btn_icon_detail"},
             };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

   
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
    /*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
    function newRecord(){
		var sCustomerType ="<%=sCustomerType%>";
		AsControl.PopView("/CustomerManage/GroupManage/GroupCustomerInfo.jsp","CustomerType="+sCustomerType,"resizable=yes;dialogWidth=50;dialogHeight=30;center:yes;status:no;statusbar:no");
		reloadSelf();
    } 
    
    /*~[Describe=���Ÿſ�;InputParam=��;OutPutParam=��;]~*/
	function viewGroupInfo(){
      	var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sMgtOrgID=getItemValue(0,getRow(),"MgtOrgID");
		var sMgtUserID=getItemValue(0,getRow(),"MgtUserID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KeyMemberCustomerID");
		var sGroupName=getItemValue(0,getRow(),"GroupName");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
		
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
      	
		//�鿴�����Ƿ�����;���룬�����򷵻� 
		var sReturn =RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkOnLineApply","GroupID="+sGroupID);  
		
		var hasRole016 = "<%= hasRole016%>";  //added by yzheng 2013/05/29
		var hasRole216 = "<%= hasRole216%>";
		
		if ( (sReturn == "ReadOnly" && hasRole016 == "true") || (sReturn == "ReadOnly" && hasRole216 == "true") ){
			sRightType=sReturn;
		}
		else{
			sRightType="<%=sRight %>";
		}
		
		//�򿪼�������ҳ��
		AsControl.PopView("/CustomerManage/CustomerDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
		reloadSelf();	
	}  
    
    /*~[Describe=���ż���;InputParam=��;OutPutParam=��;]~*/
	function viewGroupFamily(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sMgtOrgID=getItemValue(0,getRow(),"MgtOrgID");
		var sMgtUserID=getItemValue(0,getRow(),"MgtUserID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KeyMemberCustomerID");
		var sGroupName=getItemValue(0,getRow(),"GroupName");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
      	
        //�鿴�����Ƿ�����;���룬�����򷵻� 
		var sReturn =RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkOnLineApply","GroupID="+sGroupID);  
        
		var hasRole016 = "<%= hasRole016%>";  //added by yzheng 2013/05/29
		var hasRole216 = "<%= hasRole216%>";
		
		if ( (sReturn == "ReadOnly" && hasRole016 == "true") || (sReturn == "ReadOnly" && hasRole216 == "true") ){
			sRightType=sReturn;
		}
		else  sRightType="<%=sRight %>";
		
		AsControl.PopView("/CustomerManage/GroupFamilyDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
		reloadSelf();	
	}  
  
    /*~[Describe=���ż����������϶��汾;InputParam=��;OutPutParam=��;]~*/
	function viewGroupFamilyList(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sMgtOrgID=getItemValue(0,getRow(),"MgtOrgID");
		var sMgtUserID=getItemValue(0,getRow(),"MgtUserID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KeyMemberCustomerID");
		var sGroupName=getItemValue(0,getRow(),"GroupName");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
      	
        //�鿴�����Ƿ�����;���룬�����򷵻� 
		var sReturn =RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkOnLineApply","GroupID="+sGroupID);  
        
		var hasRole016 = "<%= hasRole016%>";  //added by yzheng 2013/05/29
		var hasRole216 = "<%= hasRole216%>";
		
		if ( (sReturn == "ReadOnly" && hasRole016 == "true") || (sReturn == "ReadOnly" && hasRole216 == "true") ){
			sRightType=sReturn;
		}
		else  sRightType="<%=sRight %>";
		
		AsControl.PopView("/CustomerManage/GroupFamilyListDetailTab.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"");
		reloadSelf();		
	} 
    
    /*~[Describe=ɾ�����ſͻ�;InputParam=��;OutPutParam=��;]~*/
    function deletePhyRecord(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sGroupName = getItemValue(0,getRow(),"GroupName");
		var sFamilyMapStatus = getItemValue(0,getRow(),"FamilyMapStatus");    //���׸���״̬ 
		var sFamilyMapStatusName = getItemValue(0,getRow(),"FamilyMapStatusName");
		var sUserID = "<%=sUserID%>";
		var sOrgID = "<%=sOrgID%>";
		
        if (typeof(sGroupID)=="undefined" || sGroupID.length==0) {
        	alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(sFamilyMapStatus != "0"){
			alert("�ü��ſͻ����ڡ�"+sFamilyMapStatusName+"��״̬,����ɾ����");
			return;
		}else{
			//У�鼯�ſͻ��Ƿ��������Ч�汾
		    var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkGroupApproveOpinion","GroupID="+sGroupID);
			if(sReturn != "NOTEXIST" && sReturn != "ERROR"){
				alert("�ü��ſͻ���������Ч�汾,����ɾ����");
				return;
			}
		}
		
		//У�鼯�ſͻ��Ƿ������Ч�����Ŷ��
        var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkBeforeDeleteGroup","GroupID="+sGroupID);
		if(sReturn != "IsNotExist" && sReturn != "ERROR"){
			alert(sReturn);
			return;
		}
		
        if(confirm("�Ƿ�ȷ��ɾ���ü��ſͻ���")){
			// ɾ�����ſͻ�
			var sReturnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","deleteGroupCustomer","GroupID="+sGroupID+",UserID="+sUserID+",OrgID"+sOrgID+",GroupName="+sGroupName);
			if(sReturnValue == "true"){
				alert("ɾ���ɹ���");
				reloadSelf();
			}else{
				alert("ɾ��ʧ�ܣ�");
			}
        }
    }
    
    /*~[Describe=�������й�������;InputParam=��;OutPutParam=��;]~*/
    function changeGroupType2(){
		//1. ��ȡҵ�����
		var sGroupID = getItemValue(0,getRow(),"GroupID"); //���ſͻ�ID
		var sGroupType2 = getItemValue(0,getRow(),"GROUPTYPE2");
		var sInputUserID=getItemValue(0,getRow(),"InputUserID");
		var sInputOrgID=getItemValue(0,getRow(),"InputOrgID");
		var sFamilyMapStatus=getItemValue(0,getRow(),"FamilyMapStatus");
		var sFamilyMapStatusName = getItemValue(0,getRow(),"FamilyMapStatusName");

		if(sGroupType2 == "1"){
			alert("�Ѿ������й���������!");
			return;
		}
		if(sFamilyMapStatus == "1"){
			alert("�ü��ſͻ����ڡ�"+sFamilyMapStatusName+"��״̬,���ܽ��и���!");//���״��ڡ�����С����������޸ġ�
			return;
		}
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("ȷ��Ҫ�������й���������")){
			var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","updateGroupType2","GroupID="+sGroupID+",UserID="+sInputUserID+",OrgID="+sInputOrgID);
			if(sReturn == "Success"){
				alert("����ɹ�!");
			}else{
				alert("����ʧ��");
				return;
			}
		}
		reloadSelf();
    }
    
    /*~[Describe=�鿴���ż��׸������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		var sGroupID = getItemValue(0,getRow(),"GroupID");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
      	AsControl.PopView("/CustomerManage/GroupManage/GroupApproveOpinions.jsp", "GroupID="+sGroupID+"&RightType=All", "");
      	reloadSelf();	
	}  

    
    /**
     * 
     * ����ѡ��򣬴���һ�������ţ�ѡ����Ӧ����
     * ��������ط�ʹ�õ�ѡ�����Ƚ�Ƶ����������ɿ��ǽ��˺�������common.js
     * @author syang 2009/10/14
     * @param codeNo ������
     * @param Caption �����Ի�������
     * @param defaultValue ѡ���Ĭ��ֵ
     * @param filterExpr ��ItemNo����������ʽ����ƥ��
     * @return ѡ���ItemNo
     */
    function selectCode(codeNo,Caption,defaultValue,filterExpr){
        if(typeof(filterExpr) == "undefined"){
            filterExpr = "";
        }
        var codePage = "/CustomerManage/SelectCode.jsp";
        var sPara = "CodeNo="+codeNo+"&Caption="+Caption+"&DefaultValue="+defaultValue
                   +"&ItemNoExpr="+encodeURIComponent(filterExpr)  //������Ҫ������ת������������&,%,+�����ַ������������
                   ;
        style = "resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no";
        sReturnValue = PopPage(codePage+"?"+sPara,"",style);
        return sReturnValue;
    }
    </script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
    my_load(2,0,'myiframe0');
</script>   
<%/*~END~*/%>

   
<%@ include file="/IncludeEnd.jsp"%>