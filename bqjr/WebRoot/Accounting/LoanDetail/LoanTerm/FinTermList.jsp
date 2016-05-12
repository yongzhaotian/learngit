<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "��Ϣ���"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������
	String businessType = "";
	String projectVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String status = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Status")));//״̬
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(sObjectType, sObjectNo,Sqlca);
	if(businessObject != null)
	{
		businessType = businessObject.getString("BusinessType");
		projectVersion = businessObject.getString("ProductVersion");
	}else
	{
		throw new Exception("����"+sObjectType+".+"+sObjectNo+"�������ڣ�");
	}
	

	//��ʾģ����
	String sTempletNo = "FinRateSegmentList";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+businessObject.getObjectType());
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
			{"true", "All", "Button", "����", "����","newRecord()",sResourcesPath},
			{"true", "", "Button", "����", "����","viewAndEdit()",sResourcesPath},
			{"true", "All", "Button", "ɾ��", "ɾ��","deleteRecord()",sResourcesPath},
	};
	if(sObjectType.equals("PutOutApply")){ 
		CurComp.setAttribute("RightType", "ReadOnly");
	}
	
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>	
	function newRecord()
	{
		var returnValue = setObjectValue("SelectTermLibrary","TermType,FIN,ObjectType,Product,ObjectNo,<%=businessType+"-"+projectVersion%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") 
		{
			return;
		}
		var sTermID = returnValue.split("@")[0];
		for(var i=0;i<getRowCount(0);i++)
		{
			var termID = getItemValue(0,i,"RateTermID");
			if(sTermID == termID)
			{
				alert("�Ѿ����ڡ�"+getItemValue(0,i,"RateTermName")+"����");
				return;
			}
		}
		//������Ϣ
		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=businessObject.getObjectType()%>,<%=sObjectNo%>");
		//���»�׼������
		RunMethod("BusinessManage","UpdateFineBusinessRate","<%=businessObject.getObjectType()%>,<%=sObjectNo%>");
		reloadSelf();
	}
	
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	    popComp("FinTermInfo","/Accounting/LoanDetail/LoanTerm/FinTermInfo.jsp","ToInheritObj=y&SerialNo="+sSerialNo+"&ObjectType=<%=businessObject.getObjectType()%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y","dialogWidth=50;dialogHeight=50;");
	    reloadSelf();
	}
	
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@include file="/IncludeEnd.jsp"%>