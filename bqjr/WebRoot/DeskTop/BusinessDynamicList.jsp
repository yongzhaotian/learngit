<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ҵ���б�
			sListType 11 ��������
			          12 ��׼����
			          13 �������
			          14 ��ͬ�Ǽ�
			          15 ������Ŵ�����
			          21 �ڼ䷢��
			          22 �ڼ����
			          23 չ��
			          24 ���
			          25 ����
			          26 ����
			          31 ��������
			          32 ��������
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql1="",sSql2="",sSql3="";

	//���ҳ�����
	
	//����������
	String sOrgName ="";
	String sOrgId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	String sToday = StringFunction.getToday();

	if (sOrgId==null) {
		sOrgId = CurOrg.getOrgID();
	}
	String sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgId));
	if(sSortNo==null)sSortNo="";
	sOrgName = Sqlca.getString(new SqlObject("select OrgName from ORG_INFO where OrgID = :OrgID").setParameter("OrgID",sOrgId));
	String sDay = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DataDate"));
	if (sDay==null) {
		sDay = StringFunction.getToday();
	}
	String sEndDay = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EndDay"));
	if (sEndDay==null) {
		sEndDay = sDay;
	}
	String sViewDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewDate"));
	if (sViewDate==null) {
		sViewDate = StringFunction.getToday();
	}
	String sListType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ListType"));
	if (sListType==null) {
		sListType = "13";
	}
	String sCurrency = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Currency"));
	if (sCurrency==null) {
		sCurrency = "";
	}

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","��ˮ��"},
							{"CustomerName","�ͻ�����"},							
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"CreditAggreement","���Э����"},						
							{"OccurTypeName","��������"},
							{"ArtificialNo","��ͬ���"},							
							{"Currency","����"},
							{"BusinessSum","���(Ԫ)"},
							{"Balance","���(Ԫ)"},
							{"BailAccount","��֤���ʺ�"},
							{"BailSum","��֤��(Ԫ)"},
							{"ClearSum","���ڽ��(Ԫ)"},
							{"OverdueBalance","����/�����(Ԫ)"},
							{"FineBalance","ǷϢ���(Ԫ)"},
							{"BusinessRate","����(��)"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"VouchTypeName","������ʽ"},
							{"RiskRate","���ն�"},
							{"RelativeContractNo","��ͬ��ˮ��"},
							{"RelativeSerialNo","��ݺ�"},
							{"OccurTypeName","��ˮ����"},
							{"OccurDate","��������"},
							{"BusinessCCYName","����"},
							{"BackType","���շ�ʽ"},
							{"ActualDebitSum","���Ž��(Ԫ)"},
							{"ActualCreditSum","���ս��(Ԫ)"},
							{"UserName","�ͻ�����"},
							{"OperateOrgName","�������"}
						  };
    String sSql =" select SerialNo,CustomerName,ArtificialNo, "+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,Balance,"+
				" FineBalance,BusinessRate,PutOutDate,Maturity,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,OverdueBalance,"+
				" getOrgName(ManageOrgID) as OrgName,"+
				" getUserName(ManageUserID) as UserName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_CONTRACT";
	String sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and BusinessCurrency != ''";
	if (!sCurrency.equals("")) {
		sWhere += " and BusinessCurrency = '"+sCurrency+"'";
	}

	if (!sOrgId.equals("9900")) {
		sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
	}

	if (sListType.equals("10")) {
		 sSql =" select SerialNo,CustomerName,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_APPLY";
	}
	else if (sListType.equals("11")) {
		 sSql =" select SerialNo,CustomerName,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_APPROVE";
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and ApproveType='010'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		if (!sCurrency.equals("")) {
			sWhere += " and BusinessCurrency = '"+sCurrency+"'";
		}
	}
	else if (sListType.equals("12")) {
		 sSql =" select SerialNo,CustomerName,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_APPROVE";
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and ApproveType='020'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		if (!sCurrency.equals("")) {
			sWhere += " and BusinessCurrency = '"+sCurrency+"'";
		}
	}
	else if (sListType.equals("14")) {
		 sSql =" select SerialNo,CustomerName,ArtificialNo,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_PUTOUT";
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and BusinessCurrency != '' and ContractSerialNo is not null";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		if (!sCurrency.equals("")) {
			sWhere += " and BusinessCurrency = '"+sCurrency+"'";
		}
	}
	else if (sListType.equals("20")) {
		sSql =	" select CustomerName,SerialNo,"+
				" RelativeContractNo,OccurDate,ActualDebitSum "+
				" from BUSINESS_WASTEBOOK";
		sWhere = " where TransactionFlag = '0' and OccurDate >= '"+sDay+"' and OccurDate <= '"+sEndDay+"' and OccurDirection = '0'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and OrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("21")) {
		sSql =	" select CustomerName,SerialNo,"+
				" RelativeContractNo,OccurDate,ActualCreditSum "+
				" from BUSINESS_WASTEBOOK";
		sWhere = " where TransactionFlag = '0' and OccurDate >= '"+sDay+"' and OccurDate <= '"+sEndDay+"' and OccurDirection = '1'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and OrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("22")) {
		sSql =" select SerialNo,CustomerName,ArtificialNo, "+
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,Balance,"+
				" FineBalance,BusinessRate,PutOutDate,Maturity,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,OverdueBalance,"+
				" getOrgName(ManageOrgID) as OrgName,"+
				" getUserName(ManageUserID) as UserName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_CONTRACT";
		sWhere = " where BusinessType = '9010' and PutOutDate >= '"+sDay+"' and PutOutDate <= '"+sEndDay+"' and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("23")) {
		sWhere = " where BusinessType = '1100050' and PutOutDate >= '"+sDay+"' and PutOutDate <= '"+sEndDay+"' and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("24")) {
		sWhere = " where OverdueBalance>0 and Maturity >= '"+sDay+"' and Maturity <= '"+sEndDay+"'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("25")) {
		sWhere = " where FinishType like '060%' and FinishDate >= '"+sDay+"' and FinishDate <= '"+sEndDay+"'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("30")) {
		 sSql =" select SerialNo,CustomerName,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_PUTOUT";
		sWhere = " where PutOutDate >= '"+sToday+"' and PutOutDate <= '"+sViewDate+"'and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("31")) {
    	sSql =" select SerialNo,CustomerName,ArtificialNo, "+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,Balance,"+
				" FineBalance,BusinessRate,PutOutDate,Maturity,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,OverdueBalance,"+
				" getOrgName(ManageOrgID) as OrgName,"+
				" getUserName(ManageUserID) as UserName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_CONTRACT";
		sWhere = " where Maturity >= '"+sToday+"' and Maturity <= '"+sViewDate+"'  and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}

	sSql = sSql + sWhere;// +" order by CustomerName";
	
	//out.println(sSql);
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);

	//���ò��ɼ���
	doTemp.setVisible("SerialNo,BusinessType,OccurType,CreditAggreement,BusinessCurrency,VouchType,OperateOrgID,OrgName,FineBalance",false);	
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance,BailSum,OverdueBalance,FineBalance,BusinessRate,RiskRate,ClearSum,PdgRatio","3");
	doTemp.setType("BusinessSum,Balance,BailSum,OverdueBalance,FineBalance,BusinessRate,ClearSum,PdgRatio","Number");
	doTemp.setCheckFormat("BusinessSum,Balance,BailSum,OverdueBalance,FineBalance,PdgRatio,ClearSum","2");
	doTemp.setCheckFormat("BusinessRate","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName,Currency"," style={width:60px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");

	doTemp.setColumnAttribute("ArtificialNo,CustomerName,BusinessTypeName,BusinessSum","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
			{"true","","Button","����","����","viewTab()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		sObjectType = "AfterLoan";
		if ("<%=sListType%>"=="10") {
			sObjectType = "CreditApply";
		}
		else if ("<%=sListType%>"=="11") {
			sObjectType = "ApproveApply";
		}
		else if ("<%=sListType%>"=="12") {
			sObjectType = "ApproveApply";
		}
		else if ("<%=sListType%>"=="14" || "<%=sListType%>"=="30") {
			sObjectType = "PutOutApply";
		}
		else if ("<%=sListType%>"=="20") {
			sObjectType = "WasteBook";
		}
		else if ("<%=sListType%>"=="21") {
			sObjectType = "WasteBook";
		}

		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID=002";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	</script>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>