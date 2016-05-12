<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
		Author:   phe  2015/03/17
		Tester:
		Content: 业务基本信息   CCS-213 PRM-26 质量标注 增加文件名称
	 */
	%>
<%/*~END~*/%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "质量标注维护";

	// 获得页面参数
	String sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));
	if(sCodeNo==null) sCodeNo="";
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));
	if(sItemNo==null) sItemNo="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "QualityLableCodeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setDDDWSql("Attribute8", "select ErrorType,getitemname('ErrorType',ErrorType) from ErrorTypeCode_Info");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCodeNo+","+sItemNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
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
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/QualityLableCodeList.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0, 0, "CODENO", "QualityLable");
			var sItemNo=RunMethod("SystemManage","SelectMaxNo","QualityLable");
			sItemNo=parseInt(sItemNo)+10;
			setItemValue(0, 0, "ITEMNO", sItemNo);
			setItemValue(0, 0, "SORTNO", sItemNo);
			setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			bIsInsert = true;
		}
    }
	//通过选择质量等级进行对应的判断
	function changeValue(){
		var a =getItemValue(0,getRow(),"Attribute7");//质量等级
		if(a==1||a==2){//alert("为关键与非关键时，下面3个下拉框必填！");
			setItemValue(0, getRow(), "ITEMNAME", "");//先清空选项
			setItemValue(0, getRow(), "Attribute8", "");//先清空选项
			setItemValue(0, getRow(), "Attribute5", "");//先清空选项
			setItemValue(0, getRow(), "Attribute4", "");//先清空选项
	
			setItemDisabled(0,getRow(),"ITEMNAME",false);//设置可填
			setItemDisabled(0,getRow(),"Attribute6",false);//设置可填
			setItemDisabled(0,getRow(),"Attribute4",false);//设置可填
			setItemDisabled(0,getRow(),"Attribute5",false);//设置可填
			
			setItemRequired(0,getRow(),"ITEMNAME",1);//设置必填项
			setItemRequired(0,getRow(),"Attribute8",1);//设置必填项
			setItemRequired(0,getRow(),"Attribute4",1);//设置必填项
			setItemRequired(0,getRow(),"Attribute5",1);//设置必填项

		}else if(a==3){//alert("为合格时，下面3个下拉框不可填！");
			setItemValue(0, getRow(), "ITEMNAME", "");//先清空选项
			setItemValue(0, getRow(), "Attribute8", "");//先清空选项
			setItemValue(0, getRow(), "Attribute6", "");//先清空选项
			setItemValue(0, getRow(), "Attribute5", "");//先清空选项
			setItemValue(0, getRow(), "Attribute4", "");//先清空选项
			
			setItemRequired(0,getRow(),"ITEMNAME",0);//设置必填项
			setItemRequired(0,getRow(),"Attribute8",0);//设置必填项
			setItemRequired(0,getRow(),"Attribute4",0);//设置必填项
			setItemRequired(0,getRow(),"Attribute5",0);//设置必填项
			
			setItemDisabled(0,getRow(),"ITEMNAME",true);//设置不可填
			setItemDisabled(0,getRow(),"Attribute8",true);//设置不可填
			setItemDisabled(0,getRow(),"Attribute6",true);//设置不可填
			setItemDisabled(0,getRow(),"Attribute5",true);//设置不可填
			setItemDisabled(0,getRow(),"Attribute4",true);//设置不可填
			
		}else if (a==4 || a==5||a==6){//alert("为特办时，下面3个下拉框可填可不填！");
			setItemValue(0, getRow(), "ITEMNAME", "");//先清空选项
			setItemValue(0, getRow(), "Attribute8", "");//先清空选项
			setItemValue(0, getRow(), "Attribute6", "");//先清空选项
			setItemValue(0, getRow(), "Attribute5", "");//先清空选项
			setItemValue(0, getRow(), "Attribute4", "");//先清空选项
			
			setItemDisabled(0,getRow(),"ITEMNAME",false);//设置可填
			setItemDisabled(0,getRow(),"Attribute8",false);//设置可填
			setItemDisabled(0,getRow(),"Attribute6",false);//设置可填
			setItemDisabled(0,getRow(),"Attribute4",false);//设置可填
			setItemDisabled(0,getRow(),"Attribute5",false);//设置可填
			
			setItemRequired(0,getRow(),"ITEMNAME",0);//设置为非必填项
			setItemRequired(0,getRow(),"Attribute8",0);//设置为非必填项
			setItemRequired(0,getRow(),"Attribute6",0);//设置为非必填项
			setItemRequired(0,getRow(),"Attribute4",0);//设置为非必填项
			setItemRequired(0,getRow(),"Attribute5",0);//设置为非必填项
		}else{
			setItemDisabled(0,getRow(),"Attribute8",true);

		}
	}
	/*~[Describe=弹出多选框选择错误类型;InputParam=无;OutPutParam=无;]~*/
	function selectErrorTypeMulti() {
		var Attribute7= getItemValue(0,getRow(),"Attribute7");
		if(Attribute7==""){
			alert("请选择对应质量等级!");
			return;
		}
		var qualitygradecodeno ="qualitygradecodeno,"+Attribute7;
		
		var sRetVal = setObjectValue("SelectErrorType", qualitygradecodeno,"@qualitygradecodeno@0" , 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择错误类型");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "Attribute8", sCTypeIds.substring(0, sCTypeIds.length-1));  //商品范畴ID
		// code_library 中 t.codeno='QualityFile'模板下面 Attribute5用来做Attribute8的名称显示字段
		setItemValue(0, 0, "Attribute5", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	/*~[Describe=弹出多选框选择文件名称;InputParam=无;OutPutParam=无;]~*/
	function selectFileNameMulti() {
		var Attribute7= getItemValue(0,getRow(),"Attribute7");//质量等级
		var Attribute8= getItemValue(0,getRow(),"Attribute8");//错误类型
		if(Attribute7==""){
			alert("请选择对应质量等级!");
			return;
		}
		if(Attribute8==""){
			alert("请选择对应错误类型!");
			return;
		}
		var sParaString ="ATTRIBUTE7"+","+Attribute7+","+"ATTRIBUTE8"+","+Attribute8;
		var sRetVal = setObjectValue("SelectFileName", sParaString,"@itemno@0@itemname@1" , 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择错误类型或文件名称");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "Attribute6", sCTypeIds.substring(0, sCTypeIds.length-1));  
		// code_library 中 t.codeno='QualityFile'模板下面 Attribute4用来做Attribute6的名称显示字段
		setItemValue(0, 0, "Attribute4", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
