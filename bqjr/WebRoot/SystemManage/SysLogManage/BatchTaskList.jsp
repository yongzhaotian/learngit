<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   yyang3 2013-03-12
		Tester:
		Content: ҵ����������־�б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ����������־�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//��ȡ�������
	
	//��ȡҳ�����
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "BatchTaskList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //���ӹ�����	
	doTemp.setColumnAttribute("INPUTDATE,TASKNAME,TARGETDESCRIBE,TASKDESCRIBE,STATUS","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and InputDate = '"+SystemConfig.getBusinessDate()+"'";
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
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
		{"true","","Button","�鿴��Ϣ","�鿴��ϸ��Ϣ","viewError()",sResourcesPath},
		{"true","","Button","����","����ѡ�еĲ���","skip()",sResourcesPath},
		{"true","","Button","��Ԫ������ϸ","��Ԫ������ϸ","viewErrorDetail()",sResourcesPath}
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
	/*~[Describe=�鿴��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewError()
	{
		inputDate = getItemValue(0,getRow(),"INPUTDATE");
		targetName = getItemValue(0,getRow(),"TARGETNAME");
		taskName = getItemValue(0,getRow(),"TASKNAME");
		hostIP = getItemValue(0,getRow(),"HOSTIP");
		processID = getItemValue(0,getRow(),"PROCESSID");
        if(typeof(inputDate) == "undefined" || inputDate.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		popComp("BatchTaskInfo","/SystemManage/SysLogManage/BatchTaskInfo.jsp","InputDate="+inputDate+"&TargetName="+targetName+"&TaskName="+taskName+"&HostIP="+hostIP+"&ProcessID="+processID);
	}

	//�����ò���
	function skip()
	{
		inputDate = getItemValue(0,getRow(),"INPUTDATE");
		targetName = getItemValue(0,getRow(),"TARGETNAME");
		taskName = getItemValue(0,getRow(),"TASKNAME");
		hostIP = getItemValue(0,getRow(),"HOSTIP");
		processID = getItemValue(0,getRow(),"PROCESSID");
        if(typeof(inputDate) == "undefined" || inputDate.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		if(!confirm("ȷ�������˲���")) return;
		RunMethod("LoanAccount","UpdateBatchTaskStatus",inputDate+","+targetName+","+taskName+","+hostIP+","+processID+",4");
		reloadSelf();
	}

	/*~[Describe=�鿴������ϸ;InputParam=��;OutPutParam=��;]~*/
	function viewErrorDetail()
	{
		inputDate = getItemValue(0,getRow(),"INPUTDATE");
		targetName = getItemValue(0,getRow(),"TARGETNAME");
		taskName = getItemValue(0,getRow(),"TASKNAME");
		hostIP = getItemValue(0,getRow(),"HOSTIP");
		processID = getItemValue(0,getRow(),"PROCESSID");
        if(typeof(inputDate) == "undefined" || inputDate.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		popComp("BatchTaskError","/SystemManage/SysLogManage/BatchTaskError.jsp","InputDate="+inputDate+"&TaskName="+taskName);
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
