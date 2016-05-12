<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong  2004.12.09
		Tester:
		Content: ��ծ�ʲ�������ͬ��ϸ��Ϣ_info
		Input Param:
		Content: ��ծ�ʲ�������ͬ��ϸ��ϢPDABasicInfo.jsp
		Input Param:
			        SerialNo:��ծ�ʲ���ˮ��
			        ContractSerialNo����ͬ��ˮ��						
		Output param:
		
		History Log: 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�������ͬ��ϸ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";		
	String sCustomerName = "";//�ͻ�����
	String sBusinessCurrency = "";//����
	String sBusinessSum = "";//��ͬ���
	String sBalance = "";//��ͬ���
	String sBusinessType = "";//ҵ��Ʒ��
	ASResultSet rs = null;
	
	//����������
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo"));			
	if(sSerialNo == null ) sSerialNo = "";
	if(sContractSerialNo == null ) sContractSerialNo = "";
	if(sAssetStatus == null ) sAssetStatus = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	//��ú�ͬ�����Ϣ	
	sSql = 	" select CustomerName,BusinessSum,getBusinessName(BusinessType) as BusinessTypeName, "+
			" Balance,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName "+
			" from BUSINESS_CONTRACT "+
			" where SerialNo=:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sContractSerialNo));
	if (rs.next()){
		sBusinessType = rs.getString("BusinessTypeName");	
		sCustomerName = rs.getString("CustomerName");	
		sBusinessCurrency = rs.getString("BusinessCurrencyname");			
		sBusinessSum = rs.getString("BusinessSum");		
	  	sBalance=rs.getString("Balance");			
	  	if (sBusinessType == null)  sBusinessType = "";	
	  	if (sCustomerName == null)  sCustomerName = "";	
	  	if (sBusinessCurrency == null)  sBusinessCurrency = "";	
	  	if ((sBusinessSum == null) || (sBusinessSum.equals(""))) sBusinessSum="0.00";	
		if ((sBalance == null) || (sBalance.equals(""))) sBalance="0.00";
	}
	rs.getStatement().close(); 
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo ="PDAAssetContract";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+','+sContractSerialNo);
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
			{sAssetStatus.equals("04")?"false":"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","���ص�����ҳ��","goBack()",sResourcesPath}
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
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0");		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function goBack()
	{
		top.close();
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			
			sSerialNo="<%=sSerialNo%>";
			sContractSerialNo="<%=sContractSerialNo%>";
			setItemValue(0,0,"ContractSerialNo",sContractSerialNo);
			setItemValue(0,0,"SerialNo",sSerialNo);
			//setItemValue(0,0,"ContractNo",sContractSerialNo);
			setItemValue(0,0,"IndebtSum","0.00");
			setItemValue(0,0,"Principal","0.00");
			setItemValue(0,0,"IndebtInterest","0.00");
			setItemValue(0,0,"OutdebtInterest","0.00");
			setItemValue(0,0,"OtherInterest","0.00");
			setItemValue(0,0,"UnDisposalSum","0.00");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");		
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		};
		setItemValue(0,0,"BusinessType","<%=sBusinessType%>");
		setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
		setItemValue(0,0,"BusinessCurrency","<%=sBusinessCurrency%>");
		setItemValue(0,0,"BusinessSum","<%=sBusinessSum%>");
		setItemValue(0,0,"Balance","<%=sBalance%>");
		
		var sColName = "AssetName"+"~";
		var sTableName = "ASSET_INFO"+"~";
		var sWhereClause = "String@SerialNo@"+<%=sSerialNo%>+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array1[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array1.length;j++)
			{
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(m = 0;m < sReturnInfo.length;m++)
				{
					my_array2[m] = sReturnInfo[m];
				}
				
				for(n = 0;n < my_array2.length;n++)
				{									
					//�����ʲ�����
					if(my_array2[n] == "assetname")
						setItemValue(0,getRow(),"AssetName",sReturnInfo[n+1]);					
				}
			}			
		}		
    }

	/*~[Describe=�����ͬ���������ϼƻ��;InputParam=��;OutPutParam=��;]~*/
    function getSum()
    {
 		fPrincipal = getItemValue(0,getRow(),"Principal");
 		fIndebtInterest = getItemValue(0,getRow(),"IndebtInterest");
 		fOutdebtInterest = getItemValue(0,getRow(),"OutdebtInterest");
 		fOtherInterest = getItemValue(0,getRow(),"OtherInterest");
     		
 		if(typeof(fPrincipal)=="undefined" || fPrincipal.length==0) fPrincipal=0; 
 		if(typeof(fIndebtInterest)=="undefined" || fIndebtInterest.length==0) fIndebtInterest=0; 
 		if(typeof(fOutdebtInterest)=="undefined" || fOutdebtInterest.length==0) fOutdebtInterest=0; 
 		if(typeof(fOtherInterest)=="undefined" || fOtherInterest.length==0) fOtherInterest=0; 
     		
 		fSum = fPrincipal+fIndebtInterest+fOutdebtInterest+fOtherInterest;
        setItemValue(0,getRow(),"IndebtSum",fSum);
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

