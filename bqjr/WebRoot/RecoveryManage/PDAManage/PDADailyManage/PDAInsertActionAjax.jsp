<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong 2004-12-09
 * Tester:
 *
 * Content:   ֱ�Ӳ���һ���ʲ���¼
 * Input Param:
 *		AssetType���ʲ�����
 *		SerialNo���ʲ�����
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//��ȡҳ�����
	String sAssetType = DataConvert.toRealString(iPostChange,CurPage.getParameter("AssetType")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 
	//����ֵת��Ϊ���ַ���
	if(sAssetType == null) sAssetType = "";
	if(sSerialNo == null) sSerialNo = "";	
	
	//�������	
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
		"AssetStatus,"+  //�ѱ�׼����롣
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
