<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author:   djia  2010.07.21
		Tester:
		Content: 创建授信业务申请，把原本的两个页面合并成一个页面完成。
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号
			OccurType：发生类型	
			OccurDate：发生日期
		Output param:
		History Log: 
			qfang 2011-6-10 在新增申请时，加入“三个办法一个指引”业务品种分类的判断  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号、发生方式、发生日期
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sOccurType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurType"));
	String sOccurDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDate"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sOccurType == null) sOccurType = "";	
	if(sOccurDate == null) sOccurDate = "";	
	
	//定义变量
	String InputDate = StringFunction.getToday();
	String InputOrgName = CurOrg.getOrgName();
	String InputUserName = CurUser.getUserName();
	String InputUserID = CurUser.getUserID();
	String InputOrgID = CurUser.getOrgID();
	String sSql = "";
	ASResultSet rs = null;
	//根据申请类型，获取发生方式
	if(sApplyType.equals("DependentApply")){
		sSql = "select itemno,itemname from code_library where codeno = 'OccurType' and isinuse = '1' and ItemNo <> '015' order by itemno";
	}else{
		sSql = "select itemno,itemname from code_library where codeno = 'OccurType' and isinuse = '1' order by itemno";
	}	
	rs = Sqlca.getASResultSet(sSql);
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","确认","确认新增授信申请","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消新增授信申请","doCancel()",sResourcesPath}	
	};
	%>
<%/*~END~*/%>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<title>业务申请</title>

<script type="text/javascript">
    //处理onchange事件的函数   
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

<div id="buttonBar"><!-----------------------------按扭区----------------------------->
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
			<TD class=fftdhead noWrap style="text-align: center;">发生类型 &nbsp;<FONT color=red>*</FONT></TD>
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
			<TD class=fftdhead noWrap style="text-align: center;">发生日期</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; WIDTH: 70px; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; TEXT-ALIGN: center; BORDER-BOTTOM-STYLE: groove"
				readOnly value=<%=InputDate%> name=R0F1></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">登记机构</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value=<%=InputOrgName%> name=R0F2></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">登记人</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value=<%=InputUserName%> name=R0F3></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">登记日期</TD>
			<TD class=FFContentTD noWrap colSpan=11><INPUT class=fftdinput
				onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; WIDTH: 80px; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value=<%=InputDate%> name=R0F4></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">客户类型 &nbsp;<FONT color=red>*</FONT></TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<SELECT id="customType" class=fftdselect name=R0F1 value="">
				<OPTION value=01>公司客户</OPTION>
				<OPTION value=03>个人客户</OPTION>
				</SELECT>
			</TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">客户编号 &nbsp;<FONT color=red>*</FONT></TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="customerID" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value="" name=R0F2>
				<INPUT class=inputdate onclick=selectCustomer() type=button value=...></TD>
		</TR>
		<TR height=8></TR>
		<TR>
			<TD class=fftdhead noWrap style="text-align: center;">客户名称</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="customerName" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; WIDTH: 300px; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value="" name=R0F3></TD>
		</TR>
		<TR height=8></TR>
		<TR id="occur2">
			<TD class=fftdhead noWrap style="text-align: center;">业务品种 &nbsp;<FONT color=red>*</FONT></TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="BusinessType" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value="" name=R0F7>
				<INPUT class=inputdate onclick='selectBusinessType("ALL")' type=button value=...></TD>
		</TR>
		<TR height=8></TR>
		<TR id="occur22">
			<TD class=fftdhead noWrap style="text-align: center;">产品版本 &nbsp;<FONT color=red>*</FONT></TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="VersionID" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly value="" name=R0F7>
				<INPUT class=inputdate onclick='selectProductVersion()' type=button value=...></TD>
		</TR>
		<TR height=8></TR>
		<TR id="occur3">
			<TD class=fftdhead noWrap style="text-align: center;">关联重组方案 &nbsp;<FONT color=red>*</FONT>
			</TD>
			<TD class=FFContentTD noWrap colSpan=11>
				<INPUT id="RelativeAgreement" class=fftdinput onblur=parent.trimField(this)
				style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove"
				readOnly name=R0F5>
				<INPUT class=inputdate onclick=selectNPARefrom() type=button value=...></TD>
		<TR height=8></TR>
		<TR id="occur4">
			<TD class=fftdhead noWrap style="text-align: center;">关联展期业务 &nbsp;<FONT color=red>*</FONT>
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

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

<script type="text/javascript">
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		var sTableName = "BUSINESS_APPLY";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀	
		var sIndustryType = "";							
		//获取流水号
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
			alert("请填入必输项");
			return;
		}
		if(sOccurType == "015"){
			if(sRelativeObjectType == ""){
				alert("请填入必输项");
				return;
			}
		}
		if(sOccurType == "030" ){
			if(sRelativeAgreement == ""){
				alert("请填入必输项");
				return;
			}
		}
		
		//只有公司客户才需要取得国标行业分类，避免个人客户时误取
		if(sCustomerType == "01"){
			//取得国标行业分类
			var sTableName = "ENT_INFO" ;
			var sColName = "IndustryType";
			var sWhereClause = "CustomerID="+"'"+sCustomerID+"'";
			//初始化行业投向
			sIndustryType = RunMethod("公用方法","GetColValue",sTableName + "," + sColName + "," + sWhereClause);
		}
		
		if("<%=sApplyType%>" == "DependentApply")
			ContractFlag = 1;
		else
			ContractFlag = 2;

        if(sOccurType == "015"){//针对展期业务
        	s = RunMethod("BusinessManage","InsertRelative",sSerialNo+",BusinessDueBill,"+sRelativeObjectType+",APPLY_RELATIVE");           
        }else if(sOccurType == "030"){//针对债务重组
        	s = RunMethod("BusinessManage","InsertRelative",sSerialNo+",NPAReformApply,"+sRelativeAgreement+",APPLY_RELATIVE");
        }
        //初始化BUSINESS_APPLY
		s1 = RunMethod("BusinessManage","AddBusinessApply","<%=sObjectType%>"+","+sSerialNo+","+"<%=InputUserID%>"+","+sBusinessType +","+"<%=InputDate%>"+","+sCustomerName+","+"<%=InputOrgID%>"+","+"<%=sApplyType%>"+","+sIndustryType+","+ContractFlag+","+sCustomerID+","+sOccurType+","+sVersionID);
        //初始化流程
		s2 = RunMethod("WorkFlowEngine","InitializeFlow","<%=sObjectType%>"+","+sSerialNo+","+"<%=sApplyType%>"+","+"<%=sFlowNo%>"+","+"<%=sPhaseNo%>"+","+"<%=InputUserID%>"+","+"<%=InputOrgID%>");

		sObjectNo = sSerialNo;
		sObjectType = "CreditApply";
		//返回申请类型和业务申请流水号
		top.returnValue=sObjectNo+"@"+sObjectType+"@"+sBusinessType;
		top.close();
	}
	
	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation(){
		saveRecord();
	}
	
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel(){
		top.returnValue = "_CANCEL_";
		top.close();
	}
	
	/*~[Describe=清空信息;InputParam=无;OutPutParam=无;]~*/
	function clearData(){
		document.getElementById("customerID").value="";
		document.getElementById("customerName").value="";
		document.getElementById("BusinessType").value="";
		document.getElementById("VirtualBusinessType").value="";
		document.getElementById("RelativeAgreement").value="";
		document.getElementById("RelativeObjectType").value="";		
	}

    /*~[Describe=获取客户编号和名称;InputParam=对象类型，返回列位置;OutPutParam=无;]~*/
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
			//改变客户类型时清空业务品种、关联借据和关联重组方案
			document.getElementById("BusinessType").value="";
			document.getElementById("VirtualBusinessType").value="";
			document.getElementById("RelativeAgreement").value="";
			document.getElementById("RelativeObjectType").value="";
		}catch(e){
			return;
		}
	}	

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){
		var sCustomerType = document.getElementById("customType").value;
		if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
			alert(getBusinessMessage('225'));//请先选择客户类型！
			return;
		}
		//具有业务申办权的客户信息
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType == "01")//公司客户和中小企业
			subSelectCustomer("SelectApplyCustomer3",sParaString);
		if(sCustomerType == "02")//关联集团
			subSelectCustomer("SelectApplyCustomer2",sParaString);
		if(sCustomerType == "03")//个人客户
			subSelectCustomer("SelectApplyCustomer1",sParaString);
	}

	/*~[Describe=获取业务品种;InputParam=对象类型，返回列位置;OutPutParam=无;]~*/
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
	
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectBusinessType(sType){
		var sParaString = "";		
		if(sType == "ALL"){
			var sCustomerType = document.getElementById("customType").value;
			if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
				alert(getBusinessMessage('225'));//请先选择客户类型！
				return;
			}
			
			var sCustomerID = document.getElementById("customerID").value;
			if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
				alert(getBusinessMessage('226'));//请先选择授信客户！
				return;
			}
			//如果为个人客户
			if(sCustomerType == "03"){
				sReturn = RunMethod("PublicMethod","GetColValue","CustomerType,Customer_Info,String@CustomerID@"+sCustomerID);
				if(sReturn.split("@")[1] == "0310"){
					subSelectBusinessType("SelectIndBusinessType");
				}else if(sReturn.split("@")[1] == "0320"){
					subSelectBusinessType("SelectIndEntBusinessType");
				}else{
					alert("请选择个人客户或者个体经营户！");
					return;
				}
			}	
			//如果为公司客户		
			else if(sCustomerType == "01"){
				sReturn = RunMethod("PublicMethod","GetColValue","CustomerType,Customer_Info,String@CustomerID@"+sCustomerID);
				if(sReturn.split("@")[1] == "0110"){
					subSelectBusinessType("SelectEntBusinessType");
				}else if(sReturn.split("@")[1] == "0120"){
					subSelectBusinessType("SelectSMEBusinessType");
				}else{
					alert("请选择大型企业客户或者中小企业客户！");
					return;
				}
			}
			selectProductVersion();
		}
	}
	
	/*~[Describe=弹出业务品种版本选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectProductVersion(){
		var typeNo = document.getElementById("VirtualBusinessType").value;
		if(typeof(typeNo) == "undefined" || typeNo.length == 0){alert("请先选择产品！"); return;}
		var productVersion = setObjectValue("SelectProductVersion","TypeNo,"+typeNo,"",0,0,"");
		if(typeof(productVersion) == "undefined" || productVersion.length == 0 || productVersion=="_CLEAR_") return;
		document.getElementById("VersionID").value = productVersion.split("@")[0];
	}

    /*~[Describe=获取展期借据;InputParam=对象类型，返回列位置;OutPutParam=无;]~*/
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
	
	/*~[Describe=弹出待展期的合同/借据选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectExtendContract(){
		var sCustomerID = document.getElementById("customerID").value;
		if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}
		//按照合同展期
		//sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.getUserID()%>";
		//setObjectValue("SelectExtendContract",sParaString,"@RelativeAgreement@0@BusinessType@1",0,0,"");			
		//setItemValue(0,0,"RelativeObjectType","BusinessContract");
		//按照借据展期
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateUserID"+","+"<%=CurUser.getUserID()%>";
		subSelectExtContract("SelectExtendDueBill",sParaString);
	}
	
	/*~[Describe=弹出资产重组选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
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