<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: ̨����Ϣ
		Input Param:
			        SerialNo:̨�ʱ��
			        ObjectNo:������Ż��������
			        ObjectType����������
			        BookType ��̨������
		Output param:
		               
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "̨����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	String smyAppDate = "";
	String sAcceptedCourt = "";
	String sAcceptedDate = "";
	String sAcceptedNo = "";
	String sLawsuitStatus = "";
	
	String sJudgementNo = "";
	String sAppDate = "";
	String sCurrency = "";
	
	String sApplySum = "";
	String sApplyPrincipal = "";
	String sApplyInInterest = "";
	String sApplyOutInterest = "";
	
	String sApplyOtherSum = "";
	String sAcceptedCourt1 = "";
	
	String sLawCaseOrg = "";
	String sClaim = "";
	String sApplyDate = "";
	
	//���ҳ�����
	//̨�ʱ�š�̨������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sBookType == null) sBookType = "";
	
	//������Ż�����š��������͡���������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sLawCaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LawCaseType"));
	String sDate = StringFunction.getToday();
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sLawCaseType == null) sLawCaseType = "";
	
	//�������̨�ʡ����ϱ�ǫ̈̄�ʡ�һ��̨�ʵ������Ϣ������Ϊ�´�̨�ʵ�Ĭ��ֵ
	sSql =  " select AppDate,AcceptedCourt,AcceptedDate,AcceptedNo "+
	        " from LAWCASE_BOOK "+
	        " where ObjectNo =:ObjectNo "+ 
	        " and ObjectType =:ObjectType "+ 
	        " and (BookType='026' "+
	        " or BookType='030' "+
	        " or BookType='040' "+
	        " or BookType='050' "+
	        " or BookType='060') "+
	        " and AppDate = (select max(AppDate) "+
	        " from LAWCASE_BOOK "+
	        " where ObjectNo =:ObjectNo "+
	        " and ObjectType =:ObjectType "+
	        " and (BookType='026' "+
	        " or BookType='030' "+
	        " or BookType='040' "+
	        " or BookType='050' "+
	        " or BookType='060')) ";
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType)
	.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
   	rs = Sqlca.getASResultSet(so);   	
   	if(rs.next()){
		//����Ժ���������ڡ�������
		sAcceptedCourt = DataConvert.toString(rs.getString("AcceptedCourt"));
		sAcceptedDate = DataConvert.toString(rs.getString("AcceptedDate"));
		sAcceptedNo = DataConvert.toString(rs.getString("AcceptedNo"));
		smyAppDate = DataConvert.toString(rs.getString("AppDate"));
	}
	//����ֵת��Ϊ���ַ���
	if(sAcceptedCourt == null) sAcceptedCourt = "";
	if(sAcceptedDate == null) sAcceptedDate = "";
	if(sAcceptedNo == null) sAcceptedNo = "";
	if(smyAppDate == null) smyAppDate = "";
	
 	rs.getStatement().close();
	 	 
	//���ִ��̨�ʵ������Ϣ������Ϊ�´�ִ��̨�ʵ�Ĭ��ֵ
	sSql =  " select JudgementNo,AppDate,Currency,ApplySum,ApplyPrincipal,ApplyInInterest,"+
			" ApplyOutInterest,ApplyOtherSum,AcceptedCourt "+
	        " from LAWCASE_BOOK "+
	        " where ObjectNo =:ObjectNo "+ 
	        " and ObjectType =:ObjectType "+ 
	        " and BookType='070' "+
	        " and AppDate=(select max(AppDate) from LAWCASE_BOOK "+
	        " where  ObjectNo =:ObjectNo "+
	        " and ObjectType =:ObjectType "+
	        " and BookType='070')";
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType)
	.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
   	rs = Sqlca.getASResultSet(so);    	
   	if(rs.next()){
		//��Ч�о��顢����ִ�����ڡ�����
		sJudgementNo = DataConvert.toString(rs.getString("JudgementNo"));
		sAppDate = DataConvert.toString(rs.getString("AppDate"));
		sCurrency = DataConvert.toString(rs.getString("Currency"));		
		//����ִ���ܱ��(Ԫ)�����У�����(Ԫ)��������Ϣ(Ԫ)��������Ϣ(Ԫ)
		sApplySum = DataConvert.toString(rs.getString("ApplySum"));
		sApplyPrincipal = DataConvert.toString(rs.getString("ApplyPrincipal"));
		sApplyInInterest = DataConvert.toString(rs.getString("ApplyInInterest"));
		sApplyOutInterest = DataConvert.toString(rs.getString("ApplyOutInterest"));		
		//����(Ԫ)��ִ�з�Ժ
		sApplyOtherSum = DataConvert.toString(rs.getString("ApplyOtherSum"));
		sAcceptedCourt1 = DataConvert.toString(rs.getString("AcceptedCourt"));
	}
	//����ֵת��Ϊ���ַ���
	if(sJudgementNo == null) sJudgementNo = "";
	if(sAppDate == null) sAppDate = "";
	if(sCurrency == null) sCurrency = "";
	if(sApplySum == null) sApplySum = "";
	if(sApplyPrincipal == null) sApplyPrincipal = "";
	if(sApplyInInterest == null) sApplyInInterest = "";
	if(sApplyOutInterest == null) sApplyOutInterest = "";
	if(sApplyOtherSum == null) sApplyOtherSum = "";
	if(sAcceptedCourt1 == null) sAcceptedCourt1 = "";
	 
	rs.getStatement().close();
	 
	//��ö�Ӧ���������ϵ�λ�����Ϊԭ�桢�����а���δ�������Զ�����
	sSql =  " select LawsuitStatus from LAWCASE_INFO where SerialNo =:SerialNo ";
	//���е����ϵ�λ
	sLawsuitStatus = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sLawsuitStatus == null) sLawsuitStatus = "";
   	
   	//���Ʋ�����������Ϣ�л���Ʋ�̨�ʵ������Ϣ������Ϊ�Ʋ�̨�ʵ�Ĭ��ֵ
	if(sBookType.equals("080")){
		sSql =  " select LawCaseOrg,Claim,ApplyDate from LAWCASE_INFO where SerialNo =:SerialNo ";
	    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo)); 		
	   	if(rs.next()){
			//�Ʋ������ơ��Ʋ������ˡ������Ʋ���
			sLawCaseOrg = DataConvert.toString(rs.getString("LawCaseOrg"));
			sClaim = DataConvert.toString(rs.getString("Claim"));
			sApplyDate = DataConvert.toString(rs.getString("ApplyDate"));
		}
		//����ֵת��Ϊ���ַ���
		if(sLawCaseOrg == null) sLawCaseOrg = "";
		if(sClaim == null) sClaim = "";
		if(sApplyDate == null) sApplyDate = ""; 
		rs.getStatement().close();
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sItemdescribe = "";
	String sItemdescribe1 = "";
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//���ݲ�ͬ�İ���������ʾ��ͬ����Ч�о���
	if (sLawCaseType.equals("01"))	//һ�㰸��
		sItemdescribe1="10";
	if (sLawCaseType.equals("02"))	//��֤�ٲð���
		sItemdescribe1="20";		
		
	//���ݲ�ͬ��booktype��̨�����ͣ���ʾ��ͬ��ģ��		
	if (sBookType.equals("010")){	//֧����̨��
		sTempletNo="PaymentInfo";
		sItemdescribe="10";
	}else if (sBookType.equals("020")){	//��ǰ��ǫ̈̄��
		sTempletNo="DamageInfo";
		sItemdescribe="10";		//���ݲ�ͬ��̨�����͹���������
	}else if (sBookType.equals("026")){	//���ϱ�ǫ̈̄��
		sTempletNo="DamageInfo";
		sItemdescribe="10";		//���ݲ�ͬ��̨�����͹���������
	}else if (sBookType.equals("030")){	//����̨��
		sTempletNo="BeforeLawsuitInfo";
		sItemdescribe="10";
	}else if (sBookType.equals("040")){	//һ��̨��
		sTempletNo="FirstLawsuitInfo";
		sItemdescribe="20";
	}else if (sBookType.equals("050")){	//����̨��
		sTempletNo="SecondLawsuitInfo";
		sItemdescribe="20";
	}else if (sBookType.equals("060")){	//����̨��
		sTempletNo="LastLawsuitInfo";
		sItemdescribe="20";
	}else if (sBookType.equals("070")){	//ִ��̨��
		sTempletNo="EnforceLawsuitInfo";
		sItemdescribe="30";
	}else if (sBookType.equals("080")){	//�Ʋ�̨��
		sTempletNo="BankruptcyInfo";
	}else if (sBookType.equals("065")){	//��̨֤��
		sTempletNo="ArbitrateInfo";
	}else if (sBookType.equals("068")){	//�ٲ�̨��
		sTempletNo="NotarizationInfo";
		sItemdescribe="40";
	}
		
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д	
	
	//�����һ��/����/����/ִ��̨�ʣ���ô���Զ������о������Ǳ���
	//�����Զ��ۼ��ֶ�
	if ((sBookType.equals("040"))||(sBookType.equals("050"))||(sBookType.equals("060")))
		doTemp.appendHTMLStyle("ConfirmPI,ConfirmFee,LawyerFee,OtherFee"," onChange=\"javascript:parent.getConfirmSum()\" ");

	
	//�Զ��������а���δ�����(Ԫ)
	if(!sLawsuitStatus.equals("01"))   //�������ϵ�λΪԭ��
		doTemp.appendHTMLStyle("JudgeSum,JudgePaySum"," onChange=\"javascript:parent.getJudgeSum()\" ");
	
	if(sLawsuitStatus.equals("01"))   
		doTemp.setReadOnly("JudgeNoPaySum",false);//����ֻ��


	//���ݲ�ͬ��̨�����͹���������
	doTemp.setDDDWSql("CognizanceResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CognizanceResult' and Itemdescribe like '%"+sItemdescribe+"%' ");
	
	//���ݲ�ͬ�İ������͹�����Ч�о���
	doTemp.setDDDWSql("JudgementNo","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'JudgementNo' and Itemdescribe like '"+sItemdescribe1+"%' ");
	
	if(!(sBookType.equals("068"))){
		//ѡ�����а취��
		doTemp.setUnit("WithdrawProposerName"," <input type=button class=inputDate  value=... name=button onClick=\"javascript:parent.getAgentName()\">");
		doTemp.appendHTMLStyle("WithdrawProposerName","  style={cursor:pointer;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getAgentName()\" ");
	}
	
	
	//*****The below altered by FSGong 2005-03-01
	//���ñ��ʷ�Χ
	if (sBookType.equals("070"))	//ִ��̨��
		doTemp.setVisible("RefusedReason,Received",true);
	
	//��������¼���Ҫ����ı�
	String sTableName = "LAWCASE_INFO";
	
	//����ʱ�����¼������밸����š�̨�����ͣ�
  	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateLawCaseInfo("+sObjectNo+","+sBookType+","+sDate+")");
	
	//���±���ʱ�����¼������밸����š�̨�����ͣ�
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateLawCaseInfo("+sObjectNo+","+sBookType+","+sDate+")");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	//---------------------���尴ť�¼�------------------------------------
		
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{

		//���̨������
		var sBookType = getItemValue(0,getRow(),"BookType");		
		if (sBookType == "020" || sBookType == "026" || sBookType == "030")	//��ǰ��ȫ������̨��
		{
			//��������������������ԭ��
			var sCognizanceResult = getItemValue(0,getRow(),"CognizanceResult");
			var sChangeRequestReason = getItemValue(0,getRow(),"ChangeSuitReason");
			
			//���������Ϊ��������Ҫ�����¼�벻�������ԭ��
			if(sCognizanceResult == "1002" && (sChangeRequestReason == null || sChangeRequestReason.length == 0))
			{
				 alert("�����벻�������ԭ��");
				 return;
			}
		}
		
		if (sBookType == "070")	//ִ��̨��
		{
			//���������������ծȨƾ֤Ч�ڡ�����ծȨƾ֤���(Ԫ)
			var sCognizanceResult = getItemValue(0,getRow(),"CognizanceResult");
			var sJudgedDate = getItemValue(0,getRow(),"JudgedDate");
			var sJudgePaySum = getItemValue(0,getRow(),"JudgePaySum");
			
			//���������Ϊ����ծȨƾ֤��Ҫ�����¼������ծȨƾ֤�����Ϣ
			if(sCognizanceResult == "3007" && (sJudgedDate == null || sJudgedDate.length == 0 || sJudgePaySum == null || sJudgePaySum.length == 0))
			{
				 alert("����������ծȨƾ֤��������ծȨƾ֤Ч����Ϣ��");
				 return;
			}
		}
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;			
		}
		
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseBookList.jsp","_self","");	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=����У��;InputParam=date1,data2,rule;OutPutParam=��;]~*/
	function compareDate(date1,date2,rule){
		if(typeof(date1) != "undefined" && date1 != "" && typeof(date2) != "undefined" && date2 != "")
		{
			if(rule == "1"){
				if(date1 > date2) return true;
			}
			if(rule == "2"){
				if(date1 >= date2) return true;
			}
			if(rule == "3"){
				if(date1 < date2) return true;
			}
			if(rule == "4"){
				if(date1 <= date2) return true;
			}
		}
		return false;
	}

	
	//�о����������ϼƻ�ã����У��о���Ϣ��������ң���Ҫת��Ϊ����Һϼơ�������Ϊ����ҡ�
     function getConfirmSum(){
		fConfirmPI = getItemValue(0,getRow(),"ConfirmPI"); //�о���Ϣ
		sConfirmPICurrency = getItemValue(0,getRow(),"PICurrency");  //��Ϣ����
		fConfirmFee = getItemValue(0,getRow(),"ConfirmFee"); //����Ѻͱ�ȫ��
		fLawyerFee = getItemValue(0,getRow(),"LawyerFee"); //��ʦ�����
		fOtherFee = getItemValue(0,getRow(),"OtherFee");  //��������
     		
		if(typeof(fConfirmPI) == "undefined" || fConfirmPI.length == 0) fConfirmPI = 0; 
		if(typeof(fConfirmFee) == "undefined" || fConfirmFee.length == 0) fConfirmFee = 0; 
		if(typeof(fLawyerFee) == "undefined" || fLawyerFee.length == 0) fLawyerFee = 0; 
		if(typeof(fOtherFee) == "undefined" || fOtherFee.length == 0) fOtherFee = 0; 

		//��ȡ����sConfirmPICurrency������ҵĻ���
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAGetRMBExchangeRateDialogAjax.jsp?ReclaimCurrency="+sConfirmPICurrency,"","re				sizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sReturn = getSplitArray(sReturn);
		sRatio = sReturn[0];

		fConfirmPIRMB = fConfirmPI/sRatio;  //ת��Ϊ�����
     		
 		fConfirmSum = fConfirmPIRMB+fConfirmFee+fLawyerFee+fOtherFee;
        setItemValue(0,getRow(),"JudgeSum",fConfirmSum);
    }
		
	/*~[Describe=ѡ������������;InputParam=��;OutPutParam=��;]~*/
	function getAgencyName(){
		sParaString = "AgencyType"+",01";
		setObjectValue("SelectAgency",sParaString,"@AcceptedCourt@1",0,0,"");	
	}
	
	/*~[Describe=ѡ�����а취��;InputParam=��;OutPutParam=��;]~*/
	function getAgentName(){
		sParaString = "AgentType"+",01";
		var sReturn = setObjectValue("SelectAgent",sParaString,"",0,0,"");
		if (!(sReturn == '_CANCEL_' || typeof(sReturn) == "undefined" || sReturn.length == 0 || sReturn == '_CLEAR_')){
			sReturn = sReturn.split("@");
			//��������
			var sAgentName = sReturn[2];
			setItemValue(0,0,"WithdrawProposerName",sAgentName);			
		}else if (sReturn=='_CLEAR_'){
			setItemValue(0,0,"WithdrawProposerName","");
		}else{
			return;
		}
	}
	
	/*~[Describe=ѡ�������;InputParam=��;OutPutParam=��;]~*/
	function getCurrentAgent(){
		sParaString = "AgentType"+",02";
		var sReturn = setObjectValue("SelectAgent",sParaString,"",0,0,"");
		if (!(sReturn == '_CANCEL_' || typeof(sReturn) == "undefined" || sReturn.length == 0 || sReturn == '_CLEAR_')){
			sReturn = sReturn.split("@");		
			//���������ơ���������������
			var sAgentName = sReturn[1];
			var sBelongAgency = sReturn[3];
			
			setItemValue(0,0,"CurrentAgent",sAgentName);
			setItemValue(0,0,"WithdrawName",sBelongAgency);
		}else if (sReturn=='_CLEAR_'){
			setItemValue(0,0,"CurrentAgent","");
			setItemValue(0,0,"WithdrawProposerName","");
		}else{
			return;
		}
	}
	
	/*~[Describe=ִ����������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�		
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;	
			
			//̨������
			setItemValue(0,0,"BookType","<%=sBookType%>");					
			//�������͡�������
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
						
			var sBookType = "<%=sBookType%>";			
			if(sBookType == "026" || sBookType == "030" || sBookType == "040" || sBookType == "050" || sBookType == "060"){
				//����Ժ���������ڡ������š���������
				setItemValue(0,0,"AcceptedCourt","<%=sAcceptedCourt%>");
				setItemValue(0,0,"AcceptedDate","<%=sAcceptedDate%>");
				setItemValue(0,0,"AcceptedNo","<%=sAcceptedNo%>");
				setItemValue(0,0,"AppDate","<%=smyAppDate%>");				
			}
			
			if(sBookType == "070"){
				//��Ч�о��顢����ִ�����ڡ�����
				setItemValue(0,0,"JudgementNo","<%=sJudgementNo%>");
				setItemValue(0,0,"AppDate","<%=sAppDate%>");
				setItemValue(0,0,"Currency","<%=sCurrency%>");
				
				//����ִ���ܱ��(Ԫ)�����У�����(Ԫ)��������Ϣ(Ԫ)��������Ϣ(Ԫ)
				setItemValue(0,0,"ApplySum","<%=DataConvert.toMoney(sApplySum)%>");
				setItemValue(0,0,"ApplyPrincipal","<%=DataConvert.toMoney(sApplyPrincipal)%>");
				setItemValue(0,0,"ApplyInInterest","<%=DataConvert.toMoney(sApplyInInterest)%>");
				setItemValue(0,0,"ApplyOutInterest","<%=DataConvert.toMoney(sApplyOutInterest)%>");
				
				//����(Ԫ)��ִ�з�Ժ
				setItemValue(0,0,"ApplyOtherSum","<%=DataConvert.toMoney(sApplyOtherSum)%>");
				setItemValue(0,0,"AcceptedCourt","<%=sAcceptedCourt1%>");
			}
			
			if(sBookType == "080"){
				//�Ʋ������ơ��Ʋ������ˡ������Ʋ���
				setItemValue(0,0,"BankruptcyOrgName","<%=sLawCaseOrg%>");
				setItemValue(0,0,"ApplyRequest","<%=sClaim%>");
				setItemValue(0,0,"AppDate","<%=sApplyDate%>");
			}
						
			//�Ǽ��ˡ��Ǽ������ơ��Ǽǻ������Ǽǻ�������
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			
			//�Ǽ�����						
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "LAWCASE_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}	

	//�Զ��������а���δ�����(Ԫ)
	function getJudgeSum(){ 
		sJudgeSum = getItemValue(0,getRow(),"JudgeSum");
		sJudgePaySum = getItemValue(0,getRow(),"JudgePaySum");
		
		if(typeof(sJudgeSum)=="undefined" || sJudgeSum.length==0) sJudgeSum=0; 
		if(typeof(sJudgePaySum)=="undefined" || sJudgePaySum.length==0) sJudgePaySum=0;
		
		sJudgeNoPaySum = sJudgeSum-sJudgePaySum;
		
		setItemValue(0,getRow(),"JudgeNoPaySum",sJudgeNoPaySum);
 	}
	
	//������������У����𣬱�����Ϣ��������Ϣ����������������ܶ�	
	function getAimSum(){ 
       	sApplyPrincipal = getItemValue(0,getRow(),"ApplyPrincipal");
       	sApplyInInterest = getItemValue(0,getRow(),"ApplyInInterest");
       	sApplyOutInterest = getItemValue(0,getRow(),"ApplyOutInterest");
       	sApplyOtherSum = getItemValue(0,getRow(),"ApplyOtherSum");

       	sCurrency = getItemValue(0,getRow(),"Currency");
   
       	if(typeof(sApplyPrincipal)=="undefined" || sApplyPrincipal.length==0) sApplyPrincipal=0; 
       	if(typeof(sApplyInInterest)=="undefined" || sApplyInInterest.length==0) sApplyInInterest=0;
       	if(typeof(sApplyOutInterest)=="undefined" || sApplyOutInterest.length==0) sApplyOutInterest=0; 
       	if(typeof(sApplyOtherSum)=="undefined" || sApplyOtherSum.length==0) sApplyOtherSum=0; 
      
		//��ȡ����sCurrency������ҵĻ���
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAGetRMBExchangeRateDialogAjax.jsp?ReclaimCurrency="+sCurrency,"","re				sizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sReturn = getSplitArray(sReturn);
		sRatio=sReturn[0];
		sApplyOtherSum=sApplyOtherSum*sRatio;  //ת��Ϊ���

		//alert(sApplyPrincipal+"=="+sApplyInInterest+"=="+sApplyOutInterest+"=="+sApplyOtherSum);
       	//�����ܱ��=���У�����+������Ϣ+������Ϣ+����
       	sApplySum = sApplyPrincipal+sApplyInInterest+sApplyOutInterest+sApplyOtherSum;

		setItemValue(0,getRow(),"ApplySum",sApplySum);
 	}
 	
 	//������������У����𣬱�����Ϣ��������Ϣ�����������ʵ�����ܽ��	
	function getActualSum(){ 
		sActualPrincipal = getItemValue(0,getRow(),"ActualPrincipal");
		sActualInInterest = getItemValue(0,getRow(),"ActualInInterest");
		sActualOutInterest = getItemValue(0,getRow(),"ActualOutInterest");
		sActualOtherSum = getItemValue(0,getRow(),"ActualOtherSum");
		
		sCurrency = getItemValue(0,getRow(),"Currency");
		
		if(typeof(sActualPrincipal)=="undefined" || sActualPrincipal.length==0) sActualPrincipal=0; 
		if(typeof(sActualInInterest)=="undefined" || sActualInInterest.length==0) sActualInInterest=0;
		if(typeof(sActualOutInterest)=="undefined" || sActualOutInterest.length==0) sActualOutInterest=0; 
		if(typeof(sActualOtherSum)=="undefined" || sActualOtherSum.length==0) sActualOtherSum=0; 
    
		//��ȡ����sCurrency������ҵĻ���
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDAGetRMBExchangeRateDialogAjax.jsp?ReclaimCurrency="+sCurrency,"","re				sizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sReturn = getSplitArray(sReturn);
		sRatio=sReturn[0];
		sActualOtherSum=sActualOtherSum*sRatio;  //ת��Ϊ���

		//�����ܱ��=���У�����+������Ϣ+������Ϣ+����
		sActualSum = sActualPrincipal+sActualInInterest+sActualOutInterest+sActualOtherSum;
	
     	setItemValue(0,getRow(),"ActualSum",sActualSum);
 	}
	</script>
	
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

