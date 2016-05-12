<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: cwzhan 2003-9-8
 * Tester:
 *
 * Content: 申请审批表
 * Input Param:
 *      ObjectNo: 申请流水号  
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
<title> 信用业务申请送审表</title>
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
        <td align="center" colspan=2><font size="12"><b> 信用业务申请审批表 </b></font></td>
      <tr>
      <tr>
          <td><font size="5"><b>申请编号：</b></font></td>
          <td><font size="5" ><%=DataConvert.toString(rs.getString("SerialNo"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>发生类型：</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("OccurTypeName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>客户名称：</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("CustomerName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>业务品种：</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("BusinessTypeName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>申请机构：</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("OperateOrgName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>客户经理：</b></font></td>
          <td ><font size="5" ><%=DataConvert.toString(rs.getString("OperateUserName"))%></font></td>
      </tr>
      <tr>
          <td><font size="5"><b>申请日期：</b></font></td>
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
                <td colspan=2><h2><b>一、客户概况</b></h2></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>申请人名称：</b></td>
                <td><%=DataConvert.toString(rs2.getString("EnterpriseName"))%></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>组织机构代码：</b></td>
                <td><%=DataConvert.toString(rs2.getString("CustomerID"))%></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>国标行业：</b></td>
                <td><%=DataConvert.toString(rs2.getString("IndustryTypeName"))%></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>最新信用等级：</b></td>
                <td><%=DataConvert.toString(rs2.getString("CreditLevel"))%></td>
            </tr>
            <tr>
                <td align="right" width=20%><b>最新评级时间：</b></td>
                <td><%=DataConvert.toString(rs2.getString("EvaluateDate"))%></td>
            </tr>
        </table>
        <br><br>
<%}
%>
     <table width=100%>
        <tr>
            <td colspan=5><h2><b>二、申请业务基本信息</b></h2></td>
        </tr>
        <tr>
            <td width=20%><b>申请流水号</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("SerialNo"))%></td>
            <td width=20%><b>发生日期</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("OccurDate"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>客户编号</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CustomerID"))%></td>
            <td  width=20%><b>客户名称</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CustomerName"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>发生类型</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("OccurTypeName"))%></td>
            
            <td  width=20%><b>业务品种</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("BusinessTypeName"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>额度品种</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CreditTypeName"))%></td>
            
            <td  width=20%><b>额度合同号</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CreditAggreement"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>币种</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("CurrencyName"))%></td>
            
            <td  width=20%><b>申请金额</b></td>
            <td width=30%><%=DataConvert.toMoney(rs.getString("BusinessSum"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>期限月</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("TermMonth"))%></td>
            
            <td  width=20%><b>期限日</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("TermDay"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>基准利率</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("BaseRate"))%></td>
            
            <td  width=20%><b>浮动类型</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("RateFloatType"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>利率浮动值</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("RateFloat"))%></td>
            
            <td  width=20%><b>月利率</b></td>
            <td width=30%><%=Arith.round(rs.getDouble("BusinessRate"),4)%></td>
        </tr>
        <tr>
            <td  width=20%><b>计息方式</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("ICTypeName"))%></td>
            
            <td  width=20%><b>计息周期</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("ICCyc"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>手续费比例</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("PdgRatio"))%></td>
            
            <td  width=20%><b>保证金比例</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("BailRate"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>用途</b></td>
            <td  colspan=4><%=DataConvert.toString(rs.getString("Purpose"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>主要担保方式</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("VouchTypeName"))%></td>
            
            <td  width=20%><b>人行担保方式</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("VouchType1Name"))%></td>
        </tr>
        <tr>
            
            <td  width=20%><b>第三方名称</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("ThirdParty"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>借新还旧次数</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("LNGOTimes"))%></td>
            
            <td  width=20%><b>债务重组次数</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("DRTimes"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>经办机构</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("OperateOrgName"))%></td>
            
            <td  width=20%><b>经办人</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("OperateUserName"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>登记机构</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("InputOrgName"))%></td>
            
            <td  width=20%><b>登记人</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("InputUserName"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>登记日期</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("InputDate"))%></td>
            
            <td  width=20%><b>更新日期</b></td>
            <td width=30%><%=DataConvert.toString(rs.getString("UpdateDate"))%></td>
        </tr>
        <tr>
            <td  width=20%><b>备注</b></td>
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
            <td colspan=2><h2><b>三、担保详细情况</b></h2></td>
        </tr>
        <tr> 
            <td><font face="宋体" size="2"><b>担保人名称</b></font></td>
            <td><font face="宋体" size="2"><b>担保方式</b></font></td>
            <td><font face="宋体" size="2"><b>抵质押物名称</b></font></td>
            <td><font face="宋体" size="2"><b>担保金额（元）</b></font></td>
            <td><font face="宋体" size="2"><b>担保币种</b></font></td>
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
            <td colspan=1><h2><b>五、贷前调查报告</b></h2></td>
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
            <td colspan=2><h2><b>六、客户经理意见</b></h2></td>
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
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","打印","打印申请送审表","javascript: my_Print()",sResourcesPath)%>
            </td>
            <td align="left">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","返回","返回","javascript: goBack()",sResourcesPath)%>
            </td>
        </tr>
    </table>
    </div>
<%
}else
{ 
%>
<script type="text/javascript">
    alert("没有该申请信息！");
    self.close();
</script>
<%rs.getStatement().close();
}%>
</center>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>
