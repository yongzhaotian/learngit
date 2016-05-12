<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "批量代扣逻辑详情";

	//获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "BatchWithholdLogicInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setReadOnly("withholdDate", true);
	doTemp.setReadOnly("withholdWay", true);
	
	String sSql="";
	String sWithholdWay="";
	ASResultSet rs=null;
	sSql="select withholdWay from Batch_withhold where SerialNo=:SerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	 if(rs.next()){
		 sWithholdWay=rs.getString("withholdWay");
	    	if(sWithholdWay==null){
	    		sWithholdWay="";
	    	}
	    }
	 rs.getStatement().close();
	 
	
	 if("1".equals(sWithholdWay)){
		doTemp.setRequired("withholdPercent", true);
		doTemp.setReadOnly("withholdSum", true);
	}
	if("2".equals(sWithholdWay)){
		doTemp.setReadOnly("withholdPercent", true);
		doTemp.setRequired("withholdSum", true);
	} 
	doTemp.WhereClause+=" and serialno="+sSerialNo;
	
	
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
	
	<%/*~[Describe=检查该天数是否存在;]~*/%>
	function checkIsExists() {
		var sWithholdDate = getItemValue(0, 0, "withholdDate");
		var Serialno = getItemValue(0, 0, "serialno");
		if (typeof(sWithholdDate)=='undefined' || sWithholdDate.length==0) {
			return;
		}
		if(sWithholdDate<4){
			alert("输入天数不能小于4天");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
		
		if(sWithholdDate%10 != 0){
			alert("输入天数必须是10的整数倍,请重新输入！");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
		
		var sSerialno = RunMethod("BusinessManage", "SelectWithholdInfo", sWithholdDate);
		if (sSerialno!="Null" && sSerialno.length>0 && Serialno!="<%=sSerialNo%>") {
			alert("该天数已经存在，请重新输入！");
			setItemValue(0, 0, "withholdDate", "");
			return;
		}
	}
	
	<%/*~[Describe=检查该百分比是否合法;]~*/%>
	function checkWithholdPercent() {
		var sWithholdPercent = getItemValue(0, 0, "withholdPercent");
		if (typeof(sWithholdPercent)=='undefined' || sWithholdPercent.length==0) {
			return;
		}
		/* if(sWithholdPercent<=0 || sWithholdPercent>100){
			alert("请输入0~100之间的数字，大于0，小于等于100");
			setItemValue(0, 0, "withholdPercent", "");
			return;
		} */
		if(sWithholdPercent<=0 ){
			alert("请输入大于0的数字");
			setItemValue(0, 0, "withholdPercent", "");
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
		 var sWithholdPercentTotal=RunMethod("BusinessManage", "SelectWithholdPercentTotal", sWithholdDate+",<%=sSerialNo%>");
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
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	function goBack(){
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/BatchWithholdLogic.jsp","","_self");
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		
		setItemValue(0, 0, "updateorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"updateuserid","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"updatedate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		
	}
	 
	
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		var sWithholdDate=getItemValue(0,0,"withholdDate");
		var sWithholdPercentTotal=RunMethod("BusinessManage","CountWithholdPercent",sWithholdDate);
		if(sWithholdPercentTotal=="Null") sWithholdPercentTotal="";
		setItemValue(0,0,"withholdPercentTotal",sWithholdPercentTotal);
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
