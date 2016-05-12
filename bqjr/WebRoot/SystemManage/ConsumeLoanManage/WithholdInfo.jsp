<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "新增批量代扣逻辑";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "BatchWithholdLogicInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause+=" and 1=2";
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	<%/*~[Describe=根据代扣类型确定必输项;]~*/%>
	function changeRequired(){
		//代扣类型
		var sWithholdWay=getItemValue(0,0,"withholdWay");
		   if (typeof(sWithholdWay)=='undefined' || sWithholdWay.length==0) {
					return;
		   }

		if(sWithholdWay=="1"){
			setItemRequired(0, 0, "withholdPercent", true);
			setItemRequired(0,0,"withholdSum",false);
			setItemReadOnly(0, 0, "withholdSum", true);
			setItemReadOnly(0, 0, "withholdPercent", false);
			setItemValue(0,0,"withholdSum","");
		}else{
			setItemRequired(0, 0, "withholdPercent", false);
			setItemRequired(0,0,"withholdSum",true);
			setItemReadOnly(0, 0, "withholdPercent", true);
			setItemReadOnly(0, 0, "withholdSum", false);
			setItemValue(0,0,"withholdPercent","");
			setItemValue(0,0,"withholdPercentTotal","");
		}
		return;
	}
	<%/*~[Describe=检查该天数是否存在;]~*/%>
	function checkIsExists() {
		var sWithholdDate = getItemValue(0, 0, "withholdDate");
		if (typeof(sWithholdDate)=='undefined' || sWithholdDate.length==0) {
			return;
		}
		
		if(!(/^[\d-]+$/.test(sWithholdDate))){
			alert("输入天数必须为整数");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
		sWithholdDateInt=parseInt(sWithholdDate);
		if(sWithholdDate<=0){
			alert("输入天数必须大于0");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
		
		
       	var sSerialno = RunMethod("BusinessManage", "SelectWithholdInfo", sWithholdDate);
		if (sSerialno!="Null" && sSerialno.length>0) {
			//查询上一个代扣的类型是代扣百分比还是代扣金额
			 var sWithholdPercent=RunMethod("BusinessManage", "SelectWithholdPercent", sSerialno);
			 if(typeof(sWithholdPercent)=='undefined' || sWithholdPercent.length==0){
				 //如果是代扣金额
				 setItemDisabled(0, 0, "withholdWay", true);
				 setItemValue(0,0,"withholdWay","2");
				 setItemReadOnly(0, 0, "withholdWay", true);
				 setItemRequired(0, 0, "withholdPercent", false);
				 setItemRequired(0,0,"withholdSum",true);
				 setItemReadOnly(0, 0, "withholdPercent", true);
				 setItemReadOnly(0, 0, "withholdSum", false);
				 setItemValue(0,0,"withholdPercent","");
				 //代扣金额不显示代扣百分比加总
				 setItemValue(0,0,"withholdPercentTotal","");
				 return;
				 
			 }else{
				 //如果是代扣百分比
				 setItemDisabled(0, 0, "withholdWay", true);
				 setItemValue(0,0,"withholdWay","1");
				 setItemReadOnly(0, 0, "withholdWay", true);
				 setItemRequired(0, 0, "withholdPercent", true);
				 setItemRequired(0,0,"withholdSum",false);
				 setItemReadOnly(0, 0, "withholdSum", true);
				 setItemReadOnly(0, 0, "withholdPercent", false);
				 setItemValue(0,0,"withholdSum","");
				 //代扣百分比显示代扣百分比加总
				 var sWithholdPercentTotal=RunMethod("BusinessManage", "CountWithholdPercent", sWithholdDate);
				 setItemValue(0,0,"withholdPercentTotal",sWithholdPercentTotal);
				 return;
			 }
			
		}
		
		setItemDisabled(0, 0, "withholdWay", false);
		setItemValue(0,0,"withholdPercentTotal","");
	}
	<%/*~[Describe=只要天数发生改变，就将代扣类型置空;]~*/%>
	function changeWithholdWay(){
		setItemValue(0,0,"withholdWay","");
	}
	<%/*~[Describe=检查该百分比是否合法;]~*/%>
	function checkWithholdPercent() {
		var sWithholdPercent = getItemValue(0, 0, "withholdPercent");
		if (typeof(sWithholdPercent)=='undefined' || sWithholdPercent.length==0) {
			return;
		}
		
		if(sWithholdPercent<=0 ){
			alert("请输入大于0的数字");
			setItemValue(0, 0, "withholdPercent", "");
			return;
		}
	}
	
	<%/*~[Describe=检查代扣金额;]~*/%>
	 function checkWithholdSum(){
		var sWithholdSum=getItemValue(0, 0, "withholdSum");
		if (typeof(sWithholdSum)=='undefined' || sWithholdSum.length==0) {
			return;
		}
		if(sWithholdSum<=0 ){
			alert("请输入大于0的数字");
			setItemValue(0, 0, "withholdSum", "");
			return;
		}
	} 
	
	 <%/*~[Describe=计算代扣百分比加总;]~*/%>
	 function countWithholdPercentTotal(){
		 var sWithholdDate = getItemValue(0, 0, "withholdDate");
		 if (typeof(sWithholdDate)=='undefined' || sWithholdDate.length==0) {
				return;
		 }
		 
		 var sWithholdPercent=getItemValue(0,0,"withholdPercent");
		 if (typeof(sWithholdPercent)=='undefined' || sWithholdPercent.length==0) {
			 return;
		 }
		 
		 var sWithholdPercentTotal = "";
		 var sSerialNo = getItemValue(0, 0, "serialno");
		 if(!bIsInsert) sWithholdPercentTotal=RunMethod("BusinessManage", "SelectWithholdPercentTotal", sWithholdDate+","+sSerialNo);
		 else sWithholdPercentTotal=RunMethod("BusinessManage", "CountWithholdPercent", sWithholdDate);

		 if (typeof(sWithholdPercentTotal)=='undefined' || sWithholdPercentTotal.length==0||sWithholdPercentTotal=="Null") {
			 sWithholdPercentTotal="0";
		 }
		 var sPercentTotal=parseFloat(sWithholdPercentTotal);
		 
		 var sPercent=parseFloat(sWithholdPercent);
		 var sWithholdPercentTotalNow=sPercentTotal+sPercent;
		 setItemValue(0,0,"withholdPercentTotal",sWithholdPercentTotalNow);
	 }
	function saveRecord(sPostEvents){
		var sWithholdPercentTotal = getItemValue(0, 0, "withholdPercentTotal");
		if(sWithholdPercentTotal>100){
			alert("同一逾期天数的代扣百分比加总不能超过百分百，请重新配置代扣百分比");
			return;
		}
		
		if(!bIsInsert){
			var withholdWay = getItemValue(0,0,"withholdWay");
			var sWithholdDate = getItemValue(0, 0, "withholdDate");
			var sSerialNo = getItemValue(0, 0, "serialno");
		    if (typeof(withholdWay)=='undefined' || withholdWay.length==0 || typeof(sWithholdDate)=='undefined' || sWithholdDate.length==0) {
					return;
		    }
		    
		    if(withholdWay=="2"){
			    var withholdReturn = RunMethod("BusinessManage", "WithholdWayCheck", sWithholdDate+",1,"+sSerialNo);
			    if(withholdReturn>0){
				    alert("该逾期天数已存在代扣类型的值为代扣百分比的记录，代扣类型的值不允许选代扣金额");
				    return;
			    }
		    }else{
		    	var withholdReturn = RunMethod("BusinessManage", "WithholdWayCheck", sWithholdDate+",2,"+sSerialNo);
			    if(withholdReturn>0){
				    alert("该逾期天数已存在代扣类型的值为代扣金额的记录，代扣类型的值不允许选代扣百分比");
				    return;
			    }
		    }
		    
	    }
		
		if(bIsInsert){
			beforeInsert();
		}
		
		as_save("myiframe0",sPostEvents);
		var sWithholdWay=getItemValue(0,0,"withholdWay");
	    if (typeof(sWithholdWay)=='undefined' || sWithholdWay.length==0) {
				return;
	    }
		

		if(sWithholdWay=="1"){
			setItemReadOnly(0, 0, "withholdSum", true);
			setItemReadOnly(0, 0, "withholdPercent", false);
		}else{
			setItemReadOnly(0, 0, "withholdPercent", true);
			setItemReadOnly(0, 0, "withholdSum", false);
		}
		return;
	}

	function goBack(){
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/BatchWithholdLogic.jsp","","_self");
	}


	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"inputtime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			
			var sSerialNo = getSerialNo("BATCH_WITHHOLD", "SERIALNO", "");
			setItemValue(0, 0, "serialno", sSerialNo);
			setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputtime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

			bIsInsert = true;
		}
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
