<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: ǩ�����
	Input Param:
		TaskNo��������ˮ��
		ObjectNo��������
		ObjectType����������
	Output param:
	History Log: zywei 2005/07/31 �ؼ�ҳ��
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������¼�";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	//��ȡ���������������ˮ��
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("SerialNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>

	<%
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sTempletNo = "BusinessFeeEvent";//ģ�ͱ��
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);//�������,���ŷָ�
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"false","","Button","����","�����б�ҳ��","saveRecordAndBack()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//var bIsInsert = false;
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{	
		if(!vI_all("myiframe0")) return;
		if(confirm("��ȷ��Ҫ�����ñʷ�����")){
			var sLoanSerialno=getItemValue(0,getRow(),"LoanSerialno");
			var sEventType=getItemValue(0,getRow(),"AcctFeeType");
			var sEventFee=getItemValue(0,getRow(),"EventFee");
			var sEventExplain=getItemValue(0,getRow(),"EventExplain");
			
			sParaString = sEventType+",jbo.app.ACCT_LOAN,"+sLoanSerialno+","+"<%=CurUser.getUserID()%>";
			var sFeeSerialNo=RunMethod("LoanAccount","CreateFee",sParaString);
			sParaString =sFeeSerialNo+","+sEventFee+","+sLoanSerialno+","+sEventExplain+","+"<%=CurUser.getUserID()%>"+","+"<%=CurUser.getOrgID()%>";
		    sReturn=RunMethod("BusinessManage","BusinessFeeEvent",sParaString);
			if (sReturn=="success"){
				alert("�����ɹ�");
			}else{
				alert("����ʧ��");
			}
		}
	}
	
	/*~[Describe=��ѯѡ���¼����õķ��ý��;InputParam=��;OutPutParam=��;]~*/
	function selEventFeeAmount()
	{
			var sFeeTermID=getItemValue(0,getRow(),"AcctFeeType");
			var dFeeAmount=RunMethod("BusinessManage","SelEventFeeAmount",sFeeTermID);
			if(dFeeAmount=="Null" || dFeeAmount=="") dFeeAmount=0.0;
			setItemValue(0,getRow(),"EventFee",dFeeAmount);
	}
	
	/*~[Describe=��DW��ǰ��¼���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");			      
	}
	</script>
<%/*~END~*/%>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>