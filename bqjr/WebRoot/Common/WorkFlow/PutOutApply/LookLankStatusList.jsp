<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
 
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	
		String sHeaders[][] = { 	
			{"contractNo","��ͬ��"},
			{"customerName","�ͻ�����"},
			{"inputuser","������"},
			{"eventtime","����ʱ��"},
			{"oldvalue","����ǰ�ر�"},
			{"newvalue","���ĺ�ر�"}
		   }; 

	 String sSql ="select contractNo,customerName, getusername(inputuser) as inputuser , eventtime,getItemName('LandMarkStatus',oldvalue) as oldvalue,getItemName('LandMarkStatus',newvalue) as newvalue from event_info  where type='050'";
	
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);//����ģ�ͣ�2013-5-9
	 doTemp.setHeader(sHeaders);	
	 doTemp.setKey("serialNo", true);	 
	 doTemp.setColumnAttribute("contractNo,customerName","IsFilter","1");
	 doTemp.setColumnAttribute("eventtime","IsFilter","1");
	 doTemp.setCheckFormat("eventtime","3");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","����","back()",sResourcesPath},
			{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},

	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function back(){
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/ContrackRegistrationList.jsp","doWhere=<%=sDoWhere%>","right","");
		
	}
	
	//Excel����������	
	function exportExcel(){
		amarExport("myiframe0");
	}
	//end by pli2 20140417	
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
