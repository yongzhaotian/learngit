<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ע�Ჿ����ҳ��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	  
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PackagePostList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","��������","��������","newRecord()",sResourcesPath},
		{"true","","Button","������ͬ","������ͬ","relativeContract()",sResourcesPath},
		{"true","","Button","��ӡ�ʼ��嵥","��ӡ�ʼ��嵥","printPostList()",sResourcesPath},
		{"true","","Button","ȷ���ʼ�","ȷ���ʼ�","confirmPost()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},

	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

		//Excel����������	
		function exportExcel(){
			amarExport("myiframe0");
		}
		//end by pli2 20140417	

	<%/*~[Describe=ȷ���ʼ�;InputParam=��;OutPutParam=��;] ~*/%>
	function confirmPost() {
		var sPackNo = getItemValue(0,getRow(),"PackNo");
		var sCreateUser = getItemValue(0,getRow(),"CreateUser");//����������
		var userid="<%=CurUser.getUserID()%>";

		if (typeof(sPackNo)=="undefined" || sPackNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if(sCreateUser == userid){
			//���°���״̬Ϊ"���ʼ�"
			RunMethod("BusinessManage","updatePackStatus",sPackNo);
			
			//���°��������ĺ�ͬ�ر�״̬���ŵ���Ϊ"����������"(1:�ŵꣻ2�������ܲ���3�����������ˣ�4��������)
			RunMethod("BusinessManage","updatePackContractStatus","3,"+sPackNo);
			reloadSelf();
		}else{
			alert("��ǰ�û��޷������˰�����");
		}
	}
	
	<%/*~[Describe=��ӡ�ʼ��嵥;InputParam=��;OutPutParam=��;] ~*/%>
	function printPostList() {
		var sObjectNo = getItemValue(0,getRow(),"PackNo");
		var sCreateUser = getItemValue(0,getRow(),"CreateUser");//����������
		var userid="<%=CurUser.getUserID()%>";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(sCreateUser == userid){
			sObjectType = "CreditSettle";
			sExchangeType = "";
			//edit by phe 2015/03/10 (�����ɵİ����嵥������������   CCS-181)
			//������֪ͨ���Ƿ��Ѿ�����
			//var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7004&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			
			/* if (sReturn == "false"){ //δ���ɳ���֪ͨ��
				//���ɳ���֪ͨ��	
				PopPage("/FormatDoc/Report17/00.jsp?DocID=7004&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			} */
			//���һ��ɾ��ԭ����ȥ���ʼ��嵥�ķ���
			RunMethod("BusinessManage", "DeleteFormatdocRecord", sObjectType+","+sObjectNo);
			//���ɳ���֪ͨ��	
			PopPage("/FormatDoc/Report17/00.jsp?DocID=7004&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			//end by phe 2015/03/10
			//��ü��ܺ�ĳ�����ˮ��
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//ͨ����serverlet ��ҳ��
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}else{
			alert("��ǰ�û��޷������˰�����");
		}
	}

	<%/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;] ~*/%>
	function relativeContract(){
		var sPackNo = getItemValue(0,getRow(),"PackNo");
		var sCreditID = getItemValue(0,getRow(),"CreditID");
		var sCreateUser = getItemValue(0,getRow(),"CreateUser");//����������
		
		if (typeof(sPackNo)=="undefined" || sPackNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		sCompID = "PackRelativeContractList";
		sCompURL = "/BusinessManage/ContractManage/PackRelativeContractList.jsp";
		sString="PackNo="+sPackNo+"&Flag="+"Y"+"&CreditID="+sCreditID+"&CreateUser="+sCreateUser;
		sReturn = popComp(sCompID,sCompURL,sString,"dialogWidth=850px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:yes;help:no;");
	    reloadSelf();
	}

	<%/*~[Describe=��������;InputParam=��;OutPutParam=��;] ~*/%>
	function newRecord(){
		sCompID = "PackageInfo";
		sCompURL = "/BusinessManage/ContractManage/PackageInfo.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=500px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	<%/*~[Describe=ɾ��������Ϣ;InputParam=��;OutPutParam=��;] ~*/%>
	function deleteRecord(){
		var sPackNo = getItemValue(0,getRow(),"PackNo");
		var sCreateUser = getItemValue(0,getRow(),"CreateUser");//����������
		var userid="<%=CurUser.getUserID()%>";
		
		if (typeof(sPackNo)=="undefined" || sPackNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//�����½���������������ͬ�����Բ���
		if(sCreateUser == userid){
			if(confirm("�������ɾ������Ϣ��")){
				RunMethod("BusinessManage","delRelContract",sPackNo);//��ɾ�������еĺ�ͬ
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}
			
		}else{
			alert("��ǰ�û��޷������˰�����");
		}
	}


	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>