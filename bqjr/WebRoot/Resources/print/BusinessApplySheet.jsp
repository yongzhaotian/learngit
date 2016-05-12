<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: cwzhan 2003-9-8
 * Tester:
 *
 * Content: ����������
 * Input Param:
 *      ObjectNo: ������ˮ��  
 *                  
 * Output param:
 *
 * History Log:  
 *                  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
    String sSql="",sCustomerID="";
    String sObjectNo = DataConvert.toString((String)request.getParameter("ObjectNo"));
	
    sSql = " select SerialNo,OccurType,CustomerID,CustomerName,getItemName('OccurType',OccurType) as OccurTypeName,ApplyType, "+
           " CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessTypeName," +
           " OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,OperateUserID,getUserName(OperateUserID) as OperateUserName,"+
           " OperateDate,OccurDate,getBusinessName(CreditType) as CreditTypeName,CreditAggreement,getItemName('Currency',BusinessCurrency) as CurrencyName,"+
           " BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BusinessRate,getItemName('CounterSign',ICType) as ICTypeName,ICCyc," +
           " PdgRatio,BailRate,Purpose,getItemName('VouchType',VouchType) as VouchTypeName,getItemName('VouchType1',VouchType1) as VouchType1Name,"+
           " getItemName('YesOrNo',LowRisk) as LowRiskName," +
           " LNGOTimes,DRTimes,ThirdParty," +
           " getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate,UpdateDate,Remark" +
           " from BUSINESS_APPLY where SerialNo=:SerialNo";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
    
%>
<html>
<head>
<title> ����ҵ�����������</title>
<script type="text/javascript">
		
		function my_Print()
		{
			window.print();
		}
		
		function goBack()
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
</head>

<body onbeforeprint="beforePrint()"  onafterprint="afterPrint()" >
<center>
<%if (rs.next()) 
{
    sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
%>
    <table height=1000>
      <tr height=400 valign="middle">
        <td align="center" colspan=2><font size="12"><b> ����ҵ������������ </b></font></td>
      <tr>
      <tr>
          <td><font size="5"><b>�����ţ�</b></font></td>
          <td><font size="5" ><%=DataConvert.toString(rs.getString("SerialNo"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>�������ͣ�</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("OccurTypeName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>�ͻ����ƣ�</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("CustomerName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>ҵ��Ʒ�֣�</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("BusinessTypeName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>���������</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("OperateOrgName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>�ͻ�����</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("OperateUserName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>�������ڣ�</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("OccurDate"))%></font></td>
      </tr>
      <tr height="200">
        <td></td>
        <td></td>
      </tr>
    </table>
    
<%
	String sSql2 = " select CustomerID,EnterpriseName,getItemName('IndustryType',IndustryType) as IndustryTypeName,"+
	               " CreditLevel,EvaluateDate"+
	               " from ENT_INFO where CustomerID=:CustomerID";
	ASResultSet rs2 = Sqlca.getASResultSet(new SqlObject(sSql2).setParameter("CustomerID",sCustomerID));
        
if (rs2.next())
    {%>
        <table width=100%>
            <tr>
                <td colspan=2><h2><b>һ���ͻ��ſ�</b></h2></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>���������ƣ�</b></td>
                <td><%=DataConvert.toString(rs2.getString("EnterpriseName"))%></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>��֯�������룺</b></td>
                <td><%=DataConvert.toString(rs2.getString("CustomerID"))%></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>������ҵ��</b></td>
                <td><%=DataConvert.toString(rs2.getString("IndustryTypeName"))%></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>�������õȼ���</b></td>
                <td><%=DataConvert.toString(rs2.getString("CreditLevel"))%></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>��������ʱ�䣺</b></td>
                <td><%=DataConvert.toString(rs2.getString("EvaluateDate"))%></td>
            </tr>
        </table>
        <br><br>
<%}
%>
     <table width=100%>
        <tr>
            <td colspan=5><h2><b>��������ҵ�������Ϣ</b></h2></td>
        </tr>
        <tr>
            <td width=20%><b>������ˮ��</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("SerialNo"))%></td>
            <td width=20%><b>��������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("OccurDate"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>�ͻ����</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CustomerID"))%></td>
            <td  width=20%><b>�ͻ�����</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CustomerName"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>��������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("OccurTypeName"))%></td>
            
            <td  width=20%><b>ҵ��Ʒ��</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("BusinessTypeName"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>���Ʒ��</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CreditTypeName"))%></td>
            
            <td  width=20%><b>��Ⱥ�ͬ��</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CreditAggreement"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>����</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CurrencyName"))%></td>
            
            <td  width=20%><b>������</b></td>
            <td width=30%><%=DataConvert.toMoney(rs.getString("BusinessSum"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("TermMonth"))%></td>
            
            <td  width=20%><b>������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("TermDay"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>��׼����</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("BaseRate"))%></td>
            
            <td  width=20%><b>��������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("RateFloatType"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>���ʸ���ֵ</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("RateFloat"))%></td>
            
            <td  width=20%><b>������</b></td>
            <td width=30%><%=Arith.round(rs.getDouble("BusinessRate"),4)%></td>
        </tr>
        <tr>
            <td  width=20%><b>��Ϣ��ʽ</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("ICTypeName"))%></td>
            
            <td  width=20%><b>��Ϣ����</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("ICCyc"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>�����ѱ���</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("PdgRatio"))%></td>
            
            <td  width=20%><b>��֤�����</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("BailRate"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>��;</b></td>
            <td  colspan=4><%=DataConvert.toString(rs.getString("Purpose"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>��Ҫ������ʽ</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("VouchTypeName"))%></td>
            
            <td  width=20%><b>���е�����ʽ</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("VouchType1Name"))%></td>
        </tr>
        <tr>
            
            <td  width=20%><b>����������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("ThirdParty"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>���»��ɴ���</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("LNGOTimes"))%></td>
            
            <td  width=20%><b>ծ���������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("DRTimes"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>�������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("OperateOrgName"))%></td>
            
            <td  width=20%><b>������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("OperateUserName"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>�Ǽǻ���</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("InputOrgName"))%></td>
            
            <td  width=20%><b>�Ǽ���</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("InputUserName"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>�Ǽ�����</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("InputDate"))%></td>
            
            <td  width=20%><b>��������</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("UpdateDate"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>��ע</b></td>
            <td colspan=4><%=DataConvert.toString(rs.getString("Remark"))%></td>
        </tr>
    </table>
    <br><br>
    <%  rs.getStatement().close();
        sSql = " select GD.SigneeName,getItemName('VouchType',GD.GuarantyType) as GuarantyTypeName, "+
               " GD.GuarantyName,GD.GuarantySum,getItemName('Currency',GD.GuarantyCurrency) as  "+
               " GuarantyCurName from GUARANTY_DETAIL GD,APPLY_RELATIVE AR "+
               " where AR.ObjectType = 'GuarantyDetail' and AR.SerialNo = :SerialNo "+
               " and AR.ObjectNo = GD.SerialNo ";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
    %>
    <table width=100%>
        <tr>
            <td colspan=2><h2><b>����������ϸ���</b></h2></td>
        </tr>
        <tr> 
            <td><font face="����" size="2"><b>����������</b></font></td>
            <td><font face="����" size="2"><b>������ʽ</b></font></td>
            <td><font face="����" size="2"><b>����Ѻ������</b></font></td>
            <td><font face="����" size="2"><b>������Ԫ��</b></font></td>
            <td><font face="����" size="2"><b>��������</b></font></td>
        </tr>
    <%while(rs.next())
    {%>
        <tr> 
            <td><%=DataConvert.toString(rs.getString("SigneeName"))%></td>
            <td><%=DataConvert.toString(rs.getString("GuarantyTypeName"))%></td>
            <td><%=DataConvert.toString(rs.getString("GuarantyName"))%></td>
            <td><%=DataConvert.toMoney(rs.getString("GuarantySum"))%></td>
            <td><%=DataConvert.toString(rs.getString("GuarantyCurName"))%></td>
          </tr>
     <%}
        rs.getStatement().close();
    %>
    </table>
    <br><br>

    <%
        String sReportInfo="";
        sSql = " SELECT ReportInfo FROM REPORT_INFO RI " +
               " WHERE RI.ObjectType='BusinessApply' AND RI.ObjectNo=:ObjectNo";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
        
    %>
    <table width=100%>
        <tr>
            <td colspan=1><h2><b>�塢��ǰ���鱨��</b></h2></td>
        </tr>
    <%if(rs.next())
    {
        sReportInfo = DataConvert.toString(rs.getString("ReportInfo"));
        sReportInfo = StringFunction.replace(sReportInfo,"\\r\\n","<br>");
    %>
        <tr>
            <td><%=sReportInfo%></td>
        </tr>
    <%}
    rs.getStatement().close();%>
    </table>
    <br><br>
    
    <%
      sSql = " select PhaseOpinion from FLOW_TASK "+
             " where ObjectType='BusinessApply' and ObjectNo=:ObjectNo ";
      rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
      
    %>
    <table width=100%>
        <tr>
            <td colspan=2><h2><b>�����ͻ��������</b></h2></td>
        </tr>
        <%if(rs.next())
        {%>
            <tr>
                <td><%=DataConvert.toString(rs.getString("PhaseOpinion"))%></td>
            </tr>
        <%}
        rs.getStatement().close();%>
    </table>
    <br><br>
    
    <div id='PrintButton'> 
    <table>
        <tr>
            <td align="right">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ӡ","��ӡ���������","javascript: my_Print()",sResourcesPath)%>
            </td>
            <td align="left">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","����","javascript: goBack()",sResourcesPath)%>
            </td>
        </tr>
    </table>
    </div>
<%
}else
{ 
%>
<script type="text/javascript">
    alert("û�и�������Ϣ��");
    self.close();
</script>
<%rs.getStatement().close();
}%>
</center>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>
