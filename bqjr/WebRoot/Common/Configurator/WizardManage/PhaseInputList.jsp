<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2005-1-5
		Tester:
		Content: ���������������б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
    String sWizardNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("WizardNo"));
    String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	if(sWizardNo==null) sWizardNo="";
	if(sPhaseNo==null) sPhaseNo="";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"WizardNo","��ģ�ͱ��"},
		{"PhaseNo","�׶κ�"},
		{"ParameterID","�������"},
		{"ParameterName","��������"},
	};
	sSql = "select "+
		   "WizardNo,"+
		   "PhaseNo,"+
		   "ParameterID,"+
		   "ParameterName "+
		  "from WZD_PHASE_INPUT Where WizardNo = '"+sWizardNo+"' and PhaseNo = '"+sPhaseNo+"' order by WizardNo,PhaseNo,ParameterID";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "WZD_PHASE_INPUT";
	doTemp.setKey("WizardNo,PhaseNo,ParameterID",true);
	doTemp.setHeader(sHeaders);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);
    
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sWizardNo+","+sPhaseNo);
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
        	// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","����","doReturn('N')",sResourcesPath}
		};
    %> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurRowNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("PhaseInputInfo","/Common/Configurator/WizardManage/PhaseInputInfo.jsp","WizardNo=<%=sWizardNo%>~PhaseNo=<%=sPhaseNo%>~IsNew=Y","");
        reloadSelf();         
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sWizardNo = getItemValue(0,getRow(),"WizardNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        sParameterID = getItemValue(0,getRow(),"ParameterID");
        if(typeof(sParameterID)=="undefined" || sParameterID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        sReturn=popComp("PhaseInputInfo","/Common/Configurator/WizardManage/PhaseInputInfo.jsp","WizardNo="+sWizardNo+"~PhaseNo="+sPhaseNo+"~ParameterID="+sParameterID+"~IsNew=N","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sParameterID = getItemValue(0,getRow(),"ParameterID");
        if(typeof(sParameterID)=="undefined" || sParameterID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ParameterID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
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
