<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content: ���Ŷ�ȷ����б�ҳ��
		Input Param:
			ParentLineID����ȱ��
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ�ȷ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	
	//���ҳ�����	
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	if(sParentLineID == null) sParentLineID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����
	String[][] sHeaders = {
						{"CustomerID","�ͻ����"},
						{"CustomerName","�ͻ�����"},
						{"BusinessTypeName","ҵ��Ʒ��"},
						{"RotativeName","�Ƿ�ѭ��"},
						{"BailRatio","��ͱ�֤�����"},
						{"LineSum1","�����޶�"},
						{"LineSum2","�����޶�"},
						{"SubBalance","�Ӷ�����"}
					};
	
		sSql =  " select LineID,CustomerID,CustomerName,BusinessType, "+
				" getBusinessName(BusinessType) as BusinessTypeName, "+
				" Rotative,getItemName('YesNo',Rotative) as RotativeName, "+
				" BailRatio,LineSum1,LineSum2,SubBalance,BCSerialNo "+
				" from CL_INFO "+
				" Where ParentLineID = '"+sParentLineID+"' ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID,",true);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("LineID,BusinessType,Rotative,BCSerialNo",false);
	//���ø�ʽ
	doTemp.setType("LineSum1,LineSum2,BailRatio,SubBalance","Number");
	doTemp.setCheckFormat("LineSum1,LineSum2,BailRatio,SubBalance","2");
	//doTemp.setUnit("LineSum1,LineSum2,SubBalance","(Ԫ)");
	doTemp.setUnit("BailRatio","(%)");
			
	//����Filter
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	dwTemp.setEvent("AfterDelete","!CreditLine.DeleteCLLimitationRelative(#LineID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�����Ӷ������ҵ��","�鿴�����Ӷ������ҵ������","viewBusiness()",sResourcesPath},
		{"true","","Button","�����Ӷ�����","�鿴�����Ӷ�����","viewSubLineBalance()",sResourcesPath},
		};
		
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴�����Ӷ������ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewBusiness()
	{
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("SublineSubList","/CreditManage/CreditLine/SublineSubList.jsp","LineNo="+sBCSerialNo+"&BusinessType="+sBusinessType,"","");
	}

	/*~[Describe=�鿴�����Ӷ�����;InputParam=��;OutPutParam=��;]~*/
	function viewSubLineBalance()
	{
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		PopPage("/CreditManage/CreditLine/GetSubLineBalance.jsp?LineNo="+sBCSerialNo+"&BusinessType="+sBusinessType,"","dialogWidth=26;dialogHeight=14;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSubLineID = getItemValue(0,getRow(),"LineID");
		if (typeof(sSubLineID) == "undefined" || sSubLineID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		PopComp("SubCreditLineAccountInfo","/CreditManage/CreditLine/SubCreditLineAccountInfo.jsp","ParentLineID=<%=sParentLineID%>&SubLineID="+sSubLineID,"","");
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

<%@ include file="/IncludeEnd.jsp"%>
