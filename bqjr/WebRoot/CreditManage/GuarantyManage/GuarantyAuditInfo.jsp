<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2006-8-18
		Tester:
		Describe: ����Ѻ�����/������Ϣ����;
		Input Param:
			SerialNo����ˮ��				
			GuarantyID������Ѻ����
			GuarantyStatus������Ѻ��״̬
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ѻ�����/���������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������	
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sGuarantyName = "";//����Ѻ������
	String sGuarantyType = "";//����Ѻ������
	String sInputDate = "";//���ʱ��
	
	//����������������Ѻ���š�����Ѻ��״̬
	String sGuarantyID = CurPage.getParameter("GuarantyID");
	String sGuarantyStatus  = CurPage.getParameter("GuarantyStatus");
	String sSerialNo  = CurPage.getParameter("SerialNo");
	//����ֵת��Ϊ���ַ���
	if(sGuarantyID == null) sGuarantyID = "";
	if(sGuarantyStatus == null) sGuarantyStatus = "";
	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		        
	//���ݵ���Ѻ����ȡ�õ���Ѻ�����ƺ͵���Ѻ������
	sSql = 	" select GuarantyName,GuarantyType,InputDate from GUARANTY_INFO "+
		 	" where GuarantyID = :GuarantyID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GuarantyID",sGuarantyID));
	if(rs.next()){
		sGuarantyName = rs.getString("GuarantyName");
		sGuarantyType = rs.getString("GuarantyType");
		sInputDate = rs.getString("InputDate");
		//����ֵת��Ϊ���ַ���
		if(sGuarantyName == null) sGuarantyName = "";
		if(sGuarantyType == null) sGuarantyType = "";
		if(sInputDate == null) sInputDate = "";
	}
	rs.getStatement().close();
	

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "GuarantyAuditInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sGuarantyStatus.equals("03")) //��ʱ����
	{
		//���ñ�����
		doTemp.setRequired("LostDate,Reason,PlanReturnDate",true);
		//����ֻ��
		doTemp.setReadOnly("GuarantyID,GuarantyNamem,GuarantyType,GuarantyStatus,InputOrgName,InputUserName,InputDate,UpdateDate",true);
		//�����ֶβ��ɼ�����
		doTemp.setVisible("FactReturnDate",false);
	}else if(sGuarantyStatus.equals("01")) //�ٻؿ�
	{
		//���ñ�����
		doTemp.setRequired("FactReturnDate",true);
		//����ֻ��
		doTemp.setReadOnly("GuarantyID,GuarantyNamem,GuarantyType,GuarantyStatus,LostDate,Reason,PlanReturnDate,InputOrgName,InputUserName,InputDate,UpdateDate",true);
		//���õ���״̬Ϊ�����
		sGuarantyStatus="02";

	}
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(sGuarantyStatus.equals("00")) //���鿴��Ϣ
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	else
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//��������¼�
	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateGuarantyStatus(#GuarantyID,"+sGuarantyStatus+")");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateGuarantyStatus(#GuarantyID,"+sGuarantyStatus+")");
			
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		{(!sGuarantyStatus.equals("00")?"true":"false"),"","Button","��ʱ����","���������޸�","saveRecord()",sResourcesPath},
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
		if (!checkDate()) return;
			if(confirm("ȷ��Ҫ������Ʒ��ʱ������"))
			{
				if(bIsInsert){		
					beforeInsert();
				}				
				beforeUpdate();
				as_save("myiframe0","saveOperation()");				
			}	
			
	}

	/*~[Describe=����ʱ������;InputParam=��;OutPutParam=��;]~*/
	function saveOperation()
	{
		top.returnValue = "1";//��ʾ��ʱ����ɹ����ش��ɹ���Ϣ,��Ϣ��Listҳ������ʾ��
		top.close();
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		if(<%=sGuarantyStatus%> != "00")
		{
			top.close();
		}else{
			OpenPage("/CreditManage/GuarantyManage/GuarantyAuditList.jsp","_self","");
		}
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

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"GuarantyID","<%=sGuarantyID%>");
			setItemValue(0,0,"GuarantyName","<%=sGuarantyName%>");
			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");			
			setItemValue(0,0,"GuarantyStatus","<%=sGuarantyStatus%>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");			
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;			
		}
		
    }
    //��������Ӧ��С�ڵ���Ԥ�ƻؿ����� 
    function checkDate(){
    	var sLostDate= getItemValue(0,getRow(),"LostDate"); 
    	var sPlanReturnDate = getItemValue(0,getRow(),"PlanReturnDate");
    	var sToday = "<%=StringFunction.getToday()%>";
    	if(sLostDate.length!=0 && typeof(sLostDate)!="undefined"){
			if(sPlanReturnDate.length!= 0 && typeof(sPlanReturnDate)!="undefined"){
			
				if("<%=sInputDate%>" > sLostDate){
					alert("��������Ӧ�ô����������");
					return false;
				}
			
			}
		}else{
			alert("����������Ԥ�ƻؿ����ڲ���Ϊ�գ�");
			return false;
		}
		return true;
    }
	        
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "GUARANTY_AUDIT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"SerialNo",sSerialNo);				
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
