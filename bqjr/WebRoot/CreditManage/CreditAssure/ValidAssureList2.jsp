<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-12-6
		Tester:
		Describe: ��߶����ͬ�б���Ч�ģ���һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:
				
		Output Param:
				
		HistoryLog:  pwang 2009-08-13 ����������ť
										
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��߶����ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String sSortNo=CurOrg.getSortNo();
	//����������
	
	//���ҳ�����

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sTempletNo = "ValidAssureList2";//ģ�ͱ��
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  
	//���ù�����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����ҳ����ʾ������
	dwTemp.setPageSize(10);
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
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
		{"true","","Button","����","������߶����ͬ","newContract()",sResourcesPath},
		{"true","","Button","����","�鿴������ͬ��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�����ͻ�����","�鿴������ͬ��صĵ����ͻ�����","viewCustomerInfo()",sResourcesPath},
		{"true","","Button","���ҵ������","�鿴������ͬ��ص�ҵ���ͬ��Ϣ�б�","viewBusinessInfo()",sResourcesPath},
		{"true","","Button","����ʧЧ","ʧЧ������ͬ","statusChange()",sResourcesPath},
		{"true","","Button","������ͬ���","��ѯ������ͬ���","getGuarantyBalance()",sResourcesPath},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=������߶����ͬ;InputParam=��;OutPutParam=��;]~*/
	function newContract(){
		var sGuarantyType2=PopPage("/CreditManage/CreditAssure/AddAssureDialog2.jsp","","resizable=yes;dialogWidth=400px;dialogHeight=150px;center:yes;status:no;statusbar:no");
		if(typeof(sGuarantyType2) != "undefined" && sGuarantyType2.length != 0 && sGuarantyType2 != '_none_'){
			OpenPage("/CreditManage/CreditAssure/ValidAssureInfo5.jsp?GuarantyType="+sGuarantyType2,"right");
		}	
	}
	

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//��������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//������ͬ���
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		} else {
			OpenPage("/CreditManage/CreditAssure/ValidAssureInfo2.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
		}
	}
	
	/*~[Describe=�鿴�����ͻ���������;InputParam=��;OutPutParam=��;]~*/
	function viewCustomerInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		} else {
			var sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//ϵͳ�в����ڵ����˵Ŀͻ�������Ϣ�����ܲ鿴��
			else
				openObject("Customer",sCustomerID,"002");
		}
	}
	
	/*~[Describe=��ѯ������ͬ�������;InputParam=��;OutPutParam=��;]~*/
	function getGuarantyBalance(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}

		var balance = RunMethod("CreditLine","GetGuarantyBalance",sSerialNo);
		alert("�������:��"+amarMoney(balance,2));
	}
	
	/*~[Describe=�鿴��߶����ͬ����ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewBusinessInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		} else {
			OpenComp("AssureBusinessList","/CreditManage/CreditAssure/AssureBusinessList.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=ʧЧ������ͬ;InputParam=��;OutPutParam=��;]~*/
	function statusChange(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sReturn = popComp("ValidContractList","/CreditManage/CreditAssure/ValidContractList.jsp","SerialNo="+sSerialNo,"dialogwidth:1000px;dialogheight:400px;");
		if(typeof(sReturn) != "" && sReturn =="yes"){
			RunMethod("BusinessManage","UpdateGuarantyContractStatus",sSerialNo+",030");
			alert("�ѳɹ����õ���ʧЧ");
			reloadSelf();
			OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ�ĵ�����Ϣ!","DetailFrame","");
		}
	}
	
	/*~[Describe=ѡ��ĳ�ʵ�����ͬ,������ʾ�������µĵ���Ѻ��;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else{
			var sGuarantyType = getItemValue(0,getRow(),"GuarantyType");			
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=��֤��ͬ������ϸ��Ϣ!","DetailFrame","");
			}else{
				if (sGuarantyType.substring(0,3) == "050") //��Ѻ
					OpenPage("/CreditManage/GuarantyManage/ValidAssurePawnList2.jsp?ContractNo="+sSerialNo,"DetailFrame","");
				else //��Ѻ
					OpenPage("/CreditManage/GuarantyManage/ValidAssureImpawnList2.jsp?ContractNo="+sSerialNo,"DetailFrame","");
			}
		}
	}
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ�ĵ�����Ϣ!","DetailFrame","");
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>