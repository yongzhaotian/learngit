<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-07
		Tester:
		Describe: ���շ����϶���Ϣ;
		Input Param:
			SerialNo��������ˮ��
			ObjectNo�������ţ���ͬ��ˮ��/�����ˮ�ţ�
			ObjectType���������ͣ�BusinessContract������ͬ���ࣻBusinessDueBill������ݷ��ࣩ
			ClassifyType���������ͣ�010�����϶��ķ��ࣻ020�����϶���ɵķ��ࣩ
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʲ����շ����϶�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������:��ʾģ���š��״η����ա�Sql��䡢��ѯ�����
	String sTempletNo = "";	
	String sOrgLevel = CurOrg.getOrgLevel();//��������0�����У�3�����У�6��֧�У�9�����㣩
		
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sClassifyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassifyType"));

	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sClassifyType == null) sClassifyType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//����ֵת��Ϊ���ַ���
	if(sOrgLevel == null) sOrgLevel = "";
	//����ɷ������ʾģ����
	if(sClassifyType.equals("010"))
	{
		//�����ͷ�ļ�
		if(sObjectType.equals("BusinessContract")) //����ͬ����
		{
			if(sOrgLevel.equals("0")) //����
				sTempletNo = "HeadClassifyInfo1";
			if(sOrgLevel.equals("3")) //����
				sTempletNo = "BranchClassifyInfo1";
			if(sOrgLevel.equals("6")) //֧��
				sTempletNo = "SubbranchClassifyInfo1";
		}	
		if(sObjectType.equals("BusinessDueBill")) //����ݷ���
		{
			if(sOrgLevel.equals("0")) //����
				sTempletNo = "HeadClassifyInfo2";
			if(sOrgLevel.equals("3")) //����
				sTempletNo = "BranchClassifyInfo2";
			if(sOrgLevel.equals("6")) //֧��
				sTempletNo = "SubbranchClassifyInfo2";
		}
	}
	
	//����ɷ������ʾģ����
	if(sClassifyType.equals("020"))
	{
		if(sObjectType.equals("BusinessContract"))
			sTempletNo = "ViewClassifyInfo1";
		if(sObjectType.equals("BusinessDueBill"))
			sTempletNo = "ViewClassifyInfo2";
	}
	//ͨ����ʾģ�����ASDataObject����doTemp
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//��������¼�
	if(sObjectType.equals("BusinessContract")) //����ͬ����
		dwTemp.setEvent("AfterUpdate","!�弶����.���º�ͬ������Ϣ(#OBJECTNO,#FinallyResult,#OriginalPutOutDate,#AccountMonth,#ClassifyLevel,#SUM1,#SUM2,#SUM3,#SUM4,#SUM5)");
	if(sObjectType.equals("BusinessDueBill")) //����ݷ���
		dwTemp.setEvent("AfterUpdate","!�弶����.���º�ͬ������Ϣ(#OBJECTNO,#FinallyResult,null,#AccountMonth,#ClassifyLevel,#SUM1,#SUM2,#SUM3,#SUM4,#SUM5)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo + "," + sObjectNo + "," + sObjectType);
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
		{(sClassifyType.equals("010")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},		
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
	function saveRecord(sPostEvents)
	{
		var sObjectType = "<%=sObjectType%>";
		if(sObjectType == "BusinessContract")
		{
			sSum1 = getItemValue(0,getRow(),"SUM1");			
			sSum2 = getItemValue(0,getRow(),"SUM2");			
			sSum3 = getItemValue(0,getRow(),"SUM3");			
			sSum4 = getItemValue(0,getRow(),"SUM4");			
			sSum5 = getItemValue(0,getRow(),"SUM5");
			
			sBusinessBalance = getItemValue(0,getRow(),"Balance");			
			sSum1 = sSum1 + sSum2 + sSum3 + sSum4 + sSum5;
			
			if(sSum1 != sBusinessBalance)
			{
				alert(getBusinessMessage('662'));//��ǰ�϶����֮�����ͬ��ǰ����ȣ�������϶���
				return;
			}			
		}else
		{			
			setSum();
		}   
    
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~���ݲ�ͬ���弶���������벻ͬ��ֵ~*/
	function setSum()
	{
		var sOrgLevel = "<%=sOrgLevel%>";
		var sClassifyResult = "";
		var sBusinessSum = getItemValue(0,getRow(),"Balance");
		
    	if(sOrgLevel == "0")
    		sClassifyResult = getItemValue(0,getRow(),"RESULT5");
    	if(sOrgLevel == "3")
    		sClassifyResult = getItemValue(0,getRow(),"RESULT3");
    	if(sOrgLevel == "6")
    		sClassifyResult = getItemValue(0,getRow(),"RESULT2");
    		
        setItemValue(0,getRow(),"SUM1",0);
        setItemValue(0,getRow(),"SUM2",0);
        setItemValue(0,getRow(),"SUM3",0);
        setItemValue(0,getRow(),"SUM4",0);
        setItemValue(0,getRow(),"SUM5",0);
    
		if(sClassifyResult == "01")
		    setItemValue(0,getRow(),"SUM1",sBusinessSum);

		if(sClassifyResult == "02")
		    setItemValue(0,getRow(),"SUM2",sBusinessSum);

		if(sClassifyResult == "03")
		    setItemValue(0,getRow(),"SUM3",sBusinessSum);

		if(sClassifyResult == "04")
		    setItemValue(0,getRow(),"SUM4",sBusinessSum);

		if(sClassifyResult == "05")
		    setItemValue(0,getRow(),"SUM5",sBusinessSum);
	}
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{		
		OpenPage("/CreditManage/CreditCheck/ClassifyCognList.jsp","_self","");		
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">


	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		var sOrgLevel = "<%=sOrgLevel%>";
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
				
       	if(sOrgLevel == "0")
    	{
    		sClassifyResult = getItemValue(0,getRow(),"RESULT5");
    		setItemValue(0,0,"FinallyResult",sClassifyResult);
			setItemValue(0,0,"ClassifyLevel","0");			
    	}
		if(sOrgLevel == "3")
    	{
    		sClassifyResult = getItemValue(0,getRow(),"RESULT3");
    		setItemValue(0,0,"FinallyResult",sClassifyResult);
			setItemValue(0,0,"ClassifyLevel","3");			
    	}
    	if(sOrgLevel == "6")
    	{
    		sClassifyResult = getItemValue(0,getRow(),"RESULT2");
    		setItemValue(0,0,"FinallyResult",sClassifyResult);
			setItemValue(0,0,"ClassifyLevel","6");						
    	} 	
	}

	function initRow()
	{
       	var sOrgLevel = "<%=sOrgLevel%>";
       	
       	if(sOrgLevel == "0")
    	{
    		setItemValue(0,0,"ResultUserID5","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ResultUserName5","<%=CurUser.getUserName()%>");			
    	}
		if(sOrgLevel == "3")
    	{
    		setItemValue(0,0,"ResultUserID3","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ResultUserName3","<%=CurUser.getUserName()%>");		
    	}
    	if(sOrgLevel == "6")
    	{
    		setItemValue(0,0,"ResultUserID2","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ResultUserName2","<%=CurUser.getUserName()%>");						
    	}        
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

