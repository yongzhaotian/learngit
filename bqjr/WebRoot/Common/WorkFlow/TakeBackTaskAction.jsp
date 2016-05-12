<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: CChang 2003.8.28
 * Tester:
 *
 * Content: ��ʾ��һ�׶���Ϣ 
 * Input Param:
 * 				SerialNo��	��ǰ�������ˮ��
 * Output param:
 *				sReturnValue:	����ֵCommit��ʾ��ɲ���
 * History Log: 2003-12-2:cwzhan
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>
<% 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//���ϸ�ҳ��õ������������ˮ��
	String sReturnMessage = "";//ִ�к󷵻ص���Ϣ
	String sSql = "";
    String sObjectNo = "",sFlowNo="";
    String sObjectType = "";
    boolean hasContract = false;
    String sTakeBackFlag = "";
    ASResultSet rs = null;
    
    //����������ˮ�Ż�ö������ͺͶ�����
    sSql = "select ObjectType,ObjectNo,FlowNo  from FLOW_TASK where SerialNo=:SerialNo ";
    
    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
    if(rs.next()){
        sObjectType = DataConvert.toString(rs.getString("ObjectType"));
        sObjectNo = DataConvert.toString(rs.getString("ObjectNo"));
        sFlowNo = DataConvert.toString(rs.getString("FlowNo"));
        
        
        //����ֵת��Ϊ���ַ���
        if(sObjectType == null) sObjectType = "";
        if(sObjectNo == null) sObjectNo = "";
    }
    rs.getStatement().close();
    
    //�����ջ�ʱ�����жϸ������Ƿ��Ѿ��Ǽ��������������������������ջ�
    if(sObjectType.equals("CreditApply")){
    	sSql = " select SerialNo from BUSINESS_APPROVE where RelativeSerialNo = :RelativeSerialNo ";
    	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeSerialNo",sObjectNo));
        if(rs.next()){
            hasContract = true;
            sReturnMessage = "�ñ������Ѿ��Ǽ���������������������ջأ�";
            sTakeBackFlag = "hasApprove";
        }
        rs.getStatement().close();
    }
    
    //��������������ջز��������жϸñ�������������Ƿ��Ѿ�ǩ���˺�ͬ������������ջ�
    if(sObjectType.equals("ApproveApply")){
        sSql = " select SerialNo from BUSINESS_CONTRACT where RelativeSerialNo = :RelativeSerialNo ";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeSerialNo",sObjectNo));
        if(rs.next()){
            hasContract = true;
            sReturnMessage = "�ñ�������������Ѿ�ǩ����ͬ�������ջأ�";
            sTakeBackFlag = "hasContract";
        }
        rs.getStatement().close();
    }

    if(hasContract == false){
        FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);//��ʼ���������
        ftBusiness.takeBack(CurUser);//ִ���˻ز���
        sReturnMessage = ftBusiness.takeBack(CurUser).ReturnMessage;	
        if (sReturnMessage.equals("�ջ����")){
        	
        	if(sFlowNo.startsWith("CarFlow")){//���������ջ�ʱ���º�ͬ״̬
        		sSql = "update business_contract set contractstatus = '060' where SerialNo = :Serialno";
            	Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", sObjectNo));
        	}
            sTakeBackFlag = "Commit";
        }        
    }
    
%>
<script type="text/javascript">
	alert("<%=sReturnMessage%>");
	self.returnValue = "<%=sTakeBackFlag%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>