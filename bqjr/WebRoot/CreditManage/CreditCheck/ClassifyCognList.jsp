<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: ���շ����϶��б�;
		Input Param:			
			ClassifyType���������ͣ�010������ɷ��ࣻ020������ɷ��ࣩ
			ObjectType���������ͣ�����ͬ��BUSINESS_CONTRACT������ݣ�BUSINESS_DUEBILL��
		Output Param:
			
		HistoryLog:zywei 2005/09/23 �������պ�ͬ/��ݷ���
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���շ����϶��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "";
	String sSortNo = CurOrg.getSortNo(); //����ID
	String sOrgLevel = CurOrg.getOrgLevel();//��������0�����У�3�����У�6��֧�У�9�����㣩
	
	//����������
	String sClassifyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassifyType"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//����ֵת��Ϊ���ַ���
	if(sClassifyType == null) sClassifyType = "";
	if(sObjectType == null) sObjectType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//����ֵת��Ϊ���ַ���
	if(sOrgLevel == null) sOrgLevel = "";
	//�����ͷ�ļ�
	if(sObjectType.equals("BusinessContract")){ //����ͬ����
		if(sOrgLevel.equals("0")) //����
			sTempletNo = "HeadClassifyList1";
		if(sOrgLevel.equals("3")) //����
			sTempletNo = "BranchClassifyList1";
		if(sOrgLevel.equals("6")) //֧��
			sTempletNo = "SubbranchClassifyList1";
	}	
	if(sObjectType.equals("BusinessDueBill")){ //����ݷ���
		if(sOrgLevel.equals("0")) //����
			sTempletNo = "HeadClassifyList2";
		if(sOrgLevel.equals("3")) //����
			sTempletNo = "BranchClassifyList2";
		if(sOrgLevel.equals("6")) //֧��
			sTempletNo = "SubbranchClassifyList2";
	}
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(sClassifyType.equals("010")){ //���϶�����
		if(sOrgLevel.equals("0")){ //���з��շ����϶�
			doTemp.WhereClause += " and (CLASSIFY_RECORD.FinishDate5 = ' ' or CLASSIFY_RECORD.FinishDate5 is null) and CLASSIFY_RECORD.FinishDate3 is not null and CLASSIFY_RECORD.FinishDate3 <> ' ' ";
		}
		if(sOrgLevel.equals("3")){ //���з��շ����϶�
			doTemp.WhereClause += " and (CLASSIFY_RECORD.FinishDate3 = ' ' or CLASSIFY_RECORD.FinishDate3 is null) and CLASSIFY_RECORD.FinishDate2 is not null and CLASSIFY_RECORD.FinishDate2 <> ' ' ";
		}
		if(sOrgLevel.equals("6")){ //֧�з��շ����϶�
			doTemp.WhereClause += " and (CLASSIFY_RECORD.FinishDate2 = ' ' or CLASSIFY_RECORD.FinishDate2 is null) ";
		}
	}
	
	if(sClassifyType.equals("020")){ //���϶�����
		if(sOrgLevel.equals("0")){ //���з��շ����϶�
			doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate5 <> ' ' and CLASSIFY_RECORD.FinishDate5 is not null and CLASSIFY_RECORD.ResultUserID5='"+CurUser.getUserID()+"' ";
		}
		if(sOrgLevel.equals("3")){ //���з��շ����϶�
	    	doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate3 <> ' ' and CLASSIFY_RECORD.FinishDate3 is not null and CLASSIFY_RECORD.ResultUserID3='"+CurUser.getUserID()+"' ";
		}
		if(sOrgLevel.equals("6")){ //֧�з��շ����϶�
		 	doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate2 <> ' ' and CLASSIFY_RECORD.FinishDate2 is not null and CLASSIFY_RECORD.ResultUserID2='"+CurUser.getUserID()+"' ";
		}
	}
	
	doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate <> ' ' and CLASSIFY_RECORD.FinishDate is not null ";
		
	//���ò�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
    dwTemp.setPageSize(20);

	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sSortNo);
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
		{"true","","Button","ģ�ͷ�������","�鿴ģ�ͷ�������","Model()",sResourcesPath},
		{(sClassifyType.equals("010")?"true":"false"),"","Button","�����϶�","�����϶�","viewAndEdit()",sResourcesPath},		
		{(sClassifyType.equals("020")?"true":"false"),"","Button","�����϶�����","�鿴�����϶�����","viewAndEdit()",sResourcesPath},				
		{(sClassifyType.equals("010")?"true":"false"),"","Button","�������","�������","Finished()",sResourcesPath},	
		{(sObjectType.equals("BusinessContract")?"true":"false"),"","Button","��ͬ����","�鿴��ͬ����","ContractInfo()",sResourcesPath},
		{(sObjectType.equals("BusinessDueBill")?"true":"false"),"","Button","�������","�鿴�������","DueBillInfo()",sResourcesPath}	
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴ģ�ͷ�������;InputParam=��;OutPutParam=��;]~*/
	function Model(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");		
		var sObjectType = getItemValue(0,getRow(),"ObjectType");

		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenComp("ClassifyDetails","/CreditManage/CreditCheck/ClassifyDetail.jsp","ComponentName=���շ���ο�ģ��&Action=_DISPLAY_&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&AccountMonth="+sAccountMonth+"&SerialNo="+sSerialNo+"&ModelNo=Classify1&ClassifyType=020"+ "&ResultType=" + sObjectType,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/CreditManage/CreditCheck/ClassifyCognInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&ClassifyType=<%=sClassifyType%>", "_self","");
	}
	
	/*~[Describe=��ɷ���;InputParam=��;OutPutParam=��;]~*/
	function Finished(){
		var sOrgLevel = "<%=sOrgLevel%>"; 
		var sResult = "";
		var sFieldName = "";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��Result1
			return;
		}
		if(sOrgLevel == "0"){ //����
			sResult = getItemValue(0,getRow(),"Result5");
			sFieldName = "FinishDate5"
		}
		if(sOrgLevel == "3"){ //����
			sResult = getItemValue(0,getRow(),"Result3");
			sFieldName = "FinishDate3"
		}
		if(sOrgLevel == "6"){ //֧��
			sResult = getItemValue(0,getRow(),"Result2");
			sFieldName = "FinishDate2"
		}
		if (typeof(sResult)=="undefined" || sResult.length==0){
			alert(getBusinessMessage('658'));//���շ���û����ɣ�
			return;
		}
		if(confirm(getBusinessMessage('659'))){ //��ȷ���Ѿ����������
			//�϶���ɲ���
			sFinishDate = "<%=StringFunction.getToday()%>";
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@"+sFieldName+"@"+sFinishDate+",CLASSIFY_RECORD,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
				alert(getBusinessMessage('660'));//����ʲ����շ���ʧ�ܣ�
				return;			
			}else{
				reloadSelf();	
				alert(getBusinessMessage('661'));	//����ʲ����շ���ɹ���
			}
		}
	}
	
	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function ContractInfo(){ 
		//��ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("AfterLoan",sSerialNo,"002");
	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function DueBillInfo(){
		//�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("BusinessDueBill",sSerialNo,"002");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
