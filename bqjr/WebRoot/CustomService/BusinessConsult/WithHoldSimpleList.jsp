<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
 <%
	/*
		ҳ��˵��: ʾ���б�ҳ��  
	 */
	String PG_TITLE = "ʵʱ���۽����ѯ";
	ASDataObject doTemp = new ASDataObject("WithHoldSimpleList",Sqlca);
	
	doTemp.setRequired("businessdate", false);
	//���ò�ѯ����
	doTemp.setFilter(Sqlca, "0101", "businessdate", "Operators=EqualsString,IsNotNull;");
	
	doTemp.setFilter(Sqlca, "0050", "contractno", "Operators=EqualsString,BeginsWith;");
	
	//doTemp.setFilter(Sqlca, "0100", "sendflag1", "Operators=EqualsString;");
	
	//doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()){
		String sBusinessDate=SystemConfig.getBusinessDate();
		doTemp.Filters.get(0).sFilterInputs[0][1] = sBusinessDate;
		doTemp.WhereClause+=" and 1=2";
	}else if(doTemp.Filters.get(0).sFilterInputs[0][1]==null||doTemp.Filters.get(1).sFilterInputs[0][1]==null){
		   %>
			<script type="text/javascript">
				alert("¼�����ڡ���ͬ�Ų���Ϊ�գ�");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
	}
	
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	//ʹ��new ASDataWindow(CurPage,doTemp,Sqlca)����ɲ�ѯ�����ظ����ĳ�dwTemp
	 Vector vTemp =  dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			//{"true","","Button","���۽����ѯ","���۽����ѯ","affirmWithhold()",sResourcesPath},
		    };
%>

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


<%/*~[Describe=�ٴδ�������ȷ��;InputParam=��;OutPutParam=��;]~*/%>

	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//��ѯ����չ������
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>