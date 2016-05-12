<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.biz.reserve.business.DateTools" %>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author:zwang 2008.11.12
		Tester:
		Content: ��ֵ�����������ҳ��
		Input Param:
			����·ݣ�AccountMonth
			�ͻ����ͣ�CustomerType
				01 ��˾�ͻ� 
				03 ���˿ͻ�
			��ʧ�ʼ�������: LossRateCalType
		Output param:
			����·ݣ�AccountMonth
			�ͻ����ͣ�CustomerType
				01 ��˾�ͻ� 
				03 ���˿ͻ�
		History Log: 
			zytan 20090108 ҳ��ֻ������
	*/
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
<%
	// ��������ڱ��� <title> PG_TITLE </title>
	String PG_TITLE = "��ֵ�����������"; 
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	
	//����������
	
	//���ҳ�����			
	String sAssetsType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetsType"));
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	//����������Ĳ�����Ϣҳ�棬���Զ�ȡ�û���·�ֵ��ĿǰĬ��Ϊ���ռ�����ȡֵ
	if(sAccountMonth == null) sAccountMonth = DateTools.getAccountMonth("yyyy/MM/dd",3);
	if(sAssetsType == null) sAssetsType = "01";
	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ReserveEntPara";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "0";
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sAssetsType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
%>
<%/*~END~*/%>




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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
<script type="text/javascript">
	//���DW�Ƿ���"����״̬"
	var bIsInsert = false; 
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){			
			//����������֤�����ݿ����Ѿ����ڵĸĿͻ����Ͷ�Ӧ�·��Ѿ�����ʱ��������ʾ������ѡ��
			sAccountMonth = getItemValue(0,0,"AccountMonth");//ȡ�û���·�
			sAssetsType = getItemValue(0,0,"AssetsType");//ȡ�ÿͻ�����
			//����ҳ����֤ "01"��ʾ�ͻ�����Ϊ��˾�ͻ�
		    sParaString = sAccountMonth + "," + "01" + "," + sAssetsType;
		    sPassRight = RunMethod("ReserveManage","ReserveCheckAccountMonth",sParaString);
			if(sPassRight=="Pass"){
				beforeInsert();	
			}else{
				alert(" ��ѡ�ʲ���Ļ���·ݲ����Ѿ����ڣ�������ѡ��");
				return;
			}				
		}else{
			beforeUpdate();			
		}
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
   		OpenPage("/Reserve/ReservePara/ReserveEntParaList.jsp","_self","");
   	}
	
	/*~[Describe=����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getMonth(sObject)
	{
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined")
		{
			setItemValue(0,0,sObject,sReturnMonth);
		}
	}
</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
		
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{			
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/	
	function beforeUpdate()
	{
		//���ø���ʱ��Ҫ�Զ������ֶ�
	}
		
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		if (getRowCount(0)==0) 
		{
			//������¼
			as_add("myiframe0");
			bIsInsert = true;
			setItemValue(0,0,"AssetsType","<%=sAssetsType%>");
			setItemValue(0,0,"AccountMonth","<%=sAccountMonth%>");
		}
	}
</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	//ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	initRow(); 
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
