<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong 2004-12-09
 * Tester:
 *
 * Content:   直接插入一条资产纪录
 * Input Param:
 *		AssetType：资产类型
 *		SerialNo：资产类型
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//获取页面参数
	String sAssetType = DataConvert.toRealString(iPostChange,CurPage.getParameter("AssetType")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 
	//将空值转化为空字符串
	if(sAssetType == null) sAssetType = "";
	if(sSerialNo == null) sSerialNo = "";	
	
	//定义变量	
	String sSql = "";
	
	
	sSql = "insert into ASSET_INFO(SerialNo,"+
		"ObjectType,"+
		"ObjectNo,"+
		"AssetNo,"+
		"AssetBalance,"+
		"OutInitBalance,"+
		"OutNowBalance,"+
		"AssetAmount,"+
		"AssetSum,"+
		"IntoCashRatio,"+
		"IntoCashSum,"+
		"LossesSum,"+
		"FinancialLossesSum,"+
		"PershareValue,"+
		"EnterValue,"+
		"UnDisposalSum,"+
		"AssetStatus,"+  //已比准拟抵入。
		"AssetAttribute,"+
		"AssetType,"+
		"OperateOrgID,"+
		"OperateUserID,"+
		"ManageUserID,"+
		"ManageOrgID,"+
		"InputOrgID,"+
		"InputUserID,"+
		"InputDate,"+
		"UpdateDate,"+
		"Currency) "+
		"values(:SerialNo,'AssetInfo',:ObjectNo,null,0,0,0,'0',0,0,0,0,0,0,0,0,'02','01',"+
		":AssetType,:OperateOrgID,:OperateUserID,"+
		":ManageUserID,:ManageOrgID,:InputOrgID,"+
		":InputUserID,:InputDate,:UpdateDate,'01')";
	SqlObject so = new SqlObject(sSql);
	so.setParameter("SerialNo",sSerialNo);
	so.setParameter("ObjectNo",sSerialNo);
	so.setParameter("AssetType",sAssetType);
	so.setParameter("OperateOrgID",CurOrg.getOrgID());
	so.setParameter("OperateUserID",CurUser.getUserID());
	so.setParameter("ManageUserID",CurUser.getUserID());
	so.setParameter("ManageOrgID",CurOrg.getOrgID());
	so.setParameter("InputOrgID",CurOrg.getOrgID());
	so.setParameter("InputUserID",CurUser.getUserID());
	so.setParameter("InputDate",StringFunction.getToday());
	so.setParameter("UpdateDate",StringFunction.getToday());
	Sqlca.executeSQL(so);
%>

<%@ include file="/IncludeEndAJAX.jsp"%>
