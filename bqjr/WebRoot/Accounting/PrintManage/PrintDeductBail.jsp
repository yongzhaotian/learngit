<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.util.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sloanNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("loanNo"));
	
	String sInputUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUserID"));
	String sBailUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BailUserID"));
	String sBailOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BailOrgID"));
	String sBailsDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BailsDate"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	//��ӡҵ��ƾ֤(�۱�֤��)
	
	String sBusinessDate = SystemConfig.getBusinessDate();//��ǰϵͳ����
	String sYear = sBusinessDate.substring(0,4);//��ǰ��
	String sMonth = sBusinessDate.substring(5,7);//��ǰ��
	String sDay = sBusinessDate.substring(8,10);//��ǰ��
	int sCount = 1;
	
	//��������
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject bailInfo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.bail_info, sObjectNo);//��֤����Ϣ
	
%>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>

<table width="621" height="330">
  <tr>
    <td colspan="3" align="right" style="padding-bottom:20px;"><%=sYear%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sMonth%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDay%>&nbsp;</td>
  </tr>
  <tr>
    <td width="259"> ҵ�����ݣ�&nbsp;<%=sBusinessType %></td>
    <td width="228"> ��ˮ�ţ�&nbsp;<%=sObjectNo %></td>
    <td width="124">&nbsp;</td>
  </tr>
  <tr>
    <td >��ݺţ�&nbsp;<%=sloanNo%></td>
    <td>��֤���&nbsp;<%=bailInfo.getDouble("BusinessSum") %>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>���֣�&nbsp;<%=CodeManager.getItemName("Currency",bailInfo.getString("Currency"))%></td>
    <td>�������ͣ�&nbsp;��֤��׷��</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">�ͻ����ƣ�&nbsp;<%=bailInfo.getString("BailFromName") %></td>
  </tr>
  <tr>
    <td colspan="3">��֤���˺ţ�&nbsp;<%=bailInfo.getString("BailAccout") %></td>
  </tr>
  <tr>
    <td colspan="3">��֤����Դ�˺ţ�&nbsp;<%=bailInfo.getString("BailFromAccout") %></td>
  </tr>
  <tr>
    <td colspan="3">��֤����Դ�˻����ƣ�&nbsp;<%=bailInfo.getString("BailFromName")%></td>
  </tr>
  <tr>
    <td>�����Ա��<%= sInputUserID%> ���˹�Ա��<%= sBailUserID%></td>
    <td>���׻�����<%= sBailOrgID%>�����룺</td>
    <td>����ʱ�䣺<%= sBailsDate%></td>
  </tr>
</table>

<div id='PrintButton'> 
<table width=100%>
    <tr align="center">
        <td align="right" id="print">
            <%=HTMLControls.generateButton("��ӡ","��ӡ����֪ͨ��","javascript: my_Print()",sResourcesPath)%>
        </td>
        <td align="left" id="back">
            <%=HTMLControls.generateButton("����","����","javascript: window.close();",sResourcesPath)%>
        </td>
    </tr>
</table>
</div>
<script language=javascript>
		
		function my_Print()
		{
			var print=document.getElementById("PrintButton").innerHTML;
			document.getElementById("PrintButton").innerHTML="";
			window.print();
			var sPrintCount=<%=sCount%>+1;
			document.getElementById("PrintButton").innerHTML=print;
		}
		
		function my_Cancle()
		{
			self.close();
		}		
		
		function beforePrint()
		{
			document.all('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.all('PrintButton').style.display="";
		}
</script>

<%@	include file="/IncludeEnd.jsp"%>