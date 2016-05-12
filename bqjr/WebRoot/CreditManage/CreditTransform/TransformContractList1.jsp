<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ccxie 2010/03/22
		Tester:
		Describe: ҵ���ͬ����Ӧ�������ĵ�����ͬ�б�һ����֤��ͬ��Ӧһ����֤�ˣ�;
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
	String PG_TITLE = "������ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
    String  sWhereCondition="";
	//�������������������͡�������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TRSerialNo"));
	String sRelationStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RelationStatus"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sSerialNo == null) sSerialNo = "";	
	if(sRelationStatus == null) sRelationStatus = "";
	sSql ="select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo ";
	String sObjectNo = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	sWhereCondition= "where TRANSFORM_RELATIVE.ObjectNo = GUARANTY_CONTRACT.SerialNo "+
	                                 " and TRANSFORM_RELATIVE.SerialNo = '"+sSerialNo+"' ";
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "TransformContractList1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
			
	if(sRelationStatus.equals("010"))
		doTemp.WhereClause = doTemp.WhereClause +sWhereCondition+ " and (TRANSFORM_RELATIVE.RelationStatus = '"+sRelationStatus+"' or TRANSFORM_RELATIVE.RelationStatus = '030' )";
	else
		doTemp.WhereClause = doTemp.WhereClause +sWhereCondition+ " and TRANSFORM_RELATIVE.RelationStatus = '"+sRelationStatus+"' ";
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
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
		{sRelationStatus.equals("020")?"true":"false","All","Button","����","����������ͬ","newRecord()",sResourcesPath},
		{sRelationStatus.equals("020")?"true":"false","All","Button","����","������߶����ͬ","importGuaranty()",sResourcesPath},
		{sRelationStatus.equals("030")?"true":"false","All","Button","����","����������ͬ","importRecord()",sResourcesPath},
		{"true","","Button","����","�鿴������Ϣ����","viewAndEdit()",sResourcesPath},
		{sRelationStatus.equals("020")?"true":"false","All","Button","ɾ��","ɾ��������Ϣ","deleteRecord()",sResourcesPath},
		{sRelationStatus.equals("030")?"true":"false","All","Button","ɾ��","ɾ���������","cancelRecord()",sResourcesPath},
		{"true","","Button","�����ͻ�����","�鿴������صĵ����ͻ�����","viewCustomerInfo()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sGuarantyType=PopPage("/CreditManage/CreditAssure/AddAssureDialog2.jsp","","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sGuarantyType) != "undefined" && sGuarantyType.length != 0 && sGuarantyType != '_none_')
		{
			OpenPage("/CreditManage/CreditTransform/TransformContractAssureInfo1.jsp?GuarantyType="+sGuarantyType,"right");
		}
	}

	/*~[Describe=������߶����ͬ;InputParam=��;OutPutParam=��;]~*/
	function importGuaranty()
	{
	  	sParaString = "RelativeTableName,TRANSFORM_RELATIVE RT,ObjectNo,<%=sObjectNo%>,ContractStatus,020,ContractType,020,OrgID,<%=CurUser.getOrgID()%>";
		sReturn = selectObjectValue("SelectImportGuarantyContract",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sObjectNo = sReturn[0];
		sReturn = RunMethod("BusinessManage","InsertTransformRelative",<%=sSerialNo%>+","+sObjectNo+",GuarantyContract,020");
		if(sReturn == "EXIST") alert(getBusinessMessage('415'));//�õ�����ͬ�Ѿ����룡
		if(sReturn == "SUCCEEDED") {
			alert(getBusinessMessage('416'));//���뵣����ͬ�ɹ���
			reloadSelf();
		}
	}
	
	/*~[Describe=��������������ͬ;InputParam=��;OutPutParam=��;]~*/
	function importRecord()
	{
		var sParaString = "SerialNo,<%=sSerialNo%>,RelationStatus,010";
		var sReturn= selectObjectValue("SelectTransformGuaranty",sParaString,"");
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'||sReturn=='_NONE_'))
		{
			sReturns = sReturn.split('@');
			RunMethod("BusinessManage","UpdateTransformStatus",<%=sSerialNo%>+",030,"+sReturns[0]);
			alert("����ɹ���");
			reloadSelf();
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		sContractType = getItemValue(0,getRow(),"ContractType");
		if(sContractType == "010"){
			if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
			{
				sReturn=RunMethod("BusinessManage","DeleteGuarantyContract","<%=sObjectType%>,<%=sSerialNo%>,"+sSerialNo);
				if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED") 
				{
					alert(getHtmlMessage('7'));//��Ϣɾ���ɹ���
					reloadSelf();
				}else
				{
					alert(getHtmlMessage('8'));//�Բ���ɾ����Ϣʧ�ܣ�
					return;
				}
			}
		}else{
			RunMethod("BusinessManage","DeleteTransformRelative","<%=sSerialNo%>,<%=sObjectNo%>,GuarantyContract,"+sSerialNo);
			alert(getHtmlMessage('7'));//��Ϣɾ���ɹ���
			reloadSelf();
		}
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function cancelRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			sReturn=RunMethod("BusinessManage","UpdateTransformStatus",<%=sSerialNo%>+",010,"+sSerialNo);
			alert(getHtmlMessage('7'));//��Ϣɾ���ɹ���
			reloadSelf();
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--������Ϣ���
		sContractType = getItemValue(0,getRow(),"ContractType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//--������ʽ
			OpenPage("/CreditManage/CreditTransform/TransformContractAssureInfo1.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&ContractType="+sContractType+"&TRSerialNo=<%=sSerialNo%>","right");
		}
	}

	/*~[Describe=�鿴�����ͻ���������;InputParam=��;OutPutParam=��;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//ϵͳ�в����ڵ����˵Ŀͻ�������Ϣ�����ܲ鿴��
			else
				openObject("Customer",sCustomerID,"002");
		}
	}


	/*~[Describe=ѡ��ĳ�ʵ�����ͬ,������ʾ�������µĵ���Ѻ��;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=��֤����������ϸ��Ϣ!","DetailFrame","");
			}else 
			{
				if (sGuarantyType.substring(0,3) == "050") //��Ѻ
					OpenPage("/CreditManage/CreditTransform/TransformContractPawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&RelationStatus=<%=sRelationStatus%>&ContractNo="+sSerialNo,"DetailFrame","");
				else //��Ѻ
					OpenPage("/CreditManage/CreditTransform/TransformContractImpawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&RelationStatus=<%=sRelationStatus%>&ContractNo="+sSerialNo,"DetailFrame","");
			}
		}
	}
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">


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