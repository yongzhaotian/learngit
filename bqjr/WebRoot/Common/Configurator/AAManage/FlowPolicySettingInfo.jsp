<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   zywei 2006/03/24
		Tester:
		Content:    ����ģ����Ϣ����
		Input Param:
             FlowNo�����̱��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ģ����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	
	//���ҳ�����
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	if(sFlowNo==null) sFlowNo="";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders={
			{"FlowNo","���̱��"},
			{"FlowName","��������"},
			{"FlowTypeName","��������"},
			{"FlowDescribe","��������"},
			{"InitPhaseName","��ʼ�׶�"},
			{"AAEnabled","�Ƿ������Ȩ����"},
			{"AAPolicyName","��Ȩ����"}
		};

	sSql =  " select FlowNo,FlowName,FlowType,getItemName('ApplyType',FlowType) as FlowTypeName, "+
			" FlowDescribe,InitPhase,getPhaseName(FlowNo,InitPhase) as InitPhaseName, "+
			" AAEnabled,AAPolicy,getPolicyName(AAPolicy) as AAPolicyName "+
			" from FLOW_CATALOG where FlowNo = '"+sFlowNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_CATALOG";
	doTemp.setKey("FlowNo",true);
	doTemp.setHeader(sHeaders);
	//����ֻ��
	doTemp.setReadOnly("FlowNo,FlowName,FlowType,FlowDescribe,InitPhaseName",true);   
	//����������
	doTemp.setDDDWCode("AAEnabled","YesNo");
	//���ò��ɼ���
	doTemp.setVisible("FlowType,InitPhase,AAPolicy",false);
	//���ò��ɸ���
	doTemp.setUpdateable("FlowTypeName,InitPhaseName,AAPolicyName",false);
	//���ø�ʽ	
	doTemp.setHTMLStyle("FlowName"," style={width:300px} ");
	doTemp.setEditStyle("FlowDescribe","3");
	doTemp.setHTMLStyle("FlowDescribe","style={width=400px;height=150px;}");
   	//���õ���ʽѡ�񴰿�
	doTemp.setUnit("AAPolicyName","<input class=inputdate type=button value=\"...\" onClick=parent.getPolicyID()>");
	
	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	

	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","���ص��б�ҳ��","doReturn()",sResourcesPath}        
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
        sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1") //�Ƿ������Ȩ����
		{
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0)
			{
				alert("��ѡ����Ȩ������"); 
				return;
			}
		}else
		{
			//������д����Ȩ������Ϊ���ַ���
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
        as_save("myiframe0","");        
	}
       
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn()
    {
		OpenPage("/Common/Configurator/AAManage/FlowPolicySettingList.jsp","_self","");    	
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=������Ȩ����ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function getPolicyID()
	{		
		sToday = "<%=StringFunction.getToday()%>";	
		sParaString = "Today,"+sToday;
		setObjectValue("SelectPolicy",sParaString,"@AAPolicy@0@AAPolicyName@1",0,0,"");			
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
