<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  
		Tester:
		Content: 
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�		
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));

	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null)   sObjectNo = "";

		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CarCommApplyInfo";
	
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//���ñ��䱳��ɫ
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//���ͻ����ͷ����ı�ʱ��ϵͳ�Զ������¼�����Ϣ
	//doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ñ���ʱ�����������ݱ�Ķ���
	//dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","ȷ��","ȷ��","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ��","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		checkType();//���ͻ���
		InsertCustomer();//����ͻ���Ϣ��
		
		//���������Ϣ��
		customerRel();
		//���ؽ��
		doReturn();
		//as_save("myiframe0",sPostEvents);
	}
	
	//������Ϣ��
	function customerRel(){
		//----������Ϣ����������-----
		//�ͻ����
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		//�ͻ�����
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");
		//�����ɫ����
		var sCustomerRole = getItemValue(0,getRow(),"CustomerRole");
		//��������
		//var sBirthDay = getItemValue(0,getRow(),"BirthDay");
		var sBirthDay = "";
		//��������
		var sObjectType = "<%=sObjectType%>";
		//�����
		var sSerialNo = "<%=sObjectNo%>";
		
		//alert("=========�ͻ����============"+sCustomerID);
		
		
		//alert("��ȡ�ͻ���ţ�"+sCustomerID+"�����ɫ:"+sCustomerRole+"�ͻ�����:"+sCustomerType+"��������:"+sObjectType+"�����:"+sSerialNo);
		//�жϹ��������Ƿ���ڼ�¼
		var sReturn=RunMethod("BusinessManage","ContractYesNo",sSerialNo+","+sObjectType+","+sCustomerID);
		//alert("----------------"+sReturn);
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn == "Null"){
			  //������Ϣ����������
		      RunMethod("BusinessManage","AddContractRecord",sSerialNo+","+sObjectType+","+sCustomerID+","+sCustomerType+","+sCustomerRole+","+sBirthDay);
		}else{
			  //������Ϣ����������
		      RunMethod("BusinessManage","UpdateContractRecord",sSerialNo+","+sObjectType+","+sCustomerID+","+sCustomerType+","+sCustomerRole+","+sBirthDay);
		}
		
	}
	
	function InsertCustomer(){
		//�жϵ�ǰ�ͻ��Ƿ����
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sCertID = getItemValue(0,0,"CertID");
		var sCertType = getItemValue(0,0,"CertType");
		var sCustomerType = getItemValue(0,0,"CustomerType");
		var sCustomerID = getItemValue(0,0,"CustomerID");
		
		//alert("�ͻ�ID��"+sCustomerID+"�ͻ����ͣ�"+sCustomerType+"�ͻ����ƣ�"+sCustomerName+"֤�����룺"+sCertID);
		
		var sStatus = "01";
		var sCustomerOrgType = sCustomerType;
		var sHaveCustomerType = sCustomerType;
		//��ȡ�ͻ�ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sCertID);
		//alert("����ֵ00000��"+sReturn);
		
		if(sReturn == "Null"){
			var sParam = "";
            sParam = sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;

			sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
        }
	}
		   
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		if(isCardNo()== false){
			return;
		}else{
			saveRecord("doReturn()");
		}
	}
	
	
	/*~[Describe=ȷ������;InputParam=��;OutPutParam=��;]~*/
	function doReturn(){
		sCustomerID = getItemValue(0,0,"CustomerID");
		sCustomerType = getItemValue(0,0,"CustomerType");
		//alert("22222222"+sCustomerID);
		top.returnValue = sCustomerID+"@"+sCustomerType;
		top.close();
	}

	
	//���ݿͻ����ͣ���д֤����Ϣ
	function selectCustomerType(){
		sCustomerType = getItemValue(0,0,"CustomerType");
		
		if(sCustomerType=="03"){//���˿ͻ�
			//����֤������Ϊ���֤
			setItemValue(0,0,"CertType","Ind01");
		}else if(sCustomerType=="04"){//�Թ͡���˾�ͻ�
			setItemValue(0,0,"CertType","Ent02");
		}else if(sCustomerType=="05"){
			setItemValue(0,0,"CertType","Ent02");
		}else{
			setItemValue(0,0,"CertType","");
		}
	}
	
	//���֤������У��
	function isCardNo()
	{
		var card = getItemValue(0,getRow(),"CertID");
		var sCertType = getItemValue(0,0,"CertType");
		
		//ֻ�����֤����֤
		if(sCertType=="Ind01"){
			// ���֤����Ϊ15λ����18λ��15λʱȫΪ���֣�18λǰ17λΪ���֣����һλ��У��λ������Ϊ���ֻ��ַ�X   
			var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;  
			if(reg.test(card) === false)  
			 {
			    alert("���֤���벻�Ϸ�");  
			    return  false;  
			 } 
		}
	}
	
	//���ͻ����Ƿ����
	function checkType(){
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sIdentityId = getItemValue(0,0,"CertID");
        //alert("---1111---"+sCustomerName+"--2222----"+sIdentityId);

		//��ȡ�ͻ�ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sIdentityId);
		//alert("����ֵ��"+sReturn);
			
	    //���ÿͻ�ID
	    if(sReturn == "Null"){
	    	//��ȡ�ͻ���
			var sCustomerID = getSerialNo("Customer_Info","CustomerID","");
			setItemValue(0,getRow(),"CustomerID",sCustomerID);
	    }else{
	    	//�ѿͻ��ţ����֤������ֻ��
	    	setItemReadOnly(0,0,"CustomerName",true);
	    	setItemReadOnly(0,0,"CertID",true);
	    	//�Ѳ�ѯ�Ŀͻ�ID���õ�CustomerID��
	        setItemValue(0,0,"CustomerID",sReturn);
	    }
	}
	
							
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼
			setItemValue(0,0,"CustomerRole","02");//��ͬ�����
			bIsInsert = true;
		}
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