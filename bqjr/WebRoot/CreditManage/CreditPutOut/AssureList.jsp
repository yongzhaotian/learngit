<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --FMWu 2004-12-6
		Tester:
		Describe: --������ͬ�б�;
		Input Param:
				ObjectType: --��������(ҵ��׶�)��
				ObjectNo: --�����ţ�����/����/��ͬ��ˮ�ţ���
				ContractType: --��ͬ����
					010 --һ�㵣����Ϣ
					020 --��߶����ͬ
		Output Param:
				SerialNo:--������ͬ��
				ContractType: --��ͬ����
					010 --һ�㵣����Ϣ
					020 --��߶����ͬ

		HistoryLog:
			2005-08-07 ��ҵ� �����ؼ� 
								1.��������bizlet
								2.�޸�ɾ��ʱ������߼��������������ߵ�����ͬ��ɾ��ʱ����ɾ��������ͬ����
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	ASResultSet rs=null;//--��Ž����
	//�������������������͡������š���ͬ����
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
	String sWhereType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("WhereType"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sContractType == null) sContractType = "";
	if(sWhereType == null) sWhereType = "";
	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ�������
	sSql="select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
	String sRelativeTableName = "",sObjectTable="";
	rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
	if(rs.next()){
		sRelativeTableName=rs.getString("RelativeTable");
		sObjectTable=rs.getString("ObjectTable");
	}
	rs.getStatement().close();

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","������ͬ��ˮ��"},
							{"ContractNo","������ͬ���"},
							{"GuarantyTypeName","��������"},
				            {"ContractStatusName","��ͬ״̬"},
							{"Currency","����"},
				            {"GuarantorName","��֤��/��Ѻ��/����������"},
				            {"GuarantyValue","�����ܽ��"},
						  };

	sSql =  " select"+
			" SerialNo,CustomerID,ContractNo,"+
			" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName,"+
			" GuarantorID,GuarantorName,GuarantyValue,"+
			" ContractStatus,getItemName('ContractStatus',ContractStatus) as ContractStatusName"+
			" from GUARANTY_CONTRACT"+
			" where SerialNo in (Select ObjectNo from "+sRelativeTableName+" where "+
			" SerialNo='"+sObjectNo+"' and ObjectType='GuarantyContract') ";
	if(sWhereType.equals("User"))
		sSql =  " select"+
			" SerialNo,CustomerID,ContractNo,"+
			" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName,"+
			" GuarantorID,GuarantorName,GuarantyValue,"+
			" ContractStatus,getItemName('ContractStatus',ContractStatus) as ContractStatusName"+
			" from GUARANTY_CONTRACT "+
			" where InputUserID='"+CurUser.getUserID()+"'";
	else if(sWhereType.equals("Org"))
		sSql =  " select"+
			" SerialNo,CustomerID,ContractNo,"+
			" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName,"+
			" GuarantorID,GuarantorName,GuarantyValue,"+
			" ContractStatus,getItemName('ContractStatus',ContractStatus) as ContractStatusName"+
			" from GUARANTY_CONTRACT "+
			" where  InputOrgID='"+CurOrg.getOrgID()+"'";

    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,CustomerID,GuarantorID,ContractStatus,ContractType,GuarantyType,GuarantyCurrency,InputOrgId,InputUserId",false);
	doTemp.setUpdateable("",false);
	//���ø�ʽ
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyType,ContractStatus"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	if(sObjectTable.equals("BUSINESS_APPROVE")||sObjectTable.equals("BUSINESS_APPLY"))
	{
		if(sContractType.equals("010"))
		{
			doTemp.setVisible("ContractNo,ContractStatusName",false);
			doTemp.WhereClause+=" and (ContractStatus='010' or ContractStatus is null) ";
		}
		else if(sContractType.equals("020"))
			doTemp.WhereClause+=" and ContractStatus='020' and ContractType='020'";
	}
	else
	{
		doTemp.WhereClause+=" and ContractType='"+sContractType+"' ";
	}
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//out.print(doTemp.SourceSql);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		{"true","","Button","����","����������ͬ��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","���뵣����ͬ��Ϣ","addRecord()",sResourcesPath},
		{"true","","Button","����","�鿴������ͬ��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��������ͬ��Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","�����ͻ�����","�鿴������ͬ��صĵ����ͻ�����","viewCustomerInfo()",sResourcesPath},
		{"true","","Button","���ҵ������","�鿴������ͬ��ص�����ͬ��Ϣ�б�","viewBusinessInfo()",sResourcesPath},
		{"true","","Button","����ʧЧ","ʧЧ������ͬ","statusChange()",sResourcesPath},
		};

	//������һ�㵣����ͬ����û������
	if (sContractType.equals("010")) {
		sButtons[1][0] = "false";
	}

	if(!sObjectTable.equals("BUSINESS_CONTRACT"))
	{
		sButtons[6][0] = "false";
		if(sContractType.equals("020"))
		{
			sButtons[0][0] = "false";
		}
	}
	if(sWhereType.equals("User")||sWhereType.equals("Org"))
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[3][0] = "false";
	}
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
		sGList=PopPage("/CreditManage/CreditPutOut/AddAssureDialog.jsp","","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sGList)!="undefined" && sGList.length!=0 && sGList != '_none_')
		{
			OpenPage("/CreditManage/CreditPutOut/AssureInfo.jsp?GuarantyType="+sGList,"right");
		}
	}

	/*~[Describe=�����¼;InputParam=��;OutPutParam=��;]~*/
	function addRecord()
	{
	    //���뵱ǰ����������
	    sParaString = "ContractStatus"+","+"020"+","+"ContractType"+","+"020";
		sReturn = selectObjectValue("SelectImportGuarantyContract",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sSerialNo = sReturn[0];
		sReturn=RunMethod("BusinessManage","ImportGauarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
		if(sReturn == "EXIST") alert("�õ�����ͬ�Ѿ����룡");
		if(sReturn == "SUCCEEDED") {
			alert("�����ͬ�ɹ���");
			reloadSelf();
		}
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			sReturn=RunMethod("BusinessManage","DeleteAssure","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED") 
			{
				alert("ɾ���ɹ�!");
				reloadSelf();
			}
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			OpenPage("/CreditManage/CreditPutOut/AssureInfo.jsp?SerialNo="+sSerialNo,"right");
		}
	}

	/*~[Describe=�鿴�����ͻ���������;InputParam=��;OutPutParam=��;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (sCustomerID.length == 0)
				alert("�����ͻ�����ϸ��Ϣ��");
			else
				openObject("Customer",sCustomerID,"002");
		}
	}

	/*~[Describe=�鿴��߶����ͬ����ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewBusinessInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			OpenComp("AssureBusinessList","/CreditManage/CreditPutOut/AssureBusinessList.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=ʧЧ������ͬ;InputParam=��;OutPutParam=��;]~*/
	function statusChange()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm('�������ʧЧ������ͬ��')) //�������ʧЧ������ͬ��
		{
			RunMethod("BusinessManage","UpdateGuarantyContractStatus",sSerialNo+",030");
			reloadSelf();
			OpenPage("/Blank.jsp??TextToShow=�����Ϸ��б���ѡ��һ��������ͬ��Ϣ","rightdown");
		}
	}

	/*~[Describe=ѡ��ĳ�ʵ�����ͬ,������ʾ�������µĵ���Ѻ��;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}
		else {
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
			//alert(sGuarantyType);
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=��֤����������ϸ��Ϣ!","rightdown");
			}
			else {
				OpenComp("GuarantyList","/CreditManage/GuarantyManage/GuarantyList.jsp","ObjectNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&GuarantyType="+sGuarantyType+"&WhereType=Guaranty_Contract","rightdown");
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
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>