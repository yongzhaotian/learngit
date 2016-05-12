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
	//��ѯ֪ͨ����Ϣ
	String sSql = " select RelativeSerialNo,CustomerName,getItemName('Currency',BusinessCurrency) "+
	              " as BusinessCCYName,getBusinessName(BusinessType) as BusinessTypeName, "+
	              " BusinessSum,getItemName('VouchType',VouchType) as VouchTypeName,TermMonth, "+
	              " TermDay,BusinessRate,Purpose,Remark,Describe1,getOrgName(OperateOrgID) as OperateOrgName,"+
	              " getUserName(OperateUserID) as OperateUserName,getUserName(InputUserID) as InputUserName,getItemName('FinishOrg',FinishOrg) "+
	              " as FinishOrgName,UpdateDate from BUSINESS_APPROVE where "+
	              " SerialNo=:SerialNo ";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	String sRelativeSerialNo = "",sCustomerName = "",sBusinessCCYName = "",sBusinessTypeName = "";
	String sBusinessSum = "",sVouchTypeName = "",sTermMonth = "",sTermDay = "";
	String sBusinessRate = "",sPurpose = "";
	String sRemark = "",sDescribe1="",sOperateOrgName = "",sOperateUserName = "",sUpdateDate = "";
	String sProjectNo = "",sProjectName = "",sSigneeName = "",sFinishOrgName = "";
	String sGuarantyTypeName = "",sGuarantyName = "",sGuarantySum = "",sInputUserName = "";
	if(rs.next())
	{
	    sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
	    sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
	    sBusinessCCYName = DataConvert.toString(rs.getString("BusinessCCYName"));
	    sBusinessTypeName = DataConvert.toString(rs.getString("BusinessTypeName"));
	    sBusinessSum = DataConvert.toString(rs.getString("BusinessSum"));
	    sVouchTypeName = DataConvert.toString(rs.getString("VouchTypeName"));
	    sTermMonth = DataConvert.toString(rs.getString("TermMonth"));
	    sTermDay = DataConvert.toString(rs.getString("TermDay"));
	    sBusinessRate = DataConvert.toString(rs.getString("BusinessRate"));
	    sPurpose = DataConvert.toString(rs.getString("Purpose"));
	    sRemark = DataConvert.toString(rs.getString("Remark"));
	    sDescribe1 = DataConvert.toString(rs.getString("Describe1"));
	    sOperateOrgName = DataConvert.toString(rs.getString("OperateOrgName"));
	    sOperateUserName = DataConvert.toString(rs.getString("OperateUserName"));
	    sFinishOrgName = DataConvert.toString(rs.getString("FinishOrgName"));	
	    sUpdateDate  = DataConvert.toString(rs.getString("UpdateDate"));   	  
        sInputUserName  =   DataConvert.toString(rs.getString("InputUserName"));
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
  <h2>����ҵ��ͬ��֪ͨ��</h2>
</center>
  
<table width="90%" border="0" align="center"  bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><b>֪ͨ����ˮ�ţ�</b></td>
    <td><%=sObjectNo%></td>
  </tr>
  <tr> 
    <td colspan="3"><b>��ҵ����</b><%=sOperateOrgName%></td>
  </tr>
  <tr> 
    <td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;<b>�����ϱ���</b><%=sRelativeSerialNo%><b>����������ˮ�ţ���Ŀ����Ϥ�����쵼��ʾ��ͬ�����ǰ����������������Ŀ��</b></td>
  </tr>
  <tr> 
    <td><b>�ͻ����ƣ�</b></td>
    <td colspan="4"><%=sCustomerName%></td>
  </tr>
  <tr> 
    <td><b>ҵ��Ʒ�֣�</b></td>
    <td colspan="4"><%=sBusinessTypeName%></td>
  </tr>
  <tr> 
    <td><b>�������ࣺ</b></td>
    <td colspan="4"><%=sBusinessCCYName%></td>
  </tr>
  <tr> 
    <td><b>��Ԫ����</b></td>
    <td colspan="4"><%=sBusinessSum%></td>
  </tr>  
  <tr> 
    <td><b>��Ҫ������ʽ:</b></td>
    <td colspan="4"><%=sVouchTypeName%></td>
  </tr>
  <tr> 
    <td colspan="5"><b>������ϸ�����</b></td>
  </tr>
  <tr> 
    <td><b>���</b></td>
    <td><b>����������</b></td>
    <td><b>������ʽ</b></td>
    <td><b>����Ѻ������</b></td>
    <td><b>�������ۺ������Ԫ��</b></td>
  </tr>
  <%
    int j = 0;
    //��ѯ������Ϣ
	sSql = " select GD.SigneeName,getItemName('VouchType',GD.GuarantyType) as GuarantyTypeName, "+
	       " GD.GuarantyName,GD.GuarantySum from GUARANTY_DETAIL GD,APPROVE_RELATIVE AR "+
	       " where AR.ObjectType = 'GuarantyDetail' and AR.SerialNo = '"+ sObjectNo +"' "+
	       " and AR.ObjectNo = GD.SerialNo ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next())
	{
	    j = j + 1;
	    sSigneeName = DataConvert.toString(rs.getString("SigneeName"));
	    sGuarantyTypeName = DataConvert.toString(rs.getString("GuarantyTypeName"));
	    sGuarantyName = DataConvert.toString(rs.getString("GuarantyName"));
	    sGuarantySum = DataConvert.toString(rs.getString("GuarantySum"));	   
  %>
  <tr> 
    <td><%=j%></td>
    <td><%=sSigneeName%></td>
    <td><%=sGuarantyTypeName%></td>
    <td><%=sGuarantyName%></td>
    <td><%=sGuarantySum%></td>
  </tr>
  <%
    }
    rs.getStatement().close();
  %>
  <tr> 
    <td><b>���ޣ�</b></td>
    <td colspan="4"><%=sTermMonth%><b>����</b><%=sTermDay%><b>��</b></td>
  </tr>
  <tr> 
    <td><b>�����ʣ��룩��</b></td>
    <td colspan="4"><%=sBusinessRate%></td>
  </tr>
  <tr> 
    <td><b>��;��</b></td>
    <td colspan="4"><%=sPurpose%></td>
  </tr>
  <tr> 
    <td><b>����������Ҫ��</b></td>
    <td colspan="4"><%=sDescribe1%></td>
  </tr>
  <tr> 
    <td><b>��ע��</b></td>
    <td colspan="4"><%=sRemark%></td>
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
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right" width=150px><b>�´�����֪ͨ�鲿�ţ�</b></td>
    <td><%=sFinishOrgName%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><b>��鲿�ž�����Ա��</b></td>
    <td><%=sInputUserName%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><b>�����ˣ�</b></td>
    <td><%=sOperateUserName%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><b>�´�ʱ�䣺</b></td>
    <td><%=sUpdateDate%></td>
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
    <tr align="center">
        <td align="right">
            <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ӡ","��ӡ����֪ͨ��","javascript: my_Print()",sResourcesPath)%>
        </td>
        <td align="left">
            <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","����","javascript: window.close();",sResourcesPath)%>
        </td>
    </tr>
</table>
</div>
</body>

<%@ include file="/IncludeEnd.jsp"%>

