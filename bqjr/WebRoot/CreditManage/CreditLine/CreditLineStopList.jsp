<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2006/04/01
		Tester:
		Content: ���Ŷ����ֹ�б�ҳ��
		Input Param:
			StopFlag����ֹ��־��1����Ч�ģ�2���ѱ���ֹ�ģ�
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ����ֹ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	String sStopFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("StopFlag"));
	if(sStopFlag == null) sStopFlag = "";
	//���ҳ�����	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����				
	String sTempletNo="CreditLineStopList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//�����־FreezeFlag��1��������2�����᣻3���ⶳ��4����ֹ��		
	if(sStopFlag.equals("1")) //��Ч��
		doTemp.WhereClause +=  " and FreezeFlag in ('1','2','3') ";  
	if(sStopFlag.equals("2")) //�ѱ���ֹ��
		doTemp.WhereClause +=  " and FreezeFlag = '4' ";
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//���ͨ��filter���ѯ���򲻻������µ���������
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and BeginDate <= '"+StringFunction.getToday()+"' "+
                                                           " and PutOutDate <= '"+StringFunction.getToday()+"' "+
          												   " and Maturity >= '"+StringFunction.getToday()+"' ";  	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{(sStopFlag.equals("1")?"true":"false"),"","Button","��ֹ","��ֹ��ѡ�Ķ�ȼ�¼","stopRecord()",sResourcesPath},
		{"true","","Button","�������","�鿴/�޸�����","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","���Ŷ������ҵ��","������Ŷ������ҵ��","lineSubList()",sResourcesPath},
		{"true","","Button","�����ص�����","�����ص�����","addUserDefine()",sResourcesPath},
		{"true","","Button","���ʹ�ò�ѯ","���ʹ�ò�ѯ","QueryUseInfo()",sResourcesPath}
		};
		
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=��ֹ���Ŷ��;InputParam=��;OutPutParam=��;]~*/
	function stopRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getBusinessMessage('406')))//ȷʵҪ��ֹ�ñ����Ŷ����
		{
			//��ֹ����
			sReturn=RunMethod("BusinessManage","FreezeCreditLine",sSerialNo+","+"4");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('407'));//��ֹ���Ŷ��ʧ�ܣ�
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('408'));//��ֹ���Ŷ�ȳɹ���
			}
		}		
	}
			
	/*~[Describe=���Ŷ������ҵ��;InputParam=��;OutPutParam=��;]~*/
	function lineSubList()
	{		
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//modify by hwang 20070701,�޸������������CreditAggreement��ΪLineNo
		popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","LineNo="+sSerialNo,"","");
	}
			
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("BusinessContract",sSerialNo,"002");
	}
    
	/*~[Describe=�鿴���ʹ�����;InputParam=��;OutPutParam=��;]~*/
	function QueryUseInfo()
	{
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }  
		AsControl.PopView("/CreditManage/CreditLine/CreditLineUseList.jsp","SerialNo="+serialNo,"dialogWidth=800px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=�����ص��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function addUserDefine(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage('420'))){ //Ҫ�������ͬ��Ϣ�����ص��ͬ��������
			var sRvalue=PopPageAjax("/Common/ToolsB/AddUserDefineActionAjax.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
			alert(getBusinessMessage(sRvalue));
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
