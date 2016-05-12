<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: sjchuan
		       
		Tester:	
		Content: �ͻ���Ϣ�б�
		Input Param:
			CustomerType���ͻ�����
				01����˾�ͻ���
				0110��������ҵ�ͻ���
				0120����С����ҵ�ͻ���
				02�����ſͻ���
				0210��ʵ�弯�ſͻ���
				0220�����⼯�ſͻ���
				03�����˿ͻ�
				0310�����˿ͻ���
				0320�����徭Ӫ����
            CustomerListTemplet���ͻ��б�ģ�����          
		���ϲ���ͳһ�ɴ����:--MainMenu���˵��õ�����
		Output param:
		   CustomerID���ͻ����
           CustomerType���ͻ�����		                				
           CustomerName���ͻ�����
           CertType���ͻ�֤������						                
           CertID���ͻ�֤������
		History Log: 
			DATE	CHANGER		CONTENT
			2005-07-20	fbkang	ҳ������
			2005/09/10 zywei �ؼ����
			2009/08/13 djia ����AmarOTI --> queryCusomerInfo()
			2009/10/12 pwang �޸ı�ҳ����漰�ͻ������жϵ����ݡ�
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���Ϣ�б�"   ; // ��������ڱ��� <title> PG_TITLE </title>  
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//��� sql���	
	String sUserID = CurUser.getUserID(); //�û�ID
	String sOrgID = CurOrg.getOrgID(); //����ID
	
	//���˾�Ӫ����ʾģ��
	String sTempletNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelType"));
	//�����ͻ��ţ����˾�Ӫ���ͻ���
	String sRelativeSerialno = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//���˾�Ӫ���ͻ����ͣ�Ĭ��Ϊ��С��ҵ0120
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NoteType"));

	//����ֵת��Ϊ���ַ���
	if(sCustomerType == null) sCustomerType = "";
	if(sRelativeSerialno == null) sRelativeSerialno = "";
	if(sTempletNo == null) sTempletNo = "";
	//���ҳ�����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//���ӹ�����	
    doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(20);
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRelativeSerialno+","+sUserID+","+sCustomerType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sbCustomerType = sCustomerType.substring(0,2);
	
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼� 
		//6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"false","","Button","����","�����Ѵ��ڵĿͻ�","importCustomer()",sResourcesPath},
			};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		var sCustomerType="<%=sCustomerType%>";//�ͻ�����
		var sCustomerID ='';									//�ͻ�ID
		var sReturn ='';											//����ֵ���ͻ���¼����Ϣ�Ƿ�ɹ�
		var sReturnStatus = '';								//�ͻ���Ϣ�����
		var sStatus = '';											//�ͻ���Ϣ���״̬		
		var sReturnValue = '';								//�ͻ�������Ϣ
		var sCustomerOrgType ='';							//�ͻ���������
		
		sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=14;center:yes;status:no;statusbar:no");
		if(typeof(sReturnValue) == "undefined" || sReturnValue.length == 0 || sReturnValue == '_CANCEL_'){
			return;
		}
		sReturnValue = sReturnValue.split("@");
		//�õ��ͻ�������Ϣ
		sCustomerOrgType = sReturnValue[0];
		sCustomerName = sReturnValue[1];
		sCertType = sReturnValue[2];
		sCertID = sReturnValue[3];
	
		//���ͻ���Ϣ����״̬
		//������ʽ��CustomerType,CustomerName,CertType,CertID,UserID
		sReturnStatus = RunMethod("CustomerManage","CheckCustomerAction",sCustomerType+","+sCustomerName+","+sCertType+","+sCertID+",<%=CurUser.getUserID()%>");
		//�õ��ͻ���Ϣ������Ϳͻ���
		var sReturnStatus1 = sReturnStatus.split("@");
		//01 �޸ÿͻ� 
		//02 ��ǰ�û�����ÿͻ��������� 
		//04 ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ 
		//05 ��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ 
		sStatus = sReturnStatus1[0];
		sCustomerID = sReturnStatus1[1];
		sHaveCustomerType = sReturnStatus1[2];
		//sHaveCustomerTypeName = sReturnStatus1[3];
		//sHaveStatus = sReturnStatus1[4];
		var realCustomerName = sReturnStatus1[5];
		

		
		//01Ϊ�ÿͻ�������
		if(sStatus == "01"){				
			//���ɿͻ���
			sCustomerID = getNewCustomerID();
			//����˵��CustomerID,CustomerName,CustomerType,CertType,CertID,Status,CustomerOrgType,UserID,OrgID
			var sParam = (sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID)
			sParam += (","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
			//�����ͻ���Ϣ
			sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
			//�Ѿ������ͻ�
			if(sReturn == "1"){
				//����CI���Status�ֶ�Ϊ0(��С��ҵ�϶�)
				RunMethod("CustomerManage","UpdateCustomerStatus",sCustomerID+",0");
				//��������
				RunMethod("CustomerManage","InsertSmeCustRela",sCustomerID+",<%=sRelativeSerialno%>");
				alert(getBusinessMessage('109')); //�����ͻ��ɹ�
				openObject("Customer",sCustomerID,"001");
			}else{
				alert("�����ͻ�����");
				return;
			}
		//����ÿͻ����ڱ�ϵͳ��  			
		}else if(sStatus == "02"){
			if(sHaveCustomerType != "0120"){  //���ӽ�������С��ҵ�ж� added by yzheng 2013-7-2
				alert("������ѡ��ͻ�,����������С��ҵ.");
				return;
			}
			
			if(!confirm("��ǰ�û�����ÿͻ��������� ��ȷ������ͻ���" + realCustomerName +"����")){
				return;
			}		
			//��������
			RunMethod("CustomerManage","InsertSmeCustRela",sCustomerID+",<%=sRelativeSerialno%>");
		}else if(sStatus == "04"){
			if(!confirm("��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ ��ȷ�������𲢻��������Ȩ��")){
				return;
			}				
			//����˵��CustomerID,CustomerName,CustomerType,CertType,CertID,Status,CustomerOrgType,UserID,OrgID
			var sParam = (sCustomerID+",,,,")
			sParam += (","+sStatus+",,<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
			//�����ͻ���Ϣ
			RunMethod("CustomerManage","AddCustomerAction",sParam);
			//��������
			RunMethod("CustomerManage","InsertSmeCustRela",sCustomerID+",<%=sRelativeSerialno%>");
		}else if(sStatus == "05"){
			if(!confirm("��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ��ȷ��������")){
				return;
			}
			//����˵��CustomerID,CustomerName,CustomerType,CertType,CertID,Status,CustomerOrgType,UserID,OrgID
			var sParam = (sCustomerID+",,,,")
			sParam += (","+sStatus+",,<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
			//�����ͻ���Ϣ
			RunMethod("CustomerManage","AddCustomerAction",sParam);
			//��������
			RunMethod("CustomerManage","InsertSmeCustRela",sCustomerID+",<%=sRelativeSerialno%>");
		}
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			sReturn = RunMethod("CustomerManage","DelIndEntRela",sCustomerID+","+"<%=CurUser.getUserID()%>");
			if(sReturn == "1"){
				alert("�ÿͻ�ɾ���ɹ���");
				reloadSelf();
			}else{
				alert("�ÿͻ�ɾ��ʧ�ܣ�");
				return;
			}
		}
	}


	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}		
		var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0){
        	return;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];                        
        if(sReturnValue1 == "Y"){
    		openObject("Customer",sCustomerID,"001");           
    		reloadSelf();
		}else{
		    alert(getBusinessMessage('115'));//�Բ�����û�в鿴�ÿͻ���Ȩ�ޣ�
		}
	}

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function importCustomer(){
		sReturnValue = PopPage("/CustomerManage/IndManage/ImportIndEntpriseDialog.jsp","","resizable=yes;dialogWidth=25;dialogHeight=14;center:yes;status:no;statusbar:no");
		if(typeof(sReturnValue) == "undefined" || sReturnValue.length == 0 || sReturnValue == "_CANCEL_"){
			return;
		}
		var sReturn = sReturnValue.split("@");
		var sCustomerName = sReturn[0];
		var sCertType = sReturn[1];
		var sCertID = sReturn[2];
		var sRelativeSerialno = "<%=sRelativeSerialno%>";
		var sValue = PopPageAjax("/CustomerManage/IndManage/ImportIndEntpriseActionAjax.jsp?CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID+"&RelativeSerialNo="+sRelativeSerialno,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sValue) == "undefined" || sValue.length == 0){
			alert("������˾�Ӫ����ҵʧ�ܣ�");
			return;
		}
		if(sValue=="01"){
			alert("�ÿͻ������ڣ����������֤��������֤�������Ƿ���ȷ��");
			return;
		}
		if(sValue=="02"){
			alert("�ÿͻ�������С��ҵ���ͣ����ת����ҵ���ͺ������룡");
			return;
		}
		if(sValue=="04"){
			alert("�ÿͻ��Ѵ����б��У������ظ����룡");
			return;
		}
		if(sValue=="06"){
			alert("����С��ҵ�ͻ�δͨ���϶������飡");
			return;
		}
		if(sValue=="07"){
			alert("��û�иÿͻ�������Ȩ���������룡");
			return;
		}
		if(sValue=="10"){
			alert("�ÿͻ�����δ�ս�ĺ�ͬ��Ϣ���������룡");
			return;
		}
		if(sValue=="11"){
			alert("�ÿͻ�����δ��ɵ��������������Ϣ���������룡");
			return;
		}
		if(sValue=="12"){
			alert("�ÿͻ�����δ��ɵ�ҵ��������Ϣ���������룡");
			return;
		}
		if(sValue=="09"){
			alert("������˾�Ӫ����ҵ�ɹ���");
			reloadSelf();
		}
	}

	/**
	 *�����¿ͻ���
	 */
	function getNewCustomerID(){
		var sTableName = "CUSTOMER_INFO";//����
		var sColumnName = "CustomerID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		return sSerialNo;
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