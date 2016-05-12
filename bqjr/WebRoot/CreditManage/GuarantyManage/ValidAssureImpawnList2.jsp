<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ��߶����ͬ����Ӧ��������Ϣ�б���Ч�ģ�;
		Input Param:
			ContractNo: ������ͬ���
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sTempletNo = "";

	//���ҳ���������������
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractNo"));
	if(sContractNo == null) sContractNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	sTempletNo = "ImpawnGuarantyList2";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//������Ϣ���µ�����	
	PG_TITLE = "������ͬ["+sContractNo+"]���µ�������Ϣ�б�@PageTitle";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//����ҳ����ʾ������
    dwTemp.setPageSize(10);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sContractNo);
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
		{"true","All","Button","����","����������Ϣ","newRecord()",sResourcesPath},
		{"true","All","Button","����","�����Ѿ��Ǽǵ�������Ϣ","importGuaranty()",sResourcesPath},
		{"true","","Button","����","�鿴������Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","All","Button","ɾ��","ɾ��������Ϣ","deleteRecord()",sResourcesPath}
	};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		//��ȡ��������
		sReturn = setObjectValue("SelectImpawnType","","",0,0,"");
		//�ж��Ƿ񷵻���Ч��Ϣ
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sImpawnType = sReturn[0];	
		OpenPage("/CreditManage/GuarantyManage/ValidAssureImpawnInfo2.jsp?ContractNo=<%=sContractNo%>&ImpawnType="+sImpawnType,"_self");
	}
	
	/*~[Describe=�����¼;InputParam=��;OutPutParam=��;]~*/
	function importGuaranty(){
		//��ȡ��������
		sReturn = setObjectValue("SelectImpawnType","","",0,0,"");
		//�ж��Ƿ񷵻���Ч��Ϣ
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sImpawnType = sReturn[0];
		sParaString = "GuarantyType"+","+sImpawnType;
		sReturn = setObjectValue("SelectImportImpawn",sParaString,"",0,0,"");	
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn = sReturn.split('@');
		sGuarantyID = sReturn[0];
		if(typeof(sGuarantyID) != "undefined" && sGuarantyID.length > 0){
			//�����������������ϵ��������
			sReturn=RunMethod("BusinessManage","AddGuarantyRelative","<%=sContractNo%>"+","+sGuarantyID+","+"Copy"+","+"Import");
			if(typeof(sReturn) != "undefined" && sReturn != "" && parseInt(sReturn) == '1'){
				alert(getBusinessMessage('864'));//��������ɹ���
				reloadSelf();
			}else{
				alert(getBusinessMessage('865'));//��������ʧ�ܣ�
				return;
			}
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sGuarantyID = getItemValue(0,getRow(),"GuarantyID");		
		if(typeof(sGuarantyID) == "undefined" || sGuarantyID.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			//�������������ϵɾ������
			sReturn=RunMethod("BusinessManage","DeleteGuarantyRelative","<%=sContractNo%>"+","+sGuarantyID);
			if(typeof(sReturn) != "undefined" && sReturn != ""){
				alert("ɾ���ɹ���");
				reloadSelf();
			}else{
				alert("ɾ��ʧ�ܣ������²�����");
				return;
			}
		}		
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		var sImpawnType = getItemValue(0,getRow(),"GuarantyType");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			OpenPage("/CreditManage/GuarantyManage/ValidAssureImpawnInfo2.jsp?ContractNo=<%=sContractNo%>&GuarantyID="+sGuarantyID+"&ImpawnType="+sImpawnType,"_self");
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

<%@	include file="/IncludeEnd.jsp"%>