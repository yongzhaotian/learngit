<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "费用参数页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
		//dwTemp.DataObject.setHeader("FeeRate_DV", "贷款本金比");
		dwTemp.DataObject.setValue("FeePayDateFlag2_DV", "08");
		dwTemp.DataObject.setValue("FeePayDateFlag_DV", "01");//随关联交易一次性收取
		dwTemp.DataObject.setReadOnly("FeePayDateFlag2_DV", true);
		dwTemp.DataObject.setValue("FeeTransactionCode_VL", "0055");//提前还款交易
		
		//dwTemp.DataObject.setReadOnly("FeePayDateFlag_DV", true);
	}else if(sFeeType.equals("A11")){//印花税
		dwTemp.DataObject.setVisible("FeeRate_Min", false);
		dwTemp.DataObject.setVisible("FeeRate_Max", false);
		dwTemp.DataObject.setVisible("FeeTransactionCode_VLN", false);
		dwTemp.DataObject.setVisible("FeePayDateFlag_DV", false);
		dwTemp.DataObject.setVisible("AdvancehesitateDate_DV", false);
		//dwTemp.DataObject.setHeader("FeeRate_DV", "贷款本金比");
		dwTemp.DataObject.setReadOnly("FeePayDateFlag2_DV", true);
		
	}else if(sFeeType.equals("A12")){//保险金
		dwTemp.DataObject.setVisible("FeeAmount_Max", false);
		dwTemp.DataObject.setVisible("FeeAmount_Min", false);
		dwTemp.DataObject.setVisible("FeeAmount_DV", false);
		dwTemp.DataObject.setVisible("FeeRate_Min", false);
		dwTemp.DataObject.setVisible("FeeRate_Max", false);
		dwTemp.DataObject.setVisible("FeeTransactionCode_VLN", false);
		dwTemp.DataObject.setReadOnly("FeePayDateFlag2_DV", true);
		dwTemp.DataObject.setValue("FeeCalType_DV", "02");
		dwTemp.DataObject.setReadOnly("FeeCalType_DV", true);
		dwTemp.DataObject.setHeader("FeeRate_DV", "月费率(%)");
	}else if(sFeeType.equals("A10")){//滞纳金
		dwTemp.DataObject.setUnit("CPDOverDays_DV", "天");
		dwTemp.DataObject.setUnit("CPDAmt_DV", "元");
		dwTemp.DataObject.setUnit("CPDOverDays2_DV", "天");
		dwTemp.DataObject.setUnit("CPDAmt2_DV", "元");
		dwTemp.DataObject.setUnit("CPDOverDays3_DV", "天");
		dwTemp.DataObject.setUnit("CPDAmt3_DV", "元");
		dwTemp.DataObject.setUnit("CPDOverDays4_DV", "天");
		dwTemp.DataObject.setUnit("CPDAmt4_DV", "元");
		dwTemp.DataObject.setUnit("CPDOverDays5_DV", "天");
		dwTemp.DataObject.setUnit("CPDAmt5_DV", "元");
		
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
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String parameterCount = Sqlca.getString("select count(*) from PRODUCT_TERM_PARA "
            				+" where ObjectType='"+objectType+"' and ObjectNo='"+objectNo+"' and TermID = '"+termID+"'");
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","保存","保存","updateParaValues()",sResourcesPath},
	};
	if(!stypeNo.equals("")){
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		as_save("myiframe0","updateParaValues();");
	}

	function updateParaValues(){
		var FeePayDateFlag = getItemValue(0,getRow(),"FeePayDateFlag2_DV");
		var sFeeTypeCPD =  "<%=sFeeType%>";
		if(FeePayDateFlag=="07"||FeePayDateFlag=="08"){//07:放款时一次性收取;08:提前还款时收取
			setItemValue(0, 0, "FeePayDateFlag_DV", "01");
			if(FeePayDateFlag=="07"){
				setItemValue(0, 0, "FeeTransactionCode_VL", "0020");
			}else{
				setItemValue(0, 0, "FeeTransactionCode_VL", "0055");
			}
		}else if(FeePayDateFlag=="05"){//按还款计划收取
			setItemValue(0, 0, "FeePayDateFlag_DV", "05");
			setItemValue(0, 0, "FeeTransactionCode_VL", "");
		}else if(FeePayDateFlag=="06"){//首次还款日收取
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
		if (getRowCount(0)==0) {//如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
		}
		sFeeType="<%=sFeeType%>";
		if(sFeeType=="A9"||sFeeType=="A11"){//A9：提前还款费率,A11：印花税
			setItemValue(0, 0, "FeePayDateFlag_DV", "01");//初始化费用收付时点
			if(sFeeType=="A9"){
				setItemValue(0, 0, "FeePayDateFlag2_DV", "08");
			}else{
				setItemValue(0, 0, "FeePayDateFlag2_DV", "05");
				setItemValue(0, 0, "FeeCalType_DV", "02");
				setItemValue(0, 0, "FeeTransactionCode_VL", "");
			} 
			sReturn = "FeeType@FeeAmount@AdvancehesitateDate@LoanPercenTage@FeePayDateFlag@AccountingOrgFlag@";
		}else if(sFeeType=="A12"){//保险费
			setItemValue(0, 0, "FeeCalType_DV", "02");//初始化费用计算方式
			sReturn = "FeeType@FeeAmount@FeeRate@FeePayDateFlag@CommissionRatio@";
		}else if(sFeeType=="A13"){//事件费用
			sReturn = "FeeType@FeeFrequency@FeePayDateFlag@FeeCalType@FeeTransactionCode@FeeFlag@AccountingOrgFlag@FeeAmount@FeeCurrency";
		} else if(sFeeType=="A18") {	// 随心还服务费
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

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
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
