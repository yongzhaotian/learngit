<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�����ձ��";
	//�������
		String sSql="",sCustomerID="",sCarNumber="",sRepaymentWay="",sCustomerName="",sRepaymentNo="";
		//�����������ѯ�����
		ASResultSet rs = null;
		//���ҳ�������
		String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
		if(sSerialNo==null)  sSerialNo="";
		
	    sSql="select CustomerID,CustomerName,CarNumber,RepaymentWay,RepaymentNo from business_contract  where serialno =:serialno";
	    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sSerialNo));
	    if(rs.next()){
	    		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));//�ͻ����
	    		sCarNumber = DataConvert.toString(rs.getString("CarNumber"));//���ƺ���
	    		sRepaymentWay = DataConvert.toString(rs.getString("RepaymentWay"));//���ʽ
	    		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
	    		sRepaymentNo = DataConvert.toString(rs.getString("RepaymentNo"));

	   	 
				//����ֵת���ɿ��ַ���
				if(sCustomerID == null) sCustomerID = "";
				if(sCarNumber == null) sCarNumber = "";
				if(sRepaymentWay == null) sRepaymentWay = "";
				if(sCustomerName == null) sCustomerName = "";
				if(sRepaymentNo == null) sRepaymentNo = "";
	    }
	    rs.getStatement().close();
		
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RepaymentChangeInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ�ϱ��","ȷ�ϱ��","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------

	function saveRecord()
	{
		if(!vI_all("myiframe0")) return;
		as_save("myiframe0","");
	}
	
	function initRow()
	{	
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			//��ˮ��
			initSerialNo();
			setItemValue(0,0,"PutoutNo","<%=sSerialNo%>");
			
			setItemValue(0,0,"RepaymentFlag","<%=sRepaymentNo%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"CarNumber","<%=sCarNumber%>");
			setItemValue(0,0,"OldRepaymentWay","<%=sRepaymentWay%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "CONTRACT_REPAYMENT_CHANGE";//����
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
