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
	String PG_TITLE = "��ͬ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sCustomerInfoTemplet = "";//--ģ������
	String sSql = "";//--���sql���
	String sItemAttribute = "" ;
	String sAttribute3 = "";
	ASResultSet rs = null;//-- ��Ž����
	
	//�������������ͻ�����
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	
	//System.out.println("-------aaaaa------------"+sObjectType);
	//System.out.println("--------bbbbb-----------"+sObjectNo);
	System.out.println("--------ccccc-----------"+sCustomerID);
	System.out.println("--------ddddd-----------"+sCustomerType);
	
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null)   sObjectNo = "";
	if(sCustomerID == null)   sCustomerID = "";
	if(sCustomerType == null)   sCustomerType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	    //ȡ����ͼģ������
		if(sCustomerType.equals("03")){ //�������ڸ��˿ͻ���Ϣģ��
			sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
		}
		if(sCustomerType.equals("04")){//�Թ�
			sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
		}
		if (sCustomerType.equals("05")){//��˾
			sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
		}
		
		if(rs.next()){ 
			sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));		//������ҵ�ͻ�������ͼ����		
		    sAttribute3 = DataConvert.toString(rs.getString("Attribute3"));		        //��С��ҵ�ͻ�������ͼ����
		}
		rs.getStatement().close(); 
		
		if(sItemAttribute == null) sItemAttribute = "";	
		if(sAttribute3 == null) sAttribute3 = "";	
	    //��ȡģ����
		sCustomerInfoTemplet = sItemAttribute;
		
	    if(sCustomerInfoTemplet == null) sCustomerInfoTemplet = "";
	    if(sCustomerInfoTemplet.equals(""))
		throw new Exception("�ͻ���Ϣ�����ڻ�ͻ�����δ���ã�"); 
	
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = sCustomerInfoTemplet;
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly="0";

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
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
		as_save("myiframe0");
	}	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/IndManage/CommonBorrowerList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
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
	
	/*~[Describe=�ʼĵ�ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getEmailRegionCode()
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
		
		setItemValue(0,0,"CommAdd",sAddress);//��ַID
		setItemValue(0,0,"CommAddName",sAddressName);//��ַNAME
		setItemValue(0,0,"EmailCountryside",sTownShip);//��/��
		setItemValue(0,0,"EmailStreet",sStreet);//�ֵ�/��
		setItemValue(0,0,"EmailPlot",sCell);//С��/¥��
		setItemValue(0,0,"EmailRoom",sRoom);//��/��Ԫ/�����
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
	
	/*~[Describe=�������ڵ�;InputParam=��;OutPutParam=��;]~*/
	function getRegionCodes()
	{
		var sAreaCode = getItemValue(0,getRow(),"NativePlace");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");

		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"NativePlace","");
			setItemValue(0,getRow(),"NativePlaceName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"NativePlace",sAreaCodeValue);
					setItemValue(0,getRow(),"NativePlaceName",sAreaCodeName);			
			}
		}
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
	
	/*~[Describe=ס�����ڵ�;InputParam=��;OutPutParam=��;]~*/
	function getLiveRoom()
	{
		var sAreaCode = getItemValue(0,getRow(),"LiveRoom");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");

		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"LiveRoom","");
			setItemValue(0,getRow(),"LiveRoomName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"LiveRoom",sAreaCodeValue);
					setItemValue(0,getRow(),"LiveRoomName",sAreaCodeName);			
			}
		}
	}
	
	
	
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
