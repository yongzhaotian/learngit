<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: 信用等级认定信息;
		Input Param:
			--SerialNo   : 流水号
			--sObjectNo  ：对象编号
			--sisReadOnly：对按钮的操作权标志
	 */
	String PG_TITLE = "信用等级认定"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sSql = "";//--存放sql语句
	String sUserID = "";//--用户代码
	String sUserName = "";//--用户名称
	String sRole = "";//--角色
	String sResult="";//--结果
	String sDate = "";//--日期
	String sSourceValue = "";//--更新客户信息时以和结果为准\
	String sButtonFlags="";
	
	//获得页面参数,流水号码、对象编号、按钮标志
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sIsReadOnly = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsReadOnly"));
	if(sSerialNo == null) sSerialNo = "";
	if(sIsReadOnly == null) sIsReadOnly = "";

	String sHeaders[][] = { {"AccountMonth","会计月份"},
	                        {"ModelName","评估模型"},
	                        {"EvaluateDate","系统评估日期"},
	                        {"EvaluateScore","系统评估得分"},
	                        {"EvaluateResult","系统评估结果"},
							{"CognScore","人工评定得分"},
							{"CognResult","人工评定结果"},
							{"CognResult4","支行认定结果"},
							{"CognReason4","支行认定理由"},
							{"FinishDate4","支行认定完成日期"},							
							{"CognResult2","分行认定结果"},
							{"CognReason2","分行认定理由"},
							{"FinishDate2","分行认定完成日期"},
							{"CognResult3","总行认定结果"},
							{"CognReason3","总行认定理由"},
							{"FinishDate3","总行认定完成日期"},
							{"CognOrgName","评估单位"},
							{"CognUserName","评估人"},
							{"CognUserName4","支行认定人"},
							{"CognUserName2","分行认定人"},
							{"CognUserName3","总行认定人"},	         												
	                        {"Remark","调整说明"}
			              };   				   		
	
	sSql =  " select R.SerialNo,R.AccountMonth,C.ModelName,C.ModelNo,R.EvaluateDate,"+
			" R.EvaluateScore,R.EvaluateResult,R.CognScore,R.CognResult,R.CognResult4,"+
			" R.CognReason4,FinishDate4,R.CognResult2,"+
			" R.CognReason2,R.FinishDate2,R.CognResult3,R.CognReason3,R.FinishDate3,R.Remark,"+
			" R.CognOrgID,getOrgName(CognOrgID) as CognOrgName,"+
			" R.CognUserID,getUserName(CognUserID) as CognUserName,"+
			" CognUserID4,CognUserName4,"+
			" CognUserID2,CognUserName2,"+
			" CognUserID3,CognUserName3"+
			" from EVALUATE_RECORD R,EVALUATE_CATALOG C" + 
			" where R.ModelNo = C.ModelNo"+
			" and SerialNo='"+sSerialNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	//判断用户的角色 
	if(CurUser.hasRole("442")){ //支行信用等级认定员
 		doTemp.setRequired("CognResult4,CognReason4",true);
 		doTemp.setReadOnly("CognResult3,CognReason3,CognResult2,CognReason2",true);
 		sUserID = "CognUserID4";
 		sUserName = "CognUserName4";
 		sRole = "3";
 		sResult = "CognResult4";
 		sDate = "FinishDate4";
 	}else if(CurUser.hasRole("242")){ //分行信用等级认定员
 		doTemp.setRequired("CognResult2,CognReason2",true);
 		doTemp.setReadOnly("CognResult3,CognReason3,CognResult4,CognReason4",true);
 		sUserID = "CognUserID2";
 		sUserName = "CognUserName2";
 		sRole = "2";
 		sResult = "CognResult2";
 		sDate = "FinishDate2";
 	}else if(CurUser.hasRole("042")){ //总行信用等级认定员
 		doTemp.setRequired("CognResult3,CognReason3",true);
 		doTemp.setReadOnly("CognResult2,CognReason2,CognResult4,CognReason4",true);
 		sUserID = "CognUserID3";
 		sUserName = "CognUserName3";
 		sRole = "1";
 		sResult = "CognResult3";
 		sDate = "FinishDate3";
 		sButtonFlags="Y";
 	}else{
 	    doTemp.WhereClause += " and 1=2";
 	}
 	if(sIsReadOnly.equals("Y")){
        doTemp.setRequired("",false);
        doTemp.setReadOnly("",true);
 	}
	
	doTemp.setHeader(sHeaders);
	//设不可见
	doTemp.setVisible("SerialNo,ModelNo,CognUserID,CognOrgID,CognUserID2,CognUserID3,CognUserID4,FinishDate2,FinishDate3,FinishDate4",false);
	//为了删除
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setUpdateable("ModelName,CognOrgName,CognUserName",false);
	
	//设置宽度
	doTemp.setHTMLStyle("ModelName","style={width:300px} ");
	doTemp.setHTMLStyle("AccountMonth,EvaluateDate","  style={width:70px}  ");
	doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
	doTemp.setCheckFormat("EvaluateScore,CognScore","2");
	doTemp.setType("EvaluateScore,CognScore","Number");
	doTemp.setDDDWSql("EvaluateResult,CognResult,CognResult2,CognResult3,CognResult4","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' order by SortNo ");
	doTemp.setReadOnly("AccountMonth,ModelName,EvaluateDate,EvaluateScore,EvaluateResult,CognOrgName,CognUserName,CognScore,CognResult,CognUserName2,CognUserName3,FinishDate3,FinishDate2,FinishDate4",true);
	doTemp.setHTMLStyle("FinishDate2,FinishDate3,FinishDate4","style={width:80px");
	//style={color:#848284;width:70px}
	doTemp.setEditStyle("CognReason2,CognReason3,CognReason4,Remark","3");
	doTemp.setHTMLStyle("CognReason2,CognReason3,CognReason4,Remark"," style={width:200px;height:70px} ");
	doTemp.setLimit("CognReason2,CognReason3,CognReason4,Remark",200);
	doTemp.setRequired("R.Remark",true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//定义后续事件
	if(CurUser.hasRole("442"))	sSourceValue = "CognResult4";
	if(CurUser.hasRole("242"))	sSourceValue = "CognResult2";
	if(CurUser.hasRole("042"))	sSourceValue = "CognResult3";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","保存","保存所有修改","saveRecord('updateENTINFO()')",sResourcesPath},
			{"true","","Button","提交","提交信用等级认定","Finished()",sResourcesPath},
			{"false","","Button","认定","认定提交的信用等级","Finished()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
	if(sIsReadOnly.equals("Y")){
        sButtons[0][0]="false";
        sButtons[1][0]="false";
    }else if(sButtonFlags.equals("Y")){
		sButtons[1][0]="false";
        sButtons[2][0]="true";
    }
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	function saveRecord(sPostEvents){
		beforeUpdate();
		CheckEvaluate();
		as_save("myiframe0",sPostEvents);		
	}
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function updateENTINFO(){
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        sLineID = RunMethod("信用等级评估","更新客户最新等级结果","<%=sSerialNo%>,<%=sObjectNo%>,<%=sSourceValue%>,"+sAccountMonth);		
	}
	
	/*~[Describe=检查信用评级;InputParam=无;OutPutParam=无;]~*/
	function CheckEvaluate(){
        var sCognResult = getItemValue(0,getRow(),"<%=sResult%>");
        var sCognLevel = "<%=sRole%>";
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        PopPageAjax("/Common/Evaluate/CheckEvaluateActionAjax.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&CognLevel="+sCognLevel+"&CognResult="+sCognResult+"&AccountMonth="+sAccountMonth,"","resizable=yes;dialogWidth=21;dialogHeight=19;center:yes;status:no;statusbar:no");        
	}
	
	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function Finished(sPostEvents){
		if(confirm("您确定要提交认定吗？")){
    	   setItemValue(0,0,"<%=sDate%>","<%=StringFunction.getToday()%>");
    	   //as_save("myiframe0",sPostEvents); 
    		saveRecord(sPostEvents);
        }
	}

	function goBack(){
		OpenPage("/Common/Evaluate/EvaluateCognList.jsp","_self","");
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"<%=sUserID%>","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"<%=sUserName%>","<%=CurUser.getUserName()%>");
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	
<%@ include file="/IncludeEnd.jsp"%>