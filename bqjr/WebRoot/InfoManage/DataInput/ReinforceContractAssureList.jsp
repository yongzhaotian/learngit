<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ccxie	2010/04/06
		Tester:
		Describe: ҵ���ͬ��������Ӧ�������ĵ�����ͬ�б�һ����֤��ͬ��Ӧһ����֤�ˣ�;
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
	//�������������������͡�������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	if(sContractType == null) sContractType = "";	
	//add by hwang 20090721.�����������е���Ѻ��������ʾ�������⡣����������ΪAfterLoan����������ʱ,GUARANTY_RELATIVE���������ݡ�
	//�����޸��߼�,����������Ϊ�����롢��������ͬʱ��Ĭ��Ϊ��ͬ��
	//�жϵ�ObjectType����ΪReinforceContractʱ����ʾ������ɾ����ť 2010/04/01
	if(sObjectType.equals("ReinforceContract"))
	{
		sObjectType="BusinessContract";
	}else if(!(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract"))){
		sObjectType="BusinessContract";
	}
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
 	String sTempletNo = "ReinforceContractAssureList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sContractType);
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
		{"true","","Button","����","����������Ϣ","newRecord()",sResourcesPath},
		{("020".equals(sContractType)?"true":"false"),"","Button","����","����������Ϣ","importGuaranty()",sResourcesPath},
		{"true","","Button","����","�鿴������Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��������Ϣ","deleteRecord()",sResourcesPath},
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
		sGuarantyType=PopPage("/CreditManage/CreditAssure/AddAssureDialog.jsp","","dialogWidth=350px;dialogHeight=120px;center:yes;status:no;statusbar:no;resizable:no;");
		if(typeof(sGuarantyType) != "undefined" && sGuarantyType.length != 0 && sGuarantyType != '_none_')
		{
			OpenPage("/InfoManage/DataInput/ReinforceContractAssureInfo.jsp?GuarantyType="+sGuarantyType,"right");
		}
	}
	//���ӡ����롱��ť��ʵ����߶����ͬ������ yxzhang@2010/04/08
	function importGuaranty()
	{
		sParaString = "RelativeTableName,TRANSFORM_RELATIVE RT,ObjectNo,<%=sObjectNo%>,ContractStatus,020,ContractType,020,OrgID,<%=CurUser.getOrgID()%>";
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
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			sReturn=RunMethod("BusinessManage","DeleteGuarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
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
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--������Ϣ���
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//--������ʽ
			OpenPage("/InfoManage/DataInput/ReinforceContractAssureInfo.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
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
					OpenPage("/InfoManage/DataInput/ReinforceContractPawnList.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
				else //��Ѻ
					OpenPage("/InfoManage/DataInput/ReinforceContractImpawnList.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo="+sSerialNo,"DetailFrame","");
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