<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: �ļ�����������Ҫ�㹦��ά��
		Input Param:
		Output param:
		History Log: //CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ҫ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ҫ����Ϣ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	//����������
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if (null == sTypeNo) sTypeNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
										{"TypeNo","���ͱ��"},
										{"TypeName","��������"},
										{"SerialNo","���к�"},
										{"Time","����ʱ��"},
						   }; 
	
	sSql = 	" select eit.TypeNo,eit.TypeName,eit.addtime as Time "+
			" from ecm_image_type eit "+
			" where eit.TypeNo='"+sTypeNo+"' "+
			" order by AddTime desc ";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ùؼ���
	doTemp.setKeyFilter("TypeNo");
	doTemp.setKey("TypeNo",true);	
	//�����ֶ�
	//doTemp.setVisible("AuditPoints",false);//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
	
	//doTemp.multiSelectionEnabled=true;// �����ѡ
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","Time","");
	doTemp.parseFilterData(request,iPostChange);
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

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
		{"true","","Button","����","�������Ҫ��","AddAuditPoints()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ�����Ҫ��","DeleteAuditPoints()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------//
	
	function AddAuditPoints()
	{//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
		//OpenPage("/SystemManage/CarManage/DocAuditPointsModelInfo.jsp","_self","");
		  AsControl.OpenView("/SystemManage/CarManage/DocAuditPointsModelInfo.jsp","TypeNo=<%=sTypeNo%>","_self","");
	} 

	function DeleteAuditPoints()
	{
		var sTime =getItemValue(0,getRow(),"Time");
		if (typeof(sTime)=="undefined" || sTime.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷʵɾ���ü�¼��")){
			RunMethod("���÷���","DelByWhereClause","ecm_image_type,AddTime='"+sTime+"'");
			as_del("myiframe0");
			reloadSelf();
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

<%@ include file="/IncludeEnd.jsp"%>
