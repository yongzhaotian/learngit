<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong  2004.12.09
		Tester:
		Content: ��ծ�ʲ���ֵ��������
		Input Param:
			        ObjectNo�������ţ�����������룩
			        ObjectType���������ͣ�����������룩
			        SerialNo����ծ�ʲ���ֵ������ˮ��	��ҳ��������룩					
		Output param:
		
		History Log: zywei 2005/09/06 �ؼ����
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ���ֵ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));  //�ʲ���ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//��ȡ��ͬ�ս�����
    String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null ) sObjectNo = "";
	if(sObjectType == null ) sObjectType = "";
	if(sAssetStatus ==  null) sAssetStatus = "";
	if(sFinishType == null) sFinishType = "";
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));			//������¼��ˮ��
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo ="PDAEvaluateInfo";

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
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
			{sAssetStatus.equals("04")?"false":(sFinishType.equals("")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
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

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);					
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateList.jsp","right");
	}


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
			setItemValue(0,0,"LossesSum","0");
			setItemValue(0,0,"IntoCashSum","0");
			setItemValue(0,0,"EvaluateRate","0");
			setItemValue(0,0,"EvaluateSum","0");
			setItemValue(0,0,"EvaluateCost","0");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");							
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
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
					if(my_array2[n] == "assetname" && sReturnInfo[n+1]!="null")//@jlwu��û�������ʲ�����ʱ�������null
					{
						setItemValue(0,getRow(),"AssetName",sReturnInfo[n+1]);
						break;
					}else if(my_array2[n] == "assetname" && sReturnInfo[n+1]=="null")
					{
						setItemValue(0,getRow(),"AssetName"," ");
						break;
					}				
				}
			}			
		}		
    }
	

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Evaluate_Info";//����
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