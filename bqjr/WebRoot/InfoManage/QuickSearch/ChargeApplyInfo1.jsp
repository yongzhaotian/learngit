<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�����˺ű������";
	//�������
	String sSql="",sCustomerName="",sCertID="",sMobileTelephone="",sReplaceName="",sReplaceAccount="",sOpenBank="",sArtificialNo="";
	String sOldCityName="",sOldCity="";
	//�����������ѯ�����
	ASResultSet rs = null;
	//���ҳ�������
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null)  sSerialNo="";
	%>
	<%/*~END~*/%>
	
	<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ChargeApplyInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setLimit("NewAccount",18); //�޶����ŵ�¼�볤��
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="0";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//{"true","","Button","ȷ�ϱ��","ȷ�ϱ��","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------

	function saveRecord()
	{
		//��ȡ�����Ŀ����������ۿ��˻��š�������
		ContractSerialno = getItemValue(0,getRow(),"ContractSerialNo");
		NewAccountName = getItemValue(0,getRow(),"NewAccountName");
		CustomerID = getItemValue(0,getRow(),"CustomerID");
		NewBankName = getItemValue(0,getRow(),"NewBankName");
		AccountIndicator = "01";//�ۿ�
		NewAccount = getItemValue(0,getRow(),"NewAccount");
		NewCity = getItemValue(0,getRow(),"NewCity");		
		NewRePaymentWay = getItemValue(0,getRow(),"NEWREPAYMENTWAY");//�µĻ��ʽ1������ 2���Ǵ���
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	
		if (!(typeof(NewAccountName) == "undefined" || NewAccountName != ""|| typeof(NewBankName) == "undefined" || NewBankName != ""
		|| typeof(NewAccount) == "undefined" || NewAccount != ""))
		{
			alert("������������Ϣ��");
			return;
		}
		//����ͻ���Ϣ������ͻ������к�ͬ�� ���ʽ(����/�Ǵ���);
		sReturnValue = RunMethod("CustomerManage","UpdateReplaceAccount", AccountIndicator+","+ContractSerialno+","+CustomerID+","+NewAccountName+","+NewBankName+","+NewAccount+","+NewCity+","+NewRePaymentWay);
	 	 if(sReturnValue=="Success") {
			alert("��������˻���Ϣ�ɹ�!");
		}else{
			alert("��������˻���Ϣʧ��!");
			return;
		}
		as_save("myiframe0");
	}
	
	/*~[Describe=����ʡ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getCityName()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"NewCity","");
			setItemValue(0,getRow(),"NewCityName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"NewCity",sAreaCodeValue);
					setItemValue(0,getRow(),"NewCityName",sAreaCodeName);			
			}
		}
	}
	
	
	function initRow()
	{	
		var sOpenBank=RunMethod("���÷���","GetColValue","code_library,itemName,itemNo='<%=sOpenBank%>'");
		if(sOpenBank=="Null") {sOpenBank="";}
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
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "WITHHOLD_CHARGE_INFO";//����
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
