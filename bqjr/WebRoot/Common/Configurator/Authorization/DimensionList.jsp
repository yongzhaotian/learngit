<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zllin@amarsoft.com
		Tester:
		Describe: ��Ȩά���б�
		Input Param:
				
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","200");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	//�������������������͡�������
	
	//����ֵת��Ϊ���ַ���
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("AuthorDimensionList",Sqlca);
	
	//���ӹ����� 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//����setEvent
	dwTemp.setEvent("AfterDelete", "!PublicMethod.AuthorObjectManage('remove','dimension',#DIMENSIONID)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
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
		{"true","","Button","����","����������Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��������Ϣ","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/Authorization/DimensionInfo.jsp?","DetailFrame","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sDimensionID = getItemValue(0,getRow(),"DIMENSIONID");	//--��ˮ����
		if(typeof(sDimensionID)=="undefined" || sDimensionID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ!
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
    		as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ����Ȩ������Ϣ!","DetailFrame","");
		}
		
	}

	/*~[Describe=ѡ��ĳ�ʵ�����ͬ,������ʾ�������µĵ���Ѻ��;InputParam=��;OutPutParam=��;]~*/
	var currentId = "";
	function mySelectRow()
	{
		var sDimensionID = getItemValue(0,getRow(),"DIMENSIONID");	
		if(typeof(sDimensionID)=="undefined" || sDimensionID.length==0) {
			
		}else if(sDimensionID==currentId){
			
		}else
		{
			OpenPage("/Common/Configurator/Authorization/DimensionInfo.jsp?DimensionID="+sDimensionID,"DetailFrame","");
			currentId = sDimensionID;
		}
		
	}
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ����Ȩ������Ϣ!","DetailFrame","");
	hideFilterArea();
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>