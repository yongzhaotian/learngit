<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: ���Ŷ������������б�ҳ��
		Input Param:
			
		Output param:
		History Log: 
			zywei 2007/10/10 ���ӹ��˵������Ŷ�ȵ�����
			jgao1 2009-10-27 ��������ҳ��ı���CL_INFO��BUSINESS_CONTRACT
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ�����������"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//��ʾ����				
	String sTempletNo = "CreditLineSettingList";		
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//���ͨ��filter���ѯ���򲻻������µ���������
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and BeginDate <= '"+StringFunction.getToday()+"' "+
		                                                           " and PutOutDate <= '"+StringFunction.getToday()+"' "+
		          												   " and Maturity >= '"+StringFunction.getToday()+"' "+
																   " and (FreezeFlag = '1' "+//�����־FreezeFlag(1:����;2:����;3:�ⶳ;4:��ֹ)
																   " or FreezeFlag = '3') ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
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
		{"true","","Button","�������","�鿴/�޸�����","openWithObjectViewer()",sResourcesPath},
		//{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","���Ŷ������ҵ��","������Ŷ������ҵ��","lineSubList()",sResourcesPath},
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
		popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","ObjectNo="+sSerialNo,"","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			sReturn = PopPageAjax("/CreditManage/CreditLine/CheckCLDelActionAjax.jsp?ObjectNo="+sSerialNo,"","");
			if (typeof(sReturn)=="undefined" || sReturn.length==0){
	            RunMethod("CreditLine","DeleteLineRelative",sSerialNo);
	            alert(getHtmlMessage('7'));//��Ϣɾ���ɹ��� add by cdeng 2009-02-25
	            reloadSelf();
	        }else if(sReturn == 'Reinforce')
	        {
	            alert(getBusinessMessage('425'));//�ú�ͬΪ���Ǻ�ͬ������ɾ����
	            return;
	        }else if(sReturn == 'Finish')
	        {
	            alert(getBusinessMessage('426'));//�ú�ͬ�Ѿ����ս��ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'Pigeonhole')
	        {
	            alert(getBusinessMessage('427'));//�ú�ͬ�Ѿ���ɷŴ��ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'Use')
	        {
	            alert(getBusinessMessage('430'));//�����Ŷ���ѱ�ռ�ã�����ɾ����
	            return;
	        }
		}
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
		openObject("BusinessContract",sSerialNo,"001");
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
