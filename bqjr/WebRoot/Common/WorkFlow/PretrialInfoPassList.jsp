<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "Ԥ����Ϣ";
	 
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PretrialInfoList";//����ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    doTemp.WhereClause = " where State <> '001' and inputuserid='"+CurUser.getUserID()+"'";
	
	
    
	doTemp.generateFilters(Sqlca);
	//���ƵǼ����ڲ�ѯ����ѡ��
	doTemp.setFilter(Sqlca, "0350", "InputDate", "Operators=BetweenString,BeginsWith;");
	doTemp.parseFilterData(request,iPostChange);

	// û�������κ�������ֻ�ܲ�ѯ��ѯ��������
	if(!doTemp.haveReceivedFilterCriteria()) {
		doTemp.WhereClause += " and (to_date(to_char(SYSDATE,'YYYY/MM/DD'),'YYYY/MM/DD')-to_date(to_char(to_date(InputDate,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD'),'YYYY/MM/DD'))=0";
	} else {
		//�������κ�������ֻ�ܲ�ѯ3�����ڵ�����
	    doTemp.WhereClause += " and months_between(to_date(to_char(SYSDATE,'YYYY/MM/DD'),'YYYY/MM/DD'),to_date(to_char(to_date(InputDate,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD'),'YYYY/MM/DD'))<=3";
	}
	
	//���������ַ�����
	for(int k=0;k<doTemp.Filters.size();k++){
		
		//��������������ܺ���%��_����
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null 
				&& (doTemp.Filters.get(k).sFilterInputs[0][1].contains("%") 
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("_")
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("#")
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("$"))){
			%>
			<script type="text/javascript">
				alert("������������ܺ���['%'��'_'��'#'��'$']����!");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
			break;
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);//���÷�ҳ����
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","�ύ��һ��","�ύ��Ʒ����","submit()",sResourcesPath},
		{"true","","Button","ȡ������","ȡ���ñ���Ϣ","cancelData()",sResourcesPath},
	};
	
	//���ڿ��Ƶ��а�ť��ʾ��������  
	String iButtonsLineMax = "5";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = ""; //���SQL���
	ASResultSet rs = null; //��Ų�ѯ�����
	String sPhaseTypeSet = ""; //��Ž׶�������
	String sObjectType = ""; //��Ŷ�������
	String sInitFlowNo = ""; 
	String sInitPhaseNo = "";
	
	//����������:��������,�׶�����
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String transactionFilter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransactionFilter",10));
	String stuApplyType= DataConvert.toRealString(iPostChange,(CurComp.getParameter("subApplyType")));
	//����ֵת���ɿ��ַ���
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(transactionFilter == null) transactionFilter = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
    //�����ŵ�
    String sSNo = CurUser.getAttribute8();
    if(sSNo == null) sSNo = "";
    
    
	//�����������(��������)�Ӵ����CODE_LIBRARY�л��ApplyMain����ͼ�Լ�������Ľ׶�,���̶�������,ApplyListʹ���ĸ�ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApplyType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
	if(rs.next()){
		sPhaseTypeSet = rs.getString("ItemDescribe");
		sObjectType = rs.getString("ItemAttribute");
		if(sPhaseTypeSet == null) sPhaseTypeSet = "";
		if(sObjectType == null) sObjectType = "";
	}else{
		throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApplyType:"+sApplyType+"����");
	}
	rs.getStatement().close();
	//�����������(��������)�Ӵ����CODE_LIBRARY�л��Ĭ������ID
	sSql = " select Attribute2 from CODE_LIBRARY where CodeNo = 'ApplyType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
	while(rs.next()){
		sInitFlowNo = rs.getString("Attribute2");
		if(sInitFlowNo == null) sInitFlowNo = "";
	}
	rs.getStatement().close();
	
	//����Ĭ������ID�����̱�FLOW_CATALOG�л�ó�ʼ�׶�
	sSql = " select InitPhase from FLOW_CATALOG where FlowNo =:FlowNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("FlowNo",sInitFlowNo));
	while(rs.next()){
		sInitPhaseNo = rs.getString("InitPhase");
		if(sInitPhaseNo == null) sInitPhaseNo = "";
	}
	rs.getStatement().close();
	%>

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*~[Describe=ȡ�� */%>
	function cancelData(){
		var SERIALNO = getItemValue(0,getRow(),"SERIALNO");
		var STATE    = getItemValue(0,getRow(),"STATE");
		if (typeof(SERIALNO)=="undefined" || SERIALNO.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}else{
			if(STATE=="002"){
				if (confirm("��ȷ��Ҫȡ���ñ�Ԥ��������")) {
					RunMethod("���÷���", "UpdateColValue", "Pretrial_Info,STATE,005,SERIALNO='"+SERIALNO+"'");
				}
			}else{
					alert("ֻ��ȡ��Ԥ��ͨ�������ݣ�");
			}
		}
		reloadSelf();	
	}
	<%/*~[Describe=�ύ��һ��  */%>
	function submit(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sState = getItemValue(0,getRow(),"STATE");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}else{
			if(sState=="002"){
			var SERIALNO = getItemValue(0,getRow(),"SERIALNO");
			var CustomerID = getItemValue(0,getRow(),"CustomerID");
			var CustomerName = getItemValue(0,getRow(),"CustomerName");
			var CertID = getItemValue(0,getRow(),"CertID");
			var MobileTelephone = getItemValue(0,getRow(),"MobileTelephone");
			var WorkCorp = getItemValue(0,getRow(),"WorkCorp");
			var SelfMonthIncome = getItemValue(0,getRow(),"SelfMonthIncome");
			var RelativeType = getItemValue(0,getRow(),"RelativeType");
			var KinshipName = getItemValue(0,getRow(),"KinshipName");
			var KinshipTel = getItemValue(0,getRow(),"KinshipTel");
			var Contactrelation = getItemValue(0,getRow(),"Contactrelation");
			var OtherContact = getItemValue(0,getRow(),"OtherContact");
			var ContactTel = getItemValue(0,getRow(),"ContactTel");
			var InteriorCode = getItemValue(0,getRow(),"InteriorCode");

			//��jsp�еı���ֵת����js�еı���ֵ
			var sObjectType = "<%=sObjectType%>";	
			var sApplyType = "<%=sApplyType%>";	
			var ssSubApplyType="<%=stuApplyType%>";
			var sPhaseType = "<%=sPhaseType%>";
			var sInitFlowNo = "<%=sInitFlowNo%>";
			var sInitPhaseNo = "<%=sInitPhaseNo%>";


			var sUserID = "<%=CurUser.getUserID()%>";
			// add by xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
			//var sStore = RunMethod("BusinessManage","getStore",sUserID);
			var sSno = "<%=CurUser.getAttribute8()%>";
			var sStore = RunMethod("BusinessManage","getStoreNew",sSno);
			// end by xswang 2015/06/01
			var ssCity=RunMethod("GetElement","GetElementValue","city,user_info,userid='"+sUserID+"'");
			
			if(typeof(sStore)=="undefined" || sStore.length==0 || sStore == "Null"){
				alert("ѡ�������ŵ�Ϊ�գ�������ҳ��ť�Աߵ���ŵ�ѡ���ŵ�����ѡ���ŵ꣡");
				return;
			}
			var subProductType=null;
			if(sApplyType == "CreditLineApply"){
				if(ssSubApplyType=="StuEducation"){//����ѧ��������
					subProductType = 5;
				}else if("AdultEducation"==ssSubApplyType){//������˽�����
					subProductType = 4;
				}else if("ssSubApplyType"==ssSubApplyType){//����ѧ������
					subProductType = 7;
				}else{
					subProductType = 0;//������ͨ���Ѵ�
				}
			}else if (sApplyType == "NoOrderdCashApply"){//������ԤԼ�ֽ��
					subProductType = 2;
			}
			
			if(confirm("��ǰ��¼�����ŵ�Ϊ��\n\r"+sStore+"\n\r�Ƿ�ȷ���ڸ��ŵ귢�����룿")){
				var rValues=RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getCreditID", "ProductType="+subProductType+",citys="+ssCity);
				 if(rValues=="false"){
					alert("�ó����²�Ʒ����Ϊ���Ѵ�û����ش����ˣ�");
					return;
				} 
				//����������������Ի���
				if(sApplyType == "CreditLineApply"){
					if(ssSubApplyType=="StuEducation"){//����ѧ��������
						sCompID = "CreditLineApplyCreationInfo";
						sCompURL = "/BusinessManage/ApplyEducationMain/CreditEducationApplyCreationInfo.jsp";
						subProductType="5";
					} else if("AdultEducation"==ssSubApplyType){//������˽�����
						sCompID = "CreditLineApplyCreationInfo";
						sCompURL = "/BusinessManage/ApplyEducationMain/CreditEducationApplyCreationInfo.jsp";
						subProductType="4";
					}else if( "StuPos" == ssSubApplyType ){//ѧ�����Ѵ�   add by dahl
						sCompID = "CreditStuPosApplyCreationInfo";
						sCompURL = "/CreditManage/CreditApply/CreditStuPosApplyCreationInfo.jsp";	 
						subProductType="7";
					}else{//��ͨ���Ѵ�
				 		sCompID = "CreditLineApplyCreationInfo";
						sCompURL = "/CreditManage/CreditApply/CreditLineApplyCreationInfo.jsp";	 
					}
				}else if (sApplyType == "NoOrderdCashApply"){//������ԤԼ�ֽ��
					sCompID = "NoOrderdCashApplyInfo";
					sCompURL = "/CreditManage/CashLoan/NoOrderdCashApplyInfo.jsp";	 
					subProductType="2";
				}else{
					sCompID = "CreditApplyCreation";
					sCompURL = "/CreditManage/CreditApply/CreditApplyCreationInfoAll.jsp";
				}
				 var ParamString="ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo+"&SubProductType="+subProductType
				     +"&SERIALNO="+SERIALNO+"&CustomerID="+CustomerID+"&CustomerName="+CustomerName+"&CertID="+CertID+"&MobileTelephone="+MobileTelephone+"&WorkCorp="+WorkCorp
			         +"&SelfMonthIncome="+SelfMonthIncome+"&RelativeType="+RelativeType+"&KinshipName="+KinshipName+"&KinshipTel="+KinshipTel+"&Contactrelation="+Contactrelation+"&OtherContact="+OtherContact+"&ContactTel="+ContactTel+"&InteriorCode="+InteriorCode;
				sReturn = popComp(sCompID,sCompURL,ParamString,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
				if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
				sReturn = sReturn.split("@");
				sObjectNo=sReturn[0];

				//add by qfang �����жϣ����Ϊ"�����¹����ò�Ʒ"���򵯳�ҳ�棬��ʾҵ��Ʒ�ַ����������־λ�ֶ�
				sObjectType=sReturn[1];	
				if(sReturn[2] != null){ 
					sTypeNo=sReturn[2];
					sSortReturn = RunMethod("CreditLine","CheckProductSortFlag",sTypeNo);
					if(sSortReturn.split("@")[0] == "true"){
						popComp("SortFlagInfo","/CreditManage/CreditApply/SortFlagInfo.jsp","TypeNo="+sTypeNo+"&ObjectNo="+sObjectNo,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");		
					}
				} 
				//add end
				
		         //���������������ˮ�ţ��������������
				sCompID = "CreditTab";
				sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
				sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle); 
			}
			reloadSelf();	
			}else{
				alert("ֻ����Ԥ��ͨ���������ύ��һ����");
			}
		}
	}
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newApply(){
			
	}
	
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>