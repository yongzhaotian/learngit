<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author:   djia  2010.07.21
		Tester:
		Content: ��������ҵ�����룬��ԭ��������ҳ��ϲ���һ��ҳ����ɡ�
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�
			OccurType����������	
			OccurDate����������
		Output param:
		History Log: 
			qfang 2011-6-10 ����������ʱ�����롰�����취һ��ָ����ҵ��Ʒ�ַ�����ж�  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α�š�������ʽ����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sOccurType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurType"));
	String sOccurDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDate"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sOccurType == null) sOccurType = "";	
	if(sOccurDate == null) sOccurDate = "";	
	
	//�������
	String InputDate = StringFunction.getToday();
	String InputOrgName = CurOrg.getOrgName();
	String InputUserName = CurUser.getUserName();
	String InputUserID = CurUser.getUserID();
	String InputOrgID = CurUser.getOrgID();
	String sSql = "";
	ASResultSet rs = null;
	//�����������ͣ���ȡ������ʽ
	if(sApplyType.equals("DependentApply")){
		sSql = "select itemno,itemname from code_library where codeno = 'OccurType' and isinuse = '1' and ItemNo <> '015' order by itemno";
	}else{
		sSql = "select itemno,itemname from code_library where codeno = 'OccurType' and isinuse = '1' order by itemno";
	}	
	rs = Sqlca.getASResultSet(sSql);
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
			{"true","","Button","ȷ��","ȷ��������������","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ��������������","doCancel()",sResourcesPath}	
	};
	%>
<%/*~END~*/%>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<title>ҵ������</title>

<script type="text/javascript">
    //����onchange�¼��ĺ���   
    $(document).ready(function(){
		var occur1Obj = $("#occur1");
		var occur2Obj = $("#occur2");
		var occur3Obj = $("#occur3");
		var occur4Obj = $("#occur4"); 
		occur3Obj.hide();
       	occur4Obj.hide();
    	$("#occurTypeuse").change(function(){
            if($(this).val() == "010" || $(this).val() == "020"){   
            	occur1Obj.show();
            	occur2Obj.show();
            	occur3Obj.hide();
            	occur4Obj.hide();     
            }else if($(this).val() == "030"){   
            	occur1Obj.show();
            	occur2Obj.show();
            	occur3Obj.show();
            	occur4Obj.hide();      
            }else if($(this).val() == "015"){   
            	occur1Obj.show();
            	occur2Obj.hide();
            	occur3Obj.hide();
            	occur4Obj.show();      
            }                    	
    	});
    	
    	$("#customType").change(function(){
    		clearData();
       	});
     });   

</script>
<style>
body {
}
</style>
</head>

<div id="buttonBar"><!-----------------------------��Ť��----------------------------->
<table>
	<tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top>
			<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
		</td>
	</tr>
</table>
</div>
<FORM class=ffform name=form1>
<DIV id="occurtype" style="WIDTH: 100%; HEIGHT: 100px">
<TABLE cellSpacing=0 cellPadding=1 width="100%" border=0>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">�������� &nbsp;<FONT color=red>*</FONT></TD>
			<TD class=FFContentTD noWrap colSpan=11>
			<SELECT id="occurTypeuse" class=fftdselect>
				<%
				while(rs.next()){
					out.println("<option  value='"+rs.getString("itemno")+"'>"+rs.getString("itemname")+"</option>");
				}
				rs.getStatement().close(); 
				rs = null;
				%>
			</SELECT>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">��������</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; WIDTH: 70px; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; TEXT-ALIGN: center; BORDER-BOTTOM-STYLE: groove"
				readOnly value=<%=InputDate%> name=R0F1></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">�Ǽǻ���</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value=<%=InputOrgName%> name=R0F2></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">�Ǽ���</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value=<%=InputUserName%> name=R0F3></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">�Ǽ�����</TD>
			<TD class=FFContentTD noWrap colSpan=11><INPUT class=fftdinput
				onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; WIDTH: 80px; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value=<%=InputDate%> name=R0F4></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">�ͻ����� &nbsp;<FONT color=red>*</FONT></TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<SELECT id="customType" class=fftdselect name=R0F1 value="">
				<OPTION value=01>��˾�ͻ�</OPTION>
				<OPTION value=03>���˿ͻ�</OPTION>
				</SELECT>
			</TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">�ͻ���� &nbsp;<FONT color=red>*</FONT></TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="customerID" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value="" name=R0F2>
				<INPUT class=inputdate onclick=selectCustomer() type=button value=...></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">�ͻ�����</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="customerName" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; WIDTH: 300px; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value="" name=R0F3></TD>
		</TR>
		<TR height=8></TR>
		<TR id="occur2">
			<TD class=fftdhead noWrap style="text-align: center;">ҵ��Ʒ�� &nbsp;<FONT color=red>*</FONT></TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="BusinessType" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value="" name=R0F7>
				<INPUT class=inputdate onclick='selectBusinessType("ALL")' type=button value=...></TD>
		</TR>
		<TR height=8></TR>
		<TR id="occur22">
			<TD class=fftdhead noWrap style="text-align: center;">��Ʒ�汾 &nbsp;<FONT color=red>*</FONT></TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="VersionID" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value="" name=R0F7>
				<INPUT class=inputdate onclick='selectProductVersion()' type=button value=...></TD>
		</TR>
		<TR height=8></TR>
		<TR id="occur3">
			<TD class=fftdhead noWrap style="text-align: center;">�������鷽�� &nbsp;<FONT color=red>*</FONT>
			</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="RelativeAgreement" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly name=R0F5>
				<INPUT class=inputdate onclick=selectNPARefrom() type=button value=...></TD>
		<TR height=8></TR>
		<TR id="occur4">
			<TD class=fftdhead noWrap style="text-align: center;">����չ��ҵ�� &nbsp;<FONT color=red>*</FONT>
			</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="RelativeObjectType" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly name=R0F5>
				<INPUT class=inputDate onclick=selectExtendContract(); type=button value=... name=button1></TD>
		<TR height=8></TR>
</TABLE>
</DIV>

<INPUT id="VirtualBusinessType" type=hidden></FORM>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

<script type="text/javascript">
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		var sTableName = "BUSINESS_APPLY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺	
		var sIndustryType = "";							
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);		

		sCustomerID = document.getElementById("customerID").value;
		sCustomerType = document.getElementById("customType").value;
		sCustomerName = document.getElementById("customerName").value;
		sBusinessType = document.getElementById("VirtualBusinessType").value;
		sOccurType = document.getElementById("occurTypeuse").value;
		sRelativeObjectType = document.getElementById("RelativeObjectType").value;
		sRelativeAgreement = document.getElementById("RelativeAgreement").value;
		sVersionID = document.getElementById("VersionID").value;

		if(sCustomerID == "" ||sCustomerType == "" ||sBusinessType == "" || sVersionID==""){
			alert("�����������");
			return;
		}
		if(sOccurType == "015"){
			if(sRelativeObjectType == ""){
				alert("�����������");
				return;
			}
		}
		if(sOccurType == "030" ){
			if(sRelativeAgreement == ""){
				alert("�����������");
				return;
			}
		}
		
		//ֻ�й�˾�ͻ�����Ҫȡ�ù�����ҵ���࣬������˿ͻ�ʱ��ȡ
		if(sCustomerType == "01"){
			//ȡ�ù�����ҵ����
			var sTableName = "ENT_INFO" ;
			var sColName = "IndustryType";
			var sWhereClause = "CustomerID="+"'"+sCustomerID+"'";
			//��ʼ����ҵͶ��
			sIndustryType = RunMethod("���÷���","GetColValue",sTableName + "," + sColName + "," + sWhereClause);
		}
		
		if("<%=sApplyType%>" == "DependentApply")
			ContractFlag = 1;
		else
			ContractFlag = 2;

        if(sOccurType == "015"){//���չ��ҵ��
        	s = RunMethod("BusinessManage","InsertRelative",sSerialNo+",BusinessDueBill,"+sRelativeObjectType+",APPLY_RELATIVE");           
        }else if(sOccurType == "030"){//���ծ������
        	s = RunMethod("BusinessManage","InsertRelative",sSerialNo+",NPAReformApply,"+sRelativeAgreement+",APPLY_RELATIVE");
        }
        //��ʼ��BUSINESS_APPLY
		s1 = RunMethod("BusinessManage","AddBusinessApply","<%=sObjectType%>"+","+sSerialNo+","+"<%=InputUserID%>"+","+sBusinessType +","+"<%=InputDate%>"+","+sCustomerName+","+"<%=InputOrgID%>"+","+"<%=sApplyType%>"+","+sIndustryType+","+ContractFlag+","+sCustomerID+","+sOccurType+","+sVersionID);
        //��ʼ������
		s2 = RunMethod("WorkFlowEngine","InitializeFlow","<%=sObjectType%>"+","+sSerialNo+","+"<%=sApplyType%>"+","+"<%=sFlowNo%>"+","+"<%=sPhaseNo%>"+","+"<%=InputUserID%>"+","+"<%=InputOrgID%>");

		sObjectNo = sSerialNo;
		sObjectType = "CreditApply";
		//�����������ͺ�ҵ��������ˮ��
		top.returnValue=sObjectNo+"@"+sObjectType+"@"+sBusinessType;
		top.close();
	}
	
	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation(){
		saveRecord();
	}
	
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel(){
		top.returnValue = "_CANCEL_";
		top.close();
	}
	
	/*~[Describe=�����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function clearData(){
		document.getElementById("customerID").value="";
		document.getElementById("customerName").value="";
		document.getElementById("BusinessType").value="";
		document.getElementById("VirtualBusinessType").value="";
		document.getElementById("RelativeAgreement").value="";
		document.getElementById("RelativeObjectType").value="";		
	}

    /*~[Describe=��ȡ�ͻ���ź�����;InputParam=�������ͣ�������λ��;OutPutParam=��;]~*/
    function subSelectCustomer(selectName,sParaString){
		try{
			o = setObjectValue(selectName,sParaString,"",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				document.getElementById("customerID").value="";
				document.getElementById("customerName").value="";
				return;
			}
			document.getElementById("customerID").value = oArray[0];
			document.getElementById("customerName").value = oArray[1];
			//�ı�ͻ�����ʱ���ҵ��Ʒ�֡�������ݺ͹������鷽��
			document.getElementById("BusinessType").value="";
			document.getElementById("VirtualBusinessType").value="";
			document.getElementById("RelativeAgreement").value="";
			document.getElementById("RelativeObjectType").value="";
		}catch(e){
			return;
		}
	}	

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		var sCustomerType = document.getElementById("customType").value;
		if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
			alert(getBusinessMessage('225'));//����ѡ��ͻ����ͣ�
			return;
		}
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType == "01")//��˾�ͻ�����С��ҵ
			subSelectCustomer("SelectApplyCustomer3",sParaString);
		if(sCustomerType == "02")//��������
			subSelectCustomer("SelectApplyCustomer2",sParaString);
		if(sCustomerType == "03")//���˿ͻ�
			subSelectCustomer("SelectApplyCustomer1",sParaString);
	}

	/*~[Describe=��ȡҵ��Ʒ��;InputParam=�������ͣ�������λ��;OutPutParam=��;]~*/
    function subSelectBusinessType(selectName){
		try{
			o = setObjectValue(selectName,"","",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				document.getElementById("BusinessType").value="";
				document.getElementById("VirtualBusinessType").value="";
				return;
			}
			document.getElementById("BusinessType").value = oArray[1];
			document.getElementById("VirtualBusinessType").value = oArray[0];
		}catch(e){
			return;
		}
	}
	
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType(sType){
		var sParaString = "";		
		if(sType == "ALL"){
			var sCustomerType = document.getElementById("customType").value;
			if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
				alert(getBusinessMessage('225'));//����ѡ��ͻ����ͣ�
				return;
			}
			
			var sCustomerID = document.getElementById("customerID").value;
			if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
				alert(getBusinessMessage('226'));//����ѡ�����ſͻ���
				return;
			}
			//���Ϊ���˿ͻ�
			if(sCustomerType == "03"){
				sReturn = RunMethod("PublicMethod","GetColValue","CustomerType,Customer_Info,String@CustomerID@"+sCustomerID);
				if(sReturn.split("@")[1] == "0310"){
					subSelectBusinessType("SelectIndBusinessType");
				}else if(sReturn.split("@")[1] == "0320"){
					subSelectBusinessType("SelectIndEntBusinessType");
				}else{
					alert("��ѡ����˿ͻ����߸��徭Ӫ����");
					return;
				}
			}	
			//���Ϊ��˾�ͻ�		
			else if(sCustomerType == "01"){
				sReturn = RunMethod("PublicMethod","GetColValue","CustomerType,Customer_Info,String@CustomerID@"+sCustomerID);
				if(sReturn.split("@")[1] == "0110"){
					subSelectBusinessType("SelectEntBusinessType");
				}else if(sReturn.split("@")[1] == "0120"){
					subSelectBusinessType("SelectSMEBusinessType");
				}else{
					alert("��ѡ�������ҵ�ͻ�������С��ҵ�ͻ���");
					return;
				}
			}
			selectProductVersion();
		}
	}
	
	/*~[Describe=����ҵ��Ʒ�ְ汾ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectProductVersion(){
		var typeNo = document.getElementById("VirtualBusinessType").value;
		if(typeof(typeNo) == "undefined" || typeNo.length == 0){alert("����ѡ���Ʒ��"); return;}
		var productVersion = setObjectValue("SelectProductVersion","TypeNo,"+typeNo,"",0,0,"");
		if(typeof(productVersion) == "undefined" || productVersion.length == 0 || productVersion=="_CLEAR_") return;
		document.getElementById("VersionID").value = productVersion.split("@")[0];
	}

    /*~[Describe=��ȡչ�ڽ��;InputParam=�������ͣ�������λ��;OutPutParam=��;]~*/
    function subSelectExtContract(selectName,sParaString){
		try{
			o = setObjectValue(selectName,sParaString,"",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				document.getElementById("RelativeObjectType").value="";	
				return;
			}
			document.getElementById("RelativeObjectType").value = oArray[0];
			document.getElementById("VirtualBusinessType").value = oArray[1];
		}catch(e){
			return;
		}
	}
	
	/*~[Describe=������չ�ڵĺ�ͬ/���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectExtendContract(){
		var sCustomerID = document.getElementById("customerID").value;
		if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}
		//���պ�ͬչ��
		//sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.getUserID()%>";
		//setObjectValue("SelectExtendContract",sParaString,"@RelativeAgreement@0@BusinessType@1",0,0,"");			
		//setItemValue(0,0,"RelativeObjectType","BusinessContract");
		//���ս��չ��
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateUserID"+","+"<%=CurUser.getUserID()%>";
		subSelectExtContract("SelectExtendDueBill",sParaString);
	}
	
	/*~[Describe=�����ʲ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectNPARefrom(){
		try{				
			o = setObjectValue("SelectNPARefrom","","",0,0,"");	
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				document.getElementById("RelativeAgreement").value="";	
				return;
			}
			document.getElementById("RelativeAgreement").value = oArray[0];
		}catch(e){
			return;
		}
	}
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>