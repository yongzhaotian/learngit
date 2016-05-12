<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
<div class="strip_tit" >
	<table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" style='cursor: pointer;' width='100%'>
		<tr bgcolor="#00659C" valign=center height="20"> 
			<td><font color="#FFFFFF">系统属性参数</font></td>
		</tr>
	</table>
</div>
<div class="strip_doc" style="height:150%;display: block"">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <ul>
<%
  Properties ps = System.getProperties();
  Iterator<?> ir = ps.keySet().iterator();
  for (int i=1; ir.hasNext();i++) {
      String sKey = (String) ir.next();
%>
        <tr>
          <td width="100%" >
              <li>(<%=i%>)[<%=sKey%>]=<strong>[<%=ps.getProperty(sKey)%>]</strong></li>
          </td>
        </tr>
<%
  }
%>
        </ul>
    </table>
</div>
</div>
</body>
<%@ include file="/IncludeEnd.jsp"%>