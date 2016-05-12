<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: ��˾�ͻ�Ԥ���ź���Ϣ_List
		Input Param:			
			CustomerID���ͻ����			  
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��˾�ͻ�Ԥ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
		
	//����������		
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));	
	//����ֵת��Ϊ���ַ���	
	if(sCustomerID == null) sCustomerID = "";
	
	//���ҳ�����	
%>
<%/*~END~*/%>


<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "EntRiskSignalList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
			{"true","All","Button","����","����һ����¼","newRecord()",sResourcesPath},			
			{"true","","Button","����","�鿴/�޸�Ԥ���ź�����","viewAndEdit()",sResourcesPath},
			{"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"true","All","Button","�ύ","�ύ��ѡ�еļ�¼","commitRecord()",sResourcesPath}		
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
		OpenPage("/CreditManage/CreditAlarm/EntRiskSignalInfo.jsp?EditRight=02","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSignalStatus = getItemValue(0,getRow(),"SignalStatus");
		sUserID = getItemValue(0,getRow(),"InputUserID");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>' && sSignalStatus == '10')
		{			
			if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
			{
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}			
		}else alert(getHtmlMessage('3'));	
	}
			
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSignalStatus = getItemValue(0,getRow(),"SignalStatus");//--Ԥ��״̬
		sUserID = getItemValue(0,getRow(),"InputUserID");//--�û�����
		if(sUserID=='<%=CurUser.getUserID()%>' && sSignalStatus == '10')
			sEditRight='02';
		else
			sEditRight='01';
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/CreditManage/CreditAlarm/EntRiskSignalInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight,"_self","");
	}
	
	/*~[Describe=�ύ��¼;InputParam=��;OutPutParam=��;]~*/
	function commitRecord()
	{
		sSignalStatus = getItemValue(0,getRow(),"SignalStatus");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		
		if(sSignalStatus == '10')
		{	
			if(confirm(getHtmlMessage('17'))) //ȷ����Ҫ�ύ�ü�¼��
		    {
				//�ύ����
				sReturn = RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@15,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
					alert(getHtmlMessage('9'));//�ύʧ�ܣ�
					return;
				}else
				{
					reloadSelf();
					alert(getHtmlMessage('18'));//�ύ�ɹ���
				}				
		   	}
		}else alert(getHtmlMessage('28'));//�Ѿ��ύ����Ϣ�����ٴ��ύ��
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
