<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-20
		Tester:
		Describe: ������Ϣ�е�Ʊ����Ϣ�б�
		Input Param:
		Output Param:		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ʊ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sPutoutSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
    if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sContractSerialNo == null) sContractSerialNo = "";
    if(sBusinessType == null) sBusinessType = ""; 
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	{"BillNo","Ʊ�ݺ���"},
							{"BillType","Ʊ������"},
							{"BillSum","Ʊ����"},
							{"WriteDate","Ʊ��ǩ����"},
							{"Maturity","Ʊ�ݵ�����"},
							{"UserName","�Ǽ���"},
	                        {"OrgName","�Ǽǻ���"},
	                        {"SerialNo","Ʊ����ˮ��"}
	                       }; 
	String sSql = " select BI.ObjectNo,BI.ObjectType,BI.SerialNo,BI.BillNo,BI.BillSum,"+
				  " BI.WriteDate,BI.Maturity,"+
				  " getUserName(BI.InputUserID) as UserName,getOrgName(BI.InputOrgID) as OrgName "+
				  " from BILL_INFO BI,PUTOUT_RELATIVE PR "+
				  " where BI.ObjectNo = '"+sContractSerialNo+"' and BI.ObjectType='BusinessContract' "+
				  " and BI.SerialNo=PR.SerialNo and PR.PutOutNo='"+sPutoutSerialNo+"'";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "PUTOUT_RELATIVE";
	doTemp.setKey("SerialNo,PutoutNo",true);	 //Ϊ�����ɾ��
	
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	
	//���ò��ɼ���
	doTemp.setVisible("InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setHTMLStyle("UserName,WriteDate,Maturity"," style={width:80px} ");
	
	//���ý��Ϊ��λһ������
	doTemp.setType("BillSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BillSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BillSum","3");
	
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
		{"true","All","Button","����Ʊ��","����Ʊ����Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","Ʊ������","�鿴Ʊ������","viewAndEdit()",sResourcesPath},
		{"true","All","Button","ɾ��Ʊ��","ɾ��Ʊ����Ϣ","deleteRecord()",sResourcesPath},		
		{(!"2010".equals(sBusinessType)?"true":"false"),"All","Button","����Ʊ��","�����ͬ���Ѵ��ڵ�Ʊ��","importBill()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditApply/BillInfo.jsp","_self","");
	}


	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}

		//��ҵ��Ʒ��Ϊ"���гжһ�Ʊ"ʱ������Ҫ��BILL_INFO����ɾ����¼��add by cbsu 2009-11-11
	    sBusinessType = "<%=sBusinessType%>";
	    if (sBusinessType == "2010") {
	    	RunMethod("BusinessManage","DeleteBillInfo",sSerialNo);
		}
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sBusinessType = "<%=sBusinessType%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
			OpenPage("/CreditManage/CreditApply/BillInfo.jsp?SerialNo="+sSerialNo,"_self","");				
		}
	}

	/*~[Describe=�������ͬ������Ʊ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	// add by cbsu 2009-11-03
	function importBill()
	{
		var sContarctSerialNo = "<%=sContractSerialNo%>";
		var sPutOutNo = "<%=sPutoutSerialNo%>";
		var sParaString = "ObjectNo" + "," + sContarctSerialNo + ",PutOutNo" + "," + sPutOutNo;
		sReturn = setObjectValue("selectContractBillInfo",sParaString,"",0,0,"");
		if (typeof(sReturn) == "undefined" || sReturn.length == 0) {
		    return false;
		} else {
			var sSerialNo = sReturn.split("@")[0];
			sParaString = sPutOutNo + "," + sSerialNo + "," + 
			              "<%=StringFunction.getToday()%>" + "," + "<%=CurUser.getUserID()%>" + "," + "<%=sBusinessType%>";
		    RunMethod("BusinessManage","InsertPutoutRelative",sParaString);
		    reloadSelf();
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
