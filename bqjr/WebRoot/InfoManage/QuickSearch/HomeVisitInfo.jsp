<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�ҷ�Ҫ����Ϣ";
	//�������
	String sSql="",sCustomerName="",sCustomerID="",sArtificialNo="";
	//�����������ѯ�����
	ASResultSet rs = null;
	//���ҳ�������
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null)  sSerialNo="";
	
    sSql="select CustomerID,CustomerName,ArtificialNo from business_contract where serialno =:serialno";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sSerialNo));
    
    if(rs.next()){
   	        sCustomerName = DataConvert.toString(rs.getString("CustomerName"));//�ͻ����
     	    sCustomerID = DataConvert.toString(rs.getString("CustomerID"));//�ͻ����
		   	sArtificialNo = DataConvert.toString(rs.getString("ArtificialNo"));//��ͬ��
   	 
			//����ֵת���ɿ��ַ���
			if(sCustomerName == null) sCustomerName = "";
			if(sCustomerID == null) sCustomerID = "";
			if(sArtificialNo == null) sArtificialNo = "";

    }
    rs.getStatement().close();
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "HomeVisitInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ��","ȷ��","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------

	function saveRecord()
	{
		as_save("myiframe0");
	}
	
	/*~[Describe=��ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getAddCode(){
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"Address",sAddress);//�־�ס��ַ
		setItemValue(0,0,"AddressName",sAddressName);
		setItemValue(0,0,"TownShip",sTownShip);//��/��
		setItemValue(0,0,"Street",sStreet);//�ֵ�
		setItemValue(0,0,"Cell",sCell);//С��/¥��
		setItemValue(0,0,"Room",sRoom);//��/��Ԫ/�����
		
	}
	
	/*~[Describe=�ֻ�����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getTelPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		setItemValue(0,0,"PhoneCode",sPhoneCode);//�ֻ�����
		
	}
	
	
	function initRow()
	{	
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			//��ˮ��
			initSerialNo();

			//��ͬ���
			setItemValue(0,0,"ContractSerialNo","<%=sArtificialNo%>");
			//������
			setItemValue(0,0,"ApplySerialNo","<%=sSerialNo%>");

			//�ͻ���Ϣ
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");

			
            //�Ǽ�����Ϣ
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "home_visit_info";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	</script>

<script language=javascript>	
	AsOne.AsInit();
	//showFilterArea();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
