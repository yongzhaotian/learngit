<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�ŵ����ʼİ���";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ShopedPackageList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//CCS-885 �޸İ���������¼��Աֻ�ܲ�ѯ�Լ�����Ϣ update huzp 20150702
	doTemp.WhereClause = " WHERE status='02' and packtype='01' and CreateUser='"+CurUser.getUserID()+"'";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","������ͬ","������ͬ","relativeContract()",sResourcesPath},
		{"true","","Button","�鿴�ʼ��嵥","�鿴�ʼ��嵥","viewReservCustomerInfo()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

    <%/*~[Describe=�鿴�ʼ��嵥;InputParam=��;OutPutParam=��;] ~*/%>
	function viewReservCustomerInfo(){
		var sObjectNo = getItemValue(0,getRow(),"PackNo");
		var sCreateUser = getItemValue(0,getRow(),"CreateUser");//����������
		var userid="<%=CurUser.getUserID()%>";
		//alert(sCreateUser+"------"+userid);

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(sCreateUser == userid){
		    sObjectType = "CreditSettle";
		    sExchangeType = "";
			//������֪ͨ���Ƿ��Ѿ�����
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7004&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //δ���ɳ���֪ͨ��
				//���ɳ���֪ͨ��	
				//PopPage("/FormatDoc/Report17/00.jsp?DocID=7004&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			    alert("�ʼ��嵥δ����!");
			    return;
			}
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

		if (typeof(sPackNo)=="undefined" || sPackNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		sCompID = "ShopPackRelativeContractList";
		sCompURL = "/BusinessManage/ContractManage/ShopPackRelativeContractList.jsp";
		sString="PackNo="+sPackNo;
		sReturn = popComp(sCompID,sCompURL,sString,"dialogWidth=800px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}



	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>