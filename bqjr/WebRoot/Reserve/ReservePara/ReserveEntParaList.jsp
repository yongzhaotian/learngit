<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.biz.reserve.business.DateTools" %>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
	/*
		Author:zwang 2008.11.12
		Tester:
		Content: ����ά���б�ҳ��
		Input Param:		
		Output param:	
			����·ݣ�AccountMonth
			�ͻ����ͣ�CustomerType
				01 ��˾�ͻ� 
				03 ���˿ͻ�
		History Log: 
			zytan 20090108 ��������������¼��ģʽ
	*/
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
<%
	// ��������ڱ��� <title> PG_TITLE </title>
	String PG_TITLE = "����ά���б�"; 
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
    String sCurrentAccountMonth = DateTools.getAccountMonth("yyyy/MM/dd",3);
	//����������
	
	//���ҳ�����
	String sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sTempletNo = "ReserveEntParaList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);			
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));			
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1"; 
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д     
	dwTemp.ReadOnly = "1"; 
	dwTemp.setPageSize(10);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerType);
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
		{"true","","Button","����������Ϣ","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","�鿴������Ϣ","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","����","������ѡ�еļ�¼","copyRecord()",sResourcesPath}
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
		var sCurrentAccountMonth = "<%=sCurrentAccountMonth%>";
		var sCustomerType = "<%=sCustomerType%>";
		var sAssetsType = sCustomerType;
		var sParaString = sCurrentAccountMonth + "," + sCustomerType + "," + sAssetsType;
		var sReturn = RunMethod("ReserveManage","ReserveCheckAccountMonth",sParaString);
		if (typeof(sReturn) == "undefined" || sReturn == "Refuse") {
		    if (confirm("���ڻ���·ݻ���������Ϣ�Ѵ��ڣ���ϣ���鿴����Ϣ��")) {
		    	OpenPage("/Reserve/ReservePara/ReserveEntParaInfo.jsp","_self","");
		    }
		} else if (sReturn == "Pass") {
			OpenPage("/Reserve/ReservePara/ReserveEntParaInfo.jsp","_self","");
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sAccountMonth=getItemValue(0,getRow(),"AccountMonth");
		sAssetsType=getItemValue(0,getRow(),"AssetsType");
		if((typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
				|| (typeof(sAssetsType) == "undefined" || sAssetsType.length == 0))
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		OpenPage("/Reserve/ReservePara/ReserveEntParaInfo.jsp?AccountMonth="+sAccountMonth+"&AssetsType="+sAssetsType,"_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sAccountMonth=getItemValue(0,getRow(),"AccountMonth");
		sAssetsType=getItemValue(0,getRow(),"AssetsType");
		if((typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0) 
			|| (typeof(sAssetsType) == "undefined" || sAssetsType.length == 0))
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		if(confirm("�������ɾ������Ϣ��")) 
		{
			as_del("myiframe0");
			//�������ɾ������Ҫ���ô����
			as_save("myiframe0"); 
		}
		reloadSelf();
	}

	/*~[Describe=���Ƽ�¼;InputParam=��;OutPutParam=��;]~*/
	function copyRecord()
	{
		var sAccountMonth=getItemValue(0,getRow(),"AccountMonth");
		var sAssetsType=getItemValue(0,getRow(),"AssetsType");
		var sCustomerType="<%=sCustomerType%>";
		var sFlag = "3";//��ʾ����·ݵ�Ƶ�ȣ�1�������£�3�����ռ��ȣ�6�����հ��꣬12��������
		if((typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0) 
			|| (typeof(sAssetsType) == "undefined" || sAssetsType.length == 0))
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		//�������flag���ʲ�������
		var sReturn = RunMethod("ReserveManage","ReserveCopyPara",sAccountMonth+","+sAssetsType+","+sCustomerType+","+sFlag);
		if(sReturn == "SuccessFul"){
			alert("��ǰ����·ݻ�������������Ϣ���Ƴɹ���");
			reloadSelf();
		}else if(sReturn == "Exit"){
			alert("��ǰ����·ݻ�������������Ϣ�Ѿ����ڣ���ȷ�ϣ�");
			return;
		}else{
			alert("���ƻ�������������Ϣ��������ϵϵͳ����Ա��");
			return;
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
