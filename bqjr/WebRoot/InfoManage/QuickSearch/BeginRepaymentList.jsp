<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ��ǰ�����ѯ
		Input Param:
			ObjectType:
			ObjectNo:
			SerialNo��ҵ����ˮ��
		Output Param:
			SerialNo��ҵ����ˮ��
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ǰ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	{"SerialNo","������"},
		                    {"ArtificialNo","��ͬ���"},
		                    {"FeasibleDate","��ǰ�����������"},
	                        {"BusinessSum","��ǰ�����"},
							{"Interest","��ǰ������Ϣ"},
							{"CustomerCost","�ͻ������"},
							{"PayMent","���������"},
							{"Fee","��ǰ����������"},
							{"TotalSum","�ܽ��"}
	                       }; 


	String sSql =  " select bc.SerialNo as SerialNo,bc.ArtificialNo as ArtificialNo,"+
			" '' as FeasibleDate,bre.principal as BusinessSum,bre.interest as Interest,"+
			" bre.customercost as CustomerCost,"+
			" bre.payment as PayMent,"+
			" '' as Fee,"+
			" '' as TotalSum"+
			" from business_contract bc, business_rate br ,business_repayment bre"+
	     	" where bc.serialno=br.contractserialno and bc.serialno=bre.contractserialno and bc.SerialNo='"+sSerialNo+"' ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//doTemp.UpdateTable = "LC_INFO";
	//doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //Ϊ�����ɾ��
	//���ò��ɼ���
	//doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	//���ò��ɼ���
	//doTemp.setVisible("InputOrgID,InputUserID",false);
	//doTemp.setUpdateable("UserName,OrgName,LCCurrencyName",false);
	//doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	//doTemp.setUpdateable("",false);
	//doTemp.setAlign("LCSum","3");
	//doTemp.setCheckFormat("LCSum","2");

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
		{"true","","Button","��ǰ��������","��ǰ��������","newRecord()",sResourcesPath}
	};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//������ˮ��
		sArtificialNo = getItemValue(0,getRow(),"ArtificialNo");//��ͬ���
		sFeasibleDate = getItemValue(0,getRow(),"FeasibleDate");
		sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		sInterest = getItemValue(0,getRow(),"Interest");
		sCustomerCost = getItemValue(0,getRow(),"CustomerCost");
		sPayMent = getItemValue(0,getRow(),"PayMent");
		sFee = getItemValue(0,getRow(),"Fee");
		sTotalSum = getItemValue(0,getRow(),"TotalSum");
		sApplicationType="05";//��ǰ�����ʶ
		sStatus="01";//������״̬
		
		if(sSerialNo==null) sSerialNo="";
		if(sArtificialNo==null) sArtificialNo="";
		if(sFeasibleDate==null) sFeasibleDate="";
		if(sBusinessSum==null) sBusinessSum="";
		if(sInterest==null) sInterest="";
		if(sCustomerCost==null) sCustomerCost="";
		if(sPayMent==null) sPayMent="";
		if(sFee==null) sFee="";
		if(sTotalSum==null) sTotalSum="";


		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ!
			return;
		}
		
		//��ȡ��ˮ��
		var ssSerialNo = getSerialNo("WITHHOLD_CHARGE_INFO","SerialNo","");
		//��ѯ��ǰ�����¼�Ƿ����
		sReturn = RunMethod("BusinessManage","SelectPay",sSerialNo);
       // alert("------"+sReturn);
		if(sReturn=="Null"){
			//����ǰ������Ϣ���뵽withhold_charge_info����
			sString=ssSerialNo+","+sArtificialNo+","+sFeasibleDate+","+sBusinessSum+","+sInterest+","+sCustomerCost+","+sPayMent+","+sFee+","+sTotalSum+","+sApplicationType+","+sSerialNo+","+sStatus;
			sReturn = RunMethod("BusinessManage","InsertContract",sString);
			if(sReturn=="1.0"){
				alert("������ǰ����ɹ���");
			}else{
				alert("������ǰ����ʧ�ܣ����飡");
			}
		 }else{
			alert("�ñʺ�ͬ������ǰ���������У����飡");
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
