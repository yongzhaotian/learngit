<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: �ʲ����շ�����Ϣ
		Input Param:
			SerialNo��������ˮ��
			ObjectNo�������ţ���ͬ��ˮ��/�����ˮ�ţ�
			ObjectType���������ͣ�BusinessContract������ͬ���ࣻBusinessDueBill������ݷ��ࣩ
			ClassifyType���������ͣ�010������ɷ��ࣻ020������ɷ��ࣩ			
		Output Param:			

		HistoryLog: zywei 2005/09/09 �ؼ����
				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʲ����շ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������:��ʾģ���š��״η����ա�Sql��䡢��ѯ�����
	String sTempletNo = "";
	String sOriginalPutOutDate = "";
	String sSql = "";
		
	//���ҳ�����
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType")); 
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
	//����ɷ������ʾģ����
	if(sClassifyType.equals("010")){
		if(sObjectType.equals("BusinessDueBill"))
			sTempletNo = "ManagerClassifyInfo2";
	}
	
	//����ɷ������ʾģ����
	if(sClassifyType.equals("020")){
		if(sObjectType.equals("BusinessContract"))
			sTempletNo = "ViewClassifyInfo1";
		if(sObjectType.equals("BusinessDueBill"))
			sTempletNo = "ViewClassifyInfo2";
	}
	//����ǰ���ͬ���з��շ��࣬��ô����״η�����
	if(sObjectType.equals("BusinessContract")){
		sSql = " select min(PUTOUTDATE) from BUSINESS_DUEBILL where RelativeSerialNo2 =:RelativeSerialNo2 ";
		sOriginalPutOutDate = Sqlca.getString(new SqlObject(sSql).setParameter("RelativeSerialNo2",sObjectNo));
		if(sOriginalPutOutDate == null) sOriginalPutOutDate = "";
	}
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
				
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sObjectNo+","+sObjectType);
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
			{(sFinishType.equals("")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
				alert("��ǰ�϶����֮�����ͬ��ǰ����ȣ�������϶���");
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
		
		var sBusinessSum = getItemValue(0,getRow(),"Balance");
		var sClassifyResult = getItemValue(0,getRow(),"RESULT1");
    
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
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPAClassifyList.jsp","_self","");		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");	
		//���ͻ������϶��ķ�������������շ�������	
		sResult1 = getItemValue(0,getRow(),"Result1");		
		setItemValue(0,0,"FinallyResult",sResult1);		
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
  		var sClassifyType = "<%=sClassifyType%>";
  		var sObjectType = "<%=sObjectType%>";
  		
  		if(sClassifyType == "010")
  		{
  			if(sObjectType == "BusinessContract")
  				setItemValue(0,0,"OriginalPutOutDate","<%=sOriginalPutOutDate%>");
  			setItemValue(0,0,"ClassifyUserID","<%=CurUser.getUserID()%>");
  			setItemValue(0,0,"ClassifyUserName","<%=CurUser.getUserName()%>");
  			setItemValue(0,0,"ClassifyOrgID","<%=CurOrg.getOrgID()%>");
  			setItemValue(0,0,"ClassifyOrgName","<%=CurOrg.getOrgName()%>");  			
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

