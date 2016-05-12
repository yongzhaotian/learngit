<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:   HYLiu  2004.09.16
 * Tester:
 * Content: 信用评级检查表格
 * Input Param:
 *			ObjectType：对象类型
 *			ObjectNo：对象编号
 *			ModelType：模型类型
 *			ModelNo：模型编号
 *			AccountMonth：会计月份
 *					
 * Output param:
 *			
 * History Log:
 *                  
 *                  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.evaluate.*" %>
<%!
public String getSingleStringResult(String SqlString,Transaction Sqlca) throws Exception
{
	ASResultSet rs = null;
	String sReturn = null;
	rs = Sqlca.getASResultSet(SqlString);
	if(rs.next()) sReturn = rs.getString(1);
	rs.getStatement().close();
	return sReturn;
}
%>
<html>
<head>
<title>新增并测算</title>
</head>
<body leftmargin="10" topmargin="10" >
</body>
</html>
<%
	//定义变量
	String sSql = "";
	String sModelTypeAttributes = "",sDefaultModelNoSQL = "",sDefaultModelNo = "";
	ASResultSet rs = null,rs1 = null;
	SqlObject so = null;
	
	//获得页面参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sModelType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelType"));
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo"));
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sModelType == null) sModelType = "";
	if(sModelNo == null) sModelNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
		
	sSql = "select * from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo=:ItemNo";
	so = new SqlObject(sSql).setParameter("ItemNo",sModelType);
	rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		sModelTypeAttributes = rs.getString("RelativeCode");
	}else{
		throw new Exception("模型类型 ["+sModelType+"] 没有定义。请查看CODE_LIBRARY:EvaluateModelType");
	}
	rs.getStatement().close();
	
	if(sModelTypeAttributes==null) throw new Exception("模型类型 ["+sModelType+"] 的属性集 没有定义，请查看CODE_LIBRARY:EvaluateModelType的RelativeCode属性");
	sDefaultModelNoSQL = StringFunction.getProfileString(sModelTypeAttributes,"DefaultModelNoSQL");
	//替换变量
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ObjectType",sObjectType);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ObjectNo",sObjectNo);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ModelType",sModelType);
	//获取模型号
	sModelNo = getSingleStringResult(sDefaultModelNoSQL,Sqlca);
    
	sSql = "select count(*) from EVALUATE_CATALOG where  (Method1 is null or Method1 not like '%停用%') and ModelNo = :ModelNo";
	so = new SqlObject(sSql).setParameter("ModelNo",sModelNo);
	rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		if(rs.getInt(1)<1) throw new Exception("该客户指定了一个停用的信用评级模型，请在客户概况中修改。ModelNo:"+sModelNo);
	}
	rs.getStatement().close();

	if(sDefaultModelNoSQL!=null && !sDefaultModelNoSQL.equals("")){
		sDefaultModelNo = getSingleStringResult(sDefaultModelNoSQL,Sqlca);
		sModelNo = sDefaultModelNo;
	}else{
		%>	
		<script type="text/javascript"> 
			alert(getBusinessMessage('194'));//没有指定默认的模型！
			self.returnValue="failed";
			self.close();
		</script>		
		<%
		return;
	}

	if (Evaluate.existEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,Sqlca)){
%>	
		<script type="text/javascript"> 
			alert(getBusinessMessage('195'));//该期信用等级评估记录已存在！
			self.returnValue="failed";
			self.close();
		</script>		
<%
		//return;
	}else{
		String sEvaluateDate = StringFunction.getToday();
		String sOrgID = CurOrg.getOrgID();
		String sUserID = CurUser.getUserID();
		String sEvaDate="",sEvaResult="";
		float dEvaScore=0;
		int iCount=0;
		ASResultSet sReport=null;

		String sSerialNo = Evaluate.newEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,sEvaluateDate,sOrgID,sUserID,Sqlca);
		Evaluate evaluate;
		evaluate  = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);
		evaluate.evaluate();

		sSql = "select EvaluateDate,EvaluateScore,EvaluateResult from EVALUATE_RECORD where ObjectType=:ObjectType and ObjectNo=:ObjectNo and SerialNo=:SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("ObjectType",sObjectType);
		so.setParameter("ObjectNo",sObjectNo);
		so.setParameter("SerialNo",sSerialNo);
		rs = Sqlca.getASResultSet(so);
		if (rs.next()){
			sEvaDate = rs.getString(1);
			dEvaScore = rs.getFloat(2);
			sEvaResult = rs.getString(3);
		}
		rs.getStatement().close();
		sSql = " Update EVALUATE_RECORD Set CognDate=:CognDate,CognScore=:CognScore,CognResult=:CognResult,"+
		          " CognOrgID=:CognOrgID,CognUserID=:CognUserID" +
		          " where ObjectType=:ObjectType and ObjectNo=:ObjectNo and SerialNo=:SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("CognDate",sEvaDate);
		so.setParameter("CognScore",dEvaScore);
		so.setParameter("CognResult",sEvaResult);
		so.setParameter("CognOrgID",CurOrg.getOrgID());
		so.setParameter("CognUserID",CurUser.getUserID());
		so.setParameter("ObjectType",sObjectType);
		so.setParameter("ObjectNo",sObjectNo);
		so.setParameter("SerialNo",sSerialNo);
     	Sqlca.executeSQL(so);
     	sSql = " select AccountMonth,CognResult from EVALUATE_RECORD Where ObjectNo=:ObjectNo1"  +
	     		  "' and  modelno in ('210','215','220') and AccountMonth = (select max(AccountMonth) from EVALUATE_RECORD Where ObjectNo=:ObjectNo2)";
     	so = new SqlObject(sSql);
     	so.setParameter("ObjectNo1",sObjectNo);
     	so.setParameter("ObjectNo2",sObjectNo);
     	rs = Sqlca.getASResultSet(so);
	 	String sEvaDate1="",sEvaResult1="";
		if (rs.next()){
			sEvaDate1 = rs.getString(1);			
			sEvaResult1 = rs.getString(2);
		}
		rs.getStatement().close();

		sSql = "Update ENT_INFO  Set EvaluateDate=:EvaluateDate,CreditLevel=:CreditLevel"+
	       	      "where  CustomerID= :CustomerID";
		so = new SqlObject(sSql);
		so.setParameter("EvaluateDate",sEvaDate1);
		so.setParameter("CreditLevel",sEvaResult1);
		so.setParameter("CustomerID",sObjectNo);
		Sqlca.executeSQL(so);        
%>	
		<script type="text/javascript"> 
			self.returnValue="<%=sEvaResult%>@<%=sModelNo%>";
			self.close();
		</script>		
<%
	}
%>
<script type="text/javascript">
</script>
<%@ include file="/IncludeEnd.jsp"%>