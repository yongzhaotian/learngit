<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: 
		
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ת�ú�ͬ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	{"RelativeSerialNo","��ͬ���"},
                            {"CustomerName","�ͻ�����"},
							{"ProductID","��Ʒ���"},
							{"ProductName","��Ʒ����"}
           }; 

		String sSql = "select bc.relativeserialno as RelativeSerialNo,"+
				       " bc.customername as CustomerName,"+
				       " bc.issuedate as IssueDate,"+
				       " bc.lastpaydate as LastPayDate,"+
				       " bc.issue as Issue,"+
				       " bc.endnum as EndNum,"+
				       " bc.residue as Residue,"+
				       " bc.balance as Balance,"+
				       " bc.nextpaydate as NextPayDate,"+
				       " bc.customerType as CustomerType,"+
				       " ii.occupation as Occupation,"+
				       " ii.unitkind as Unitkind,"+
				       " bc.productid as ProductID,"+
				       " bc.productname as ProductName,"+
				       " bc.creditrate as CreditRate,"+
				       " bc.overduedays as OverdueDays,"+
				       " bc.classifyresult as ClassifyResult,"+
				       " bc.creditperson as CreditPerson,"+
				       " bc.overduetime as OverdueTime"+
				       " from business_contract bc, ind_info ii"+
				       " where bc.customerid = ii.customerid";

	
		//��SQL������ɴ������
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		//���ñ���
		doTemp.UpdateTable = "business_contract";
		//��������
		doTemp.setKey("SerialNo",true);
		//���ò��ɼ���
		//doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	    //���ø����ֶ�
		//doTemp.setUpdateable("UserName,OrgName,LCCurrencyName",false);
	    //�����ֶ���ʽ
		//doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	    //���ö��뷽ʽ�����С��ң�
		//doTemp.setAlign("LCSum","3");
	    //���ø�ʽ���ַ��������֡����ڣ�
		//doTemp.setCheckFormat("LCSum","2");
		//���ò�ѯ����
		//doTemp.setFilter(Sqlca,"2","IndustryType","DefaultOperator=BeginsWith");

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
		{"false","","Button","����","��������¼","newRecord()",sResourcesPath},
		{"false","","Button","����","�����¼","myDetail()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	if(!sSerialNo.equals("")){
		sButtons[0][3]="ȷ��";
		sButtons[0][4]="ȷ��";
		sButtons[0][5]="determine()";
		sButtons[1][3]="ȡ��";
		sButtons[1][4]="ȡ��";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
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
	function newRecord(){
		sCompID = "CostType";
		sCompURL = "/BusinessManage/Products/CostTypeInfo.jsp";
	    popComp(sCompID,sCompURL," ","dialogWidth=320px;dialogHeight=430px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	function myDetail(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");
		var sFeeType =getItemValue(0,getRow(),"feeType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}else{
			AsControl.OpenView("/BusinessManage/Products/CostTypeDetailInfo.jsp","serialNo="+sSerialNo+"&feeType="+sFeeType,"_self");
			
		}
	}
	
	function deleteRecord(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			 reloadSelf();
		}
	}
	
	function determine(){
		var sSerialNo = getItemValueArray(0,"serialNo");
		var temp="";//��¼���ô���
		var flag=true;
		for(var i=0;i<sSerialNo.length;i++){
			var count= RunMethod("Unique","uniques","businessType_Cost,count(1),costNo='"+sSerialNo[i]+"' and busTypeID=<%=sTypeNo%>");
			if(count>="1.0"){
				 temp=temp+sSerialNo[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sSerialNo!=""){
			for(var i=0;i<sSerialNo.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","businessType_Cost,busTypeCostID,busTypeID,costNo,"+getSerialNo("businessType_Cost", "busTypeCostID", " ")+",<%=sTypeNo%>,"+sSerialNo[i]);
			}
			alert("����ɹ�������");
			top.close();
		}else if(sSerialNo!=""){
			alert("��ѡ�������Ѵ��ڼ�¼��������ѡ��лл��");
		}else{
			alert("��û��ѡ���¼�����ܵ��룡��ѡ��");
		}		
		
	}
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
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

