<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
 <%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "���ǩ�����͹���";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ExpressManageList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	for(int k=0; k<doTemp.Filters.size(); k++){
		//��������������ܺ���%����
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){
			%>
			<script type="text/javascript">
				alert("������������ܺ���\"%\"����!");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
			break;
		}
	}
	
	//�����ѯ����Ϊ���򲻲�ѯ
	if(!doTemp.haveReceivedFilterCriteria()) {
		if(!sDoWhere.equals("")){
			doTemp.WhereClause=sDoWhere;
		}else{
			doTemp.WhereClause+=" and 1=2 ";
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
	<%/*~[Describe=�鿴/�޸�����;]~*/%>
	function viewAndEdit(){
		var sItemNo = getItemValue(0,getRow(),"serialno");
		if (typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		sCompID = "ExpressManageInfo";
		sCompURL = "/Common/WorkFlow/PutOutApply/ExpressManageInfo.jsp";
		sParamString ="serialNo="+sItemNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=350px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
