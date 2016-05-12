<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-28
		Tester:
		Describe: ҵ����������Ӧ��������ĵ�����ͬ�б�һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:
				ObjectType���������ͣ�CreditApply��
				ObjectNo: �����ţ�������ˮ�ţ�
		Output Param:
				
		HistoryLog:	gftang 2013-5-9 �ĳ�ģ������			
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
	//�������������������͡�������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
   //ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ApplyAssureList2";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
	//��ȡҵ�������˴���
	sSql = " select CustomerID from BUSINESS_APPLY where SerialNo =:SerialNo ";
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
		{"true","All","Button","����","���뵣����ͬ��Ϣ","importRecord()",sResourcesPath},
		{"true","","Button","����","�鿴������ͬ��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","All","Button","ɾ��","ɾ��������ͬ��Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","�����ͻ�����","�鿴������ͬ��صĵ����ͻ�����","viewCustomerInfo()",sResourcesPath},
		};
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
	  sParaString = "RelativeTableName,APPLY_RELATIVE RT,ObjectNo,<%=sObjectNo%>,ContractStatus,020,ContractType,020,OrgID,<%=CurUser.getOrgID()%>";
		sReturn = selectObjectValue("SelectImportGuarantyContract",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
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
			OpenPage("/CreditManage/CreditAssure/ApplyAssureInfo2.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
		}
	}

	/*~[Describe=�鿴�����ͻ���������;InputParam=��;OutPutParam=��;]~*/
	function viewCustomerInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
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
					OpenPage("/CreditManage/GuarantyManage/ApplyPawnList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
				else //��Ѻ
					OpenPage("/CreditManage/GuarantyManage/ApplyImpawnList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
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