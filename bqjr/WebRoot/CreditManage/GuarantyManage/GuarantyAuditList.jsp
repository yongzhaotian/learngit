<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2006-8-18
		Tester:
		Describe: ����Ѻ�����/������Ϣ�б�;
		Input Param:
			GuarantyID: ����Ѻ����
			GuarantyStatus������Ѻ��״̬			
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ѻ�����/������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������������Ѻ���š�����Ѻ��״̬
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	String sGuarantyStatus  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyStatus"));
	if(sGuarantyID == null) sGuarantyID = "";
	if(sGuarantyStatus == null) sGuarantyStatus = "";
	
	//���ҳ�����
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sTempletNo = "GuarantyAuditList";//ģ�ͱ��
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//��������¼�
	dwTemp.setEvent("AfterDelete","!BusinessManage.UpdateGuarantyStatus(#GuarantyID,01)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);//����datawindow��Sql���

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
		//{(sGuarantyStatus.equals("03")?"true":"false"),"","Button","����","����������Ϣ","newRecord()",sResourcesPath},
		//{(sGuarantyStatus.equals("03")?"true":"false"),"","Button","ɾ��","ɾ��������Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","����","�鿴����Ѻ����ʱ��������","viewAndEdit()",sResourcesPath}
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
		OpenPage("/CreditManage/GuarantyManage/GuarantyAuditInfo.jsp","_self");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{			
			sInputUser = getItemValue(0,getRow(),"InputUser");
			sFaceReturnDate = getItemValue(0,getRow(),"FaceReturnDate");
			//�����û��Լ�¼��ģ���ʱ�����һ�δ�ؿ����Ϣ����ɾ��
			if(sInputUser == "<%=CurUser.getUserID()%>" && "<%=sGuarantyStatus%>" == "03" 
			&& (typeof(sFaceReturnDate)=="undefined" || sFaceReturnDate.length==0))
			{
				as_del('myiframe0');
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����	
			}else
			{
				alert("����Ϣ����ɾ����");
				return;
			}				
		}		
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");			
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenComp("AddGuarantyAudit","/CreditManage/GuarantyManage/GuarantyAuditInfo.jsp","SerialNo="+sSerialNo+"&GuarantyID=<%=sGuarantyID%>"+"&GuarantyStatus=<%=sGuarantyStatus%>","_self");
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