<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   qfang 2011-06-02 
		Tester:
		Content:   �˻���������	
		Input Param:	
 		Output param:                
		History Log:            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�˻���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
	//����������:�˺�
	String sAccount =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Account"));
	String readOnly =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReadOnly"));
	if(sAccount==null) sAccount = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AccountManageInfo"; //ģ����
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ�������
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    if(!sAccount.equals(""))
    {
    	doTemp.setReadOnly("Account,IsOwnBank",true);	
    }
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccount);
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
			{"y".equalsIgnoreCase(readOnly)?"true":"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"false","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>	
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(bIsInsert){
			if (!ValidityCheck()){
				return;
			}else{
				as_save("myiframe0");
			}
		}else
		{
			alert("�˻����鲻���޸�");
		}
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function goBack(){
        self.close();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function initRow(){
		
		
		
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>")
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"AccountSource","020");
			bIsInsert = true;
		}
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ�����		
		sReturn = setObjectValue("SelectOrgCustomer","","@CustomerID@0@CustomerName@1",0,0,"");
		if(sReturn == "_CLEAR_"){
			setItemDisabled(0,0,"CustomerID",false);
			setItemDisabled(0,0,"CustomerName",false);
		}else{
			//��ֹ�û��㿪��ʲôҲ��ѡ��ֱ��ȡ��������ס�⼸������
			sCustomerID = getItemValue(0,0,"CustomerID");
			if(typeof(sCertID) != "undefined" && sCertID != ""){
				setItemDisabled(0,0,"CustomerID",false);
				setItemDisabled(0,0,"CustomerName",false);
			}else{
				setItemDisabled(0,0,"CustomerID",false);
				setItemDisabled(0,0,"CustomerName",false);
			}
		}
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		sAccount = getItemValue(0,getRow(),"Account");//�˺�
		//����˻�����Ч��
		if (sAccount.length > 0)
		{
			var Letters = "#";
			//����ַ������Ƿ����"#"�ַ�
			if (!(sAccount.indexOf(Letters) == -1))
			{			        
				alert("������˺����������������˺�");
				return false;
			}
		}		
		//����˻���Ψһ��
		sReturn=RunMethod("BusinessManage","CheckAccountChangeCustomer",sAccount);

		if(typeof(sReturn) != "undefined" && sReturn == "false")
		{
			alert("�˻��Ѿ��Ǽ�");
			return false;
		}else
		return true;
		
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
