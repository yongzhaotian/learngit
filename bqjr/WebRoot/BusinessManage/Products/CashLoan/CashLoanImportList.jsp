<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "�����ֽ���ά��";
	//���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	String sEventStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EventStatus"));//�״̬
	if(sEventStatus==null) sEventStatus="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("CashLoanRelativeList",Sqlca);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����","����","ContractImport()",sResourcesPath},
		{"true","","Button","�ͻ�����","�ͻ�����","viewtab()",sResourcesPath},
	};

	//δ��ʼ�Ļ
	if("01".equals(sEventStatus))
	{
		sButtons[0][0] = "true";
	}

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~��ͬ������~*/
	function viewtab(){
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenComp("CustomerInfo","/CustomerManage/CustomerInfo.jsp","CustomerID="+sCustomerID+"&RightType=ReadOnly","_blank","");
	}
	
	function ContractImport(){
		var serialNo = "<%=sSerialNo%>";
		var sReturn  = RunMethod("���÷���","GetColValue","BUSINESS_CASHLOAN_RELATIVE,count(*),EVENTSERIALNO='"+serialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			if(!confirm("�Ѵ��ڿͻ����ݣ��Ƿ����µ��룿")){
				return;
			}
		}
		//�ļ��ϴ�
		AsControl.PopView("/BusinessManage/Products/CashLoan/CashLoanImportInfo.jsp", "ObjectNo="+serialNo, "dialogWidth=450px;dialogHeight=250px;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
		reloadSelf();
	}
	
	$(document).ready(function(){
		hideFilterArea();
		AsOne.AsInit();
		init();
		my_load_show(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>