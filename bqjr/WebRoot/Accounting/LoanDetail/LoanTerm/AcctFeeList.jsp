<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%
	String PG_TITLE = "�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String status = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Status")));//״̬
	String sTransCode = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TransCode")));//���ױ��
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sTransCode == null || "".equals(sTransCode)) sTransCode = " ";
	
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
	String sTempletNo = "AcctFeeList";
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
			{"true", "All", "Button", "����", "����һ����Ϣ","createFee()",sResourcesPath},
			{"true", "All", "Button", "ɾ��", "ɾ��һ����Ϣ","deleteRecord()",sResourcesPath},
			{"true", "", "Button", "����", "��������","viewFee()",sResourcesPath},
			{"false", "", "Button", "������ȡ", "������ȡ","FeeTransaction('3508')",sResourcesPath},
			{"false", "", "Button", "����֧��", "����֧��","FeeTransaction('3520')",sResourcesPath}
	};
	
	if(sObjectType.equals("PutOutApply")){
		sButtons[0][1]="false";
		sButtons[1][1]="false";
	}
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	/*~[Describe=�½�����;InputParam=��;OutPutParam=��;]~*/
	function createFee(){
		var returnValue = setObjectValue("SelectTermLibrary","TermType,FEE,ObjectType,Product,ObjectNo,<%=businessType+"-"+projectVersion%>,TransCode,<%=sTransCode%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") return;
		
		var sTermID = returnValue.split("@")[0];
		
		var sReturn = RunMethod("LoanAccount","CreateFee",sTermID+",<%=businessObject.getObjectType()%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
		reloadSelf();
	}
	
	function viewFee(){
		var feeSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(feeSerialNo)=="undefined"||feeSerialNo.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		popComp("AcctFeeInfo","/Accounting/LoanDetail/LoanTerm/AcctFeeInfo.jsp","FeeSerialNo="+feeSerialNo,"");
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
	
	/*~[Describe=���ý���;InputParam=��;OutPutParam=��;]~*/
	function FeeTransaction(transCode){
		var feeSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(feeSerialNo) == "undefined" || feeSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		var transactionSerialNo = RunMethod("LoanAccount","CheckExistsTransaction","<%=BUSINESSOBJECT_CONSTATNTS.fee%>,"+feeSerialNo+","+transCode+"");
		if(typeof(transactionSerialNo)=="undefined" || transactionSerialNo.length==0||transactionSerialNo=="Null") {
			//��������Ҫ���̵Ľ���
			var returnValue = RunMethod("LoanAccount","CreateTransaction",","+transCode+",<%=BUSINESSOBJECT_CONSTATNTS.fee%>,"+feeSerialNo+",,<%=CurUser.getUserID()%>,2");
			returnValue = returnValue.split("@");
			transactionSerialNo = returnValue[1];
			if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
				alert("��������{"+transCode+"}ʱʧ�ܣ�����ԭ��Ϊ��"+returnValue);
				return;
			}
		}
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&ViewID=000";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		if(confirm("��ȷ���Ƿ�������˴���"))
		{
			var returnValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,Y");
			if(typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("ϵͳ�����쳣��");
				return;
			}
			var message=returnValue.split("@")[1];
			alert(message);
			reloadSelf();
		}
	}
	
	
	//��ʼ��
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>