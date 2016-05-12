<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: Ԥ���źŽ����Ϣ_List
		Input Param:
			SignalType��Ԥ�����ͣ�01������02�������						 
			SignalStatus��Ԥ��״̬��10��������15�����ַ���20�������У�30����׼��40�������     
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
		
	//����������	
	String sSignalType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));	
	String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));	
	//����ֵת��Ϊ���ַ���	
	if(sSignalType == null) sSignalType = "";
	if(sSignalStatus == null) sSignalStatus = "";	
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {							
							{"CustomerName","�ͻ�����"},
							{"SignalName","Ԥ���ź�"},
							{"SignalType","Ԥ������"},
							{"SignalStatus","Ԥ��״̬"},													
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�ʱ��"}
						};
		
	sSql =  " select ObjectNo,GetCustomerName(ObjectNo) as CustomerName, "+
			" SignalName,getItemName('SignalType',SignalType) as SignalType, "+
			" getItemName('SignalStatus',SignalStatus) as SignalStatus, "+
			" GetOrgName(InputOrgID) as InputOrgName, "+
			" GetUserName(InputUserID) as InputUserName,InputDate,SerialNo, "+
			" ObjectType "+
			" from RISK_SIGNAL "+
			" where ObjectType = 'Customer' "+
			" and SignalType = '"+sSignalType+"' "+   
			" and SignalStatus = '"+sSignalStatus+"' "+
			" and InputUserID = '"+CurUser.getUserID()+"' ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	//���ø�ʽ
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");	
	//���ù�����
	doTemp.setColumnAttribute("CustomerName,SignalName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
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
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","����","����һ���������Ԥ���ź�","newRecord()",sResourcesPath},
			{((!sSignalStatus.equals("10") && !sSignalStatus.equals("20"))?"true":"false"),"","Button","�鿴���","�鿴/�޸��϶��������","viewOpinion()",sResourcesPath},
			{"true","","Button","Ԥ���������","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","�ύ","�ύ��ѡ�еļ�¼","commitRecord()",sResourcesPath}		
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
		//��ȡ����׼��Ԥ���ź�
		sParaStr = "InputUserID"+","+"<%=CurUser.getUserID()%>";
		sReturn = setObjectValue("SelectRiskSignal",sParaStr,"",0,0,"");
		//�ж��Ƿ񷵻���Ч��Ϣ
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sSerialNo = sReturn[0];	
		//����׼��Ԥ���ź���Ϣ������Ԥ���źŽ����Ϣ��
		sReturn = RunMethod("BusinessManage","AddRiskSignalFreeInfo",sSerialNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sReturn) != "undefined" && sReturn.length > 0) 			
			OpenPage("/CreditManage/CreditAlarm/RiskSignalFreeApplyInfo.jsp?SerialNo="+sReturn,"_self","");
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinion()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		popComp("ViewRiskSignalOpinions","/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","ObjectNo="+sSerialNo+"&SignalType=<%=sSignalType%>","");
	}
					
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/CreditManage/CreditAlarm/RiskSignalFreeApplyInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=�ύ��¼;InputParam=��;OutPutParam=��;]~*/
	function commitRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
			
		if(confirm(getHtmlMessage('17'))) //ȷ����Ҫ�ύ�ü�¼��
	    {
			//ȡ���鵵����
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

<%@ include file="/IncludeEnd.jsp"%>
