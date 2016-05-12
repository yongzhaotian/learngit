<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: Dahl 2015-3-19
		Tester:
		Describe: p2p��ѯ
		
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "p2p��ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String  sP2pType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("p2pType"));
	String sExport = "false";	//Ĭ�ϲ�ѯδ������p2p��ͬ��Ĭ�ϲ�ѯʱ�Ű�δ������p2p��ͬ���õ���ʱ��
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sTempletNo = "P2PContractQueryList"; //ģ����
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setKeyFilter("SerialNo");
	
	//���ɲ�ѯ��
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
	
	ARE.getLog().debug("--------------------p2pType:"+sP2pType);
	
	if( "AirtualStore".equals(sP2pType) ){	//��Ǯô�����ŵ��p2p��ͬ
		//doTemp.WhereClause += " and RI.RNO = '4403000471' ";
		doTemp.WhereClause += " and BC.SURETYPE = 'JQM' ";
	}else if( "EBuyFun".equals(sP2pType) ){	//���װ۷֡����̻����Ϊ��4403000403��
		//doTemp.WhereClause += " and RI.RNO = '4403000403' ";
		doTemp.WhereClause += " and BC.SURETYPE = 'EBF' ";
	}else{	//��ͨ���Ѵ���p2p��ͬ
		//doTemp.WhereClause += " and RI.RNO <> '4403000471' ";	//��������Ǯô�����ŵ��p2p��ͬ��
		//doTemp.WhereClause += " and RI.RNO <> '4403000403' ";	//���������װ۷֡����̻����Ϊ��4403000403��
		doTemp.WhereClause += " and BC.SURETYPE = 'PC' ";
	}
	
	//P2P��ͬ �ų� ��ͬ״̬Ϊ���·���������У�����ͨ��������δע�ᣬ��ȡ�����ѷ��,�ѳ���
	doTemp.WhereClause += " and BC.ContractStatus not in ('060','070','080','090','100','010','210')";
	
	//Ĭ�ϵ���ǩ������Ϊ����16:00������16:00��p2p��ͬ
	if(!doTemp.haveReceivedFilterCriteria()){
		doTemp.WhereClause += " and BCO.P2P_EXPORT_TIME is null ";
		sExport = "true";	//Ĭ�ϲ�ѯ����Ϊtrue
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","����","����Excel","ExportExcel()",sResourcesPath},
	};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

	//����excel
	function ExportExcel(){
		amarExport("myiframe0"); //����Excel 
		//����p2p��ͬ�ĵ���ʱ��    add by Dahl 2015-3-19s
		var sExport = "<%=sExport%>";
		if( "true" == sExport ){	//Ĭ�ϲ�ѯ�ŵ��á�
			RunJavaMethodSqlca("com.amarsoft.proj.action.P2PCredit", "updateP2pExportTime","p2pType=<%=sP2pType%>");
		
		}
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

