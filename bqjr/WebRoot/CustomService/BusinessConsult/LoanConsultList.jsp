<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleId"));
	String sPrevUrl =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrevUrl"));
	String flag = CurPage.getParameter("flag");
	if(sExampleId==null) sExampleId="";
	if(sPrevUrl==null) sPrevUrl="";
	if(flag==null) flag = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "BusinessConsultQuery";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//doTemp.setHTMLStyle("TotalSum","onblur=\"javascript:parent.chkTotalSumValue()\"");
	doTemp.setHTMLStyle("TotalSum","onblur=\"javascript:parent.inputTotalSumValue()\"");
	doTemp.setHTMLStyle("TotalSum","onfocus=\"javascript:parent.inputTotalOnfocus()\"");
	//,DownPay,DpsMnt
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleId);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
	 	{"true","","Button","��ѯ","��ѯÿ���ڿ�","queryMonthlyPay()",sResourcesPath},
		{"true","","Button","����","����","resetAll()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	var sPrevUrl = "<%=sPrevUrl%>";
	
	<%/*~[Describe=��ѯֵ�Ƿ�Ϊ����;] added by tbzeng 2014/02/21~*/%>
	function chkTotalSumValue() {
		var sTotalSum = ''+getItemValue(0,getRow(),"TotalSum");
		
		if (sTotalSum.length<=0) {
			alert("��������Ʒ�ܼ۸�");
			return "false";
		}
		
		if (parseFloat(sTotalSum)<0.0) {
			alert("��Ʒ�ܼ۸�ӦΪ��������ȷ�ϣ�"); 
			setItemValue(0,0,"MonthPay",""); return "false";
		}
		return "true";
	}
	
	
	/*~[Describe=�����׸�����;InputParam=��;OutPutParam=��;]~*/
	function inputDpsMnt(){
		var sTotalSum_ = '0'+getItemValue(0,getRow(),"TotalSum");//��Ʒ�ܼ۸�
		var nLoanTerm = getItemValue(0,getRow(),"LoanTerm");//��������
		var sDpsMnt_ = '0'+getItemValue(0,getRow(),"DpsMnt");//�׸����
		var sDownPay = '0'+getItemValue(0,getRow(),"DownPay");//�׸�����
		var nMonthRate = ''+getItemValue(0,getRow(),"MonthRate");//������
		var nMonthPay = 0.0;
		
		var sTotalSum=parseFloat(sTotalSum_);
		var sDpsMnt=parseFloat(sDpsMnt_);
		
		/* ��ǪĬ�������� */
		var nMonthRate = 4.58;
		
		// У����Ʒ�ܼ۸������Ƿ���ȷ
		if(chkTotalSumValue()!="true") {
			setItemValue(0,0,"MonthPay","");
			return;
		}
		
		if(sDpsMnt<0.0) {
			alert("��������ڵ���0���׸���");
			setItemValue(0,0,"MonthPay","");
			return;
		}else if(sDpsMnt==0.0){
			setItemValue(0,0,"MonthPay","0");
		}else if(sDpsMnt>sTotalSum){
			alert("�׸���ܴ���Ʒ�ܼ۸�");
			setItemValue(0,0,"MonthPay","");
			return;
		}
		setItemValue(0, 0, "DownPay", (sDpsMnt/sTotalSum*100).toFixed(2));//�׸�����
		setItemValue(0, 0, "DpsMnt", sDpsMnt);//�׸����
		setItemValue(0,0,"MonthPay","");	
	}
	/*~[Describe=�����׸����;InputParam=��;OutPutParam=��;]~*/
	function inputDownPay(){
		var sTotalSum_ = '0'+getItemValue(0,getRow(),"TotalSum");//��Ʒ�ܼ۸�
		var nLoanTerm = getItemValue(0,getRow(),"LoanTerm");//��������
		var sDpsMnt_ = '0'+getItemValue(0,getRow(),"DpsMnt");//�׸����
		var sDownPay = '0'+getItemValue(0,getRow(),"DownPay");//�׸�����
		var nMonthRate = ''+getItemValue(0,getRow(),"MonthRate");//������
		var nMonthPay = 0.0;
		
		var sTotalSum=parseFloat(sTotalSum_);
		var sDpsMnt=parseFloat(sDpsMnt_);
		
		/* ��ǪĬ�������� */
		var nMonthRate = 4.58;
		
		// У����Ʒ�ܼ۸������Ƿ���ȷ
		if(chkTotalSumValue()!="true") {
			setItemValue(0,0,"MonthPay","");
			return;
		}
		
		if(parseFloat(sDownPay)<0.0) {
			alert("��������ڵ���0���׸�������");
			setItemValue(0,0,"MonthPay","");
			return;
		}else if(parseFloat(sDownPay)>100.0){
			alert("�׸��������ܴ���100��");
			setItemValue(0,0,"MonthPay","");
			return;
		}
		
		setItemValue(0, 0, "DpsMnt", (sTotalSum*parseFloat(sDownPay)*0.01).toFixed(0));//�׸����
		setItemValue(0,0,"MonthPay","");
	}
	/*~[Describe=������Ʒ�ܼ۸�;InputParam=��;OutPutParam=��;]~*/
	function inputTotalSumValue(){
		setItemValue(0,0,"LoanTerm",12);
		setItemValue(0,0,"DpsMnt","");
		setItemValue(0,0,"DownPay","");
		setItemValue(0,0,"MonthPay","");
	}
	
	<%/*~[Describe=��ѯÿ���ڿ�;] added by tbzeng 2014/02/19~*/%>
	function queryMonthlyPay() {
		
		var sTotalSum_ = ''+getItemValue(0,getRow(),"TotalSum");//��Ʒ�ܼ۸�
		var nLoanTerm = getItemValue(0,getRow(),"LoanTerm");//��������
		var sDpsMnt_ = ''+getItemValue(0,getRow(),"DpsMnt");//�׸����
		var sDownPay = ''+getItemValue(0,getRow(),"DownPay");//�׸�����
		var nMonthRate = ''+getItemValue(0,getRow(),"MonthRate");//������
		var nMonthPay = 0.0;
		
		var sTotalSum=parseFloat(sTotalSum_);
		var sDpsMnt=parseFloat(sDpsMnt_);
		
		if(parseFloat(sDownPay)<10.0){
			alert("�׸���������С10%");
			
			return;
		}
		
		if (typeof(sTotalSum_)=="undefined" || sTotalSum_=="_CLEAR_" || sTotalSum_.length==0) {
			alert("����������Ʒ�ܼ۸�");
			return;
		}
		if (typeof(sDpsMnt_)=="undefined" || sDpsMnt_.length==0) {
			alert("�������׸���");
			return;
		} 
		if(nLoanTerm.length==0){
			alert("��ѡ��������ޣ�");	
			return;
		}
		
		
		/* ��ǪĬ�������� */
		var nMonthRate = 4.58;
		
		// У����Ʒ�ܼ۸������Ƿ���ȷ
		if(chkTotalSumValue()!="true") {
			setItemValue(0,0,"MonthPay","");
			return;
		}
		nMonthPay = ((sTotalSum-sDpsMnt)*(nMonthRate/100)*(Math.pow((1+nMonthRate/100),nLoanTerm)))/(Math.pow((1+nMonthRate/100),nLoanTerm)-1);
		
		
		/* 
		if (sDpsMnt_.length>0 && sDownPay.length<=0) {
			// ֻ�������׸����
			setItemValue(0, 0, "DownPay",sDpsMnt/sTotalSum*100);
			nMonthPay = ((sTotalSum-sDpsMnt)*(nMonthRate/100)*(Math.pow((1+nMonthRate/100),nLoanTerm)))/(Math.pow((1+nMonthRate/100),nLoanTerm)-1);
			//nMonthPay = (parseFloat(sTotalSum)-parseFloat(sDpsMnt))/nLoanTerm;
		} else if(sDpsMnt_.length<=0 && sDownPay.length>0) {
			// ֻ�������׸�����
			setItemValue(0, 0, "DpsMnt",sTotalSum*sDownPay*100);
			nMonthPay = ((sTotalSum*sDownPay/100)*(nMonthRate/100)*(Math.pow((1+nMonthRate/100),nLoanTerm)))/(Math.pow((1+nMonthRate/100),nLoanTerm)-1);
			//nMonthPay = (parseFloat(sTotalSum)*(1-parseFloat(sDownPay)/100.0))/nLoanTerm;
		}else {
			alert("�׸�����׸�����������ֻ����һ�� ��");
			setItemValue(0,0,"MonthPay","");
			setItemValue(0,0,"DpsMnt","");
			return ;
		} */
		setItemValue(0,0,"MonthPay",nMonthPay.toFixed(0));
	}
	
	<%/*~[Describe=�ܽ��õ�����;] added by jiangyuanlin 2015/5/21~*/%>
	function inputTotalOnfocus(){
		var sTotalSum_ = +getItemValue(0,getRow(),"TotalSum");//��Ʒ�ܼ۸�
		if(sTotalSum_==0){
			setItemValue(0,0,"TotalSum","");
		}
		
	}
	<%/*~[Describe=����;] added by tbzeng 2014/02/19~*/%>
	function resetAll() {
		
		setItemValue(0,0,"TotalSum","");
		setItemValue(0,0,"LoanTerm",12);
		setItemValue(0,0,"DpsMnt","");
		setItemValue(0,0,"DownPay","");
		setItemValue(0,0,"MonthPay","");
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		if(sPrevUrl){
			AsControl.OpenView(sPrevUrl,"","_self");
			return;
		}
		
		if("<%=flag%>"=="02"){
			AsControl.OpenView("/FrameCase/ExampleList02.jsp","","_self");
		}else{
			AsControl.OpenView("/FrameCase/ExampleList.jsp","","_self");
		}
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"ExampleId",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			bIsInsert = true;
		}
		setItemValue(0,0,"LoanTerm",12);
		setItemValue(0,0,"DownPay","");
		setItemValue(0,0,"DpsMnt","");
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
		
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
