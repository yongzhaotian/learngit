<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jschen  2010.03.17
		Tester:
		Content: ���Ƕ��ҳ��
		Input Param:
			ObjectType����������
			ApplyType����������
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ҵ�񲹵�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������
	
	//����ֵת���ɿ��ַ���
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CreditLineInputCreationInfo";
	
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
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
			{"true","","Button","ȷ��","ȷ�϶�Ȳ�������","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ����Ȳ�������","doCancel()",sResourcesPath}	
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
		setItemValue(0,0,"ContractFlag","2");//��ռ�ö��
		initSerialNo();
		as_save("myiframe0",sPostEvents);		
	}
		   
    /*~[Describe=ȡ����Ȳ�������;InputParam=��;OutPutParam=ȡ����־;]~*/
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
		var sCustomerID = "";
		sCustomerType = getItemValue(0,0,"CustomerType");
		sCertType = getItemValue(0,0,"CertType");	
		sCertID = getItemValue(0,0,"CertID");	
		sCustomerName = getItemValue(0,0,"CustomerName");	
		sCustomerOrgType = getItemValue(0,0,"OrgNature");	
		//�ж���֯��������Ϸ���
		if(sCertType =='Ent01')
		{			
			if(!CheckORG(sCertID))
			{
				alert(getBusinessMessage('102'));//��֯������������
				setItemFocus(0,0,"CertID");
				return;
			}			
		}
		//�����ͻ�
		sReturnStatus = RunMethod("CustomerManage","CheckCustomerAction",sCustomerType+","+sCustomerName+","+sCertType+","+sCertID+",<%=CurUser.getUserID()%>");	
        //�õ��ͻ���Ϣ������Ϳͻ���
        sReturnStatus = sReturnStatus.split("@");
        sStatus = sReturnStatus[0];
        sCustomerID = sReturnStatus[1];
      	//01Ϊ�ÿͻ������ڱ�ϵͳ��
		if(sStatus == "01")
		{
			sCustomerID = getNewCustomerID();
			
			var sParam = "";
            sParam = sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+"";
            sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
            //Ϊ�˲��ö�ȹ���Աӵ�иÿͻ��Ĺܻ�Ȩ�����������ӿͻ���ɾ�����йܻ�Ȩ
            sDelReturn = PopPageAjax("/CustomerManage/DelCustomerBelongActionAjax.jsp?CustomerID="+sCustomerID+"","","");
            
            if(sStatus == "01"){
                alert("�ͻ��ţ�"+sCustomerID+"�����ɹ�!"); //�����ͻ��ɹ�
            }else{
                alert("�����ͻ�ʧ�ܣ�"); //�����ͻ��ɹ�
                return;
            }
		}
		setItemValue(0,0,"CustomerID",sCustomerID);
		
		saveRecord("doReturn()");
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");		
		top.returnValue = sObjectNo;
		top.close();
	}
		
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{			
		sCustomerType = getItemValue(0,0,"CustomerType");
		sCustomerType = sCustomerType.substr(0,2);
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert("����ѡ��ͻ�����!");
			return;
		}
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType == "02")
			//ѡ���ſͻ�
			setObjectValue("SelectApplyCustomer2",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		else
			//ѡ��˾��ͻ�(����������ҵ�����϶�����С��ҵ)
			setObjectValue("SelectApplyCustomer3",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType(sType)
	{		
		if(sType == "CL") //���Ŷ�ȵ�ҵ��Ʒ��
		{
			sCustomerType = getItemValue(0,0,"CustomerType");
			sCustomerType = sCustomerType.substr(0,2);
			if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
			{
				alert("����ѡ��ͻ�����!");
				return;
			}
			//��01������˾�ͻ�����02�������ſͻ������ѡ����ǹ�˾�ͻ����򵯳����Ŷ��ҵ��Ʒ�֣����ѡ����Ǽ��ſͻ�����Ĭ��Ϊ�������Ŷ��
			if(sCustomerType=="01")
				setObjectValue("SelectCLBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
			if(sCustomerType=="02"){
				//������������ʾ��䣬��ֹ�������飡
				alert("���ſͻ�ֻ�����뼯�����Ŷ�ȣ�");
				return;
			}		
		}
	}
							
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼			
			//��������
			setItemValue(0,0,"OccurType","010");
			//��������
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//��Ʒ����
			setItemValue(0,0,"BusinessType","3010");
			//��Ʒ��������
			//setItemValue(0,0,"BusinessTypeName","��˾�ۺ����Ŷ��");  //commented by yzheng 2013-6-25
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
			//�ͻ�����Ĭ��Ϊ��˾�ͻ�
			setItemValue(0,0,"CustomerType","01");
			//����
			setItemValue(0,0,"BusinessCurrency","01");//�����
			//��������
			setItemValue(0,0,"ApplyType","DependentApply");//��������
			//���Ǳ�־
			setItemValue(0,0,"ReinforceFlag","110");//δ������ɵ����Ŷ��
			//�ܻ�����
			setItemValue(0,0,"ManageOrgID","<%=CurUser.getOrgID()%>");//�ܻ�����
			//�ܻ���
			setItemValue(0,0,"ManageUserID","<%=CurUser.getUserID()%>");//�ܻ���
			//�����־
			setItemValue(0,0,"FreezeFlag","1");//����
			//�Ŵ�����
			setItemValue(0,0,"PutOutOrgID","<%=CurUser.getOrgID()%>");//�Ŵ�����
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

	/*~[Describe=�����Ϣ;InputParam=��;OutPutParam=������ˮ��;]~*/
	function clearData(){
		var sCustomerType = getItemValue(0,0,"CustomerType");
		sCustomerType = sCustomerType.substr(0,2);
		if(sCustomerType=="01")
		{
			//����ͻ�����Ϊ��˾�ͻ�����Ĭ��Ϊ�ۺ����Ŷ�ȣ�����Ϊ3010
			setItemValue(0,0,"BusinessType","3010");
			setItemValue(0,0,"BusinessTypeName","�ڲ����Ŷ��");
		}else if(sCustomerType=="02")
		{
			//����ͻ�����Ϊ���ſͻ�����Ĭ��Ϊ�������Ŷ�ȣ�����Ϊ3020
			setItemValue(0,0,"BusinessType","3020");
			setItemValue(0,0,"BusinessTypeName","�������Ŷ��");
		}else{
			setItemValue(0,0,"BusinessTypeName","");
			setItemValue(0,0,"BusinessType","");
		}
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
	}

    /*~[Describe=�����¿ͻ�ID;InputParam=��;OutPutParam=��;]~*/
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


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>