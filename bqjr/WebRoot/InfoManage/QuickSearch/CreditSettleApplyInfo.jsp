<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�������֤��������Ϣ";
	//�������
	String sSql="",sCustomerName="",sContractStatus="",sContractStatusName="",sMobileTelephone="",sReplaceName="",sReplaceAccount="",sOpenBank="",sArtificialNo="";
	//�����������ѯ�����
	ASResultSet rs = null;
	//���ҳ�������
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null)  sSerialNo="";
	
    sSql="select getItemName('ContractStatus',ContractStatus) as ContractStatusName from Business_Contract bc where bc.serialno =:serialno";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sSerialNo));
    if(rs.next()){
   	       
		   	sContractStatusName = DataConvert.toString(rs.getString("ContractStatusName"));//��ͬ״̬
   	 
			//����ֵת���ɿ��ַ���
			if(sContractStatusName == null) sContractStatusName = "";		
			
    }
    rs.getStatement().close();
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CreditSettleApplyInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ���ύ","ȷ���ύ","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------

	function saveRecord()
	{
		//��ͬ������
		ContractSerialno = "<%=sSerialNo%>";
		//��ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sCotractStatus = getItemValue(0,getRow(),"ContractStatus");
		sIsScan = getItemValue(0,getRow(),"IsScan");
	
	 	if (!(typeof(sIsScan) == "undefined" || sIsScan != ""))
		{
			alert("�������Ƿ�ɨ�裡");
			return;
		} 

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
 			//��ͬ������
			setItemValue(0,0,"ApplySerialNo","<%=sSerialNo%>");
			setItemValue(0,0,"ContractStatus","<%=sContractStatusName%>");

		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "WITHHOLD_SETTLE_INFO";//����
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
