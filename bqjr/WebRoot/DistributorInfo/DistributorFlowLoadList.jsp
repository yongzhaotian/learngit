<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: �����ʽ�������
		
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʽ������� "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "DistributorFlowLoadList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 doTemp.setColumnAttribute("customerID,customerName","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�����������ݣ�2013-5-9
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
		{"true","","Button","�������� ","��������","newRecord()",sResourcesPath},
		{"true","","Button","�鿴/�޸Ĵ�������","�鿴/�޸Ĵ�������","modifyDetail()",sResourcesPath},	
		{"true","","Button","�ļ��ϴ���ɨ��","�ļ��ϴ���ɨ��","d()",sResourcesPath},
		{"true","","Button","���ͷſ�","���ͷſ�","sendLoad()",sResourcesPath},
		{"true","","Button","����","����","KeepAccounts()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">	
	
	function KeepAccounts(){
		//var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectNo = getItemValue(0,getRow(),"serialNo");
		var productID = getItemValue(0,getRow(),"BusinessType");
		/* if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} */
		var sReturn = RunMethod("LoanAccount","RunTransaction3",productID+",,TRA001,<%=BUSINESSOBJECT_CONSTATNTS.business_contract%>,"+sObjectNo+",<%=CurUser.getUserID()%>,");
		if(typeof(sReturn)=="undefined"||sReturn.length==0){
			alert("ϵͳ�����쳣��");
			return;
		}
		alert(sReturn.split("@")[1]);
		reloadSelf();
	}
	
	function newRecord(){
		sCompID = "DistributorFlowLoadInfo";
		sCompURL = "/DistributorInfo/DistributorFlowLoadInfo.jsp";
	    popComp(sCompID,sCompURL,"","dialogWidth=300px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	    
	}
	function modifyDetail(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");	
		var sQuotaID=getItemValue(0,getRow(),"quotaID");	
		var sCustomerID=getItemValue(0,getRow(),"customerID");	
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		AsControl.OpenView("/DistributorInfo/DistributorFlowLoadDetailInfo.jsp","serialNo="+sSerialNo+"&businessType="+sBusinessType+"&quotaID="+sQuotaID+"&customerID="+sCustomerID,"_self");		
	}

	function sendLoad(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(confirm("����ķ��͸÷ſ���")){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,quotaStatus='03',serialNo='"+sSerialNo+"'");
		}
		reloadSelf();
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

