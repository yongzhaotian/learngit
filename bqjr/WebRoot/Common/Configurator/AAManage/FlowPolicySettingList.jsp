<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei 2006-3-24
		Tester:
		Content: Ϊ����ָ����Ȩ�����б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ȩ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	
	//���ҳ�����	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"FlowNo","���̱��"},
			{"FlowName","��������"},
			{"FlowType","��������"},
			{"FlowDescribe","��������"},
			{"InitPhase","��ʼ�׶�"},
			{"AAEnabled","�Ƿ������Ȩ����"},
			{"AAPolicy","��Ȩ����"}
		};

	sSql =  " select FlowNo,FlowName,getItemName('ApplyType',FlowType) as FlowType, "+
			" FlowDescribe,getPhaseName(FlowNo,InitPhase) as InitPhase, "+
			" getItemName('YesNo',AAEnabled) as AAEnabled,AAPolicy "+
			" from FLOW_CATALOG where 1=1";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_CATALOG";
	doTemp.setKey("FlowNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("FlowNo,FlowName"," style={width:150px} ");
	doTemp.setHTMLStyle("FlowType,InitPhase"," style={width:120px} ");	
	doTemp.setHTMLStyle("FlowDescribe"," style={width:260px} ");


	//��ѯ
 	doTemp.setColumnAttribute("FlowNo,FlowName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
	
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
		{"true","","Button","ָ����Ȩ����","����һ����¼","setPolicy()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ָ����Ȩ����;InputParam=��;OutPutParam=��;]~*/
	function setPolicy()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        OpenPage("/Common/Configurator/AAManage/FlowPolicySettingInfo.jsp?FlowNo="+sFlowNo,"_self","");    
    }
	          		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function mySelectRow()
	{
        
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
