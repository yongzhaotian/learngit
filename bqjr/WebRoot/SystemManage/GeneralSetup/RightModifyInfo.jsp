<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29 
		Tester:
		Describe: �ͻ�����Ȩά����ϵͳû�м�¼������־���������д������뱣��ʱ������ӣ�
		Input Param:
			CustomerID����ǰ�ͻ����
			SerialNo:	��ˮ��
		Output Param:
			CustomerID����ǰ�ͻ����

		HistoryLog:
			     ndeng 2004-11-30
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�����Ȩά����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//���ҳ�����
	
	//����������	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	//����ֵת��Ϊ���ַ���
	if(sCustomerID == null) sCustomerID = "";
	if(sOrgID == null) sOrgID = "";	
	if(sUserID == null) sUserID = "";
		
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	String sTempletNo = "RightModifyInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sOrgID+","+sUserID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//--��ÿͻ����
		var sUserID = getItemValue(0,getRow(),"UserID");//--����û����
		var sBelongAttribute =  getItemValue(0,getRow(),"BelongAttribute");//--��ÿͻ�����Ȩ��־
        var sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");//--�����Ϣ�鿴Ȩ��־
        var sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");//--�����Ϣά��Ȩ��־
        var sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");//--���ҵ�����Ȩ��־
        var sBelongAttribute4 = getItemValue(0,getRow(),"BelongAttribute4");//--��ô�����Ȩ�ޱ�־
        sReturn = PopPageAjax("/CustomerManage/AuthorizeRoleActionAjax.jsp?CustomerID="+sCustomerID+"&UserID="+sUserID+"&ApplyAttribute="+sBelongAttribute+"&ApplyAttribute1="+sBelongAttribute1+"&ApplyAttribute2="+sBelongAttribute2+"&ApplyAttribute3="+sBelongAttribute3+"&ApplyAttribute4="+sBelongAttribute4,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
        sReturn = getSplitArray(sReturn);
        sHave = sReturn[0];
        sOrgName = sReturn[1];
        sUserName = sReturn[2];
        sBelongUserID = sReturn[3];
        if(sHave == "_TRUE_"){
            if(confirm(sOrgName+" "+sUserName+" "+"�Ѿ�ӵ�иÿͻ�������Ȩ���Ƿ�������������Ȩת�ƣ�ԭ������Ȩ�����Զ�ɥʧһ�пͻ�Ȩ�����������������������룡"))
            {
                var sReturn=PopPageAjax("/CustomerManage/ChangeRoleActionAjax.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&BelongUserID="+sBelongUserID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
				if(typeof(sReturn)!="undefined" && sReturn=="true"){
	                alert(getBusinessMessage('224'));//�ͻ�Ȩ�ޱ���ɹ���
					self.close();
				 }else{
					 alert("�ͻ�Ȩ�ޱ���ʧ�ܣ�");
				 }
            }            
        }else{
            alert(getBusinessMessage('224'));//�ͻ�Ȩ�ޱ���ɹ���
        }	
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>