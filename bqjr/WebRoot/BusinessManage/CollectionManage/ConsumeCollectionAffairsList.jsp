<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "��������ҳ��";
	//���ҳ�����
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));
	if(sPhaseType1==null) sPhaseType1="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ConsumeCollectionLawList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseType1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","�鿴��ͬ","�鿴��ͬ","OverDuelContractList()",sResourcesPath},
		{"true","","Button","�ж�����¼��","�ж�����¼��","viewAndEdit()",sResourcesPath},
		{"true","","Button","��ʷ��ѯ","��ʷ��ѯ","viewHistory()",sResourcesPath},
	};
	

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	//�ж�����¼��
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");//������ˮ��
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");//�ͻ����
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		sCompID = "ConsumeCollectionRegistInfo";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeCollectionRegistInfo.jsp";
	    popComp(sCompID,sCompURL,"CollectionSerialNo="+sSerialNo+"&CustomerID="+sCustomerID,"dialogWidth=400px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	
	//�鿴������ʷ 
	function viewHistory(){
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ConsumeCollectionRegistList.jsp", "CustomerID="+sCustomerID+"&PhaseType1=<%=sPhaseType1%>", "_self","");
		
	}
	
	
	/*�鿴�ͻ������������ں�ͬ*/
	function OverDuelContractList(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("�ô���������Ϣ���������ͻ���Ϊ�գ�");
			return;
		}
	
		sCompID = "ConsumeOverDuelBCList";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeOverDuelBCList.jsp";
		sParamString = "CustomerID="+sCustomerID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		reloadSelf();
	}



	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
