<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:	--fwang 2009.6.16
		Tester:
		Content: �ͻ���Ϣ���ļ�¼ҳ��
		Input Param:
			CustomerID���ͻ���
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���Ϣ���ļ�¼"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%//���ҳ�����
String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
if(sCustomerID==null) sCustomerID="";

//ͨ��DWģ�Ͳ���ASDataObject����doTemp
String sTempletNo = "ChangeHistoryList";//ģ�ͱ��
ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

doTemp.generateFilters(Sqlca);
doTemp.parseFilterData(request,iPostChange);
CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
dwTemp.setPageSize(10);

//����HTMLDataWindow
Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));%>




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
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/ChangeCustomerList.jsp","_self","");		
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
