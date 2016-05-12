<%@page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.RateConfig"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>

	//��ȡ����
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType")));//��������
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")));//������
	String termID = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermID")));//���ID
	String status = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Status")));//״̬
	String currency = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Currency")));//����
	String termMonth=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("termMonth")));//��������
	if(termMonth == null) termMonth = "0.0";
	
	BusinessObject businessObject= AbstractBusinessObjectManager.getBusinessObject(objectType,objectNo,Sqlca);
	if(businessObject==null){
		throw new Exception("δȡ��ҵ��������ObjectType="+objectType+",ObjectNo="+objectNo+"�����飡");
	}
	objectType = businessObject.getObjectType();
	//��ʼ��ҵ��������
	String productVersion = businessObject.getString("ProductVersion");
	String productID = businessObject.getString("BusinessType");
	if("".equalsIgnoreCase(productVersion))
		throw new Exception("ȡ���Ĳ�Ʒ�汾Ϊ�գ����飡");
	if("".equalsIgnoreCase(productID)) 
		throw new Exception("ȡ���Ĳ�Ʒ���Ϊ�գ����飡");
	if(currency==null || "".equals(currency))
		currency = businessObject.getString("Currency");

	//��ʼ���������
	ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, termID);
	if(term == null || term.isEmpty()) term = ProductConfig.getTerm(termID);
	
	String termType = term.getString("TermType"); 
	String setFlag = term.getString("SetFlag");
	String groupTermIDColName = ProductConfig.getTermTypeAttribute(termType, "GroupTermAttributeID");
	String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
		
	String rightType = CurComp.getParameter("RightType");
	if(!"ReadOnly".equals(rightType))
	{
		com.amarsoft.app.accounting.product.ProductManage productManage = new com.amarsoft.app.accounting.product.ProductManage(Sqlca);
		productManage.createTermObject(termID, businessObject);
		productManage.getBomanager().updateDB();
		productManage.getBomanager().commit();
	}
	//ͨ����ʾģ�����ASDataObject����doTemp
	String templetNo = ProductConfig.getTermTypeAttribute(termType, "InfoTempletNo");//��ʾģ����
	
	String templetFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(templetNo,templetFilter,Sqlca);
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	//����DW����
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	if(objectType.equals(BUSINESSOBJECT_CONSTATNTS.business_putout)
		|| objectType.equals(BUSINESSOBJECT_CONSTATNTS.flow_opinion)){
		dwTemp.ReadOnly = "1"; 
		CurComp.setAttribute("RightType","ReadOnly");
	}
	if("BAS".equals(setFlag)){
		dwTemp.Style="2";
	}
	
	
	dwTemp.setEvent("AfterUpdate", "!BusinessManage.UpdateFineBusinessRate("+objectType+","+objectNo+")");
	
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("Currency", currency);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	
	String dwControlScript = DWExtendedFunctions.genDataWindowControlScript(term, dwTemp);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType+","+termID);
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
			{"false","","Button","����","����һ����Ϣ","newRecord()",sResourcesPath},
			{"false","","Button","����","�����¼","saveRecord()",sResourcesPath},
			{"false","","Button","ɾ��","ɾ��һ����Ϣ","deleteRecord()",sResourcesPath},
	};
	
	String segEditControl = ProductConfig.getTermParameterAttribute(term, "SEGEditControl","DefaultValue");//�Ƿ�����༭�ֶ�

	if("BAS".equals(setFlag))
	{
	
		//sButtons[1][0] = "true";
	}
	else if("SET".equals(setFlag))
	{
		sButtons[0][0] = "true";
		//sButtons[1][0] = "true";
		sButtons[2][0] = "true";
	}
	//�����ɱ༭�ֶ�ʱ����������ɾ�İ�ť
	if("2".equals(segEditControl)){
		sButtons[0][0] = "false";
		//sButtons[1][0] = "true";
		sButtons[2][0] = "false";
	}
	
	if("BAS".equals(setFlag)){
%>
<%@ include file="/Resources/CodeParts/Info05.jsp"%>
<% 	}else{
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<% 	}%>


<script language=javascript>
<%out.print(com.amarsoft.app.accounting.config.loader.RateConfig.createJSArray(currency));%>

	function saveRecord(){		
		if("RPT"=="<%=termType%>"){
			var rpt = getItemValue(0,getRow(),"RPTTermID");
			//������������У�� by qzhang1 20131203
			/* if(rpt!="RPT05"){
				var day;
				day = getItemValue(0,getRow(),"DefaultDueDay");	
				if(getRowCount(0)==2){
					for(var i=0;i<2;i++){
						day = getItemValue(0,i,"DefaultDueDay");
						if(typeof(day)!="undefined"&&day.length>0){
							break;
						}
					}								
				}
				if(typeof(day)=="undefined"||day.length==0){
					alert("��¼�뻹����!");
					return ;
				} 
				if(typeof(day)!="undefined"){
					if(day>25||day<1){
						alert("������ֻ��¼��1-25��֮��,������¼��!");
						return false;					
					}
				}
			} */
			
		}		
		if("RAT"=="<%=termType%>"){
			calcBusinessRate("<%=currency%>");
		}
		as_save("myiframe0","setDWControl()");
		return true;
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		popComp("AddTermSetPara2","/CreditManage/CreditApply/AddTermSetPara2.jsp","ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TermID=<%=termID%>&TermObjectType<%=objectType%>","dialogWidth=50;dialogHeight=50;");
		reloadSelf();
	}
	
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
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
	
	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage(1));
			return;
		}
		popComp("AddTermSetPara2","/CreditManage/CreditApply/AddTermSetPara2.jsp","ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TermID=<%=termID%>&TempletNo=<%=templetNo%>&TermObjectType<%=objectType%>&SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=50;");
		RunMethod("BusinessManage","UpdateFineBusinessRate","<%=objectType%>,<%=objectNo%>");
		reloadSelf();
	}
	
	/*У�������Ĭ�ϻ�������--gj*/
	function checkDefaultDay(){
		//var defaultDay=getItemValue(0,getRow(),"DefaultDueDay");
		//if(typeof(defaultDay)!="undefined"||defaultDay!=""){
			//if(defaultDay>=31||defaultDay<0){
				//alert("��������ȷ��Ĭ�ϻ����գ�");
				//setItemValue(0,getRow(),"DefaultDueDay","15");  //����Ĭ��Ϊ15��
				//return;
			//}
		//}
	}
	
	/*~[Describe=����Ȩ��;InputParam=��;OutPutParam=��;]~*/
	function setDWControl()
	{
		<%=dwControlScript%>
	}
	
	//ҳ���ʼ��
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	setDWControl();
	
	currency = "<%=currency%>";
	termMonth = "<%=termMonth%>";
	businessDate = "<%=SystemConfig.getBusinessDate()%>";
	rightType = "<%=rightType%>";
	
</script>

<%
	String jsfile=ProductConfig.getTermTypeAttribute(termType, "JSFile");
	if(jsfile!=null&&jsfile.length()>0){
%>
<script type="text/javascript" src="<%=sWebRootPath+jsfile%>"> </script>
<%	} %>
<script language=javascript>

</script>
<%@include file="/IncludeEnd.jsp"%>