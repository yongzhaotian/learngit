<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	 /*
		Author:
		Tester:
		Describe: ����ͻ���Ϣ
		Input Param:
		Output Param:
		HistoryLog: fbkang on 2005/08/14 
		HistoryLog: fwang on 2009/06/15 ɾ��������ж�4���޸����Ƿ�ȫΪ�գ�ȫΪ�ղ��ܱ���
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%	
	String PG_TITLE = "����ͻ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//��ñ������ͻ����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//���������sql���
	String sSql = "";			 
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//���ݿͻ���Ż�ȡ�ͻ�����
	String sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
	if(sCustomerType == null) sCustomerType = "";
	
		// ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sTempletNo = "ChangeCustomerInfo";//ģ�ͱ��
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);//�������,���ŷָ�
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
		   {"true","","Button","����","�������ͻ���Ϣ","saveRecord()",sResourcesPath},
		   {"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//����һ����ˮ�ŵı���
	var sSerialNo;
	//---------------------���尴ť�¼�------------------------------------	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		sCustomerType = "<%=sCustomerType%>";
		//��ȡ�����Ŀͻ����ơ�֤�����͡�֤����š�������
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sNewCustomerName = getItemValue(0,getRow(),"NewCustomerName");
		sNewCertType = getItemValue(0,getRow(),"NewCertType");
		sNewCertID = getItemValue(0,getRow(),"NewCertID");
		sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");
		if(sCustomerType == '03') //����
		{		
			if (!(typeof(sNewCustomerName) == "undefined" || sNewCustomerName != "" 
			|| typeof(sNewCertType) == "undefined" || sNewCertType != "" 
			|| typeof(sNewCertID) == "undefined" || sNewCertID != ""))
			{
				alert(getBusinessMessage('923'));//�����������Ŀͻ���Ϣ��
				return;
			}
		}else
		{
			if (!(typeof(sNewCustomerName) == "undefined" || sNewCustomerName != ""
			|| typeof(sNewCertType) == "undefined" || sNewCertType != ""
			|| typeof(sNewCertID) == "undefined" || sNewCertID != ""
			|| typeof(sNewLoanCardNo) == "undefined" || sNewLoanCardNo != ""))
			{
				alert(getBusinessMessage('923'));//�����������Ŀͻ���Ϣ��
				return;
			}
		}
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
	
		initSerialNo();//��ʼ����ˮ���ֶ�
		
		//����ͻ���Ϣ
		sCustomerID =sCustomerID + "@" + "<%=CurUser.getUserID()%>"+ "@" + "<%=CurUser.getOrgID()%>"+ "@" + "<%=StringFunction.getToday()%>"+"@"+sSerialNo;	
		sReturnValue = RunMethod("CustomerManage","UpdateCustomerInfo",sCustomerID+","+sNewCustomerName+","+sNewCertType+","+sNewCertID+","+sNewLoanCardNo);
	    /* if(typeof(sReturnValue) != "undefined" && sReturnValue != "") 
		{
			alert(getBusinessMessage('924'));//����ͻ���Ϣ�ɹ�!
			return;
		}else
		{
			alert(getBusinessMessage('925'));//����ͻ���Ϣʧ��!
			return;
		} */
		as_save("myiframe0","");;
	}	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/ChangeCustomerList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		if(sCustomerType == '0110' || sCustomerType == '0120') //��˾�ͻ�
		{		
			//�����֯��������֤����Ч��	
			sNewCertType = getItemValue(0,getRow(),"NewCertType");
			sNewCertID = getItemValue(0,getRow(),"NewCertID");
			
			//������ŵ���Ч��
			sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");			
			if(typeof(sNewLoanCardNo) != "undefined" && sNewLoanCardNo != "" )
			{
				
				//���������Ψһ��
				sCustomerID = getItemValue(0,getRow(),"CustomerID");
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoChangeCustomer",sCustomerID+","+sNewLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('227'));//�ô������ѱ������ͻ�ռ�ã�							
					return false;
				}						
			}						
		}
				
	
		return true;	
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_INFO_CHANGE ";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
