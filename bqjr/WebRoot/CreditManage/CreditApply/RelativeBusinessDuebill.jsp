<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: ��ͬ���½��
		Input Param:
			ObjectType: �׶α��
			ObjectNo��ҵ����ˮ��
		Output Param:
			
		HistoryLog:
			2009/08/13 djia ����AmarOTI --> queryBalance()
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ���½��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//���ҳ�����

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	CreditObjectAction creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	String occurType = creditObjectAction.getCreditObjectBO().getAttribute("OccurType").toString();
    
	String sTempletNo="RelativeBusinessDuebill";
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(occurType.equals("015")){  //չ�ڹ�����֮ǰ�Ľ����Ϣ
		doTemp.WhereClause += " and SerialNo = (SELECT ObjectNo FROM APPLY_RELATIVE where SerialNo = '" + sObjectNo + "' and ObjectType = 'BusinessDueBill') ";   
	}
	else{
		doTemp.WhereClause += " and RelativeSerialNo2 = '" + sObjectNo + "' ";
	}
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
			{"true","","Button","����","�鿴ҵ������","viewAndEdit()",sResourcesPath},
			{"true","","Button","���������ͬ","�����ݵĹ�����ͬ","ChangeContract()",sResourcesPath},
			{"true","","Button","��ѯ������","���ݽ�ݺŲ�ѯ������","queryBalance()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
			openObject("BusinessDueBill",sSerialNo,"002");
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=�����ݵĹ�����ͬ;InputParam=��;OutPutParam=��;]~*/
	function ChangeContract()
	{
		//�����ˮ�š�ԭ��ͬ��š��ͻ����
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sOldContractNo   = "<%=sObjectNo%>";
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else 
		{
			sParaString = "SerialNo"+","+sOldContractNo+",CustomerID"+","+sCustomerID;	
			sContractNo = setObjectValue("SelectChangeContract",sParaString,"",0,0,"");
			if (!(sContractNo=='_CANCEL_' || typeof(sContractNo)=="undefined" || sContractNo.length==0 || sContractNo=='_CLEAR_' || sContractNo=='_NONE_'))
			{
				if(confirm(getBusinessMessage('487'))) //ȷʵҪ�����ݵĹ�����ͬ��
				{
					sContractNo = sContractNo.split('@');
					sContractSerialNo = sContractNo[0];					
					var sReturn = PopPageAjax("/InfoManage/DataInput/ChangeContractActionAjax.jsp?ContractNo="+sContractSerialNo+"&DueBillNo="+sSerialNo+"&OldContractNo="+sOldContractNo,"","");
					if(sReturn == "true")
					{
						alert("��ͬ��"+sOldContractNo+"���µĽ�ݡ�"+sSerialNo+"���Ѿ��ɹ��������ͬ��"+sContractNo+"����!");
						reloadSelf();
					}
				}					
			}			 	
		}
	}
	
	/*~[Describe=��ѯ������;InputParam=��;OutPutParam=��;]~*/
	function queryBalance(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sOrgID = getItemValue(0,getRow(),"OperateOrgID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sReturn = PopPageAjax("/CreditManage/CreditApply/QueryBalanceAjax.jsp?SerialNo="+sSerialNo+"&orgID="+sOrgID,"","");
		if(typeof(sReturn) != "undefined"){
			sReturn=getSplitArray(sReturn);
	        sStatus=sReturn[0];
	        sMessage=sReturn[1];
	    	if(sStatus == "0"){
	    		sReturn = "�����ɹ������״��룺"+"Q002" + "������Ϊ��"+sMessage;
	    	}else{
	    		sReturn = "������ʾ��"+"Q002"+" ����ʧ�ܣ�ʧ����Ϣ��"+sMessage;
	    	}
	    	alert(sReturn);
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

<%@	include file="/IncludeEnd.jsp"%>
