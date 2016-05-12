<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong  2004.12.16
		Tester:
		Content: ��ծ�ʲ����䶯̨��
		���䶯���ͣ�����ͳ��ۣ�BalanceChangeType
		�ʲ������ʲ����y=�ʲ����е�����a-�䶯���б䶯���b.
		���ʽ�����b>0;otherwise b<0.
		Input Param:
			  ObjectNo�������ţ���ծ�ʲ���ˮ�ţ�
			  ObjectType���������ͣ�ASSET_INFO��
			  SerialNo:	�䶯��¼��
		Output param:
		
		History Log: zywei 2005/09/07 �ؼ����
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ����䶯����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	
	//����������
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));  //�ʲ���ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));//asset_info
	if(sObjectNo == null ) sObjectNo = "";
	if(sObjectType == null ) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));			//�䶯��¼��ˮ��
	if(sSerialNo == null ) sSerialNo = "";//��ʾ����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo ="PDABalanceChangeInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//�õ����ʲ��ı���/��/δ�����־,�Ѿ�����ʾ���	
	String mySql = " select Flag from ASSET_INFO where  SerialNo =:SerialNo ";
	String myFlag = Sqlca.getString(new SqlObject(mySql).setParameter("SerialNo",sObjectNo));
	if(myFlag == null) myFlag = ""; 
	if(myFlag.equals("")) myFlag = "010";  //ȱʡ���� 		

	//���ݱ���/����/δ�����־,���������ʾAssetBalance,EnterValue�ֶ�.α�ֶ�,���ɸ���,��ʾ��.

	if (myFlag.equals("010")) //����
	{
		doTemp.setVisible("AssetBalanceOutTable,EnterValueOutTable",false);		
		doTemp.setVisible("AssetBalanceInTable,EnterValueInTable",true);		
	}
	if (myFlag.equals("020"))  //����
	{
		doTemp.setVisible("AssetBalanceOutTable,EnterValueOutTable",true);		
		doTemp.setVisible("AssetBalanceInTable,EnterValueInTable",false);		
	}

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
			{"true","","Button","����","���ص��ϼ�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var OldValue = "0.00";//ȱʡԭ���ı䶯ֵΪ0:���������.
	var OldChangeType = "000";//ȱʡԭ�䶯����ȷǼ���Ҳ������:���������.
	var NewValue = "0.00";
	var NewChangeType = "000";

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=��������¼�;InputParam=��;OutPutParam=��;]~*/
	function myafterSave()
	{
		OldValue = NewValue;
		OldChangeType = NewChangeType;	
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var TempValue;
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}	
		beforeUpdate();

		NewValue = getItemValue(0,getRow(),"ChangeSum");  //�õ��޸�֮���ֵ.
		NewChangeType = getItemValue(0,getRow(),"ChangeType");//�õ��޸�֮��䶯����

		//���������Ҫ�䶯��ֵ:�з���!!!
		if ((OldChangeType == NewChangeType) || (OldChangeType == "000"))  //������������߷���û�б仯.
		{
			TempValue = parseFloat(NewValue)-parseFloat(OldValue);
		}else  //�쿴�������޸�,���ұ䶯�������仯.
		{
			TempValue=parseFloat(NewValue)+parseFloat(OldValue);
		}

		//�޸ĵ�ծ�ʲ���ĵ�ծ���.
		var sObjectNo = "<%=sObjectNo%>";//��ծ�ʲ����
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeActionAjax.jsp?SerialNo="+sObjectNo+"&Interval_Value="+TempValue+"&ChangeType="+NewChangeType,"","");

		//���ر䶯֮����������޸Ľ������ʾ����
		var myFlag = "<%=myFlag%>";
		if (myFlag == "010") 
			setItemValue(0,0,"AssetBalanceInTable",sReturn)
		else
			setItemValue(0,0,"AssetBalanceOutTable",sReturn);

		//�����ݱ���֮��,�����Ŀǰ�ı䶯���ͺͱ䶯ֵ��Ϊ����ֵ,�Է��ٴα���!!!
		//����ڱ���֮ǰ�����������,��ô�������ʧ��,�ٴα����ᷢ�������ϵĴ���.		
		as_save("myiframe0","myafterSave()");	
	}
	
	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeList.jsp","right");
	}

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

	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;			

			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"ChangeSum","0.00");	
			setItemValue(0,0,"ChangeType","010");	
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			OldValue = "0.00";//ȱʡԭ���ı䶯ֵΪ0:���������.
			OldChangeType = "000";//ȱʡԭ�䶯����ȷǼ���Ҳ������:���������.
		}else
		{//����ǲ쿴����,����뱣��ԭ�еı䶯ֵ,�Ա�����޸�֮���ʵ�ʱ䶯ֵ.
			OldValue = getItemValue(0,getRow(),"ChangeSum");  
			OldChangeType = getItemValue(0,getRow(),"ChangeType");  
		}
		
		var myFlag = "<%=myFlag%>";
		var sColName = "AssetName@AssetNo@EnterValue@AssetBalance@OutInitBalance@OutNowBalance"+"~";
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
					//�����ʲ����
					if(sReturnInfo[n] == "assetno")
						setItemValue(0,getRow(),"AssetNo",sReturnInfo[n+1]);
					if(myFlag == "010")
					{
						if(sReturnInfo[n] == "entervalue")
							setItemValue(0,getRow(),"EnterValueInTable",sReturnInfo[n+1]);
						if(sReturnInfo[n] == "assetbalance")
							setItemValue(0,getRow(),"AssetBalanceInTable",sReturnInfo[n+1]);
					}else	
					{
						if(sReturnInfo[n] == "outinitbalance")
							setItemValue(0,getRow(),"EnterValueOutTable",sReturnInfo[n+1]);
						if(sReturnInfo[n] == "outnowbalance")
							setItemValue(0,getRow(),"AssetBalanceOutTable",sReturnInfo[n+1]);
					}				
				}
			}			
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSET_BALANCE";//����
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