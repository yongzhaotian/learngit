<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: ���Ŷ�ȼ���б�ҳ��
		Input Param:
			
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ�ȼ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
    String sToday = StringFunction.getToday();
	
	//����������	
	
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����				
 String sTempletNo="CreditLineMonitorList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	dwTemp.setEvent("AfterDelete","!CreditLine.DeleteLineRelative(#BCSerialNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sToday);
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
		{"true","","Button","���Ŷ������ҵ��","������Ŷ������ҵ��","lineSubList()",sResourcesPath},
		{"true","","Button","���ʹ�ò�ѯ","�����ѡ�еĶ������ҵ��ĺϷ���","checkCreditLine()",sResourcesPath},
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
		popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","LineNo="+sSerialNo,"","");
	}
	
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer(){
		var sLineID=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sLineID)=="undefined" || sLineID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("BusinessContract",sLineID,"002");
	}
	
	/*~[Describe=�����ѡ�еĶ������ҵ��ĺϷ���;InputParam=��;OutPutParam=��;]~*/
	function checkCreditLine(){
		var serialNo=getItemValue(0,getRow(),"SerialNo");

		if (typeof(serialNo)=="undefined" || serialNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }  
		AsControl.PopView("/CreditManage/CreditLine/CreditLineUseList.jsp","SerialNo="+serialNo,"dialogWidth=800px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//alert("����ֵ��"+sReturn+" \n˵���� Refuse ��ʾ����У�鲻ͨ��  Pass ��ʾ����У��ͨ��!");
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
