<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: ������Ʒ����
		
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
	String PG_TITLE = "������Ʒ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ�����
	String sComponentName    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("componentName"));	
	String sCurItemID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("curItemID"));	
	if(sComponentName==null) sComponentName=""; 
    if(sCurItemID==null)  sCurItemID="";
    System.out.println(sComponentName+"----------------");
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "CBusinessTypeList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	
	 doTemp.setColumnAttribute("TypeNo,typeName","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	dwTemp.setEvent("BeforeDelete","!ProductManage.DeleteVersionInfo(#TypeNo,V1.0)");//ɾ���汾
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCurItemID);//�����������ݣ�2013-5-9
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
		{"true","","Button","������Ʒ","������Ʒ��¼","newRecord()",sResourcesPath},
		{"true","","Button","��Ʒ����","��Ʒ����","productConfigure()",sResourcesPath}, 
		{"true","","Button","ɾ����Ʒ","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}, 
		{"true","","Button","����","���ò�Ʒ","enable()",sResourcesPath},
		{"true","","Button","ͣ��","ͣ�ò�Ʒ","disable()",sResourcesPath}, 		
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
	function newRecord(){
		popComp("CBusinessTypeInfo","/BusinessManage/BusinessType/CarLoan/CBusinessTypeInfo.jsp","curItemID=<%=sCurItemID%>","dialogWidth=300px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        reloadSelf();
	}
	
	function productConfigure(){
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
    	popComp("CBusinessTypeInfo1","/BusinessManage/BusinessType/CarLoan/CBusinessTypeInfo1.jsp","typeNo="+sTypeNo+"&curItemID=<%=sCurItemID%>","");
    	reloadSelf();
	}
	
	function deleteRecord(){
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			 reloadSelf();
		}
	}
	
	function enable(){
		var sIsInUse =getItemValue(0,getRow(),"IsInUse");
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");
		if(sIsInUse=="����"){
			alert("�ò�Ʒ�ѱ������С�������");
		}else {
			if(confirm("����������øò�Ʒ��")){
				RunMethod("Enable","enableAndDisable","1,"+sTypeNo);
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
				 reloadSelf();
			}		
		}
	}
	
	function disable(){
		var sIsInUse =getItemValue(0,getRow(),"IsInUse");
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");
		if(sIsInUse=="ͣ��"){
			alert("�ò�Ʒ�ѱ�ͣ�á�������");
		}else {
			if(confirm("�������ͣ�øò�Ʒ��")){
				RunMethod("Enable","enableAndDisable","2,"+sTypeNo);
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
				 reloadSelf();
			}		
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

