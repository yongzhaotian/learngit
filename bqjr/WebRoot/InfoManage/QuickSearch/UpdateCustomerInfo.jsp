<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�ͻ���ϵ��ʽ�޸�";
	//���ҳ�������
	String sCustomerID        = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	
	System.out.println("-----"+sCustomerID);

	if(sCustomerID==null)        sCustomerID="";

	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp	
	String sTempletNo = "UpdateCustomerInfo";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()",sResourcesPath}
	};
	%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------

	function saveRecord()
	{
	  if(!ValidityCheck()) return;
	  as_save("myiframe0");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		//3.��������
		var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
		sEmailAdd = getItemValue(0,getRow(),"EmailAdd");
		
		if(!filter.test(sEmailAdd) && (sEmailAdd && sEmailAdd.trim().length>0)){
			alert("���䲻��ȷ��������д!");
			return false;
		}
		
		//2.QQ����
		sQqNo = getItemValue(0,getRow(),"QQNo");//QQ
		if(isNaN(sQqNo)==true){
			alert("QQ�������������!");
			return false;
		}

		return true;
	}
	
	/*~[Describe=������ϵ�˺���ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getOtherlinkTelPhoneCode()
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
		
		if (sPhoneType=='01' || sPhoneType=='�̶��绰' || sPhoneType=='03' || sPhoneType=='�����绰') {// �绰
			sPhoneCode = sZipCode + '-' + sPhoneCode;
			sPhoneCode = (sExtensionNo.length>0)?(sPhoneCode+'-'+sExtensionNo):sPhoneCode;
		}else if (sPhoneType=='02' || sPhoneType=='�ƶ��绰' || sPhoneType=='05' || sPhoneType=='��λ�ƶ��绰' || sPhoneType=='06' || sPhoneType=='��ͥ�ƶ��绰') {//�ƶ��绰
			
		}else if (sPhoneType=='04' || sPhoneType=='������Ϣ') {// ������Ϣ
			sPhoneCode='';
		}
		setItemValue(0,0,"ContactTel",sPhoneCode);//�ֻ�����
		
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
		
		setItemValue(0,0,"MobileTelephone",sPhoneCode);//�ֻ�����
		
	}
	
	/*~[Describe=סլ�绰ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getPhoneCode()
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
		
		sFamilyTel=sZipCode+"-"+sPhoneCode;
		setItemValue(0,0,"FamilyTel",sFamilyTel);//סլ�绰
		
	}
	
	/*~[Describe=�����绰ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getWorkPhoneCode()
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
		
		sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"WorkTel",sWorkTel);//�����绰

	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function getFaxNumber()
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
		
		sWorkTel=sZipCode+"-"+sPhoneCode;
		setItemValue(0,0,"FaxNumber",sWorkTel);//�������

	}
	
	/*~[Describe=������ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
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
		
		setItemValue(0,0,"NativePlace",sAddress);//��ַID
		setItemValue(0,0,"NativePlaceName",sAddressName);//��ַNAME
		setItemValue(0,0,"Villagetown",sTownShip);//��/��
		setItemValue(0,0,"Street",sStreet);//�ֵ�/��
		setItemValue(0,0,"Community",sCell);//С��/¥��
		setItemValue(0,0,"CellNo",sRoom);//��/��Ԫ/�����
	}
	
	/*~[Describe=�־ӵ�ַѡ��;InputParam=��;OutPutParam=��;]~*/
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
		
		setItemValue(0,0,"FamilyAdd",sAddress);//�־�ס��ַ
		setItemValue(0,0,"FamilyAddName",sAddressName);
		setItemValue(0,0,"Countryside",sTownShip);//��/��(�־�)
		setItemValue(0,0,"Villagecenter",sStreet);//�ֵ�/�壨�־ӣ�
		setItemValue(0,0,"Plot",sCell);//С��/¥�̣��־ӣ�
		setItemValue(0,0,"Room",sRoom);//��/��Ԫ/����ţ��־ӣ�
		
	}
	
	/*~[Describe=��λ��ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getCellRegionCode()
	{
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
		
		setItemValue(0,0,"WorkAdd",sAddress);//��ַID
		setItemValue(0,0,"WorkAddName",sAddressName);//��ַNAME
		setItemValue(0,0,"UnitCountryside",sTownShip);//��/��
		setItemValue(0,0,"UnitStreet",sStreet);//�ֵ�/��
		setItemValue(0,0,"UnitRoom",sCell);//С��/¥��
		setItemValue(0,0,"UnitNo",sRoom);//��/��Ԫ/�����
	}	
	

	
	function initRow()
	{	
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			
            //�Ǽ�����Ϣ
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }

	</script>

<script language=javascript>	
	AsOne.AsInit();
	showFilterArea();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
