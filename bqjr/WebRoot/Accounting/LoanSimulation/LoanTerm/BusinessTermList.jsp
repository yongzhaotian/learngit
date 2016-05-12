<%@page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "�б���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//��ȡ����
	String termType = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermType")));//�������	
	BusinessObject businessObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(businessObject==null) businessObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	
	String termLibraryObjectNo=businessObject.getString("BusinessType")+"-"+businessObject.getString("ProductVersion");
	String termIDAttribute=ProductConfig.getTermTypeAttribute(termType, "RelativeAttributeID");
	String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");

	//ͨ����ʾģ�����ASDataObject����doTemp
	String templetFilter = "1=1";
	//ͨ����ʾģ�����ASDataObject����doTemp
	String templetNo = ProductConfig.getTermTypeAttribute(termType, "ListTempletNo");//��ʾģ����
	//����ASDO����
	ASDataObject doTemp = new ASDataObject(templetNo,templetFilter,Sqlca);
	//����DW����
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = vTemp = dwTemp.genHTMLDataWindow("1,2");
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
			{"true", "", "Button", "����", "��������","viewRecord()",sResourcesPath},
			{"true", "", "Button", "ɾ��", "ɾ��һ����Ϣ","deleteBusinessObjectFromSession(\'"+termObjectType+"\',\'SerialNo\')",sResourcesPath},
			
	};
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/LoanSimulation/js/businessobject.js"> </script>
<script language=javascript>

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		if("<%=businessObject.getString("BusinessType")%>"=="null"){
			alert("<%=businessObject.getString("BusinessType")%>");
			return
		}
		var returnValue = setObjectValue("SelectTermLibrary","TermType,<%=termType%>,ObjectType,Product,ObjectNo,<%=termLibraryObjectNo%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") return;
		var termID = returnValue.split("@")[0];

		popComp("BusinessTermInfo","/Accounting/LoanSimulation/LoanTerm/ImportBusinessTermAction.jsp","TermID="+termID,"");
		reloadSelf();
	}
	
	function viewRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var termID = getItemValue(0,getRow(),"<%=termIDAttribute%>");
		
		if(typeof(serialNo)=="undefined"||serialNo.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		OpenComp("BusinessTermView","/Accounting/LoanSimulation/LoanTerm/BusinessTermInfo.jsp","TermID="+termID+"&SerialNo="+serialNo,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function initRow(){
	}

	<%
		ProductManage pm=new ProductManage(Sqlca);
		List<BusinessObject> list = pm.getTermObjectList(businessObject, termType);
		out.print(DWExtendedFunctions.setDataWindowValues(businessObject,list, dwTemp,Sqlca) );
	%>
	//��ʼ��
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@include file="/IncludeEnd.jsp"%>