<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   lyin 2012-12-11
		Tester:
		Content:  ���ſͻ��ſ�ҳ��
		Input Param:
			  
		Output param:
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ſͻ��ſ�"; // ��������ڱ���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
    String sTempletNo = "";//��ʾģ����
    String sTempletFilter = "1=1";
    
    //����������    ���ͻ����͡����ſͻ���š����ſͻ����ơ�ҵ�����������ҵ������ͻ�����������ҵ�ͻ����
    String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType==null) sCustomerType="";
	
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID==null) sGroupID="";
	
	String groupName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupName"));
	if(sCustomerType==null) sCustomerType="";
	
	String sOldGroupType2 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupType2"));
	if(sOldGroupType2==null) sOldGroupType2="";
	
	String sOldMgtOrgID=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("MgtOrgID"));
	if(sOldMgtOrgID==null) sOldMgtOrgID="";
	
	String sOldMgtUserID=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("MgtUserID"));
	if(sOldMgtUserID==null) sOldMgtUserID="";
	
	String sOldKeyMemberCustomerID=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("KeyMemberCustomerID"));
	if(sOldKeyMemberCustomerID==null) sOldKeyMemberCustomerID="";
	
	String sRightType=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if(sRightType==null) sRightType="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	sTempletNo = "GroupCustomerInfo1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setEvent("BeforeInsert","!CustomerManage.AddGroupCustomerAction(#GROUPID,"+CurOrg.getOrgID()+","+CurUser.getUserID()+")");//��ʼ���ͻ���Ϣ
    dwTemp.setEvent("AfterInsert","!CustomerManage.InitGroupCustomerAction(#GROUPID,"+sCustomerType+","+CurUser.getUserID()+")");//��ʼ�����ż��׵���Ϣ 
    
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));   
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
    String sButtons[][] = {
			{(sRightType.equals("ReadOnly")?"false":"true"),"All","Button","����","����","saveRecord()","","","",""},
			{"false","","Button","���ź�����ҵ��Ϣ","���ź�����ҵ��Ϣ","viewParent()","","","",""},
			{"false","","Button","ȡ��","ȡ��","cancel()","","","",""}
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	function saveRecord(sPostEvents)
	{ 	
		var sGroupID = getItemValue(0,getRow(),"GROUPID");
		var sGroupName = getItemValue(0,getRow(),"GROUPNAME");
		var groupName= "<%=groupName%>";  
		var sCurrentVersionSeq = getItemValue(0,getRow(),"CURRENTVERSIONSEQ");      
		//��֤���������Ƿ��ظ�
		if(groupName==null || groupName==""){
			//����ʱ
			var Return = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkGroupName","GroupName="+sGroupName);
			if(Return != "true"){
					alert("�ü��������Ѵ���,��������������");
					return;
				}
			}else{
			//�޸ļ��Ÿſ�ʱ
			var Return = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkGroupName1","GroupName="+sGroupName+",GroupID="+sGroupID);
			if(Return != "true"){
					alert("�ü��������Ѵ���,��������������");
					return;
				}
			}
		
		//��������ҵ�Ƿ������������ų�Ա
		var sKeyMemberCustomerID = getItemValue(0,getRow(),"KEYMEMBERCUSTOMERID");
 		var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkMember","keyMemberCustomerID="+sKeyMemberCustomerID+",GroupID="+sGroupID);
 		if(sReturn!="true"){
			alert(sReturn);
			return;
		}
 		
 		var sFamilyMapStatus=getItemValue(0,getRow(),"FAMILYMAPSTATUS");
		if(sFamilyMapStatus=="1"){
			alert("�ü�����������У����ܽ����޸�!");
			return ;
		}

        //�жϺ�����ҵ�Ƿ�䶯��ȡ���ɵĺ�����ҵ�ͻ����
        var sOldKeyMemberCustomerID = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkKeyMemberCustomerID","GroupID="+sGroupID);
       	if(sFamilyMapStatus!="0"&&sKeyMemberCustomerID!=sOldKeyMemberCustomerID){//��Ϊ�ݸ塢������ҵ�Ķ�
			if(!confirm("��ȷ��Ҫ�޸����޸ĺ��ż��׽����Ϊ[�ݸ�]״̬�����������ύ���˺���Ч��")) return ;
			var sRefVersionSeq=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","getNewRefVersionSeq","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",currentVersionSeq="+sCurrentVersionSeq+"");
			if(typeof(sRefVersionSeq)!="undefined" && sRefVersionSeq.length !=0 && sRefVersionSeq!="ERROR"){
				//����״̬����Ϊ0(�ݸ�)
				setItemValue(0,getRow(),"FAMILYMAPSTATUS","0");
			}
		}
		as_save("myiframe0",sPostEvents);	
		
		updateGroupFamilyMember();
		
		var sMgtOrgID=getItemValue(0,getRow(),"MGTORGID");
		var sMgtUserID=getItemValue(0,getRow(),"MGTUSERID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KEYMEMBERCUSTOMERID");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
		var sParam="GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType=All";
		AsControl.PopView("/CustomerManage/CustomerDetailTab.jsp",sParam,"");
		cancel();
	}
	
	function cancel(){
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var isAdd=false;//��ǰ�Ƿ�Ϊ����,Ĭ��Ϊ��
    /*~[Describe=����ѡ�������ҵ���ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/   
    function selectKeyMemberCustomerName(){
    	var sKeyMemberCustomerID = getItemValue(0,getRow(),"KEYMEMBERCUSTOMERID");
    	var sGroupID = getItemValue(0,getRow(),"GROUPID");
    	//��鼯�ſͻ��Ƿ�����;����
    	var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","getBusinessMessage","GroupID="+sGroupID);
    	if(sReturn != "NO"){
    		alert("�ͻ�����;���룬�������޸ĺ�����ҵ��");
    		return;
    	}
    	//��鼯�ſͻ��Ƿ������϶��ļ��װ汾
    	var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkKeyMemberCustomer","GroupID="+sGroupID);
    	var selName="";
    	var sParaString ="";
    	var sCol="";
    	if(sReturn == "NOTPAST"){//��ǰ���������϶��ļ��װ汾
    		selName="SelectKeyMemberCustomerID";
    		sCol="@CustomerID@0@CustomerName@1";
    	}else{					 //��ǰ���������϶��ļ��װ汾�������Ի�������Ϊ��ǰ���ż������϶���Ա�б�
    		var sGroupID = getItemValue(0,getRow(),"GROUPID");
    		selName="SelectKeyMember";
    		sParaString = "GroupID"+","+sGroupID;
    		sCol="@MemberCustomerID@0@MemberName@1";
    	}
        var sRet = AsDialog.OpenSelector(selName,sParaString,sCol,0,0,"");
    	if(!isNull(sRet)){
	    	if(sRet=="_CLEAR_"){//���
	        	setItemValue(0,getRow(),"KEYMEMBERCUSTOMERID","");
	        	setItemValue(0,getRow(),"KEYMEMBERCUSTOMERNAME","");
	        }else{
	        	sRet = sRet.split("@");
	        	setItemValue(0,getRow(),"KEYMEMBERCUSTOMERID",sRet[0]);
	        	setItemValue(0,getRow(),"KEYMEMBERCUSTOMERNAME",sRet[1]);
	        }
    	}
        
    }
	
    
    /*~[Describe=����ѡ������ͻ������ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/   
    function selectMgtUserID(){
    	var sGroupID = getItemValue(0,getRow(),"GROUPID");
      	//��鼯�ſͻ��Ƿ�����;����
    	var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","getBusinessMessage","GroupID="+sGroupID);
    	if(sReturn != "NO"){
    		alert("�ͻ�����;���룬�������޸�����ͻ�����");
    		return;
    	}
    	var paraString="";
        var selName="";
    	if(<%=CurUser.hasRole("016")%>){
    		paraString = "UserID"+","+"<%=CurUser.getUserID()%>"; 
        	selName="selectMgtUserID";
    	}else{
        	selName="selectMgtUserID1";
    	}
   		var sRet = AsDialog.OpenSelector(selName,paraString,"@UserID@0@UserName@1@BelongOrg@2@OrgName@3",0,0,"");
        if(!isNull(sRet)) {
	        if(sRet=="_CLEAR_"){//���
	        	setItemValue(0,getRow(),"MGTUSERID","");
	        	setItemValue(0,getRow(),"MGTUSERNAME","");
	        	setItemValue(0,getRow(),"MGTORGID","");
	        	setItemValue(0,getRow(),"MGTORGNAME","");
	        }else{
	        	sRet = sRet.split("@");
	        	setItemValue(0,getRow(),"MGTUSERID",sRet[0]);
	        	setItemValue(0,getRow(),"MGTUSERNAME",sRet[1]);
	        	setItemValue(0,getRow(),"MGTORGID",sRet[2]);
	        	setItemValue(0,getRow(),"MGTORGNAME",sRet[3]);
	        }
        }
    }
    
	/*~[Describe=У�鼯�ż�Ƴ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function checkGroupAbbName(sGroupAbbName,n){
		var sFieldLength = 0;
		for(var i = 0; i < sGroupAbbName.length; i++){
			if(sGroupAbbName.charCodeAt(i)> 255){
				sFieldLength += 2;
		    }else{
		    	sFieldLength += 1;
		    }

		    if(sFieldLength > n){ 
				$("#GroupAbbNameMessage").text("���ż�Ƴ�������Ϊ"+(n/2)+"������(2����ĸ=1������)��������������");
				return false;
			}
		}
		
		$("#GroupAbbNameMessage").text("");
		return true;
	}
	
	/*~[Describe=��������ͻ�������������;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function checkGroupType(sGroupType){
		sGroupType1 = getItemValue(0,0,"GroupType1");
		sMgtUserID = getItemValue(0,0,"MgtUserID");
		sMgtOrgID = getItemValue(0,0,"MgtOrgID");
		sGroupType4 = getItemValue(0,0,"GroupType4"); //�Ƿ��Զ�������ȷ���
		if(sGroupType1 == "02" && (sMgtUserID == "" || sMgtOrgID == "")){
			$("#MgtUserMessage").text("�ü���Ϊ�����Լ��ſͻ�����ѡ������ͻ���������������");
			return false;
		}

		if(sGroupType == "1"){
			if(sMgtUserID == "" || sMgtOrgID == ""){
				$("#MgtUserMessage").text("�ü��ſͻ������м��й��������ڣ���ѡ������ͻ���������������");
				return false;
			}else if(sGroupType1 == "01" && sMgtOrgID != "10130"){
				$("#MgtUserMessage").text("�ü���Ϊ����м��ſͻ����������м��й��������ڣ��������ӦΪ���й�˾���в�����������ѡ��");
				return false;
			}
		}

		$("#MgtUserMessage").text("");
		return true;
	}

	/*~[Describe=���Ÿſ������ĺ�������;InputParam=��;OutPutParam=��;]~*/
	function updateGroupFamilyMember(){
		var sMgtOrgID=getItemValue(0,getRow(),"MGTORGID");
		var sKeyMemberCustomerID=getItemValue(0,getRow(),"KEYMEMBERCUSTOMERID");
		var sMgtUserID=getItemValue(0,getRow(),"MGTUSERID");
		var sGroupType2=getItemValue(0,getRow(),"GROUPTYPE2");
		var oldGroupType2="<%=sOldGroupType2%>";
		var oldMgtOrgID="<%=sOldMgtOrgID%>";
		var oldMgtUserID="<%=sOldMgtUserID%>";
		var oldKeyMemberCustomerID="<%=sOldKeyMemberCustomerID%>";
		var sGroupID="<%=sGroupID%>";
		var sUserID="<%=CurUser.getUserID()%>";
		//��������ҵ�Ƿ����������ų�Ա
 		var sIsGroupMember = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","isGroupCustomer1","memberCustomerID="+sKeyMemberCustomerID+",GroupID="+sGroupID);
		RunMethod("CustomerManage","UpdateGroupCustomerAction",sMgtOrgID+","+sKeyMemberCustomerID+","+sMgtUserID+","+sGroupType2+","+oldGroupType2+","+oldMgtOrgID+","+oldMgtUserID+","+oldKeyMemberCustomerID+","+sGroupID+","+sUserID+","+sIsGroupMember);

	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		isAdd=false;
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			isAdd=true;
			initSerialNo();	
			setItemValue(0,getRow(),"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		}
		setItemValue(0,getRow(),"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
    }

	function isNull(value){
		if(typeof(value)=="undefined" || value==""){
			return true;
		}
		return false;
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "GROUP_INFO";//����
		var sColumnName = "GROUPID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
