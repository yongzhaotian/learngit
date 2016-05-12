<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   pwang 20091019   
		Tester:	
		Content: Ԥ���ֽ���List
		Input Param:
			DuebillNo:��ݱ��
			AccountMonth:����·�
			CustomerID���ͻ����
			AbleToSee�����ư�ť��ʾ
			PageType�����Ʒ���ҳ��
				Single�����ط���ҳ��
				Cognize�������������ҳ��
		Output param:
		History Log: 
			
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ���ֽ���Ԥ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//��ҳ�����
	
	//���ҳ�����	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	//����sPhaseNo,sType,sItemMenuNo������ȡ����
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sPhaseNo == null) sPhaseNo = "" ;
	if(sPhaseType == null) sPhaseType = ""; 

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sTempletNo = "ReservePredictList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//doTemp.setFilter(Sqlca,"1","ReturnDate","Operators=EqualsString;"); 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
    
	//����ASDataWindow����
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";//����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1";//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);//���÷�ҳ
	//ɾ��ʱ���輰ʱ����Reserve_Total.Reserve_apply
	dwTemp.setEvent("AfterInsert","!ReserveManage.FinishPredictData(#AccountMonth,#DuebillNo,#ObjectNo)");

	//����HTMLDataWindow	
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
		//6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","�����ֽ���","������¼","my_Add()",sResourcesPath},
			{"true","","Button","�鿴�ֽ�������","�鿴/�޸�����","my_ViewEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����¼","my_Del()",sResourcesPath},
			{"true","","Button",(sPhaseType.equals("1010")||sPhaseType.equals("1030"))?"�ϴ�����":"�鿴����","�鿴����","my_View()",sResourcesPath},
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>
<script type="text/javascript">
	
	/*~[Describe=����δ���ֽ�����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_Add(){
		PopComp("ReservePredictInfo","/Reserve/ReservePredict/ReservePredictInfo.jsp","ToInheritObj=y&ObjectNo=<%=sObjectNo%>","");
		reloadSelf();
	}
	
	/*~[Describe=�鿴δ���ֽ�������;InputParam=��;OutPutParam=��;]~*/
    function my_ViewEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		PopComp("ReservePredictInfo","/Reserve/ReservePredict/ReservePredictInfo.jsp","ToInheritObj=y&SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>","");
		reloadSelf();
	}
	
    /*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
 	function my_Del(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
			alert("��ѡ��һ����¼��");
			return;
		}		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");			
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����	
		}
 	}

 	/*~[Describe=�ϴ�����;InputParam=��;OutPutParam=��;]~*/
	function my_View(){
		PopComp("DocumentList","/AppConfig/Document/DocumentFrame.jsp","ToInheritObj=y&ObjectNo=<%=sObjectNo%>&ObjectType=Reserve","");
   	}

</script>

<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>
