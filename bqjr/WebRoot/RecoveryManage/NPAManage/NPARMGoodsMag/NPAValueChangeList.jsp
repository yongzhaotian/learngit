<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-6
		Tester:
		Describe: ����Ѻ����Ϣ����б�;
		Input Param:
			ChangeType: ������ͣ�010����ֵ�����020�����������030������Ȩ֤�����
			GuarantyID: ��������ˮ��			
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ѻ����Ϣ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletFilter = "";
	String sTempletNo = "";
	//����������	
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));
	String sChangeType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ChangeType"));
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyType"));
	//����ֵת��Ϊ���ַ���
	if(sChangeType == null) sChangeType = "";
	if(sGuarantyID == null) sGuarantyID = "";
	if(sGuarantyType == null) sGuarantyType = "";
	if(sFinishType == null) sFinishType = "";
	//���ҳ�����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//��ʾģ��		
	if(sGuarantyType.equals("050")){
		sTempletNo = "PawnChangeList";	
	}
	else if(sGuarantyType.equals("060")){
		sTempletNo = "ImpawnChangeList";
	}
	else{
		out.print("������ʽ���ǵ�Ѻ����Ѻ���޷���ʾ�����Ϣ!");
	}
		
	//����ChangeType�Ĳ�ͬ���õ���ͬ�Ĺ�������
    sTempletFilter = " (ColAttribute like '%"+sChangeType+"%' ) ";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);	

        	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����setEvent
	dwTemp.setEvent("AfterDelete","!BusinessManage.UpdateGuarantyChangeInfo("+sGuarantyID+",,"+sChangeType+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID+","+sChangeType);
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
				{sFinishType.equals("")?"true":"false","","Button","����","��������Ѻ����Ϣ���","newRecord()",sResourcesPath},
				{"true","","Button","����","�鿴����Ѻ����Ϣ�������","viewAndEdit()",sResourcesPath},
				{sFinishType.equals("")?"true":"false","","Button","ɾ��","ɾ������Ѻ����Ϣ���","deleteRecord()",sResourcesPath}
			};			
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeInfo.jsp?ChangeType=<%=sChangeType%>&GuarantyType=<%=sGuarantyType%>","_self");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}		
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeInfo.jsp?SerialNo="+sSerialNo+"&GuarantyType=<%=sGuarantyType%>","_self");
		}
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

<%@	include file="/IncludeEnd.jsp"%>