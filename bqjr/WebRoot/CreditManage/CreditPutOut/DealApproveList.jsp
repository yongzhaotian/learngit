<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: ����������������еǼ�;
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
	String PG_TITLE = "������������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sCondition="";	
    String sWhereCond = "";
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//where���ͳһ�޸Ĵ����漰ҵ������ģ����				
	sWhereCond	= " where OperateUserID ='"+CurUser.getUserID()+"' and ApproveType = '01' "+
			                   " and SerialNo in (select ObjectNo from FLOW_OBJECT where FlowNo='ApproveFlow' "+
			                   " and PhaseNo='1000') ";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "DealApproveList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(sDealType.equals("01")){
		sCondition = " and Flag5 = '010' ";
	}
	else if(sDealType.equals("02")){
		sCondition = " and Flag5 = '020' ";
	}
	doTemp.WhereClause = doTemp.WhereClause + sWhereCond + sCondition;

	doTemp.setKeyFilter("SerialNo");
	//���ӹ����� 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

	//����HTMLDataWindow
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
		{"true","","Button","���������������","���������������","viewTab()",sResourcesPath},
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
		sObjectType = "ApproveApply";//��������
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			/********************add by hwang 20090630,���ڶ������ҵ�����Ӷ����Ч�Լ��*******************************/
			sReturn = autoRiskScan("010","OccurType="+sOccurType+"&ApplyType="+sApplyType+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo);
			if(sReturn != true){
				return;
			}
			
			if(!confirm("��ȷ��Ҫ����ѡ�еĵ���������������ǼǺ�ͬ�� \n\rȷ���󽫸�����������������ɺ�ͬ��")) 
			{
				return;
			}

		    sReturn = RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.InitializeContract","initialize","ApproveSerialNo="+sSerialNo+",UserID=<%=CurUser.getUserID()%>");
		    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
			alert("������������������ɺ�ͬ�ɹ�����ͬ��ˮ��["+sReturn+"]��\n\r�������д��ͬҪ�ز������桱���Ժ��ڡ�����ɷŴ��ĺ�ͬ���б���ѡ��ú�ͬ����д��ͬҪ�أ�");

			sObjectType = "BusinessContract";
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}
	}
    
	/*~[Describe=�鿴���������������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "ApproveApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);//sApproveNeed�Ƿ�Ǽ��������������true-�Ǽǣ�false-���Ǽ�
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