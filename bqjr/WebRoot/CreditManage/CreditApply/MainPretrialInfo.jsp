<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 
		Input Param:
			
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sTempletNo = "MainPretrialInfo";	
	//�������������ͻ�����
	String sSerialNo         = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//String sflag             = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));
	String sIsFinish = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isFinish"));
	ARE.getLog().debug("��ɱ�־��"+sIsFinish);
	//if(sSerialNo == null) sSerialNo = "";
	//if(sflag == null) sflag = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setRequired("*", true);
	doTemp.setHTMLStyle("CertType", "onChange=\"javascript:parent.isCardNo()\";style={background=\"#EEEEff\"}");
	
	
	doTemp.WhereClause = " where SerialNo = '"+sSerialNo+"'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly="0";

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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}

		};
	if("ture".equalsIgnoreCase(sIsFinish)){
		sButtons[0][0] = "false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{	
		InsertCustomer();//����ͻ���Ϣ��
		
		//�ͻ����
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		//�ͻ�����(���ˡ���˾���Թ�)
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");
		//�ͻ������ɫ��������ˡ���ͬ����ˡ���֤�ˣ�
		var sCustomerRole = getItemValue(0,getRow(),"CustomerRole");
		//��������
		var sBirthDay = getItemValue(0,getRow(),"BirthDay");
		//��������
		var sObjectType = "BusinessContract";
		//�����
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
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
		
		as_save("myiframe0");
	}
	
	
	//����ͻ���Ϣ����
	function InsertCustomer(){
		//�жϵ�ǰ�ͻ��Ƿ����
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sCertID = getItemValue(0,0,"CertID");
		var sCertType = getItemValue(0,0,"CertType");
		var sCustomerType = getItemValue(0,0,"CustomerType");
		var sCustomerID = getItemValue(0,0,"CustomerID");
		
		var sStatus = "01";
		var sCustomerOrgType = sCustomerType;
		var sHaveCustomerType = sCustomerType;
		//��ȡ�ͻ�ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sCertID);
		if(sReturn == "Null"){
			var sParam = "";
            sParam = sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;

			sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
        }else{
        	//����ͻ����ڣ����ԭ���Ŀͻ����ȡ��
        	setItemValue(0,0,"SerialNo",sReturn);
        }
		
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
			if(!CheckLicense(card)){
				alert("���֤���벻�Ϸ���");
				setItemValue(0,0,"CertID","");
			}else{
				setBirthDay();//�������֤��������
			}
		}
	}
	
	
	function setBirthDay(){
		//1:У��֤������Ϊ���֤����ʱ���֤ʱ�����������Ƿ�֤ͬ������е�����һ��
		sCertType = getItemValue(0,getRow(),"CertType");//֤������
		sCertID = getItemValue(0,getRow(),"CertID");//֤�����
		sBirthday = getItemValue(0,getRow(),"BirthDay");//��������
		if(sCertType == 'Ind01' || sCertType == 'Ind08'){
				//У���֤����ʱ���֤�ĳ���
				if(sCertID.length !=18){
					alert(getBusinessMessage('250')); //֤�����볤������							
					return false;
				}
				//�����֤�е������Զ�������������,�����֤�е��Ա𸳸��Ա�
				if(sCertID.length == 15){
					sSex = sCertID.substring(14);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
				if(sCertID.length == 18){
					sSex = sCertID.substring(16,17);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,14);
					sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
			}
			setItemValue(0,getRow(),"BirthDay",sCertID); 
		}	
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			initSerialNo();//������
			initCustomerID();//�ͻ���
			//�ͻ�����(�������)
			setItemValue(0,0,"CustomerRole","01");
			//������ͬ��ʶ
			setItemValue(0,0,"CreditAttribute","0001");
			//��ͬ״̬��Ԥ��170
			setItemValue(0,0,"ContractStatus","170");
			
			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=��ʼ���ͻ����ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initCustomerID(){
		var sTableName = "Customer_Info";//����
		var sColumnName = "CustomerID";//�ֶ���
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
	//bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
