<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-26
		Tester:
		Describe1: ��ͬѡ��;
		Input Param:
		Output Param:

		HistoryLog:
		jytian 2004/12/28 �������Ŷ�Ⱥ�ͬ
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬѡ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	String sWhereClause ="";
	String sTempletNo ="";
	
	//����������	
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	
	if(sContractNo==null || sContractNo.equals("")) sContractNo=" ";
	/*modified by  ttshao 20121026
	if(sContractNo==null) sContractNo=" ";
	*/
	if(sCustomerID==null) sCustomerID=" ";
	if(sBusinessType==null) sBusinessType=" ";
	
	String sSortNo=CurOrg.getSortNo();
	//�����ͷ�ļ�
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	
	//doTemp.setHTMLStyle("BusinessCurrencyName,RecoveryUserName"," style={width:100px} ");

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	sTempletNo = "UniteContractSelectList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//��ѡ
	doTemp.multiSelectionEnabled = true;
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sContractNo+","+sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
				{"true","","Button","�ϲ�","�ϲ���ѡ��ͬ","SelectSubmit()",sResourcesPath},
				{"true","","Button","����","�ͻ�����","CreditBusinessInfo()",sResourcesPath},
			};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script>
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function CreditBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}


	
	/*~[Describe=�ϲ���ͬ;InputParam=��;OutPutParam=��;]~*/
	function SelectSubmit()
	{
		//��ú�ͬ��ˮ��
		sObjectNoArray = getItemValueArray(0,"SerialNo");
		
		if (sObjectNoArray.length==0){
			alert("��û��ѡ����Ϣ��������Ҫѡ�����Ϣǰ��̣� ");
			return;
		}		

		var iCount = 0;
		var sMessage1 = "";
		
		sMessage = "���Ѿ�ѡ����������Ҫ���ϲ��ĺ�ͬ:\n\r"+"ִ�иò����󣬱�ѡ�еĺ�ͬ��������ɾ�����޷��ָ���\n\r\n\r";
		//�ҵ���һ��ѡ�е����񣬲�������ʾ��Ϣ
		for(var iMSR = 0; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a == "��")
			{
				if (iCount == 0) 
				{
					sSerialNo = getItemValue(0,iMSR,"SerialNo");
					
				}
				
				iCount = iCount + 1;
				
				sMessage = sMessage+getItemValue(0,iMSR,"SerialNo")+"-";
				sMessage = sMessage+getItemValue(0,iMSR,"CustomerName")+"-";
				sMessage = sMessage+"\n\r";
				if(sMessage1=="")
				{
					sMessage1 = getItemValue(0,iMSR,"SerialNo");
				}else
				{
					sMessage1 = sMessage1+","+getItemValue(0,iMSR,"SerialNo");
				}
			}
		}

		sMessage = sMessage+"\n\r"+"ȷ��Ҫ����ѡ��ͬ��Ŀ���ͬ��<%=sContractNo%>���ϲ���";
		
		if (confirm(sMessage)==false){
			return;
		}		
				
		//var sReturn = PopPageAjax("/InfoManage/DataInput/UniteContractActionAjax.jsp?ContractNo=<%=sContractNo%>&ObjectNoArray="+sObjectNoArray,"","");
		var sReturn = RunMethod("��Ϣ����","UniteContract","<%=sContractNo%>"+","+sObjectNoArray);
		if(sReturn=="true")
		{
			alert("��ѡ��ͬ��"+sMessage1+"���Ѿ��ɹ��ϲ���Ŀ���ͬ��<%=sContractNo%>��!");
			self.returnValue =sReturn;
			self.close();
		}else
		{
			self.returnValue =sReturn;
			self.close();
		}
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>