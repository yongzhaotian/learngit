<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zywei 2003.9.5
 * Tester:
 *
 * Content: ����ҵ������֪ͨ�� 
 * Input Param:
 *   		�����ţ�ObjectNo
 *              ����֪ͨ����ˮ��:SerialNo     
 * Output param:
 *
 * History Log:  
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
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open
	//��ȡ������
	String sObjectNo 	  = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	
    String sRelativeSerialNo = "",sOperateOrgName = "",sOperateUserName = "",sPhaseOpinion = "123123",sRemark="123123";
	String sBusinessSum="",sBusinessCCYName="",sBusinessTypeName="",sCustomerName="";
    //��ѯ֪ͨ����Ϣ
	String sSql = " select BusinessSum,getItemName('Currency',BusinessCurrency) as BusinessCCYName,getBusinessName(BusinessType) as BusinessTypeName,CustomerName,RelativeSerialNo,getOrgName(OperateOrgID) as OperateOrgName,"+
	              " getUserName(OperateUserID) as OperateUserName,Remark"+
	              " from BUSINESS_APPROVE where SerialNo=:SerialNo ";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
	    sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));	 
		sOperateOrgName = DataConvert.toString(rs.getString("OperateOrgName"));
		sOperateUserName = DataConvert.toString(rs.getString("OperateUserName"));
		sRemark	= DataConvert.toString(rs.getString("Remark"));	
        sBusinessSum = DataConvert.toMoney(rs.getString("BusinessSum"));
        sBusinessCCYName = DataConvert.toString(rs.getString("BusinessCCYName"));
        sBusinessTypeName= DataConvert.toString(rs.getString("BusinessTypeName"));
        sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
	}
	rs.getStatement().close();	

	//��ȡ���
	sSql = " select PhaseOpinion "+
           " from FLOW_TASK where SerialNo=:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
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
  <h2>����ҵ����֪ͨ��</h2>
</center>
  
<table width="80%" border="0" align="center"  bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'>
  <tr> 
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td align="right"><font size="2"></font></td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3"><font face="����" size="2"><b>��ҵ����</b><%=sOperateOrgName%></font></td>
  </tr>
  <tr> 
    <td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;<font face="����" size="2"><b>�����ϱ���</b><%=sRelativeSerialNo%><b>��������ţ���Ŀ��</b><%=sCustomerName%>��<%=sBusinessTypeName%>��<%=sBusinessCCYName%>��<%=sBusinessSum%>��<b>����Ϥ�����쵼��ʾ����ͬ�⣨�ݻ����������Ŀ��</b></font></td>
  </tr> 
  <tr> 
    <td><font face="����" size="2">&nbsp;&nbsp;&nbsp;&nbsp;<b>�������£�</b></font></td>
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
       <td><%=sRemark%></td>
  </tr>
  <tr> 
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
  </tr>
  <tr> 
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
  </tr>
  <tr> 
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td align="right"><font face="����" size="2"><b>�´�����֪ͨ�鲿�ţ�</b></font></td>
    <td><font face="����" size="2"></font></td>
  </tr>
  <tr> 
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td><font face="����" size="2"></font></td>
    <td align="right"><font face="����" size="2"><b>�����ˣ�</b></font></td>
    <td><%=sOperateUserName%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><font face="����" size="2"><b>�´�ʱ�䣺</b></font></td>
    <td><%=StringFunction.getToday()%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<div id='PrintButton'> 
    <table width=100%>
        <tr>
            <td align="right">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ӡ","��ӡ����֪ͨ��","javascript: my_Print()",sResourcesPath)%>
            </td>
            <td align="left">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","����","javascript: window.close()",sResourcesPath)%>
            </td>
        </tr>
    </table>
</div>

</body>

<%@ include file="/IncludeEnd.jsp"%>

