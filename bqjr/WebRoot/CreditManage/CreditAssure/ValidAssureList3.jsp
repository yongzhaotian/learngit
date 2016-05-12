<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-12-6
		Tester:
		Describe: һ�㵣����ͬ�б���Ч�ģ���һ����֤��ͬ��Ӧ�����֤�ˣ�;
		Input Param:
				
		Output Param:
				
		HistoryLog:
										
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "һ�㵣����ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	//����������
	
	//���ҳ�����

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","������ͬ���"},
							{"GuarantyTypeName","������ʽ"},				           
							{"GuarantorName","����������"},
							{"GuarantyValue","�����ܽ��"},				            
							{"GuarantyCurrency","����"},
							{"ContractStatusName","��ͬ״̬"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"}
						  };

	sSql =  " select SerialNo,CustomerID,GuarantyType, "+	
			" getItemName('GuarantyType',GuarantyType) as GuarantyTypeName, "+		
			" GuarantorID,GuarantorName,GuarantyValue, "+
			" getItemName('Currency',GuarantyCurrency) as GuarantyCurrency, "+
			" getItemName('ContractStatus',ContractStatus) as ContractStatusName, "+
			" InputUserID,getUserName(InputUserID) as InputUserName, "+
			" InputOrgID,getOrgName(InputOrgID) as InputOrgName "+
			" from GUARANTY_CONTRACT "+
			" where ContractType = '010' "+
			" and ContractStatus = '020' "+
			" and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') ";
	
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,InputUserID,InputOrgID",false);
	doTemp.setUpdateable("GuarantyTypeName,GuarantyCurrency,InputUserName,InputOrgName",false);
	//���ø�ʽ
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	
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
		{"true","","Button","����","�鿴������ͬ��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�����ͻ�����","�鿴������ͬ��صĵ����ͻ�����","viewCustomerInfo()",sResourcesPath},
		{"true","","Button","���ҵ������","�鿴������ͬ��ص�����ͬ��Ϣ�б�","viewBusinessInfo()",sResourcesPath},
		{"true","","Button","����ʧЧ","ʧЧ������ͬ","statusChange()",sResourcesPath},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//��������
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//������ͬ���
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			OpenPage("/CreditManage/CreditAssure/ValidAssureInfo3.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
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
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//ϵͳ�в����ڵ����˵Ŀͻ�������Ϣ�����ܲ鿴��
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
			OpenComp("AssureBusinessList","/CreditManage/CreditAssure/AssureBusinessList.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=ʧЧ������ͬ;InputParam=��;OutPutParam=��;]~*/
	function statusChange()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getBusinessMessage('417'))) //�������ʧЧ������ͬ��
		{
			RunMethod("BusinessManage","UpdateGuarantyContractStatus",sSerialNo+",030");
			reloadSelf();
			OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ�ĵ�����Ϣ!","DetailFrame","");
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
			if (sGuarantyType.substring(0,3) == "010") //��֤
				OpenPage("/CreditManage/GuarantyManage/ValidGuarantorList1.jsp?ContractNo="+sSerialNo,"DetailFrame","");
			else if (sGuarantyType.substring(0,3) == "050") //��Ѻ
				OpenPage("/CreditManage/GuarantyManage/ValidAssurePawnList1.jsp?ContractNo="+sSerialNo,"DetailFrame","");
			else //��Ѻ
				OpenPage("/CreditManage/GuarantyManage/ValidAssureImpawnList1.jsp?ContractNo="+sSerialNo,"DetailFrame","");
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