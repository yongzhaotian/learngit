<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bwang 2009-02-17
		Tester:
		Content: ����ģ���б�,�鿴������ʷ
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	
	//����������	
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	
	//���ҳ�����	
	if(sPhaseNo==null)	sPhaseNo = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"ObjectType","��������"},
			{"FlowName","��������"},
			{"PhaseNo","�׶α��"},
			{"PhaseName","�׶�����"},
			{"UserName","�а���"},
			{"OrgName","�а����"},
			{"PhaseAction","ѡ����"},
			{"BeginTime","��ʼʱ��"},
			{"EndTime","����ʱ��"},
		};

	sSql =  " select SerialNo,ObjectType,FlowName,PhaseNo,PhaseName,UserName,"+
			" PhaseAction,BeginTime,EndTime "+
			" from FLOW_TASK where FlowNo='"+sFlowNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'  order by SerialNo";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_CATALOG";
	doTemp.setKey("FlowNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("SerialNo,ObjectType,FlowName,",false);
	doTemp.setHTMLStyle("FlowNo,BeginTime,EndTime,FlowName"," style={width:150px} ");
	doTemp.setHTMLStyle("PhaseNo,FlowType,InitPhase"," style={width:120px} ");	
	doTemp.setHTMLStyle("PhaseName,PhaseAction,FlowDescribe"," style={width:260px} ");
	
	//��ѯ
 	doTemp.setColumnAttribute("ObjectNo,CustomerName,PhaseNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

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
		{"false","","Button","���̹�����ϸ","���̹�����ϸ","FlowDetail()",sResourcesPath},
		{"false","","Button","����������","����������","backEveryStep()",sResourcesPath},
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
	/*~[Describe=�˻�ǰ����һ��;InputParam=��;OutPutParam=��;]~*/
	function backEveryStep()
	{		
		var sReturnValue ;
        //��ȡ������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = "<%=sFlowNo%>";		
   		
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
        {	
    		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		return;
		}
		
		//�˻��������   	
		sReturnValue = PopPage("/Common/WorkFlow/CancelPhaseNoSelect.jsp?SerialNo="+sSerialNo+"&FlowNo="+sFlowNo+"&rand=" + randomNumber(),"�˻��������","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");        
	
		if(typeof(sReturnValue)=="undefined"||sReturnValue=="_none_")
		{
				//alert("sReturnValue2:"+sReturnValue);  
		}
		else
		{
        	sReturnValue = PopPage("/Common/WorkFlow/CancelPhaseAction.jsp?SerialNo="+sSerialNo+"&PhaseNo="+sReturnValue+"&ObjectNo="+sObjectNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=50;dialogHeight=200;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
        	parent.reloadSelf();
		}
    	
	}
	function FlowDetail()
	{
        OpenComp("","","","_blank");
	}
	function madeFlowto()
	{
        
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
	var bHighlightFirst = true;
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
