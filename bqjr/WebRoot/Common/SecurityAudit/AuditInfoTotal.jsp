<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ҵ��̬
		Input Param:
		Output param:
			sListType 11 ���յ�½�ܴ�������������ע���ܴ�����������
			          12 ���յ�½ʧ�ܴ���
			          13 ��ǰ����������
			          14 ����ҳ������ܴ���
			          15 �������ݿ���ɾ�Ĳ����ܴ���
		History Log:   sxjiang  2010.07.12  ���ӵ��յ�½ʧ���ܴ���  Line46
	 */
	%>
<%/*~END~*/%>

<%!
	String [] getMoney1(Transaction Sqlca,String sDay) throws Exception {
		String [] sArray = {"","","","","","","","","","",""};
		String sSql="";
		String sWhere="";
		int i=0;
		int i0;

		sSql = "select count(UserID) from USER_LIST where BeginTime like :Day";
		sArray[i++] = "����........��½�ܴ���:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16);
		sSql = "select count(distinct UserID) from USER_LIST where BeginTime like :Day";
		sArray[i++] = "����........��½������:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16);
		sSql = "select count(UserID) from USER_LIST where BeginTime like :Day and EndTime is not null ";
		sArray[i++] = "����........ע���ܴ���:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16);
		sSql = "select count(distinct UserID) from USER_LIST where BeginTime like :Day and EndTime is not null ";
		sArray[i++] = "����........ע��������:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16);
		sSql = "select count(UserID) from USER_RUNTIME where BeginTime like :Day";
		sArray[i++] = "����....ҳ������ܴ���:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16);
		sSql = "select count(UserID) from USER_FAILEDLIST where LOGONTIME like :Day";
		sArray[i++] = changeRed("����....��½ʧ���ܴ���:��������     ����"+Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")));

		return sArray;
	}

	String changeRed(String s) {
		return "<span style=\"font-size: 11pt; color: #ff0000;\">"+s+"</span>";
	}

	String getSpace(String s, int len) {
		if (s.length() > 5 && len > 40)
			s = s.substring(0,s.length()-3);
		if (s.length() > len)
			return s;
		for (int i=s.length(); i < len; i ++)
			s = "&nbsp;"+s;
		s="<span style=\"font-size: 12pt; color: #0066cc;\"><b>"+s+"</b></span>";
		return s;
	}
%>
<%
	String [] sMoney1 = getMoney1(Sqlca,StringFunction.getToday());
%>
<html>
<head>
<title>��ȫ��Ϣ����</title>
</script>
<link rel="stylesheet" href="Style.css">

</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
 <tr valign="top">
    <td>
      <div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
        <table align='center' cellspacing=0 cellpadding=0 border=0 width=95% height="95%">
          <tr>
            <td align='center' valign='top'>
              <table border=0 width='100%' height='100%'>
                <tr>
                  <td valign='top'>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="12%" valign="top" align="center">
                          <p><br>
                            <br>
                            </p>
                          
                        </td>
                        <td valign="top">
                          <table align='left' border="0" cellspacing="0" cellpadding="4" bordercolordark="#FFFFFF" width="100%" >
				                        <tr>
				                        	<td align="left" colspan="2"></td>
				                        </tr>
				                        <tr >
				                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
				                          	<b> ��ȫ��Ϣ����ͳ��&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<a href="javascript:self.location.reload();">ˢ��</a></b>
				                        	</td>
				                        </tr>
										<%
										for (int i=0; i < sMoney1.length; i ++) {
										%>

			                         	<tr>
				                        	<td align="left" >&nbsp;</td>
			                         	    <td align="left" ><%=sMoney1[i]%></td>
										</tr>
										<%
											}
										%>
				                        <tr>
			                         	   <td align="left" colspan="2">��</td>
										</tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>