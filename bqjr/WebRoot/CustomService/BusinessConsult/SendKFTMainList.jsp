<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
 <%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʵʱ���۷��Ͳ�ѯ"; 
	ASDataObject doTemp = new ASDataObject("QuerySendKFTList",Sqlca);
	
	//���ò�ѯ����
	doTemp.setFilter(Sqlca, "0081", "businessdate", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0010", "serialno", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0060", "customerid", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0070", "contranctno", "Operators=EqualsString,BeginsWith;");
	
	//doTemp.generateFilters(Sqlca);
	
	doTemp.parseFilterData(request,iPostChange);

	if(!doTemp.haveReceivedFilterCriteria()){
		String sBusinessDate=SystemConfig.getBusinessDate();
		doTemp.Filters.get(0).sFilterInputs[0][1] = sBusinessDate;
		doTemp.WhereClause+=" and businessdate='"+sBusinessDate+"'";
	}else if(doTemp.Filters.get(0).sFilterInputs[0][1]==null){
			%>
				<script type="text/javascript">
					alert("����ʱ�䲻��Ϊ�գ�");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	
	//����HTMLDataWindow 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			//{"true","","Button","���۽����ѯ","���۽����ѯ","affirmWithhold()",sResourcesPath},
		    };
%>

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


<%/*~[Describe=�ٴδ�������ȷ��;InputParam=��;OutPutParam=��;]~*/%>
function affirmWithhold(){
	var sSerialNo = getItemValue(0,getRow(),"outid");
	
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
	{
		alert(getHtmlMessage(1));  //��ѡ��һ����¼��
		return;
	}
	
	
	var returlVale = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.WithholdSimpleQuery","sendPayMentSimple","serialNo="+sSerialNo);
	if(returlVale == 'true'){
		alert("��ѯ�ɹ�!");
	}else{
		alert('���ýӿ�ʧ��!');
	}
	reloadSelf();
}
	


	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//��ѯ����չ������
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>