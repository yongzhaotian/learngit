<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: byhu 2004.12.21
 * Tester:
 *
 * Content: 查看预警信号认定意见详情
 * Input Param:
 *      ObjectNo：预警信号流水号
 *      SignalType：预警类型（01：发起；02：解除）      
 * Output param:
 *
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获取组件参数
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sSignalType = DataConvert.toRealString(iPostChange,CurComp.getParameter("SignalType"));
	//将空值转化为空字符串	
	if(sObjectNo == null) sObjectNo = "";
	if(sSignalType == null) sSignalType = "";
	
	//定义变量
    String sSql = "",sConfirmTypeName = "",sNextCheckDate = "",sNextCheckUserName = "";	
    String sSignalLevelName = "",sOpinion = "",sCheckOrgName = "",sCheckDate = "",sCheckUserName = "";
	int iCountRecord=0;//用于判断记录是否有审批意见

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
<title>意见详情</title>
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
			//将空值转化为空字符串
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
                <b>核实方法:</b><%=sConfirmTypeName%>&nbsp;&nbsp;
                <b>下次预警检查日期:</b><%=sNextCheckDate%>&nbsp;&nbsp;
                <b>下次预警检查人:</b><%=sNextCheckUserName%>&nbsp;&nbsp;
                <b>预警级别:</b><%=sSignalLevelName%>&nbsp;&nbsp;            	
            </td>
        </tr>
        
        <tr>
            <td colspan=2 bgcolor="#CCCCCC">
            <b>认定机构:</b><%=sCheckOrgName%>&nbsp;&nbsp;
            <b>认定人:</b><%=sCheckUserName%>&nbsp;&nbsp;
            <b>认定时间:</b><%=sCheckDate%>&nbsp;&nbsp;
            </td>
        </tr>
        <%
        }else
        {
        %>
        <tr>
            <td colspan=2 bgcolor="#CCCCCC">
                <b>核实方法:</b><%=sConfirmTypeName%>&nbsp;&nbsp;               
	            <b>认定机构:</b><%=sCheckOrgName%>&nbsp;&nbsp;
	            <b>认定人:</b><%=sCheckUserName%>&nbsp;&nbsp;
	            <b>认定时间:</b><%=sCheckDate%>&nbsp;&nbsp;
            </td>
        </tr>
        <%
        }
        %>
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n【意见】"+ StringFunction.replace((sOpinion).trim(),"\\r\\n","\r\n")
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
	//如果没有意见，则自动关闭
	if (iCountRecord==0){
%>
<script>
    alert("目前还没有您可以查看的意见！");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>