<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    ����׶�ģ������
		Input Param:
					WizardNo:  ��ģ�ͱ��
                    PhaseNo:  �׶κ�
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����׶�ģ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	//����������	
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
		{"PhaseNo","PhaseNo"},
		{"PhaseType","�׶�����"},
		{"PhaseName","�׶�����"},
		{"PhaseDescribe","�׶�����"},
		{"PhaseAttribute","�׶�����"},
		{"HelpID","�������[ͣ��]"},
		{"SkipScript","��ԽScript"},
		{"PreScript","ǰ��ִ��Script"},
		{"InitScript","������Script"},
		{"PhaseRemark","�׶α�ע"},
		{"ActionScript","��������Script"},
		{"FinishScript","�걸��Script"},
		{"PostScript","�����׶�Scripit"}
	};
	
	sSql =  "select "+
			"WizardNo,"+
			"PhaseNo,"+
			"PhaseType,"+
			"PhaseName,"+
			"PhaseDescribe,"+
			"PhaseAttribute,"+
			"HelpID,"+
			"SkipScript,"+
			"PreScript,"+
			"InitScript,"+
			"PhaseRemark,"+
			"ActionScript,"+
			"FinishScript,"+
			"PostScript "+
		"from WZD_PHASE_DEF Where WizardNo = '"+sWizardNo+"' and PhaseNo='"+sPhaseNo+"' ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "WZD_PHASE_DEF";
	doTemp.setKey("WizardNo,PhaseNo",true);
	doTemp.setHeader(sHeaders);

 	doTemp.setRequired("WizardNo,PhaseNo",true);
	doTemp.setEditStyle("SkipScript,PreScript,InitScript,PhaseRemark,ActionScript,FinishScript,PostScript","3");
	doTemp.setHTMLStyle("SkipScript,PreScript,InitScript,PhaseRemark,ActionScript,FinishScript,PostScript"," style={height:100px;width:400px;overflow:auto} ");
 	doTemp.setLimit("SkipScript,PreScript,InitScript,PhaseRemark,ActionScript,FinishScript,PostScript",120);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sWizardNo+","+sPhaseNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurPhaseNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
        as_save("myiframe0","doReturn('Y');");
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
        as_save("myiframe0","newRecord()");
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"PhaseNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sWizardNo = getItemValue(0,getRow(),"WizardNo");
        OpenComp("PhaseDefInfo","/Common/Configurator/WizardManage/PhaseDefInfo.jsp","WizardNo="+sWizardNo,"_self","");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
            if ("<%=sWizardNo%>" !="") 
            {
                setItemValue(0,0,"WizardNo","<%=sWizardNo%>");
            }
		    bIsInsert = true;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
