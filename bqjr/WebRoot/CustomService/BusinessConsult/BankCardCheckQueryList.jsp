<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "���п���֤δ���ز�ѯ";
    //�������
    String sTempletNoType="";
    String sBusinessDate=SystemConfig.getBusinessTime();
    
	//���ҳ�����
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
		sTempletNoType = "BankCardCheckQueryList";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = sTempletNoType;//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=false;//���ÿɶ�ѡ
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause = " where 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 if(!doTemp.haveReceivedFilterCriteria()){
		 doTemp.WhereClause+="  and 1=2 "; 
	 }
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15);
	
//	doTemp.WhereClause+=" and mi.status in ('3','4','5') ) ";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			/* {"true","","Button","�˱�����","ȷ���˱�","httpPostSend()",sResourcesPath},
			{"true","","Button","ȡ���˱�","ȡ���˱�","canhttpPostSend()",sResourcesPath},
			{"true","","Button","����","����","exportAll()",sResourcesPath}, */
		};
    
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//��ѯ����չ������
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>