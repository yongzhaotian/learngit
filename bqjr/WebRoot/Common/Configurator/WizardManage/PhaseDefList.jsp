<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2005-1-5
		Tester:
		Content: ����׶�ģ���б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����׶�ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
    String sWizardNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("WizardNo"));
	if(sWizardNo==null) sWizardNo="";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"WizardNo","��ģ�ͱ��"},
		{"PhaseNo","�׶κ�"},
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
			"HelpID "+
		"from WZD_PHASE_DEF ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "WZD_PHASE_DEF";
	doTemp.setKey("WizardNo,PhaseNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("PhaseNo"," style={width:60px} ");
	doTemp.setHTMLStyle("PhaseName"," style={width:220px} ");
	doTemp.setHTMLStyle("PhaseDescribe"," style={width:300px} ");
	doTemp.setHTMLStyle("PhaseAttribute"," style={width:100px} ");
	doTemp.setVisible("HelpID",false);
	
	//��ѯ
 	doTemp.setColumnAttribute("WizardNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);
    
	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelPhaseInput(#WizardNo,#PhaseNo) + !Configurator.DelPhaseOutput(#WizardNo,#PhaseNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sWizardNo);
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
		{"true","","Button","��������б�","�鿴/�޸����������������б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","�������б�","�鿴/�޸����������������б�","viewAndEdit3()",sResourcesPath},
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
        sReturn=popComp("PhaseDefInfo","/Common/Configurator/WizardManage/PhaseDefInfo.jsp","WizardNo=<%=sWizardNo%>","");
        reloadSelf();            
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sWizardNo = getItemValue(0,getRow(),"WizardNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        sReturn=popComp("PhaseDefInfo","/Common/Configurator/WizardManage/PhaseDefInfo.jsp","WizardNo="+sWizardNo+"~PhaseNo="+sPhaseNo,"");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/WizardManage/PhaseDefList.jsp","_self","");           
            }
        }
	}

    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
        sWizardNo = getItemValue(0,getRow(),"WizardNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        popComp("PhaseInputList","/Common/Configurator/WizardManage/PhaseInputList.jsp","WizardNo="+sWizardNo+"~PhaseNo="+sPhaseNo,"");
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit3()
	{
    	sWizardNo = getItemValue(0,getRow(),"WizardNo");
    	sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
    	if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    	    return ;
		}
        popComp("PhaseOutputList","/Common/Configurator/WizardManage/PhaseOutputList.jsp","WizardNo="+sWizardNo+"~PhaseNo="+sPhaseNo,"");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
    	if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        	return ;
		}
		
		if(confirm(getHtmlMessage('53'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"PhaseNo");
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
