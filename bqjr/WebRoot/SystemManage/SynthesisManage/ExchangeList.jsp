<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: ���ʹ���
		Input Param:
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ʹ�����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//--���sql���
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

//ͨ����ʾģ�����ASDataObject����doTemp
String sTempletNo = "ExchangeList"; //ģ����
String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������

ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

//���ɲ�ѯ����
doTemp.generateFilters(Sqlca);
doTemp.parseFilterData(request,iPostChange);
CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
dwTemp.setPageSize(25);//25��һ��ҳ

//��������¼�
//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

//����HTMLDataWindow
Vector vTemp = dwTemp.genHTMLDataWindow("");//������ʾģ�����
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
			//add by hwang 20090616,���ӻ����ֹ�ά�����ܡ�
			 {"true","","Button","����","����","my_add()",sResourcesPath},
			 {"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
			 {"true","","Button","�鿴/�޸�","�鿴/�޸�","viewAndEdit()",sResourcesPath}
			//edd add		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//add by hwang 20090616,���Ӱ�ť��Ӧ�¼�
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function my_add()
	{ 	 
	    OpenPage("/SystemManage/SynthesisManage/ExchangeInfo.jsp","_self","");
	}	                                                                                                                                                                                                                                                                                                                                                 

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sCurrency = getItemValue(0,getRow(),"Currency");
		if (typeof(sCurrency)=="undefined" || sCurrency.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}	

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sCurrency = getItemValue(0,getRow(),"Currency");
		if (typeof(sCurrency)=="undefined" || sCurrency.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/SynthesisManage/ExchangeInfo.jsp","Currency="+sCurrency, "_self", "");
	}	
	//end add
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
