<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-28
		Tester:
		Describe: ������ͬ����Ӧ��������ĵ�����ͬ�б�һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:
				ObjectType���������ͣ�BusinessContract��
				ObjectNo: �����ţ���ͬ��ˮ�ţ�
		Output Param:
				
		HistoryLog:				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����뵣����ͬ�б�"; // ��������ڱ��� 
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
    String sWhereCond = "";
	//�������������������͡�������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	//add by hwang 20090721.�����������е���Ѻ��������ʾ�������⡣����������ΪAfterLoan����������ʱ,GUARANTY_RELATIVE���������ݡ�
	//�����޸��߼�,����������Ϊ�����롢��������ͬʱ��Ĭ��Ϊ��ͬ��
	//�жϵ�ObjectType����ΪReinforceContractʱ����ʾ������ɾ����ť 2010/04/01
	if(sObjectType.equals("ReinforceContract")){
		sObjectType="ReinforceContract";
	}else if(!(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract"))){
		sObjectType="BusinessContract";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
   //ͨ��DWģ�Ͳ���ASDataObject����doTemp
   String sTempletNo = "ContractAssureList2";//ģ�ͱ��
   ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

    //where���ͳһ�޸Ĵ����漰ҵ������ģ����				
    sWhereCond = " where  exists (Select CONTRACT_RELATIVE.ObjectNo from CONTRACT_RELATIVE  where "+
	                              " CONTRACT_RELATIVE.SerialNo = '"+sObjectNo+"' and CONTRACT_RELATIVE.ObjectType='GuarantyContract' "+
	                              " and CONTRACT_RELATIVE.RelationStatus = '010' and CONTRACT_RELATIVE.ObjectNo = GUARANTY_CONTRACT.SerialNo) and GUARANTY_CONTRACT.ContractType='020' "+
	                              " and (ContractStatus = '010' or ContractStatus = '020') "; 
    doTemp.WhereClause += sWhereCond;

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
	//��ȡҵ�������˴���
	sSql = " select CustomerID from BUSINESS_CONTRACT where SerialNo =:SerialNo ";
	String sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"false","All","Button","����","���뵣����ͬ��Ϣ","importRecord()",sResourcesPath},
		{"true","","Button","����","�鿴������ͬ��Ϣ����","viewAndEdit()",sResourcesPath},
		{"false","All","Button","ɾ��","ɾ��������ͬ��Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","�����ͻ�����","�鿴������ͬ��صĵ����ͻ�����","viewCustomerInfo()",sResourcesPath},
	};
	if(sObjectType.equals("ReinforceContract")){
		sButtons[0][0]="true";
		sButtons[2][0]="true";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=�����¼;InputParam=��;OutPutParam=��;]~*/
	function importRecord(){
	    //���뵱ǰ����������
	  sParaString = "RelativeTableName,CONTRACT_RELATIVE RT,ObjectNo,<%=sObjectNo%>,ContractStatus,020,ContractType,020,OrgID,<%=CurUser.getOrgID()%>";
		sReturn = selectObjectValue("SelectImportGuarantyContract",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sSerialNo = sReturn[0];
		sReturn=RunMethod("BusinessManage","ImportGauarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
		if(sReturn == "EXIST") alert(getBusinessMessage('415'));//�õ�����ͬ�Ѿ����룡
		if(sReturn == "SUCCEEDED") {
			alert(getBusinessMessage('416'));//���뵣����ͬ�ɹ���
			reloadSelf();
		}
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			sReturn=RunMethod("BusinessManage","DeleteGuarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED"){
				alert(getHtmlMessage('7'));//��Ϣɾ���ɹ���
				reloadSelf();
			}else{
				alert(getHtmlMessage('8'));//�Բ���ɾ����Ϣʧ�ܣ�
				return;
			}	
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//--������ʽ
			OpenPage("/CreditManage/CreditAssure/ContractAssureInfo2.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
		}
	}

	/*~[Describe=�鿴�����ͻ���������;InputParam=��;OutPutParam=��;]~*/
	function viewCustomerInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			var sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//ϵͳ�в����ڵ����˵Ŀͻ�������Ϣ�����ܲ鿴��
			else
				openObject("Customer",sCustomerID,"002");
		}
	}
	
	/*~[Describe=ѡ��ĳ�ʵ�����ͬ,������ʾ�������µĵ���Ѻ��;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else{
			var sGuarantyType = getItemValue(0,getRow(),"GuarantyType");			
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=��֤����������ϸ��Ϣ!","DetailFrame","");
			}else{
				if (sGuarantyType.substring(0,3) == "050") //��Ѻ
					OpenPage("/CreditManage/GuarantyManage/ContractPawnList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
				else //��Ѻ
					OpenPage("/CreditManage/GuarantyManage/ContractImpawnList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
			}
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ�ĵ�����Ϣ!","DetailFrame","");
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>