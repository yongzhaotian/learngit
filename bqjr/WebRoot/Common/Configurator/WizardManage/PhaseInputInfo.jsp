<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    ������������������
		Input Param:
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	//����������	
	String sWizardNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("WizardNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sParameterID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ParameterID"));
	String sIsNew =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("IsNew"));
	if(sWizardNo==null) sWizardNo="";
	if(sPhaseNo==null) sPhaseNo="";
	if(sParameterID==null) sParameterID="";
	if(sIsNew.equals("Y") && !sParameterID.equals("")) sParameterID="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"WizardNo","��ģ�ͱ��"},
		{"PhaseNo","PhaseNo"},
		{"ParameterID","�������"},
		{"ParameterName","��������"},
		{"CalculateScript","Ĭ��ֵ���㹫ʽ"}
	};
	sSql = "select "+
		   "WizardNo,"+
		   "PhaseNo,"+
		   "ParameterID,"+
		   "ParameterName,"+
		   "CalculateScript "+
		  "from WZD_PHASE_INPUT Where WizardNo = '"+sWizardNo+"' and PhaseNo = '"+sPhaseNo+"' and ParameterID = '"+sParameterID+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "WZD_PHASE_INPUT";
	doTemp.setKey("WizardNo,PhaseNo,ParameterID",true);
	doTemp.setHeader(sHeaders);

 	doTemp.setRequired("WizardNo,PhaseNo,ParameterID",true);
	doTemp.setEditStyle("CalculateScript","3");
	doTemp.setHTMLStyle("CalculateScript"," style={height:100px;width:400px;overflow:auto} ");
 	doTemp.setLimit("CalculateScript",120);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sWizardNo+","+sPhaseNo+","+sParameterID);
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
		sObjectNo = getItemValue(0,getRow(),"ParameterID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sWizardNo = getItemValue(0,getRow(),"WizardNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        OpenComp("PhaseInputInfo","/Common/Configurator/WizardManage/PhaseInputInfo.jsp","WizardNo="+sWizardNo+"&PhaseNo="+sPhaseNo+"&IsNew=Y","_self",""); 
        //OpenPage("/Common/Configurator/WizardManage/PhaseInputInfo.jsp?WizardNo="+sWizardNo+"&PhaseNo="+sPhaseNo,"_self","");
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
            if ("<%=sPhaseNo%>" !="") 
            {
                setItemValue(0,0,"PhaseNo","<%=sPhaseNo%>");
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
