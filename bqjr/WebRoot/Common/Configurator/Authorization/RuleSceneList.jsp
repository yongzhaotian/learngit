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
	String PG_TITLE = "��Ȩά���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	//CurPage.setAttribute("ShowDetailArea","true");
	//CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	//�������������������͡�������
	String sGroupID = DataConvert.toString((String)CurPage.getAttribute("GroupID"));
	ARE.getLog().info("GroupID="+sGroupID);
	
	//����ֵת��Ϊ���ַ���
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("AuthorSceneList",Sqlca);

	//���ӹ����� 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//����setEvent
	dwTemp.setEvent("AfterDelete", "!PublicMethod.AuthorObjectManage('remove','scene',#SCENEID)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
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
		{"true","","Button","����","������Ȩ����","newRecord()",sResourcesPath},
		{"true","","Button","�༭","�༭��Ȩ����","editRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����Ȩ����","deleteRecord()",sResourcesPath},
		{"true","","Button","���Ʒ���","��Ȩ��������","replicateScene()",sResourcesPath},
		{"true","","Button","��Ȩ��������","��Ȩ��������","configScenes()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		PopComp("RuleSceneInfo","/Common/Configurator/Authorization/RuleSceneInfo.jsp","GroupID=<%=sGroupID%>","");
		reloadSelf();
	}

	/*~[Describe=�༭��¼;InputParam=��;OutPutParam=��;]~*/
	function editRecord(){
		var sSceneID = getItemValue(0,getRow(),"SCENEID");		//--��ˮ����
		if(typeof(sSceneID)=="undefined" || sSceneID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ!
		}else{
			PopComp("RuleSceneInfo","/Common/Configurator/Authorization/RuleSceneInfo.jsp","GroupID=<%=sGroupID%>&SceneID="+sSceneID,"");
			reloadSelf();
		}
	}
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSceneID = getItemValue(0,getRow(),"SCENEID");		//--��ˮ����
		if(typeof(sSceneID)=="undefined" || sSceneID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ!
		}else if(confirm(getHtmlMessage('2'))){//�������ɾ������Ϣ��
			as_del('myiframe0');
    		as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}
	
	function configScenes(){
		var sSceneID = getItemValue(0,getRow(),"SCENEID");
		if(typeof(sSceneID)=="undefined" || sSceneID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ!
			return;
		}
		var sStatus = getItemValue(0,getRow(),"STATUS");
		if(typeof(sStatus)=="undefined" || sStatus.length==0 ||sStatus=="2"){
			alert("��Ȩ����״̬Ϊ����Ч״̬,����������Ȩ����.");
			return;
		}
		OpenComp("SceneRuleList","/Common/Configurator/Authorization/RuleList.jsp","SceneID="+sSceneID,"_blank","");
	}
	
	function replicateScene(){
		var sSceneID = getItemValue(0,getRow(),"SCENEID");
		if(typeof(sSceneID)=="undefined" || sSceneID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ!
			return;
		}
		
		ShowMessage("ϵͳ���ڸ�����Ȩ����,��ȴ�...",true,false);
		var sStatus = RunMethod("PublicMethod","AuthorObjectManage","replicate,scene,"+sSceneID);
		try{hideMessage();}catch(e){;}
		
		if(typeof(sStatus)=="undefined" || sStatus.length==0){
			
		}else if(sStatus=="SUCCESSFUL"){
			alert("��Ȩ�������Ƴɹ�!");
			OpenPage("/Common/Configurator/Authorization/RuleSceneList.jsp?GroupID=<%=sGroupID%>","_self");
		}else{
			alert("��Ȩ��������ʧ��!");
		}
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	hideFilterArea();
</script>
<%/*~END~*/%>
<%@	include file="/IncludeEnd.jsp"%>