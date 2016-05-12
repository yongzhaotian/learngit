<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS"%>

<%
	String PG_TITLE = "Լ��������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
%>

<%
	//����������
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String objectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	
	if(objectNo == null) objectNo = ""; 
    if(objectType == null) objectType = "";
    
    BusinessObject businessObject= AbstractBusinessObjectManager.getBusinessObject(objectType,objectNo,Sqlca);
	if(businessObject==null){
		throw new Exception("δȡ��ҵ��������ObjectType="+objectType+",ObjectNo="+objectNo+"�����飡");
	}
	objectType = businessObject.getObjectType();
%>

<%//�������
	String sTempletNo = "";	 
%>

<%
	//��ʾģ��		
	sTempletNo = "DRPTList";	
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType+",4");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>


<%
	String sButtons[][] = {
		{"true","","Button","��������","��������","newRecord()",sResourcesPath}, 
		{"true","","Button","���ٱ���","���ٱ��浱ǰҳ��","afterSave()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath}}; 
%>  

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">

	/*~[Describe=�����¼;InputParam=��;OutPutParam=��;]~*/
	function afterSave(){
		var sWaivePrincipalamt = "";
		for(var i=0;i<getRowCount(0);i++){
			sWaivePrincipalamt = getItemValue(0,i,"WaivePrincipalamt");
			setItemValue(0,i,"PayPrinciPalamt",sWaivePrincipalamt);
		}
		as_save("myiframe0");
	}
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		as_add("myiframe0");
		initSerialNo();
		//��������ʱ�����Ĭ��ֵ
		setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(),"PayType","<%=ACCOUNT_CONSTANTS.PS_PAY_TYPE_DRPT%>");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2'))){//�������ɾ������Ϣ��
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "ACCT_PAYMENT_SCHEDULE";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
</script>


<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@	include file="/IncludeEnd.jsp"%>
