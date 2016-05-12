<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xuzhang 2005.1.24
 * Tester:
 *
 * Content: ��ӡ����ҵ���������֪ͨ�� 
 * Input Param:
 *   		�����ţ�ObjectNo
 *              ����֪ͨ����ˮ��:SerialNo     
 * Output param:
 *
 * History Log:  zywei 2006/04/05 ���ƴ���
 *                  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<html>
<head>
<title>����ҵ������֪ͨ��</title>
</head>
<% 
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow_open
	//��ȡ������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	
    String sRelativeSerialNo = "",sOperateOrgName = "",sOperateUserName = "",sPhaseOpinion = "",sApproveOpinion="";
	String sBusinessSum="",sBusinessCurrencyName="",sBusinessTypeName="",sCustomerName="",sFinishOrgName = "";
    //��ѯ֪ͨ����Ϣ
	String sSql = 	" select BusinessSum,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName, "+
					" getBusinessName(BusinessType) as BusinessTypeName,CustomerName,RelativeSerialNo, "+
					" getItemName('FinishOrg',FinishOrg) as FinishOrgName,getOrgName(OperateOrgID) as OperateOrgName,"+
	              	" getUserName(OperateUserID) as OperateUserName,ApproveOpinion"+
	              	" from BUSINESS_APPROVE where SerialNo=:SerialNo ";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next())
	{
	    sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));	 
		sFinishOrgName = DataConvert.toString(rs.getString("FinishOrgName"));
		sOperateOrgName = DataConvert.toString(rs.getString("OperateOrgName"));
		sOperateUserName = DataConvert.toString(rs.getString("OperateUserName"));
		sApproveOpinion	= DataConvert.toString(rs.getString("ApproveOpinion"));	
		sBusinessSum ="���:"+ DataConvert.toMoney(rs.getString("BusinessSum"))+"Բ";
		sBusinessCurrencyName ="���֣�"+ DataConvert.toString(rs.getString("BusinessCurrencyName"));
		sBusinessTypeName= DataConvert.toString(rs.getString("BusinessTypeName"));
		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
	}
	rs.getStatement().close();	

	//��ȡ���
	sSql = " select PhaseOpinion from FLOW_TASK where SerialNo=:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next())
	{
		sPhaseOpinion = DataConvert.toString(rs.getString(1));	       	    
	}
	rs.getStatement().close();	
%>

<script type="text/javascript">
		
		function my_Print()
		{
			window.print();
		}
		
		function my_Cancle()
		{
			self.close();
		}		
		
		function beforePrint()
		{
			document.getElementById('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.getElementById('PrintButton').style.display="";
		}
</script>
<body onbeforeprint="beforePrint()"  onafterprint="afterPrint()">
<center>
  <h2>XXX��������ҵ������֪ͨ��</h2>
</center>
  
<table class=table1 width='640' align=center border=0 cellspacing=0 cellpadding=2 bgcolor=white  bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3"><font face="����" size="3"><b><%=sOperateOrgName%></b></font></td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;<font face="����" size="3"><b>�����ϱ���</b><%=sRelativeSerialNo%><b>��������ţ���Ŀ��</b><%=sCustomerName%>��<%=sBusinessTypeName%>��<%=sBusinessCurrencyName%>��<%=sBusinessSum%>��<b>����Ϥ�����쵼��ʾ����ͬ�⣨�ݻ����������Ŀ��</b></font></td>
  </tr> 
  <tr> 
    <td  colspan="3" width=25% ><font face="����" size="3"><b>�������£�</b></font></td>
  </tr>
  <tr> 
       <td colspan="3"><font face="����" size="3">&nbsp;&nbsp;&nbsp;&nbsp;<%=sApproveOpinion%></font></td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
   <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <tr> 
  	<td width=30%>&nbsp;</td>
    <td align="right" width=40%><font face="����" size="3"><b>�´�����֪ͨ�鲿�ţ�</b></font></td>
    <td><font face="����" size="2"><%=sFinishOrgName%></font></td>
  </tr>
  <tr> 
  	<td>&nbsp;</td>
    <td align="right"><font face="����" size="3"><b>����ͻ�����</b></font></td>
    <td><font face="����" size="3"><%=sOperateUserName%></font>&nbsp;</td>
  </tr>
  <tr> 
  	<td>&nbsp;</td>
    <td align="right"><font face="����" size="3"><b>�´�ʱ�䣺</b></font></td>
    <td><font face="����" size="3"><%=StringFunction.getToday()%></font></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<div id='PrintButton'> 
    <table width=100%>
        <tr>
            <td align="right">
                <%=HTMLControls.generateButton("��ӡ","��ӡ����֪ͨ��","javascript: my_Print()",sResourcesPath)%>
            </td>
            <td align="left">
                <%=HTMLControls.generateButton("����","����","javascript: window.close()",sResourcesPath)%>
            </td>
        </tr>
    </table>
</div>

</body>

<%@ include file="/IncludeEnd.jsp"%>

