<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: �����˻������ɲ�ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����˻������ɲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����˻������ɲ�ѯ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";

	String sCustomerID = Sqlca.getString(new SqlObject("SELECT CustomerID FROM  business_contract   where serialno='"+sObjectNo+"' "));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	



			String sHeaders[][] = {	{"SerialNo","�����ˮ��"},
									{"ContractSerialNo","��ͬ���"},
									{"CustomerID","�ͻ���"},
									{"CustomerName","�ͻ�����"},
									{"CertID","���֤��"},
									{"TelPhone","�ֻ�����"},
									{"OldAccountName","ԭ�����˻�����"},
									{"NewAccountName","�´����˻�����"},
									{"OldAccount","ԭ�����˻��˺�"},
									{"NewAccount","�´����˻��˺�"},
									{"OldBankName","ԭ�����˻�������"},
									{"NewBankName","�´����˻�������"},
									{"InputDate","¼������"},
									{"UpdateUserName","�����û�"},
									{"UpdateOrgName","���»���"},
									{"UpdateDate","��������"},
									{"StatusName","����״̬"}
			                       }; 
			
			
			String sSql = " select wci.SerialNo as SerialNo,wci.ContractSerialNo as ContractSerialNo,wci.CustomerID as CustomerID,wci.CustomerName as CustomerName,wci.CertID as CertID,wci.TelPhone as TelPhone,"+
						  " wci.OldAccountName as OldAccountName,wci.NewAccountName as NewAccountName,wci.OldAccount as OldAccount,wci.NewAccount as NewAccount,getitemname('BankCode',wci.OldBankName) as OldBankName,"+
					      " getitemname('BankCode',wci.NewBankName) as NewBankName, "+
						  " wci.InputDate as InputDate,getUserName(wci.UpdateUserID) as UpdateUserName,getOrgName(wci.UpdateOrgID) as UpdateOrgName,wci.UpdateDate as UpdateDate,getItemName('Status',wci.Status) as StatusName "+
						  " from WITHHOLD_CHARGE_INFO wci,BUSINESS_CONTRACT BC where wci.Customerid = BC.Customerid and wci.contractserialno = bc.serialno "+
						  " and BC.customerid = '"+sCustomerID+"'";

			//��SQL������ɴ������
			ASDataObject doTemp = new ASDataObject(sSql);
			doTemp.setHeader(sHeaders);
			doTemp.UpdateTable = "WITHHOLD_CHARGE_INFO";
			doTemp.setKey("SerialNo",true);	 //Ϊ�����ɾ��
			//���ò��ɼ���
			doTemp.setVisible("ContractSerialNo",false);
			//doTemp.setUpdateable("UserName,OrgName",false);
			//doTemp.setHTMLStyle("InterSerialNo,AboutBankID,UserName"," style={width:80px} ");
			//doTemp.setType("BillSum","number");
			//doTemp.setAlign("BillSum","3");
			
			//����datawindow
			ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
			dwTemp.Style="1";      //����ΪGrid���
			dwTemp.ReadOnly = "1"; //����Ϊֻ��
			
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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},

	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		 sCompID = "ChargeApplyInfo1";
		sCompURL = "/InfoManage/QuickSearch/ChargeApplyInfo1.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

	}
	
	function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sExchangeType = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		//������֪ͨ���Ƿ��Ѿ�����
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //δ���ɳ���֪ͨ��
			//���ɳ���֪ͨ��	
			PopPage("/FormatDoc/Report13/7001.jsp?DocID=7001&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//��ü��ܺ�ĳ�����ˮ��
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		
		//ͨ����serverlet ��ҳ��
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		
		
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
