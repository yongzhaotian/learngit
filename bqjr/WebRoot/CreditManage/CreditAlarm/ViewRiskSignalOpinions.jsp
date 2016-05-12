<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: byhu 2004.12.21
 * Tester:
 *
 * Content: �鿴Ԥ���ź��϶��������
 * Input Param:
 *      ObjectNo��Ԥ���ź���ˮ��
 *      SignalType��Ԥ�����ͣ�01������02�������      
 * Output param:
 *
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//��ȡ�������
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sSignalType = DataConvert.toRealString(iPostChange,CurComp.getParameter("SignalType"));
	//����ֵת��Ϊ���ַ���	
	if(sObjectNo == null) sObjectNo = "";
	if(sSignalType == null) sSignalType = "";
	
	//�������
    String sSql = "",sConfirmTypeName = "",sNextCheckDate = "",sNextCheckUserName = "";	
    String sSignalLevelName = "",sOpinion = "",sCheckOrgName = "",sCheckDate = "",sCheckUserName = "";
	int iCountRecord=0;//�����жϼ�¼�Ƿ����������

	ASResultSet rs = null;		
	sSql = 	" select getItemName('ConfirmType',ConfirmType) as ConfirmTypeName, "+
			" NextCheckDate,GetUserName(NextCheckUser) as NextCheckUserName, "+
			" getItemName('SignalLevel',SignalLevel) as SignalLevelName,Opinion, "+
			" GetOrgName(CheckOrg) as CheckOrgName,CheckDate, "+
			" GetUserName(CheckUser) as CheckUserName "+
			" from RISKSIGNAL_OPINION "+
			" where ObjectNo = :ObjectNo ";
	rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
%>
<html>
<head>
<title>�������</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground">
  <table width="100%" cellpadding="3" cellspacing="0" border="0" >
    <%
        
        while (rs.next())
        {
			sConfirmTypeName = rs.getString("ConfirmTypeName"); 
			sNextCheckDate = rs.getString("NextCheckDate");
			sNextCheckUserName = rs.getString("NextCheckUserName");
			sSignalLevelName = rs.getString("SignalLevelName");
			sOpinion = rs.getString("Opinion");
			sCheckOrgName = rs.getString("CheckOrgName");
			sCheckDate = rs.getString("CheckDate");
			sCheckUserName = rs.getString("CheckUserName");
			//����ֵת��Ϊ���ַ���
			if(sConfirmTypeName == null) sConfirmTypeName = "";
			if(sNextCheckDate == null) sNextCheckDate = "";
			if(sNextCheckUserName == null) sNextCheckUserName = "";
			if(sSignalLevelName == null) sSignalLevelName = "";
			if(sOpinion == null) sOpinion = "";
			if(sCheckOrgName == null) sCheckOrgName = "";
			if(sCheckDate == null) sCheckDate = "";
			if(sCheckUserName == null) sCheckUserName = "";			
			iCountRecord++;						
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <%
        if(sSignalType.equals("01"))
        {
        %>
        <tr>
            <td colspan=2 bgcolor="#CCCCCC">
                <b>��ʵ����:</b><%=sConfirmTypeName%>&nbsp;&nbsp;
                <b>�´�Ԥ���������:</b><%=sNextCheckDate%>&nbsp;&nbsp;
                <b>�´�Ԥ�������:</b><%=sNextCheckUserName%>&nbsp;&nbsp;
                <b>Ԥ������:</b><%=sSignalLevelName%>&nbsp;&nbsp;            	
            </td>
        </tr>
        
        <tr>
            <td colspan=2 bgcolor="#CCCCCC">
            <b>�϶�����:</b><%=sCheckOrgName%>&nbsp;&nbsp;
            <b>�϶���:</b><%=sCheckUserName%>&nbsp;&nbsp;
            <b>�϶�ʱ��:</b><%=sCheckDate%>&nbsp;&nbsp;
            </td>
        </tr>
        <%
        }else
        {
        %>
        <tr>
            <td colspan=2 bgcolor="#CCCCCC">
                <b>��ʵ����:</b><%=sConfirmTypeName%>&nbsp;&nbsp;               
	            <b>�϶�����:</b><%=sCheckOrgName%>&nbsp;&nbsp;
	            <b>�϶���:</b><%=sCheckUserName%>&nbsp;&nbsp;
	            <b>�϶�ʱ��:</b><%=sCheckDate%>&nbsp;&nbsp;
            </td>
        </tr>
        <%
        }
        %>
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n�������"+ StringFunction.replace((sOpinion).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            </td>
        </tr> 
              
      </table>
	  </td>
    </tr>
    <tr>
	<td>&nbsp;
	  </td>
    </tr>
    <%
    }
    rs.getStatement().close();    
    %>
 
  </table>
</body>
</html>
<%
	//���û����������Զ��ر�
	if (iCountRecord==0){
%>
<script>
    alert("Ŀǰ��û�������Բ鿴�������");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>