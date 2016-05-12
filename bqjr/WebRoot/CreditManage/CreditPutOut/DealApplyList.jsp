<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: wqchen 2010-03-20
		Tester:
		Describe: ��ҵ��������еǼ�;
		Input Param:
					DealType��
						01����ǩ���ͬ��֪ͨ�飨һ������ҵ��
						02����ɲ�����֪ͨ�飨һ������ҵ��
		Output Param:
			
		HistoryLog: zywei 2005/08/13 �ؼ�ҳ��
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sCondition="";	
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�����б����
	String sHeaders[][] = {
							{"SerialNo","������ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurType","��������"},
							{"Currency","����"},
							{"BusinessSum","������"},
							{"RelativeSum","�ѵǼǺ�ͬ���(Ԫ)"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"}
						  };

	String sSql =   " select SerialNo,CustomerName,"+
					" getBusinessName(BusinessType) as BusinessTypeName,"+
					" OccurType,"+
					" getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,ApplyType,"+
					" getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getUserName(InputUserID) as InputUserName,"+
					" getOrgName(InputOrgID) as InputOrgName"+
					" from BUSINESS_APPLY"+
					" where OperateUserID ='"+CurUser.getUserID()+"'"+
					" and SerialNo in (select ObjectNo from FLOW_OBJECT where ApplyType in ('CreditLineApply','DependentApply','IndependentApply') "+
					" and PhaseNo='1000') ";

	if(sDealType.equals("01"))
	{
		sCondition = " and Flag5 = '010' ";
	}else if(sDealType.equals("02"))
	{
		sCondition = " and Flag5 = '020' ";
	}
	sSql = sSql + sCondition + " order by SerialNo desc ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="BUSINESS_APPly";
	doTemp.setKey("SerialNo",true);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("Currency","2");
	
	//���ò��ɼ���
	doTemp.setVisible("ApplyType,OccurType",false);
	doTemp.setUpdateable("ApproveTypeName,CustomerName",false);
	doTemp.setAlign("BusinessSum,RelativeSum","3");
	doTemp.setType("BusinessSum,RelativeSum","Number");
	doTemp.setCheckFormat("BusinessSum,RelativeSum","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,ClassifyResultName"," style={width:80px} ");
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
    doTemp.setHTMLStyle("VouchTypeName"," style={width:350px} ");
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,BusinessSum","IsFilter","1");
	doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"3","BusinessSum","");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	String sApproveNeed = "";
	sApproveNeed = CurConfig.getConfigure("ApproveNeed");
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

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
		{"true","","Button","��������","��������","viewTab()",sResourcesPath},
		{"true","","Button","�ǼǺ�ͬ","�ǼǺ�ͬ","BookInContract()",sResourcesPath}
		}; 
	if(sDealType.equals("02"))
		sButtons[1][0]="false";
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�ǼǺ�ͬ;InputParam=��;OutPutParam=��;]~*/
	function BookInContract()
	{
		//������������,��������������,���ڶ����Ч�Լ��
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sApplyType = getItemValue(0,getRow(),"ApplyType");//��������
		sObjectType = "CreditApply";//��������
		var sOccurType=getItemValue(0,getRow(),"OccurType");//�������ͣ���������Ϊ�����»��ɡ���չ�ڡ������ж�����¹�����ȼ��
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			/********************add by hwang 20090630,���ڶ������ҵ�����Ӷ����Ч�Լ��*******************************/
			sReturn = autoRiskScan("011","OccurType="+sOccurType+"&ApplyType="+sApplyType+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo);
			if(sReturn != true){
				return;
			}
			
			if(!confirm("��ȷ��Ҫ����ѡ�е�������Ϣ�ǼǺ�ͬ��")) 
			{
				return;
			}

		    sReturn = RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.InitializeContractFromApply","initialize","ApplySerialNo="+sSerialNo+",UserID=<%=CurUser.getUserID()%>");
		    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
			alert("����������Ϣ���ɺ�ͬ�ɹ�����ͬ��ˮ��["+sReturn+"]��\n\r�������д��ͬҪ�ز������桱���Ժ��ڡ�����ɷŴ��ĺ�ͬ���б���ѡ��ú�ͬ����д��ͬҪ�أ�");

			sObjectType = "BusinessContract";
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}
	}
    
	/*~[Describe=�鿴��������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "CreditApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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