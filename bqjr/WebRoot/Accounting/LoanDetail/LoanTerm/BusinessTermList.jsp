<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "�б���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//��ȡ����
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")));//������
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType")));//��������
	String status = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Status")));//״̬
	String termType = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermType")));//�������
	String templetNo = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TempletNo")));//��ʾģ����
	
	String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");//�������ҵ�����
	String productVersion = "",productID="";
	BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(objectType, objectNo,Sqlca);
	if(businessObject != null)
	{
		productID = businessObject.getString("BusinessType");
		productVersion = businessObject.getString("ProductVersion");
	}else{
		throw new Exception("����"+objectType+".+"+objectNo+"�������ڣ�");
	}
	
	if("".equalsIgnoreCase(productVersion))
		throw new Exception("ȡ���Ĳ�Ʒ�汾Ϊ�գ����飡");
	if("".equalsIgnoreCase(productID)) 
		throw new Exception("ȡ���Ĳ�Ʒ���Ϊ�գ����飡");
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String templetFilter = "1=1";
	//����ASDO����
	ASDataObject doTemp = new ASDataObject(templetNo,templetFilter,Sqlca);
	
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	//����DW����
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("ProductID", productID);
	valuePool.setAttribute("ProductVersion", productVersion);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+businessObject.getObjectType());
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));

	//����Ϊ��
	//0.�Ƿ���ʾ
	//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
	//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.��ť����
	//4.˵������
	//5.�¼�
	//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true", "", "Button", "����", "����һ����Ϣ","newRecord()",sResourcesPath},
			{"true", "", "Button", "ɾ��", "ɾ��һ����Ϣ","deleteRecord()",sResourcesPath},
			{"false", "", "Button", "����", "��������","viewRecord()",sResourcesPath},
			{"false","","Button","����","�����¼","saveRecord()",sResourcesPath}
	};
	
	if(termType.equals("SPT")) sButtons[3][0] = "true";
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		as_save("myiframe0","");
		return true;
	}

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		var returnValue = setObjectValue("SelectTermLibrary","TermType,<%=termType%>,ObjectType,Product,ObjectNo,<%=productID+"-"+productVersion%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") return;
		
		var sTermID = returnValue.split("@")[0];
		
		var sReturn = RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=businessObject.getObjectType()%>,<%=objectNo%>");
		reloadSelf();
	}
	
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //���������б���������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷ��ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	function initRow(){
		
	}

	//��ʼ��
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@include file="/IncludeEnd.jsp"%>