<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-9
		Tester:
		Content: ��������ֵ׼����������ҳ��
		Input Param:
				 ObjectType����������
				 ObjectNo��������
		History:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������ֵ׼����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���������SQL���
	String sSql = "";
	//�����������ʾģ�����ơ��ݴ��־
	String sDisplayTemplet = "",sTempSaveFlag = "";
	//�����������ѯ�����
	ASResultSet rs = null;
	//����·ݣ���ݺ�
	String sAccountMonth = "";
	String sDuebillNo = "";
	String sCustomerType = "";
	//������
	String sTempletFilter = "1=1";
	
	//���ҳ�����	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sPhaseType == null) sPhaseType = ""; 	
	
	sSql = " select AccountMonth,DuebillNo,CustomerType from Reserve_Apply "+
    	   " where SerialNo = :SerialNo";
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if (rs.next()) 
	{  	 
		sAccountMonth = rs.getString("AccountMonth");  
		sDuebillNo = rs.getString("DuebillNo");
		sCustomerType = rs.getString("CustomerType");
	}  
	rs.getStatement().close();
	if(sAccountMonth == null) sAccountMonth = "";
	if(sDuebillNo == null) sDuebillNo = "";
	if(sCustomerType == null) sCustomerType = "";
	
%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%	
	//��ʾģ��
	sDisplayTemplet = "ReserveApplyInfo";//�鵵ʱ��ʾģ��	
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,sTempletFilter,Sqlca);		
	if(sCustomerType.equals("03"))
		doTemp.setVisible("IsMsIndustry,IndustryGrade,IsMarket,IndustryType,BelongArea",false);	
	
	//����DataWindow����	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//���Ϊ�ѵǼ�̨��״̬����ʼ�ֵ׼����������ֻ��
	dwTemp.ReadOnly = "0"; 	
				
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
				//{(sPhaseType.equals("1040"))?"false":"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		//¼��������Ч�Լ��					
		if(vI_all("myiframe0"))
		{    
			beforeUpdate();
			setItemValue(0,getRow(),"TempSaveFlag","2"); //�ݴ��־��1���ǣ�2����			
			as_save("myiframe0");
		}
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{	
		
	}

	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		
	}

	
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();	
	var bCheckBeforeUnload=false;
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>