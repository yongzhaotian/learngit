<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   fsgong  2004.12.05
		Content: ��ծ�ʲ�����̨������PDADisposalBookInfo.jsp
		Input Param:
			        ObjectType:��������Asset_Info
			        ObjectNo:��ծ�ʲ���ˮ��
			        SerialNo:���ü�¼��ˮ��					
			        DispositonType�����÷�ʽ
		Output param:		
		History Log: zywei 2005/09/07 �ؼ����
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�����̨������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "";
	
	//����������
	
	//���ҳ�������������ˮ�š��������͡������š��������ͣ�
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sDispositionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DispositionType"));//�����޷���λģ��
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null ) sSerialNo = "";//������¼
	if(sDispositionType == null ) sDispositionType = "";
	if(sObjectNo == null ) sObjectNo = "";
	if(sObjectType == null ) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	if(sDispositionType.equals("01"))
		sTempletNo="PDALeaseInfo"; //����
	if(sDispositionType.equals("02"))
		sTempletNo="PDASaleInfo"; //���� 
	if(sDispositionType.equals("03"))
		sTempletNo="PDATransferInfo"; //ת��
	if(sDispositionType.equals("04"))
		sTempletNo="PDAReplaceInfo"; //����
	if(sDispositionType.equals("05"))
		sTempletNo="PDASelfOwnInfo"; //����
	if(sDispositionType.equals("06"))
		sTempletNo="PDAOtherDispositionInfo"; //��������

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//�����Զ� �����ֶΣ�������֮�⣡��Ϊ���ò����ڴ��þ���������⡣
	if (sTempletNo.equals("PDALeaseInfo") || sTempletNo.equals("PDASaleInfo") || sTempletNo.equals("PDATransferInfo") || sTempletNo.equals("PDAReplaceInfo") || sTempletNo.equals("PDAOtherDispositionInfo"))	
		doTemp.appendHTMLStyle("DispositionSum,DispositionCharge"," onChange=\"javascript:parent.getCashNetSum()\" ");
	if (sTempletNo.equals("PDAOtherDispositionInfo"))
		doTemp.appendHTMLStyle("DispositionPrice,DispositionAmount"," onChange=\"javascript:parent.getAssetSum()\" ");

	//������ݴ��÷�ʽ,�����Ƿ���ʾ���۷�ʽ
	if (sDispositionType.equals("02") ) //����
	{//���ó��۷�ʽ,���������ɼ�
		doTemp.setVisible("SaleStyle,AuctionOrg",true);		
	}

	//�õ����ʲ��ı���/��/δ�����־,�Ѿ�����ʾ���	
	String mySql = " select Flag from ASSET_INFO where  SerialNo =:SerialNo ";
	String myFlag = Sqlca.getString(new SqlObject(mySql).setParameter("SerialNo",sObjectNo));
	if(myFlag == null) myFlag = ""; 
	if(myFlag.equals("")) myFlag = "010";  //ȱʡ����
	
	//���ݱ���/����/δ�����־,���������ʾAssetSumInTable,AssetSumOutTable�ֶ�.
	doTemp.setUpdateable("AssetSumInTable,AssetSumOutTable",false); 
	doTemp.setVisible("AssetSumInTable,AssetSumOutTable",false);		

	if (myFlag.equals("010")) //����
	{
		doTemp.setVisible("AssetSumInTable",true);		
		doTemp.setUpdateable("AssetSumInTable",true); 
	}
	if (myFlag.equals("020"))  //����
	{
		doTemp.setVisible("AssetSumOutTable",true);		
		doTemp.setUpdateable("AssetSumOutTable",true); 
	}

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+','+sObjectNo+','+sSerialNo);
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
				{"true","","Button","����","���������޸�","goBack()",sResourcesPath}
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
		sDispositionType = "<%=sDispositionType%>";
	
		//����ǳ�����Ϊ����,��ô������������Ϊ��!���ڼܹ�������,�޷���ģ��������.
		if 	(sDispositionType=="02")
		{
			var sSaleStyle=getItemValue(0,0,"SaleStyle");		
			if ((sSaleStyle.trim()=="")||(sSaleStyle==null))
			{
				alert("������÷�ʽΪ�ʲ����ۣ���ô���۷�ʽΪ������!");
				return;
			}else
			{
				if (sSaleStyle=="01")
				{
					var sAuctionOrg=getItemValue(0,0,"AuctionOrg");
					if ((sAuctionOrg==null)||(sAuctionOrg.trim()==""))
					{
						alert("������۷�ʽΪ��������ô��������Ϊ������!");
						return;
					}
				}
			}
		}
	
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

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=���þ����루��������-���÷��ã�;InputParam=��;OutPutParam=��;]~*/
    function getCashNetSum()
	{
		sDispositionSum = getItemValue(0,getRow(),"DispositionSum");
		sDispositionCharge = getItemValue(0,getRow(),"DispositionCharge");
	
		if(typeof(sDispositionSum) == "undefined" || sDispositionSum.length == 0) sDispositionSum = 0; 
		if(typeof(sDispositionCharge) == "undefined" || sDispositionCharge.length == 0) sDispositionCharge = 0; 
	
		sCashNetSum = sDispositionSum - sDispositionCharge;
	    setItemValue(0,getRow(),"CashNetSum",sCashNetSum);
	}
	
	/*~[Describe=ʵ�ʳɽ���ʵ�ʳɽ�����*ʵ�ʳɽ�������;InputParam=��;OutPutParam=��;]~*/
	function getAssetSum()
     { 
		sDispositionPrice = getItemValue(0,getRow(),"DispositionPrice");
		sDispositionAmount = getItemValue(0,getRow(),"DispositionAmount");
	       
		if(typeof(sDispositionPrice) == "undefined" || sDispositionPrice.length == 0) sDispositionPrice = 0; 
		if(typeof(sDispositionAmount) == "undefined" || sDispositionAmount.length == 0) sDispositionAmount = 0;
		sDispositonSum = sDispositionPrice * sDispositionAmount;

		setItemValue(0,getRow(),"AssetSum",sDispositonSum);
     }
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;	
				
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"DispositionType","<%=sDispositionType%>");
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");			
			setItemValue(0,0,"OperateUserName","<%=CurUser.getUserName()%>");			
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"ManageUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ManageUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"ManageOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"ManageOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"DispositionSum","0");
			setItemValue(0,0,"DispositionAmount","0");
			setItemValue(0,0,"DispositionPrice","0");
			setItemValue(0,0,"DispositionCharge","0");
			setItemValue(0,0,"CashNetSum","0");
		}
		
		var sColName = "AssetName"+"~";
		var sTableName = "ASSET_INFO"+"~";
		var sWhereClause = "String@ObjectNo@"+"<%=sObjectNo%>"+"@String@ObjectType@AssetInfo"+"~";
		
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

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		var sDispositionType = "<%=sDispositionType%>";
		if(sDispositionType == "01") //��ծ�ʲ�����̨���б�
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDALeaseBookList.jsp","right","");
		else //��ծ�ʲ�����̨���б�
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookList.jsp","right","");
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSET_DISPOSITION";//����
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