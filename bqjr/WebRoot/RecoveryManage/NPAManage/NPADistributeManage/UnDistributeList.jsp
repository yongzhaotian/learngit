<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-12-04
*	Tester:
*	Describe: δ�ַ������ʲ���Ϣ�б�
*	Input Param:
*	Output Param:  
*		RecoveryUserID  :��ȫ������ԱID
*   	SerialNo	:��ͬ��ˮ��
*		sShiftType	:�ƽ�����
*	
	HistoryLog:slliu 2004.12.17
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ�ַ������ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������	    
	String sSql = "";
	
	//����������
	
	//���ҳ�����
			
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	
	String sTempletNo = "UnDistributeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	String OrgID=CurOrg.getOrgID();

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);//20��һ��ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(OrgID);//������ʾģ�����
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
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		{"true","","Button","ָ��������","ָ����ͬ�ܻ��˻��߸����ˣ�תΪ�ѷַ�","my_Distribute()",sResourcesPath},
		{"true","","Button","���ƽ�","����ͬ�˻ظ�ԭ�ܻ���","my_ReverseHandover()",sResourcesPath}
		};

/*added by FSGong 2005-03-30
	���ݸ߿Ƴ�Ҫ������ָ�������˹���
	ԭָ�������˲��䣺����ǿͻ��ƽ�����ָ���ܻ��ˣ�ͬʱ�ƽ�������������ƽ�����ָ�������ˣ�ͬʱ�ƽ���
	����ָ�������ˣ�	  ����ǿͻ��ƽ�����ָ�������ˣ����ƽ�������������ƽ�����ָ�������ˣ�ͬʱ�ƽ���
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ָ����ȫ��������;InputParam=��;OutPutParam=��;]~*/   
	function my_Distribute(){
		//��ú�ͬ��ˮ�š��ƽ�����
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sShiftType = getItemValue(0,getRow(),"ShiftType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			//�����Ի�ѡ���
			var sRecovery = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sRecovery)!="undefined" && sRecovery.length!=0){
				sRecovery = sRecovery.split("@");
				var sRecoveryUserID = sRecovery[0];
				var sRecoveryUserName = sRecovery[1];
				var sRecoveryOrgID = sRecovery[2];
				var sReturn = PopPageAjax("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserActionAjax.jsp?"+
					 "RecoveryUserID="+sRecoveryUserID+"&RecoveryOrgID="+sRecoveryOrgID+"&SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"","","");
				if(sReturn == "true"){ //ˢ��ҳ��
					if(sShiftType=="02"){
						alert("�ò����ʲ��ɹ��ַ�����"+sRecoveryUserName+"���ܻ���");
						self.location.reload();
					}else{
						alert("�ò����ʲ��ɹ��ַ�����"+sRecoveryUserName+"�����٣�");
						self.location.reload();
					}
				}else{
					if(sShiftType=="02"){
						alert("�ò����ʲ��ַ�����"+sRecoveryUserName+"���ܻ�ʧ�ܣ�");
						self.location.reload();
					}else{
						alert("�ò����ʲ��ַ�����"+sRecoveryUserName+"������ʧ�ܣ�");
						self.location.reload();
					}
				}
			}
		}
	}
		
	/*~[Describe=�����ƽ���¼;InputParam=��;OutPutParam=��;]~*/	
	function my_ReverseHandover(){
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			if(confirm(getBusinessMessage('785'))){ //������뽫�˲����ʲ��˻ظ�ԭ�ܻ�����
				var sReturn = PopPageAjax("/RecoveryManage/Public/NPAShiftActionAjax.jsp?SerialNo="+sSerialNo+"&Type=2","","");
				if(sReturn == "true"){ //ˢ��ҳ��
					alert(getBusinessMessage('784')); //�ò����ʲ��ѳɹ��˻ظ�ԭ�ܻ��ˣ�
					self.location.reload();
				}
			}
		}
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

<%@include file="/IncludeEnd.jsp"%>