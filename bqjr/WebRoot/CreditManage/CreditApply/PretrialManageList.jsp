<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: ��������
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	// ��ȡ����Ԥ������
	String sTypeCode = "PreCredit";
	String sSql = "select attrstr1 from Basedataset_Info where TypeCode='"+sTypeCode+"' order by UpdateDate desc ";
	String attrstr1 = DataConvert.toString( Sqlca.getString(sSql));
	
	
	String sIsFinish = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isFinish"));
	ARE.getLog().debug("��ɱ�־��"+sIsFinish);
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "PretrialList"; //ģ����
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	if("true".equalsIgnoreCase(sIsFinish)){
		doTemp.WhereClause  = " where PretrialResult is not null";
	}else if("false".equalsIgnoreCase(sIsFinish)){
		doTemp.WhereClause  = " where PretrialResult is  null  and  ContractStatus='170'       ";
	}
	
	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);//25��һ��ҳ

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//������ʾģ�����
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
			{"true","","Button","����Ԥ��","����Ԥ��","my_add()",sResourcesPath},
			{"true","","Button","Ԥ������","Ԥ������","viewAndEdit()",sResourcesPath},
			{"true","","Button","�����������","�����������","view()",sResourcesPath},
			{"true","","Button","�ύ��ʽ����","�ύ��ʽ����","submitApply()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		};
	
	if("true".equalsIgnoreCase(sIsFinish)){
		sButtons[0][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
	}
	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function my_add()
	{ 
		//add by jli5 ����Ԥ���ж�
		var yesNo = "<%=attrstr1%>";
		if("1"!=yesNo){
			alert("����Ԥ�󣬿�ֱ�ӷ�����ʽ���롣");
			return;
		}else{
			sCompID = "MainPretrialInfo";
			sCompURL = "/CreditManage/CreditApply/MainPretrialInfo.jsp";
			sReturn = popComp(sCompID,sCompURL,"","dialogWidth=650px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			reloadSelf();
		}
	}                                                                                                                                                                                                                                                                                                                                                 
	/*~[Describe=�����������;InputParam=��;OutPutParam=��;]~*/
	function view()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "MainPretrialInfo";
		sCompURL = "/CreditManage/CreditApply/MainPretrialInfo.jsp";
		sParamString = "SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
		
	}
	

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//��ͬ��ţ�Ԥ���ţ�
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			RunMethod("BusinessManage","DeleteRelativeInfo",sSerialNo);
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}	
	

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sCompID = "PretrialManageList2";
		sCompURL = "/CreditManage/CreditApply/PretrialManageList2.jsp";
		sParamString = "SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
		
	}
	
	/*~[Describe=�ύ��ʽ����;InputParam=��;OutPutParam=��;]~*/
	function submitApply(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//������

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//�ж��Ƿ����δԤ��
		var sPara = "serialNo="+sSerialNo;
	    var returnValue =	RunJavaMethodSqlca("com.amarsoft.proj.action.PretrialApproveResult","isFinishAll",sPara);
	    if(returnValue=="false"){
	    	alert("����δԤ��ļ�¼");
	    	return;
	    }
		//��ѯԤ���������µ���ͬ������Ԥ����
		var sPretrialResult=RunMethod("BusinessManage","SelectPretrialResult",sSerialNo);
		//alert("------"+sPretrialResult);
		//returnValue = sReturns.split("@");
		//sPretrialResult = returnValue[1];
		
		//FinallySurveyResult:01�ܾ���02ͨ��
		if(sPretrialResult=="02"){
			//���º�ͬ��ѡ���Ʒ���ͼ���Ʒ
		    sCompID = "CarApplyInfo";
	        sCompURL = "/CreditManage/CreditApply/CarApplyInfo.jsp";
	        sParamString ="SerialNo="+sSerialNo;
            sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			reloadSelf();
		}else{
			alert("����Ԥ����δͨ�����޷��ύ����ʽ���룡");
			reloadSelf();
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