<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: �������Ŷ������
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�		
		Output param:
		History Log: zywei 2005/07/28
					 zywei 2005/07/28 �����Ŷ������ҳ�浥������
					 jgao1 2009/10/21 ���Ӽ������Ŷ�ȣ��Լ�ѡ��ͻ����ͱ仯ʱ���Data����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ŷ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CreditContractApplyInfo";
	
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
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+")");
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
			{"true","","Button","ȷ��","ȷ���������Ŷ������","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()",sResourcesPath}	
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
		initSerialNo();
		as_save("myiframe0");
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
     var  sCustomerName;
	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		sSerialNo = getItemValue(0,0,"SerialNo");
		sRemark = getItemValue(0,0,"remark");
		RunMethod("WorkFlowEngine","InitializeFlow","<%=sObjectType %>,"+sSerialNo +",<%=sApplyType %>,<%=sFlowNo %>,<%=sPhaseNo %>,<%=CurUser.getUserID() %>,<%=CurOrg.getOrgID() %>");
	    RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='200',serialNo='"+sSerialNo+"'");// �޸ĺ�ͬ״̬
	    RunMethod("ModifyNumber","GetModifyNumber","business_contract,remark='"+sRemark+"',serialNo='"+sSerialNo+"'");
		top.close();
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}

	
	
	function getRegionCode(){
	    var sEntInfoValue=setObjectValue("SelectCarContract","","@ArtificialNo@1",0,0,"");
	    if(typeof(sEntInfoValue) == "undefined" || sEntInfoValue == ""){
			alert("��ѡ��һ����¼��");
			return;
		}
	    sEntInfoValue=sEntInfoValue.split('@');
	    sSerialNo=sEntInfoValue[0];  
	    sCustomerName=sEntInfoValue[2];           //��ͬ���
	    setItemValue(0,0,"CustomerName",sCustomerName);
	    setItemValue(0,0,"SerialNo",sSerialNo);
	}
	 
	
	//ѡ���Ʒ����ʱ����ʾ��Ӧ���ı���
	function checkType(){
		var sProductId = getItemValue(0,0,"ProductId");
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sIdentityId   = getItemValue(0,0,"CertID");
		
		
		if(sProductId=="020" && sCustomerName =="" && sIdentityId ==""){
		   alert("����д�ͻ����Ƽ����֤�ţ�");  	
		}

		if(sProductId=="020" && sCustomerName !="" && sIdentityId !=""){//����ǡ�ԤԼ�ֽ���� ��֤�ͻ���Ϣ
		   //��ѯԤԼ�ֽ��׼��ͻ�����
		   ssReturn = RunMethod("BusinessManage","CustomerNameInfo",sCustomerName+","+sIdentityId);
		   //alert("------------------"+ssReturn);
		   if(ssReturn == "Null"){
			   alert("�ͻ�δ��ԤԼ�ֽ��׼��ͻ������У�");
			   return;
		   }
		}
		//��ȡ�ͻ�ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sIdentityId);
		//alert("����ֵ��"+sReturn);
			
	    //���ÿͻ�ID
	    if(sReturn == "Null"){
	    	//��ȡ�ͻ���
			var sSerialNo = getSerialNo("Customer_Info","CustomerID","");
			setItemValue(0,getRow(),"CustomerID",sSerialNo);
	    }else{
	    	//�ѿͻ��ţ����֤������ֻ��
	    	setItemReadOnly(0,0,"CustomerName",true);
	    	setItemReadOnly(0,0,"CertID",true);
	    	//�Ѳ�ѯ�Ŀͻ�ID���õ�CustomerID��
	        setItemValue(0,0,"CustomerID",sReturn);
	    }

	}
	
	//���֤������У��
	function isCardNo()  
	{
		var card = getItemValue(0,getRow(),"CertID");
		//alert("==================="+card);
		
	   // ���֤����Ϊ15λ����18λ��15λʱȫΪ���֣�18λǰ17λΪ���֣����һλ��У��λ������Ϊ���ֻ��ַ�X   
	   var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;  
	   if(reg.test(card) === false)  
	   {  
	      alert("���֤���벻�Ϸ�");  
	       return  false;  
	   }  
	}
	
							
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼	
			//֤������(���֤)
			setItemValue(0,0,"CertType","Ind01");
			//���Ѵ���ͬ��ʶ
			setItemValue(0,0,"CreditAttribute","0002");
			//��ͬ״̬:060�·���
			setItemValue(0,0,"ContractStatus","060");
			
			//�������
			setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
			//������
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
			//��������
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//�Ǽǻ���
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			//�Ǽ���
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			//�Ǽ�����			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//��������
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//�ݴ��־
			setItemValue(0,0,"TempSaveFlag","1");//�Ƿ��־��1���ǣ�2����
			//�ͻ�����Ĭ��Ϊ���˿ͻ�
			setItemValue(0,0,"CustomerType","0310");
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