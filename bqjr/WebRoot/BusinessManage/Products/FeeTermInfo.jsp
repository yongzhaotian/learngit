<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "���ò���ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
%>

<script language=javascript>
	
</script>

<%
	String termID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermID"));
	String termType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("termType"));
	String setFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("setFlag"));
	if(termID == null)
	{
		termID = "";
	}
	String objectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(objectType == null)
	{
		objectType = "Term";
	}
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(objectNo == null)
	{
		objectNo = "";
	}
	String sFeeType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FeeType"));
	if(sFeeType == null)
	{
		sFeeType = "";
	}
	String stypeNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("stypeNo"));
	if(stypeNo == null)
	{
		stypeNo = "";
	}
	ASDataWindow dwTemp=com.amarsoft.app.accounting.web.ProductTermView.createTermDataWindow(objectType, objectNo, termID, Sqlca, CurPage);
	
	if(sFeeType.equals("A9")){
		dwTemp.DataObject.setVisible("FeeRate_Min", false);
		dwTemp.DataObject.setVisible("FeeRate_Max", false);
		dwTemp.DataObject.setVisible("FeeTransactionCode_VLN", false);
		//dwTemp.DataObject.setHeader("FeeRate_DV", "������");
		dwTemp.DataObject.setValue("FeePayDateFlag2_DV", "08");
		dwTemp.DataObject.setValue("FeePayDateFlag_DV", "01");//���������һ������ȡ
		dwTemp.DataObject.setReadOnly("FeePayDateFlag2_DV", true);
		dwTemp.DataObject.setValue("FeeTransactionCode_VL", "0055");//��ǰ�����
		
		//dwTemp.DataObject.setReadOnly("FeePayDateFlag_DV", true);
	}else if(sFeeType.equals("A11")){//ӡ��˰
		dwTemp.DataObject.setVisible("FeeRate_Min", false);
		dwTemp.DataObject.setVisible("FeeRate_Max", false);
		dwTemp.DataObject.setVisible("FeeTransactionCode_VLN", false);
		dwTemp.DataObject.setVisible("FeePayDateFlag_DV", false);
		dwTemp.DataObject.setVisible("AdvancehesitateDate_DV", false);
		//dwTemp.DataObject.setHeader("FeeRate_DV", "������");
		dwTemp.DataObject.setReadOnly("FeePayDateFlag2_DV", true);
		
	}else if(sFeeType.equals("A12")){//���ս�
		dwTemp.DataObject.setVisible("FeeAmount_Max", false);
		dwTemp.DataObject.setVisible("FeeAmount_Min", false);
		dwTemp.DataObject.setVisible("FeeAmount_DV", false);
		dwTemp.DataObject.setVisible("FeeRate_Min", false);
		dwTemp.DataObject.setVisible("FeeRate_Max", false);
		dwTemp.DataObject.setVisible("FeeTransactionCode_VLN", false);
		dwTemp.DataObject.setReadOnly("FeePayDateFlag2_DV", true);
		dwTemp.DataObject.setValue("FeeCalType_DV", "02");
		dwTemp.DataObject.setReadOnly("FeeCalType_DV", true);
		dwTemp.DataObject.setHeader("FeeRate_DV", "�·���(%)");
	}else if(sFeeType.equals("A10")){//���ɽ�
		dwTemp.DataObject.setUnit("CPDOverDays_DV", "��");
		dwTemp.DataObject.setUnit("CPDAmt_DV", "Ԫ");
		dwTemp.DataObject.setUnit("CPDOverDays2_DV", "��");
		dwTemp.DataObject.setUnit("CPDAmt2_DV", "Ԫ");
		dwTemp.DataObject.setUnit("CPDOverDays3_DV", "��");
		dwTemp.DataObject.setUnit("CPDAmt3_DV", "Ԫ");
		dwTemp.DataObject.setUnit("CPDOverDays4_DV", "��");
		dwTemp.DataObject.setUnit("CPDAmt4_DV", "Ԫ");
		dwTemp.DataObject.setUnit("CPDOverDays5_DV", "��");
		dwTemp.DataObject.setUnit("CPDAmt5_DV", "Ԫ");
		
	} else if ("A18".equals(sFeeType)) {	
		dwTemp.DataObject.setVisible("FeeRate_Min", false);
		dwTemp.DataObject.setVisible("FeeRate_Max", false);
		dwTemp.DataObject.setValue("FeeRate_DV", "0.000000");
		dwTemp.DataObject.setVisible("FeeRate_DV", false);
	}
	if(!stypeNo.equals("")){
		dwTemp.ReadOnly="1";
	}
	dwTemp.DataObject.setVisible("FeeType_DV", false);
	dwTemp.DataObject.setVisible("FeeFlag_DV", false);
	dwTemp.DataObject.setVisible("FeeCurrency_DV", false);	
	dwTemp.DataObject.setVisible("FeePayDateFlag_DV", false);
	dwTemp.DataObject.setVisible("AccountingOrgFlag_DV", false);
	dwTemp.DataObject.setVisible("ComminssionRatio_DV", false);
	if ("A18".equals(sFeeType)) {
		dwTemp.DataObject.setDDDWSql("FeeCalType_DV", "SELECT itemno,itemname FROM code_library where codeno='FeeCalType' and itemno in('01','02','15')");
	} else {
		dwTemp.DataObject.setDDDWSql("FeeCalType_DV", "SELECT itemno,itemname FROM code_library where codeno='FeeCalType' and itemno in('01','02')");
	}
	
	ASDataObject doTemp = dwTemp.DataObject;
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String parameterCount = Sqlca.getString("select count(*) from PRODUCT_TERM_PARA "
            				+" where ObjectType='"+objectType+"' and ObjectNo='"+objectNo+"' and TermID = '"+termID+"'");
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
			{"true","","Button","����","����","updateParaValues()",sResourcesPath},
	};
	if(!stypeNo.equals("")){
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		as_save("myiframe0","updateParaValues();");
	}

	function updateParaValues(){
		var FeePayDateFlag = getItemValue(0,getRow(),"FeePayDateFlag2_DV");
		var sFeeTypeCPD =  "<%=sFeeType%>";
		if(FeePayDateFlag=="07"||FeePayDateFlag=="08"){//07:�ſ�ʱһ������ȡ;08:��ǰ����ʱ��ȡ
			setItemValue(0, 0, "FeePayDateFlag_DV", "01");
			if(FeePayDateFlag=="07"){
				setItemValue(0, 0, "FeeTransactionCode_VL", "0020");
			}else{
				setItemValue(0, 0, "FeeTransactionCode_VL", "0055");
			}
		}else if(FeePayDateFlag=="05"){//������ƻ���ȡ
			setItemValue(0, 0, "FeePayDateFlag_DV", "05");
			setItemValue(0, 0, "FeeTransactionCode_VL", "");
		}else if(FeePayDateFlag=="06"){//�״λ�������ȡ
			setItemValue(0, 0, "FeePayDateFlag_DV", "06");
			setItemValue(0, 0, "FeeTransactionCode_VL", "");
		}

		if(sFeeTypeCPD=="A10"){
			
		}
		
		var paraList="ObjectType=<%=objectType%>&VersionID=<%=objectNo%>&TermID=<%=termID%>";
<%
		for(int i=0;i<doTemp.Columns.size();i++){
			String paraname = doTemp.getColumnAttribute(i, "Name");
%>
			var s=getItemValue(0,getRow(),"<%=paraname%>");
		
			if(typeof(s) != "undefined" ){
				s=real2Amarsoft(s);
				paraList = paraList+"&<%=paraname%>="+s;
			}
<%
		}
%>		
		//modify end
		var result =PopPage("/Accounting/Config/TermParaSaveAction.jsp?"+paraList,"","dialogWidth=60;dialogheight=25;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		alert(result);//parent.reloadSelf(1);
	}

	function initRow(){
		if (getRowCount(0)==0) {//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
		}
		sFeeType="<%=sFeeType%>";
		if(sFeeType=="A9"||sFeeType=="A11"){//A9����ǰ�������,A11��ӡ��˰
			setItemValue(0, 0, "FeePayDateFlag_DV", "01");//��ʼ�������ո�ʱ��
			if(sFeeType=="A9"){
				setItemValue(0, 0, "FeePayDateFlag2_DV", "08");
			}else{
				setItemValue(0, 0, "FeePayDateFlag2_DV", "05");
				setItemValue(0, 0, "FeeCalType_DV", "02");
				setItemValue(0, 0, "FeeTransactionCode_VL", "");
			} 
			sReturn = "FeeType@FeeAmount@AdvancehesitateDate@LoanPercenTage@FeePayDateFlag@AccountingOrgFlag@";
		}else if(sFeeType=="A12"){//���շ�
			setItemValue(0, 0, "FeeCalType_DV", "02");//��ʼ�����ü��㷽ʽ
			sReturn = "FeeType@FeeAmount@FeeRate@FeePayDateFlag@CommissionRatio@";
		}else if(sFeeType=="A13"){//�¼�����
			sReturn = "FeeType@FeeFrequency@FeePayDateFlag@FeeCalType@FeeTransactionCode@FeeFlag@AccountingOrgFlag@FeeAmount@FeeCurrency";
		} else if(sFeeType=="A18") {	// ���Ļ������
			setItemValue(0, 0, "FeeRate_DV", "0.000000");
			// setItemValue(0, 0, "FeeAmount_DV", "0.00");
			setItemValue(0, 0, "FeeFrequency_DV", "1");
			setItemDisabled(0, 0, "FeeFrequency_DV", true);
			setItemValue(0, 0, "FeeCalType_DV", "15");
			setItemDisabled(0, 0, "FeeCalType_DV", true);
			sReturn = "FeeType@FeeAmount@FeeRate@FeeFrequency@FeeCalType@";
		}else{
			return;
		}
		if(<%=Integer.parseInt(parameterCount)%> == 0){
			var methodResult = RunMethod("ProductManage","ImportTermParameters","importTermParameters2,<%=objectNo%>,<%=termID%>,"+sReturn);
			var ddd = parent;
			reloadSelf();
		}
    }
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
	var obj = parent.document.getElementById('TermParaView');
	if(typeof(obj) != "undefined" && obj != null){
		obj.style.height = ((DZ[0][1].length/2)*18+25)+"%";
	}
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
