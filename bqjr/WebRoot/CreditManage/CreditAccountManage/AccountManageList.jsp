<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   qfang 2011-06-02
		Tester:	  
		Content:  �˻�����Listҳ��
		Input Param:
                  
		Output param:
		    
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�˻������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AccountManageList"; //ģ����
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ�������
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//���˲�ѯ
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����ҳ����ʾ������
	dwTemp.setPageSize(20);
	//ɾ���˻�����Ӧ����ˮ��(account_wastebook)�������Ϣ
	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteAccountData(#Account)");
	
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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","�˻�������ͬ","�鿴���˻������ĺ�ͬ","viewRelaContract()",sResourcesPath},					
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{		
		OpenComp("AccountManageInfo","/CreditManage/CreditAccountManage/AccountManageInfo.jsp","ReadOnly=y","_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
	    sAccount = getItemValue(0,getRow(),"Account");//--�������ͱ��
	    if(typeof(sAccount)=="undefined" || sAccount.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    sReturn=popComp("AccountManageInfo","/CreditManage/CreditAccountManage/AccountManageInfo.jsp","ReadOnly=n&Account="+sAccount,"");
	    reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sAccount = getItemValue(0,getRow(),"Account");//--�������ͱ��
		if (typeof(sAccount)=="undefined" || sAccount.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		if(confirm(getHtmlMessage('70')))//�������ȡ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
    
	/*~[Describe=�鿴�˻���غ�ͬ;InputParam=��;OutPutParam=��;]~*/
	function viewRelaContract()
	{
		sAccount = getItemValue(0,getRow(),"Account");//--�������ͱ��
		if( typeof(sAccount)=="undefined" || sAccount.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		openComp("RelaContractOfAccountList","/CreditManage/CreditAccountManage/RelaContractOfAccountList.jsp","Account="+sAccount,"_blank","");
	}

	/*~[Describe=ѡ��ĳ����¼,������ʾ��Ӧ���˻������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow()
	{
		sAccount = getItemValue(0,getRow(),"Account");//--��ˮ����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--�ͻ�ID
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//--�ͻ�����
		if(typeof(sAccount)=="undefined" || sAccount.length==0) {
			
		}else{
			OpenPage("/CreditManage/CreditAccountScout/AccountScoutList.jsp?Account="+sAccount+"&CustomerID="+sCustomerID+"&CustomerName="+sCustomerName,"DetailFrame","");
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	OpenPage("/Blank.jsp?TextToShow=<font size='3px'><b>�˻����</b></font></br></br>����ѡ��һ���˻�!","DetailFrame","");
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
