<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe:�������泡���б�
		Input Param:
       		�ĵ����:DocNo
		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������泡���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������                     
    String sSql = "";
	
	//����������
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String docTitle = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocTitle"));
	
	if(docTitle == null) docTitle = "";
	if(sUserID == null) sUserID = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
 	String sTempletNo = "RuleSceneList"; //ģ����

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);//25��һ��ҳ

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
		{"true","All","Button","����","�����������泡��","newRecord()",sResourcesPath},
		{"true","All","Button","����","�鿴�������泡������","viewRecord()",sResourcesPath},
		{"true","All","Button","ɾ��","ɾ���������泡��","deleteRecord()",sResourcesPath},
		{"true","All","Button","��������׼������","��������׼������","setRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/	
	function newRecord()
	{
		AsControl.OpenView("/SystemManage/CarManage/RuleSceneInfo.jsp","","_self");
	}
	
	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/	
	function viewRecord()
	{
		var sSceneId = getItemValue(0,getRow(),"SCENEID");
		if (typeof(sSceneId)=="undefined" || sSceneId.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
		AsControl.OpenView("/SystemManage/CarManage/RuleSceneInfo.jsp","SceneId="+sSceneId,"_self");
		}
		
	}
	
	/*~[Describe=��������׼������;InputParam=��;OutPutParam=��;]~*/	
	function setRecord()
	{
		var sSceneId = getItemValue(0,getRow(),"SCENEID");
		var sDataType = getItemValue(0,getRow(),"DATATYPE");
		if (typeof(sSceneId)=="undefined" || sSceneId.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			OpenComp("PrepareDateMain","/SystemManage/CarManage/PrepareDateList.jsp","SceneId="+sSceneId+"&DataType="+sDataType,"_blank","");
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sSceneId = getItemValue(0,getRow(),"SCENEID");
		var sDataType = getItemValue(0,getRow(),"DATATYPE");//��������
		if (typeof(sSceneId)=="undefined" || sSceneId.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			//select itemdescribe from code_library where codeno='RuleDataType' and ItemNo='"+sDataType+"'"));
			var TableName="CODE_LIBRARY";
			var ColName = "itemdescribe";
			var WhereClause="CODENO='RuleDataType' AND ITEMNO='"+sDataType+"'";
			//String TableName,String ColName,String WhereClause
			TableName = RunMethod("���÷���","GetColValue",TableName+","+ColName+","+WhereClause);
			ColName=" count(1) ";
			WhereClause = " sceneID='"+sSceneId+"'";
			var n = RunMethod("���÷���","GetColValue",TableName+","+ColName+","+WhereClause);
			n = n*1 | 0 || 0;//ȥ��С��
			if(confirm("�ó�������"+n+"�����ݹ����������ɾ����")) //�������ɾ������Ϣ��
			{
				//14	���÷���	DelByWhereClause	Sql	����where����ɾ����������	Number	String TableName, String whereClause	delete from #TableName where #whereClause							
				RunMethod("���÷���","DelByWhereClause",TableName+","+WhereClause);
        		as_del('myiframe0');
        		as_save('myiframe0'); 
        		reloadSelf();
    		}
		}
		
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

<%@	include file="/IncludeEnd.jsp"%>