<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "�ѽ�������б�";
 
	//���ҳ�����
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));
	if(sPhaseType1==null) sPhaseType1="";
	

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ConsumeCollectionSettleList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setKeyFilter("CCI.SerialNO");
    
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	if(!doTemp.haveReceivedFilterCriteria()){
		   doTemp.WhereClause+=" and 1=2 ";
		}
	if(!sPhaseType1.equals("")){
		doTemp.WhereClause=sPhaseType1;
	}
     
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseType1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","��ʷ��ѯ","��ʷ��ѯ","viewHistory()",sResourcesPath},
	};
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//�鿴������ʷ 
	function viewHistory(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ConsumeCollectionRegistList.jsp", "CustomerID="+sCustomerID+"&PhaseType1=<%=doTemp.WhereClause%>", "_self","");
		
	}
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		showFilterArea();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
