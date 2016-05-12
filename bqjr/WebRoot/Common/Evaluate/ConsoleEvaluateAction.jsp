<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:fhhao 2003.8.30
 * Tester:
 *
 * Content: 	�������õȼ���������
 * Input Param:
 *			ActionType����������
 *			ObjectType����������
 *		    ObjectNo��������
 *			SerialNO��������ˮ��
 *          AccountMonth������·�
 *          ModelNo������ģ�����ʹ���
 *			ModelType������ģ������
 * Output param:
 * History Log:   zbdeng 2004.02.09
 *                2003.02.11 FXie  �޸�Ȩ���ж�
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.evaluate.*,com.amarsoft.app.lending.bizlets.InitializeFlow" %>
<% 
	//�������
	int iTCount = 0;
	
	//��ȡ�������
	
	//��ȡҳ�����
	String sActionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sSerialNo     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	String sModelNo      = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo"));
	String sModelType    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelType"));
	String sReportScope    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	//����ֵת��Ϊ���ַ���
	if(sActionType == null) sActionType = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
	if(sModelNo == null) sModelNo = "";
	if(sModelType == null) sModelType = "";
	if(sReportScope == null) sReportScope = "";
	//���ñ�־λ����֮�����������ļ�¼ȫ��û�н������õȼ����������Բ��ò�ѯ�ü�¼�Ƿ���������
	//ԭ�������Evaluate.existEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,Sqlca)�����Ѿ��ϳ���
	if(sActionType.equals("add"))//����
	{
		//ʵ�ֶ�ھ�������һ�����õȼ����������¼ʱ��Ҫ������Ӧ�Ĳ��񱨱�Ŀھ�������
		//�����޸��˷���Evaluate.newEvaluate����ԭ���Ļ����������˿ھ�������
		//sSerialNo = Evaluate.newEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),Sqlca); //ԭ���ķ���
		sSerialNo = Evaluate.newEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),sReportScope,Sqlca); //�޸ĺ�ķ���
		if(sObjectType.equals("Customer")){
			//���õȼ�û��ϵͳ��������������ʱ��
		//	String sSql = " Update EVALUATE_RECORD Set EvaluateDate=''"+
		//	       " where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='"+ sSerialNo + "'";
		//	Sqlca.executeSQL(sSql);
			InitializeFlow InitializeFlow_CustomerEvaluate = new InitializeFlow();
			InitializeFlow_CustomerEvaluate.setAttribute("ObjectType",sObjectType);
			InitializeFlow_CustomerEvaluate.setAttribute("ObjectNo",sSerialNo); 
			InitializeFlow_CustomerEvaluate.setAttribute("ApplyType","CreditCogApply");//���õȼ�����ģ����
			InitializeFlow_CustomerEvaluate.setAttribute("FlowNo","EvaluateFlow");
			InitializeFlow_CustomerEvaluate.setAttribute("PhaseNo","0010");
			InitializeFlow_CustomerEvaluate.setAttribute("UserID",CurUser.getUserID());
			InitializeFlow_CustomerEvaluate.setAttribute("OrgID",CurUser.getOrgID());
			InitializeFlow_CustomerEvaluate.run(Sqlca);
		}
%>	
		<script type="text/javascript"> 
			self.returnValue="<%=sSerialNo%>";
			self.close();
		</script>		
<%
	}else if(sActionType.equals("delete"))//ɾ��
	{
		Evaluate eEvaluate = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);
		eEvaluate.deleteEvaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);
%> 
		<script type="text/javascript">
			self.returnValue="success";//ɾ�����õȼ�������¼�ɹ�
			self.close();
		</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>