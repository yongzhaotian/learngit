<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: DataWindow���ݹ�����ʾ��ҳ��
	 */
	String PG_TITLE = "DataWindow���ݹ�����ʾ��ҳ��";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ExampleList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//���ɲ�ѯ�������ApplySum�������Ĳ�ѯ����(�ֶ�)��DWģ��(��ʾģ��)�ﹴѡ���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","ApplySum","Operators=BetweenNumber;DOFilterHtmlTemplate=Number");//������������
	doTemp.setFilter(Sqlca,"2","InputUser","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";//��ʼ������ʾ�б�����,haveReceivedFilterCriteria()��ȡ�Ƿ���յ�filter����������״̬
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*~[Describe=��ѯ���������Ի���;]~*/%>
	function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.getElementById(sObjectID);
		oMyObj2 = document.getElementById(sObjectID2);
		if(sFilterID=="2"){
			sParaString = "SortNo,<%=CurOrg.getSortNo()%>";
			sReturn =setObjectValue("SelectUserInOrg",sParaString,"",0,0,"");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				//oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				//oMyObj2.value=sReturns[0];
			}
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		//hideFilterArea();//������ѯ����,Ĭ����������
		showFilterArea();//չ����ѯ����
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>