<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*
		Author: zq 2016-01-12
		Tester:
		Describe: ����ծȨת�ò�ѯ�б�
		Jira:PRM-658
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		Output Param:
		HistoryLog:
	 */
	%>

<%String PG_TITLE = "ծȨת�ò�ѯ�б�"; // ��������ڱ��� <title> PG_TITLE </title>%>
<%
	String sTempletNo = "AssignmentClaimsQueryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()){
	doTemp.WhereClause =" where 1=2 ";
    }
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10);  //��������ҳ
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"false","","Button","����","��������","newRecord()",sResourcesPath},
		{"false","","Button","����","�����¼","myDetail()",sResourcesPath},	
		{"false","","Button","ɾ��","ɾ����ѡ�е�����","deleteRecord()",sResourcesPath},
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">
	/**
	 * ������
	 */
	function myDetail(){
		var serialno = getItemValue(0,getRow(),"serialno");	
		if(typeof(serialno)=="undefined" || serialno.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			sCompID = "NoBespeakCashLoanParaDetail";
			sCompURL = "/BusinessManage/BusinessType/NoBespeakCashLoanParaInfo.jsp";
			sCompParam = "serialno="+serialno; //��ֵ����
			var left = (window.screen.availWidth-800)/2;
			var top = (window.screen.availHeight-400)/2;
			var features ='left='+left+',top='+top+',width='+800+',height='+400;
			var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll:no;status=no,menubar=no,'+features;
			popComp(sCompID, sCompURL, sCompParam , style);
		}
		reloadSelf();
	}
	
	/**
	 * �ر�ҳ��
	 */
	function doCancel(){		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@	include file="/IncludeEnd.jsp"%>

