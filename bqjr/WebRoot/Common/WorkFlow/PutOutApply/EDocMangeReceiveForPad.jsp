<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��ͬ�������չ���";
    //�������
    String sTempletNoType="EDocMangeReceiveForPad";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = sTempletNoType;//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//doTemp.multiSelectionEnabled=true;//���ÿɶ�ѡ
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15);
	
//	doTemp.WhereClause+=" and mi.status in ('3','4','5') ) ";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","�������˻�","��ͬ�������˻�","mangeReceiveAdd()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
  function mangeReceiveAdd(){
	   var sCompID = "EDocMangeReceiveAdd";
	    // ����һ��ҳ��  
		var sCompURL = "/Common/WorkFlow/PutOutApply/EDocMangeReceiveAdd.jsp";	 
		popComp(sCompID,sCompURL,"ser=kkk","dialogWidth=690px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
  }
  
  
	function exportAll(){
		amarExport("myiframe0");
	}

</script>	
	<script type="text/javascript">	
		AsOne.AsInit();
		init();
		showFilterArea();//��ѯ����չ������
		my_load(2,0,'myiframe0');
	</script>	
<%@ include file="/IncludeEnd.jsp"%>