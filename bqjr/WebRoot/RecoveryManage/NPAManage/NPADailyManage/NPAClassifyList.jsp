<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: ���շ����б�;
		Input Param:	
			ClassifyType���������ͣ�010������ɷ��ࣻ020������ɷ��ࣩ
			ObjectType���������ͣ�����ͬ��BusinessContract������ݣ�BusinessDueBill��
			ObjectNo����ͬ��ˮ��
		Output Param:
			
		HistoryLog: zywei 2005/09/08 �������պ�ͬ/��ݷ���
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʲ����շ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������	
	String sTempletNo = "";
	String sUserID = CurUser.getUserID(); //�û�ID
	
	//����������
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType")); 
	String sClassifyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassifyType"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sClassifyType == null) sClassifyType = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sFinishType == null) sFinishType = "";
	if(sFinishType == null) sFinishType = "";
	//���ҳ�����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�����ͷ�ļ�
	if(sObjectType.equals("BusinessDueBill")) //����ݷ���
		sTempletNo = "ManagerNPAClassifyList2";
		
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sClassifyType.equals("010")){ //����ɷ���
		doTemp.WhereClause += " and (CLASSIFY_RECORD.FinishDate = ' ' or CLASSIFY_RECORD.FinishDate is null)";
	}else if(sClassifyType.equals("020")){ //����ɷ���
		doTemp.WhereClause += " and (CLASSIFY_RECORD.FinishDate <> ' ' and CLASSIFY_RECORD.FinishDate is not null)";
	}
	//����3λ1��
	//doTemp.setType("BusinessSum,Balance","Number");
	//���ӹ�����			
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style = "1";  //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
    dwTemp.setPageSize(20);
    
	//����setEvent
	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteClassifyData(#ObjectType,#ObjectNo,#SerialNo)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sUserID);
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
			{(sFinishType.equals("")?"true":"false"),"","Button","��������","��������","newRecord()",sResourcesPath},
			{(sClassifyType.equals("010")?"true":"false"),"","Button","ģ�ͷ���","ģ�ͷ���","Model()",sResourcesPath},
			{(sClassifyType.equals("020")?"true":"false"),"","Button","ģ�ͷ�������","�鿴ģ�ͷ�������","Model()",sResourcesPath},
			{(sClassifyType.equals("010")?"true":"false"),"","Button","�����϶�","�����϶�","viewAndEdit()",sResourcesPath},		
			{(sClassifyType.equals("020")?"true":"false"),"","Button","�����϶�����","�鿴�����϶�����","viewAndEdit()",sResourcesPath},				
			{(sFinishType.equals("")?"true":"false"),"","Button","�������","�������","Finished()",sResourcesPath},	
			{(sFinishType.equals("")?"true":"false"),"","Button","ɾ��","ɾ������","deleteRecord()",sResourcesPath}	,
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
	/*~[Describe=���������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		sReturn = popComp("NPAClassifyDialog","/RecoveryManage/NPAManage/NPADailyManage/NPAClassifyDialog.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ModelNo=Classify1","dialogWidth=30;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=ɾ�������¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm("��ȷ��ɾ��������¼��")){
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=ģ�ͷ���;InputParam=��;OutPutParam=��;]~*/
	function Model(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenComp("ClassifyDetails","/CreditManage/CreditCheck/ClassifyDetail.jsp","ComponentName=���շ���ο�ģ��&Action=_DISPLAY_&ObjectType=Classify&ObjectNo="+sObjectNo+"&ResultType=BusinessDueBill&AccountMonth="+sAccountMonth+"&SerialNo="+sSerialNo+"&ModelNo=Classify1&ClassifyType=<%=sClassifyType%>","_blank",OpenStyle);
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
		
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPAClassifyInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&ClassifyType=<%=sClassifyType%>", "_self","");
	}
	
	/*~[Describe=��ɷ���;InputParam=��;OutPutParam=��;]~*/
	function Finished(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sResult1 = getItemValue(0,getRow(),"Result1");
		if (typeof(sResult1)=="undefined" || sResult1.length==0){
			alert("���շ���û����ɣ�");
			return;
		}
		if(confirm("��ȷ���Ѿ����������")){
			//�϶���ɲ���
			sFinishDate = "<%=StringFunction.getToday()%>";
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishDate@"+sFinishDate+",CLASSIFY_RECORD,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
				alert("����ʲ����շ���ʧ�ܣ�");
				return;			
			}else{
				reloadSelf();	
				alert("����ʲ����շ���ɹ�!");	
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
