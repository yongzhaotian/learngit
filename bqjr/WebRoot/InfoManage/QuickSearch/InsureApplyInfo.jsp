<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "���ս�������Ϣ";
	//�������
	String sSql="",sCustomerName="",sArtificialNo="",sCustomerID="",sCertID="";
	//�����������ѯ�����
	ASResultSet rs = null;
	//���ҳ�������
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null)   sSerialNo="";
	
    sSql="select CustomerID,CertID,CustomerName,ArtificialNo from Business_Contract where SerialNo =:serialno";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sSerialNo));
    
    if(rs.next()){
   	    sCustomerName = DataConvert.toString(rs.getString("CustomerName"));//�ͻ�����
   	    sCustomerID = DataConvert.toString(rs.getString("CustomerID"));//�ͻ����
   	    sCertID = DataConvert.toString(rs.getString("CertID"));//֤����
   	    sArtificialNo = DataConvert.toString(rs.getString("ArtificialNo"));//��ͬ���
		//����ֵת���ɿ��ַ���
		if(sCustomerName == null) sCustomerName = "";
		if(sArtificialNo == null) sArtificialNo = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sCertID == null) sCertID = "";

    }
    rs.getStatement().close();
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "InsureApplyInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","���ս�����","���ս�����","saveRecord()",sResourcesPath}
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
	

	function initRow()
	{	
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			//��ˮ��
			initSerialNo();
			//�������ͣ�ApplicationType�����ս����룺04��
			setItemValue(0,0,"ApplicationType","04");
			//����״̬
			setItemValue(0,0,"Status","01");
			//��ͬ���
			setItemValue(0,0,"ContractSerialNo","<%=sArtificialNo%>");
			//������
			setItemValue(0,0,"ApplySerialNo","<%=sSerialNo%>");
			
			//�ͻ���Ϣ
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CertID","<%=sCertID%>");

            //�Ǽ�����Ϣ
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");

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
