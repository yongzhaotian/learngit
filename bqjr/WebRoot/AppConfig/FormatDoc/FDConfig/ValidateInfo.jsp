<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "验证规则信息";
	String sSerialno=CurPage.getParameter("Serialno");
	String sDono=CurPage.getParameter("sDono");
	if(sSerialno==null) sSerialno="";
	ASDataObject doTemp = new ASDataObject("ValidateInfo");
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp,Sqlca);
	dwTemp.Style = "2";//freeform
	doTemp.setDefaultValue("Dono",sDono);
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialno);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{"true","","Button","保存","","saveRecord()","","","",""},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	//窗体初始化隐藏参数三到参数十
	var params=new Array(10);
	<%
		String[] sAttributes={"Param1","Param2","Param3","Param4","Param5","Param6","Param7","Param8","Param9","Param10"};
		for(int i=0;i<sAttributes.length;i++){%>
			params[<%=i%>] = document.getElementById("A_div_<%=doTemp.getColumnAttribute(sAttributes[i],"COLINDEX")%>").parentNode.parentNode;
			params[<%=i%>].style.display='none';
		<%}
	%>
	
	//保存数据
	function saveRecord(){
		as_save("myiframe0","parent.frames[0].as_refreshCurrentRow(0)"); //刷新list使用
		//as_save("myiframe0","afterOpen();"); //刷新tree使用
	}

	//选择通用验证规则
	function selectValidate(){
		AsControl.SetGridValue("SelectValidate","","ValidatorName=ValidatorName");
		var sValidatorName=getItemValue(0,0,"ValidatorName");
		showAttribute(sValidatorName);
	}

	//插入变量
	function insertVariable(IdName){
		var value=prompt("请输入变量名","");
		if(value!=null && value!="undefined" &&value!=""){
			document.getElementById(IdName).value="$Const:JboManager="+value;
		}
	}

	//根据通用验证规则名称判断是否显示参数
	function showAttribute(validatorName){
		var param3 = document.getElementById("div_<%=doTemp.getColumnAttribute("Param3","COLINDEX")%>");
		var param4 = document.getElementById("div_<%=doTemp.getColumnAttribute("Param4","COLINDEX")%>");
		if("Class"==validatorName){
			for ( i = 0; i < params.length; i++) {
				params[i].style.display='block';
			}
			document.getElementById("PARAM1").value="";
			param3.innerHTML="参数三 &nbsp;";
			param4.innerHTML="参数四 &nbsp;";
		}else if("Require"==validatorName){
			for ( i = 0; i < params.length; i++) {
				params[i].style.display='none';
			}
			params[1].style.display='block';
			document.getElementById("PARAM1").value="";
		}else if("Unique"==validatorName){
			for (i = 0; i < params.length; i++) {
				if(i<5)
					params[i].style.display='block';
				else
					params[i].style.display='none';
			}
			param3.innerHTML="jbomanager名称 &nbsp;";
			param4.innerHTML="jbo控件名 &nbsp;";
			document.getElementById("PARAM1").value="com.amarsoft.awe.dw.ui.validator.classrule.UniqueRule";
		}else{
			for ( i = 0; i < params.length; i++) {
				params[i].style.display='none';
			}
			document.getElementById("PARAM1").value="";
		}
	}
	var sValidatorName=getItemValue(0,0,"ValidatorName");
	showAttribute(sValidatorName);

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
		}
	}
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>